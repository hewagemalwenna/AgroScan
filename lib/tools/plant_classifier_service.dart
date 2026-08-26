import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class PlantPrediction {
  const PlantPrediction({required this.label, required this.confidence});

  final String label;
  final double confidence;

  bool get isHealthy => label.toLowerCase().contains('healthy');
}

class PlantClassifierService {
  static const String _modelAsset = 'assets/plant_disease_model.tflite';
  static const String _labelsAsset = 'assets/plant_disease_labels.txt';

  Interpreter? _interpreter;
  List<String> _labels = const [];

  Future<void> load() async {
    _interpreter ??= await Interpreter.fromAsset(_modelAsset);
    final labelText = await rootBundle.loadString(_labelsAsset);
    _labels = labelText
        .split(RegExp(r'\r?\n'))
        .map((label) => label.trim())
        .where((label) => label.isNotEmpty)
        .toList(growable: false);

    final outputClasses = _interpreter!.getOutputTensor(0).shape.last;
    if (_labels.length != outputClasses) {
      throw StateError(
        'Model output has $outputClasses classes, but ${_labels.length} '
        'labels were loaded.',
      );
    }
  }

  Future<PlantPrediction> classify(File imageFile) async {
    await load();

    final decodedImage = img.decodeImage(await imageFile.readAsBytes());
    if (decodedImage == null) {
      throw const FormatException('The selected image could not be read.');
    }

    final inputShape = _interpreter!.getInputTensor(0).shape;
    if (inputShape.length != 4 || inputShape.last != 3) {
      throw StateError('Unsupported model input shape: $inputShape');
    }

    final inputHeight = inputShape[1];
    final inputWidth = inputShape[2];
    // Training photos are square (1500x1500). Phone shots are usually
    // wider; stretching them to 224x224 distorts the leaf and lowers scores.
    final prepared = _squareCrop(img.bakeOrientation(decodedImage));
    final resized = img.copyResize(
      prepared,
      width: inputWidth,
      height: inputHeight,
      interpolation: img.Interpolation.linear,
    );

    // Training uses image_dataset_from_directory ([0, 255] floats) and
    // MobileNetV2 preprocess_input is inside the exported model — do not
    // normalize to [-1, 1] again here.
    final input = [
      List.generate(inputHeight, (y) {
        return List.generate(inputWidth, (x) {
          final pixel = resized.getPixel(x, y);
          return <double>[
            pixel.r.toDouble(),
            pixel.g.toDouble(),
            pixel.b.toDouble(),
          ];
        });
      }),
    ];

    // Must read scores from output[0] AFTER run(). tflite_flutter replaces
    // that nested list; keeping a pre-run reference always stayed at zeros
    // (0.0% confidence, first label).
    final output = [List<double>.filled(_labels.length, 0.0)];
    _interpreter!.run(input, output);
    final scores = _asProbabilityScores(output[0]);

    var bestIndex = 0;
    for (var index = 1; index < scores.length; index++) {
      if (scores[index] > scores[bestIndex]) {
        bestIndex = index;
      }
    }

    return PlantPrediction(
      label: _labels[bestIndex],
      confidence: scores[bestIndex].clamp(0.0, 1.0),
    );
  }

  img.Image _squareCrop(img.Image image) {
    final side = math.min(image.width, image.height);
    if (image.width == image.height) {
      return image;
    }
    return img.copyCrop(
      image,
      x: ((image.width - side) / 2).round(),
      y: ((image.height - side) / 2).round(),
      width: side,
      height: side,
    );
  }

  /// Ensures values behave like probabilities (sum ≈ 1). Softmax is already
  /// in the TFLite graph; this only guards against unexpected raw logits.
  List<double> _asProbabilityScores(List<double> raw) {
    final sum = raw.fold<double>(0, (a, b) => a + b);
    if (sum > 0.98 && sum < 1.02) {
      return raw;
    }

    final maxLogit = raw.reduce(math.max);
    final exps = [
      for (final value in raw) math.exp((value - maxLogit).clamp(-50.0, 50.0)),
    ];
    final expSum = exps.fold<double>(0, (a, b) => a + b);
    if (expSum == 0) {
      return raw;
    }
    return [for (final value in exps) value / expSum];
  }

  void close() {
    _interpreter?.close();
    _interpreter = null;
  }
}
