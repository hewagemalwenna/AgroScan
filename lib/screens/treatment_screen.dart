import 'package:agroscan/screens/tfmodel.dart';
import 'package:agroscan/tools/app_theme.dart';
import 'package:agroscan/widgets/agro_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TreatmentAdvice {
  const TreatmentAdvice({
    required this.title,
    required this.body,
    required this.icon,
  });

  final String title;
  final String body;
  final IconData icon;
}

class TreatmentPage extends StatelessWidget {
  const TreatmentPage({super.key, required this.predictionData});

  final PredictionData predictionData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgroScanTheme.background,
      appBar: AppBar(
        title: const Text('Care Guidance'),
        backgroundColor: AgroScanTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          children: [
            AgroHeroChip(
              label: 'Detected Condition',
              value: predictionData.label,
              icon: Icons.medical_information_outlined,
            ),
            const SizedBox(height: 24),
            const AgroSectionTitle('Recommended Actions'),
            const SizedBox(height: 12),
            FutureBuilder<List<TreatmentAdvice>>(
              future: fetchTreatmentData(predictionData.label),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AgroScanTheme.primary,
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  final message = snapshot.error
                          ?.toString()
                          .replaceFirst('Exception: ', '') ??
                      'Could not load treatment guidance';
                  return AgroInfoBanner(
                    icon: Icons.error_outline_rounded,
                    text: message,
                    color: const Color(0xFFB3261E),
                  );
                }

                final treatments = snapshot.data ?? [];
                if (treatments.isEmpty) {
                  return const AgroEmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'No guidance available',
                    subtitle:
                        'Add a Diseases document in Firestore or run Setup disease treatments in Settings.',
                  );
                }

                return Column(
                  children: [
                    for (final item in treatments)
                      AgroDetailCard(
                        title: item.title,
                        body: item.body,
                        icon: item.icon,
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            const AgroInfoBanner(
              icon: Icons.info_outline_rounded,
              text:
                  'Follow product labels and local regulations. AgroScan guidance '
                  'is advisory — confirm with an agricultural professional when unsure.',
            ),
          ],
        ),
      ),
    );
  }
}

String? _readStringField(Map<String, dynamic> data, List<String> keys) {
  for (final key in keys) {
    final value = data[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
  }
  return null;
}

String _titleCase(String value) {
  return value
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .map((part) =>
          '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}')
      .join(' ');
}

Future<DocumentSnapshot?> _findDiseaseDoc(
  CollectionReference diseases,
  String diseaseName,
) async {
  final trimmed = diseaseName.trim();
  if (trimmed.isEmpty) return null;

  final candidates = <String>{
    trimmed,
    trimmed.toLowerCase(),
    trimmed.toUpperCase(),
    _titleCase(trimmed),
  };

  for (final id in candidates) {
    final snapshot = await diseases.doc(id).get();
    if (snapshot.exists) return snapshot;
  }
  return null;
}

Future<List<TreatmentAdvice>> fetchTreatmentData(String diseaseName) async {
  final diseases = FirebaseFirestore.instance.collection('Diseases');
  final label = diseaseName.trim();

  try {
    final docSnapshot = await _findDiseaseDoc(diseases, label);
    if (docSnapshot == null) {
      throw Exception(
        'No Firestore document for "$label". '
        'Use Settings → Setup disease treatments.',
      );
    }

    final data = docSnapshot.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Diseases/$label exists but has no fields.');
    }

    final cultural = _readStringField(data, [
      'Cultural Practices',
      'cultural_practices',
      'CulturalPractices',
    ]);
    final chemical = _readStringField(data, [
      'Chemical Control',
      'chemical_control',
      'ChemicalControl',
    ]);

    final treatments = <TreatmentAdvice>[
      if (cultural != null)
        TreatmentAdvice(
          title: 'Cultural Practices',
          body: cultural,
          icon: Icons.eco_outlined,
        ),
      if (chemical != null)
        TreatmentAdvice(
          title: 'Chemical Control',
          body: chemical,
          icon: Icons.science_outlined,
        ),
    ];

    if (treatments.isEmpty) {
      throw Exception(
        'Diseases/$label is missing Cultural Practices and Chemical Control fields.',
      );
    }

    if (kDebugMode) print('Treatments loaded for $label');
    return treatments;
  } on FirebaseException catch (e) {
    if (kDebugMode) print('error fetching treatments: $e');
    throw Exception('Firestore ${e.code}: ${e.message}');
  } catch (e) {
    if (kDebugMode) print('error fetching treatments: $e');
    if (e is Exception) rethrow;
    throw Exception('Error fetching treatments');
  }
}
