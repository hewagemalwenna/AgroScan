import 'package:flutter/material.dart';
import 'crop.dart';
import 'disease_widget.dart';

class CropWidget extends StatelessWidget {
  final Crop crop;

  const CropWidget({super.key, required this.crop});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(crop.name),
        ...crop.diseases.map((disease) => DiseaseWidget(disease: disease)),
      ],
    );
  }
}
