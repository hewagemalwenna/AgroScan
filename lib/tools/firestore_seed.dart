import 'package:cloud_firestore/cloud_firestore.dart';

/// Default treatment copy for each disease label used by the TFLite model.
/// Document IDs must match [assets/plant_disease_labels.txt] exactly.
const Map<String, Map<String, String>> kDefaultDiseaseTreatments = {
  'Bacteria': {
    'Cultural Practices':
        'Remove and destroy severely infected leaves. Avoid overhead watering, improve airflow, and disinfect tools after pruning.',
    'Chemical Control':
        'Apply a copper-based bactericide according to the product label. Repeat as directed during humid weather.',
  },
  'Fungi': {
    'Cultural Practices':
        'Remove diseased foliage, avoid wetting leaves, water at soil level, and space plants for better air circulation.',
    'Chemical Control':
        'Use a suitable fungicide labeled for the crop and pathogen. Rotate active ingredients to reduce resistance.',
  },
  'Nematode': {
    'Cultural Practices':
        'Rotate crops, remove heavily infested plants, and improve soil organic matter. Avoid moving soil from affected areas.',
    'Chemical Control':
        'Where permitted, apply a nematicide or soil treatment labeled for the crop. Follow local regulations carefully.',
  },
  'Pest': {
    'Cultural Practices':
        'Hand-pick visible pests where practical, remove heavily damaged leaves, and encourage beneficial insects.',
    'Chemical Control':
        'Apply an insecticide labeled for the observed pest and crop. Prefer selective products and follow the label rate.',
  },
  'Phytophthora': {
    'Cultural Practices':
        'Improve drainage, avoid waterlogging, remove infected plant parts promptly, and sanitize tools and containers.',
    'Chemical Control':
        'Apply a fungicide labeled for Phytophthora / late blight type diseases on UK potatoes, following label intervals.',
  },
  'Virus': {
    'Cultural Practices':
        'Remove and destroy infected plants, control insect vectors, and wash hands/tools after handling diseased material.',
    'Chemical Control':
        'There is no direct cure for plant viruses. Focus on vector control with labeled insecticides if insects are spreading the disease.',
  },
};

/// Default soil guidance for the supported UK crop in the current model.
const Map<String, String> kDefaultSoilConditions = {
  'Potato': 'Well-drained loam or sandy loam with pH 5.5–6.0 is ideal for UK '
      'potatoes. Avoid waterlogged soils — they increase disease risk including '
      'late blight. Rotate potato crops to reduce nematode and disease build-up. '
      'Incorporate organic matter before planting and ensure good drainage in '
      'high-rainfall regions. Maincrop planting: March–April; harvest typically '
      'September–October.',
};

/// Writes default treatment docs into the `Diseases` collection.
Future<void> seedDiseaseTreatments() async {
  final collection = FirebaseFirestore.instance.collection('Diseases');
  final batch = FirebaseFirestore.instance.batch();

  kDefaultDiseaseTreatments.forEach((docId, fields) {
    batch.set(collection.doc(docId), fields, SetOptions(merge: true));
  });

  await batch.commit();
}

/// Writes default soil docs into the `Soil Condition` collection.
Future<void> seedSoilConditions() async {
  final collection = FirebaseFirestore.instance.collection('Soil Condition');
  final batch = FirebaseFirestore.instance.batch();

  kDefaultSoilConditions.forEach((docId, condition) {
    batch.set(
      collection.doc(docId),
      {'condition': condition},
      SetOptions(merge: true),
    );
  });

  await batch.commit();
}

/// Seeds Diseases and Soil Condition defaults for the current potato-focused app.
Future<void> seedDefaultFirestoreData() async {
  await seedDiseaseTreatments();
  await seedSoilConditions();
}
