import 'package:agroscan/Model/plant_data.dart';
import 'package:agroscan/tools/app_theme.dart';
import 'package:agroscan/tools/auth_service.dart';
import 'package:agroscan/widgets/agro_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'log_screen.dart';

class StoringPage extends StatefulWidget {
  const StoringPage({super.key});

  @override
  State<StoringPage> createState() => _StoringPageState();
}

class _StoringPageState extends State<StoringPage> {
  final _plantTypeController = TextEditingController();
  final _moistureController = TextEditingController();
  final _nutrientController = TextEditingController();
  final _pesticideController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _plantTypeController.dispose();
    _moistureController.dispose();
    _nutrientController.dispose();
    _pesticideController.dispose();
    super.dispose();
  }

  Future<void> _updateFirestore(Plantdata plant) async {
    final logs =
        FirebaseFirestore.instance.collection('Logs').doc(await getUserId());
    final entry = plant.toJson();
    final snapshot = await logs.get();
    if (snapshot.exists) {
      await logs.update({'log': FieldValue.arrayUnion([entry])});
    } else {
      await logs.set({'log': FieldValue.arrayUnion([entry])});
    }
  }

  void _openLogScreen(Plantdata plant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LogScreenPage(
          plantType: plant.plantType ?? '',
          moistureLevel: plant.moistureLevel ?? 0,
          nutrientLevel: plant.nutrientLevel ?? 0,
          pesticideVolume: plant.pesticideVolume ?? 0,
          message: 'Crop Records',
          plantdata: plant,
        ),
      ),
    );
  }

  Future<void> _save() async {
    final plantType = _plantTypeController.text.trim();
    final moisture = int.tryParse(_moistureController.text.trim());
    final nutrient = int.tryParse(_nutrientController.text.trim());
    final pesticide = int.tryParse(_pesticideController.text.trim());

    if (plantType.isEmpty ||
        moisture == null ||
        nutrient == null ||
        pesticide == null) {
      _openLogScreen(
        Plantdata(
          plantType: '',
          moistureLevel: 0,
          nutrientLevel: 0,
          pesticideVolume: 0,
        ),
      );
      return;
    }

    final plant = Plantdata(
      plantType: plantType,
      moistureLevel: moisture,
      nutrientLevel: nutrient,
      pesticideVolume: pesticide,
    );

    setState(() => _saving = true);
    try {
      await _updateFirestore(plant);
      if (!mounted) return;
      _openLogScreen(plant);
    } catch (e) {
      if (kDebugMode) print('Error updating Firestore: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save crop record. Try again.')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgroScanTheme.background,
      appBar: AppBar(
        title: const Text('Crop Records'),
        backgroundColor: AgroScanTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          children: [
            Text(
              'Log crop-care activity to keep your field records organised.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    AgroFormField(
                      label: 'Plant type',
                      hint: 'e.g. Potato',
                      icon: Icons.grass_outlined,
                      controller: _plantTypeController,
                    ),
                    const SizedBox(height: 16),
                    AgroFormField(
                      label: 'Moisture level',
                      hint: 'Numeric value',
                      icon: Icons.water_drop_outlined,
                      controller: _moistureController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    AgroFormField(
                      label: 'Nutrient level',
                      hint: 'Numeric value',
                      icon: Icons.science_outlined,
                      controller: _nutrientController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    AgroFormField(
                      label: 'Pesticide volume',
                      hint: 'Numeric value',
                      icon: Icons.opacity_outlined,
                      controller: _pesticideController,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(_saving ? 'Saving…' : 'Save & view logs'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _openLogScreen(
                Plantdata(
                  plantType: '',
                  moistureLevel: 0,
                  nutrientLevel: 0,
                  pesticideVolume: 0,
                ),
              ),
              icon: const Icon(Icons.history_rounded),
              label: const Text('View Existing Records'),
            ),
          ],
        ),
      ),
    );
  }
}
