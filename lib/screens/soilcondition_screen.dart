import 'package:agroscan/tools/app_theme.dart';
import 'package:agroscan/widgets/agro_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SoilConditionPage extends StatefulWidget {
  const SoilConditionPage({super.key, this.initialPlantName});

  final String? initialPlantName;

  @override
  State<SoilConditionPage> createState() => SoilConditionPageState();
}

class SoilConditionPageState extends State<SoilConditionPage> {
  late final TextEditingController _plantNameController;
  late String _query;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialPlantName?.trim() ?? '';
    _plantNameController = TextEditingController(text: initial);
    _query = initial;
  }

  @override
  void dispose() {
    _plantNameController.dispose();
    super.dispose();
  }

  void _search() {
    setState(() => _query = _plantNameController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgroScanTheme.background,
      appBar: AppBar(
        title: const Text('Soil Guidance'),
        backgroundColor: AgroScanTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          children: [
            Text(
              'Look up growing conditions for a crop or plant type.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AgroFormField(
                      label: 'Plant name',
                      hint: 'e.g. Potato, Tomato',
                      icon: Icons.grass_outlined,
                      controller: _plantNameController,
                      onSubmitted: (_) => _search(),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _search,
                      icon: const Icon(Icons.search_rounded),
                      label: const Text('Find Conditions'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_query.isEmpty)
              const AgroEmptyState(
                icon: Icons.terrain_outlined,
                title: 'Search for a Plant',
                subtitle:
                    'Enter a crop name to view soil and growing guidance from Firestore.',
              )
            else
              FutureBuilder<String>(
                future: fetchSoilConditionData(_query),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AgroScanTheme.primary,
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return AgroInfoBanner(
                      icon: Icons.error_outline_rounded,
                      text: 'No soil guidance found for "$_query". '
                          'Check the plant name or add a document in Firestore.',
                      color: const Color(0xFFB3261E),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AgroHeroChip(
                        label: 'Plant',
                        value: _titleCase(_query),
                        icon: Icons.eco_outlined,
                      ),
                      const SizedBox(height: 16),
                      AgroDetailCard(
                        title: 'Soil Condition',
                        body: snapshot.data!,
                        icon: Icons.water_drop_outlined,
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

String? _readSoilConditionField(Map<String, dynamic> data) {
  for (final key in [
    'condition',
    'Soil Condition',
    'soilCondition',
    'SoilCondition',
  ]) {
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

Future<DocumentSnapshot?> _findSoilConditionDoc(
  CollectionReference plants,
  String plantName,
) async {
  final trimmed = plantName.trim();
  if (trimmed.isEmpty) return null;

  final candidates = <String>{
    trimmed,
    trimmed.toLowerCase(),
    trimmed.toUpperCase(),
    _titleCase(trimmed),
  };

  for (final id in candidates) {
    final snapshot = await plants.doc(id).get();
    if (snapshot.exists) return snapshot;
  }
  return null;
}

Future<String> fetchSoilConditionData(String plantName) async {
  final plants =
      FirebaseFirestore.instance.collection('Soil Condition');
  try {
    final docSnapshot = await _findSoilConditionDoc(plants, plantName);
    if (docSnapshot == null) throw Exception('Plant not found');

    final data = docSnapshot.data() as Map<String, dynamic>?;
    final soilCondition =
        data == null ? null : _readSoilConditionField(data);

    if (soilCondition == null) throw Exception('Plant not found');
    return soilCondition;
  } catch (e) {
    if (kDebugMode) print('Error fetching soil condition: $e');
    throw Exception('Error fetching soil condition');
  }
}
