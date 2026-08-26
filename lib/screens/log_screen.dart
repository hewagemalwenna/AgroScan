import 'package:agroscan/Model/plant_data.dart';
import 'package:agroscan/screens/storing_screen.dart';
import 'package:agroscan/tools/app_theme.dart';
import 'package:agroscan/tools/auth_service.dart';
import 'package:agroscan/widgets/agro_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LogScreenPage extends StatefulWidget {
  const LogScreenPage({
    super.key,
    required this.message,
    required this.plantType,
    required this.moistureLevel,
    required this.nutrientLevel,
    required this.pesticideVolume,
    required this.plantdata,
  });

  final String message;
  final String plantType;
  final int moistureLevel;
  final int nutrientLevel;
  final int pesticideVolume;
  final Plantdata plantdata;

  @override
  State<LogScreenPage> createState() => LogScreenPageState();
}

class LogScreenPageState extends State<LogScreenPage> {
  List<dynamic> _logEntries = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final logs =
          FirebaseFirestore.instance.collection('Logs').doc(await getUserId());
      final documentSnapshot = await logs.get();

      if (!documentSnapshot.exists) {
        if (!mounted) return;
        setState(() {
          _logEntries = [];
          _loading = false;
        });
        return;
      }

      final data = documentSnapshot.data();
      final entries = List<dynamic>.from(data?['log'] ?? []);

      if (!mounted) return;
      setState(() {
        _logEntries = entries.reversed.toList();
        _loading = false;
      });
    } catch (e) {
      if (kDebugMode) print('Error fetching logs: $e');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Could not load crop records';
      });
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
        actions: [
          IconButton(
            onPressed: _fetchLogs,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: SafeArea(
        child: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StoringPage()),
        ),
        backgroundColor: AgroScanTheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Record'),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: AgroScanTheme.primary),
      );
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: AgroInfoBanner(
          icon: Icons.error_outline_rounded,
          text: _error!,
          color: const Color(0xFFB3261E),
        ),
      );
    }

    if (_logEntries.isEmpty) {
      return const AgroEmptyState(
        icon: Icons.note_alt_outlined,
        title: 'No Crop Records Yet',
        subtitle: 'Save your first log from the Crop Records form.',
      );
    }

    return RefreshIndicator(
      color: AgroScanTheme.primary,
      onRefresh: _fetchLogs,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 88),
        itemCount: _logEntries.length,
        itemBuilder: (context, index) {
          final logEntry = _logEntries[index];
          if (logEntry is! Map) return const SizedBox.shrink();

          return AgroLogCard(
            plantType: logEntry['plantType'] ?? 'Unknown plant',
            moisture: logEntry['moistureLevel'] ?? '-',
            nutrient: logEntry['nutrientLevel'] ?? '-',
            pesticide: logEntry['pesticideVolume'] ?? '-',
          );
        },
      ),
    );
  }
}
