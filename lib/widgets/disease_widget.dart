import 'package:flutter/material.dart';


class Disease {
  final String name;
  final List<String> treatments;

  Disease({required this.name, required this.treatments});
}

class DiseaseWidget extends StatelessWidget {
  final Disease disease;

  const DiseaseWidget({super.key, required this.disease});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(disease.name),
        ...disease.treatments.map((treatment) => Text(treatment)),
      ],
    );
  }
}
