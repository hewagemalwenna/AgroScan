import 'dart:io';

import 'package:agroscan/screens/treatment_screen.dart';
import 'package:agroscan/tools/app_theme.dart';
import 'package:agroscan/tools/plant_classifier_service.dart';
import 'package:agroscan/widgets/agro_ui.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TfModel extends StatefulWidget {
  const TfModel({super.key});

  @override
  State<TfModel> createState() => _TfModelState();
}

class _TfModelState extends State<TfModel> {
  final ImagePicker _picker = ImagePicker();
  final PlantClassifierService _classifier = PlantClassifierService();

  File? _image;
  PlantPrediction? _prediction;
  bool _isModelReady = false;
  bool _isClassifying = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      await _classifier.load();
      if (!mounted) return;
      setState(() => _isModelReady = true);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'The plant scanner could not start. Please restart the app.';
      });
    }
  }

  Future<void> _pickAndClassify(ImageSource source) async {
    if (!_isModelReady || _isClassifying) return;

    final selectedImage = await _picker.pickImage(
      source: source,
      imageQuality: 90,
      maxWidth: 1600,
    );
    if (selectedImage == null || !mounted) return;

    final imageFile = File(selectedImage.path);
    setState(() {
      _image = imageFile;
      _prediction = null;
      _errorMessage = null;
      _isClassifying = true;
    });

    try {
      final prediction = await _classifier.classify(imageFile);
      if (!mounted) return;
      setState(() => _prediction = prediction);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'This image could not be analysed. Try a clear, close photo of one leaf.';
      });
    } finally {
      if (mounted) setState(() => _isClassifying = false);
    }
  }

  @override
  void dispose() {
    _classifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prediction = _prediction;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Health Scan'),
        backgroundColor: AgroScanTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Identify a possible plant problem',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Photograph one leaf in good natural light against a plain background.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            _ScanPreview(
              image: _image,
              isLoading: _isClassifying,
              prediction: prediction,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 14),
              AgroInfoBanner(
                icon: Icons.error_outline_rounded,
                text: _errorMessage!,
                color: const Color(0xFFB3261E),
              ),
            ],
            if (!_isModelReady && _errorMessage == null) ...[
              const SizedBox(height: 14),
              const _LoadingBanner(),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _isModelReady && !_isClassifying
                        ? () => _pickAndClassify(ImageSource.camera)
                        : null,
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Take Photo'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isModelReady && !_isClassifying
                        ? () => _pickAndClassify(ImageSource.gallery)
                        : null,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Gallery'),
                  ),
                ),
              ],
            ),
            if (prediction != null && !prediction.isHealthy) ...[
              const SizedBox(height: 14),
              FilledButton.tonalIcon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TreatmentPage(
                        predictionData: PredictionData(prediction.label),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.medical_information_outlined),
                label: const Text('View Care Guidance'),
                style: FilledButton.styleFrom(
                  backgroundColor: AgroScanTheme.accentSoft,
                  foregroundColor: AgroScanTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ],
            const SizedBox(height: 18),
            const AgroInfoBanner(
              icon: Icons.info_outline_rounded,
              text:
                  'AgroScan provides guidance only. Confirm serious or uncertain '
                  'plant problems with a qualified agricultural adviser.',
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingBanner extends StatelessWidget {
  const _LoadingBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AgroScanTheme.accentSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AgroScanTheme.border),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Preparing the plant scanner…',
              style: TextStyle(color: AgroScanTheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanPreview extends StatelessWidget {
  const _ScanPreview({
    required this.image,
    required this.isLoading,
    required this.prediction,
  });

  final File? image;
  final bool isLoading;
  final PlantPrediction? prediction;

  @override
  Widget build(BuildContext context) {
    final result = prediction;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: image == null
                ? const _EmptyPreview()
                : Image.file(image!, fit: BoxFit.cover),
          ),
          if (isLoading)
            const LinearProgressIndicator(color: AgroScanTheme.primary),
          if (result != null)
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: result.isHealthy
                          ? AgroScanTheme.accentSoft
                          : const Color(0xFFFFE9D5),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      result.isHealthy
                          ? Icons.eco_outlined
                          : Icons.warning_amber_rounded,
                      color: result.isHealthy
                          ? AgroScanTheme.primary
                          : const Color(0xFF8B4A00),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.isHealthy
                              ? 'Healthy result'
                              : 'Possible issue',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          result.label,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AgroScanTheme.text,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AgroScanTheme.accentSoft,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${(result.confidence * 100).toStringAsFixed(1)}% confidence',
                            style: const TextStyle(
                              color: AgroScanTheme.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyPreview extends StatelessWidget {
  const _EmptyPreview();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AgroScanTheme.accentSoft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AgroScanTheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AgroScanTheme.border),
            ),
            child: const Icon(
              Icons.document_scanner_outlined,
              size: 36,
              color: AgroScanTheme.primary,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'No leaf image selected',
            style: TextStyle(
              color: AgroScanTheme.text,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Use camera or gallery to begin',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class PredictionData {
  PredictionData(this.label);

  final String label;
}
