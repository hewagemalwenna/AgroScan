import 'package:agroscan/screens/soilcondition_screen.dart';
import 'package:agroscan/screens/tfmodel.dart';
import 'package:agroscan/tools/app_theme.dart';
import 'package:agroscan/widgets/agro_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UkCropSupportScreen extends StatelessWidget {
  const UkCropSupportScreen({super.key});

  static const _detectableProblems = [
    _ProblemInfo(
      label: 'Phytophthora',
      ukContext: 'Late blight — a major risk for UK potato crops in wet summers.',
      icon: Icons.water_drop_outlined,
    ),
    _ProblemInfo(
      label: 'Virus',
      ukContext: 'Potato virus Y (PVY), leaf roll, and mosaic-type symptoms.',
      icon: Icons.coronavirus_outlined,
    ),
    _ProblemInfo(
      label: 'Bacteria',
      ukContext: 'Blackleg, soft rot, and bacterial wilt-type leaf damage.',
      icon: Icons.biotech_outlined,
    ),
    _ProblemInfo(
      label: 'Fungi',
      ukContext: 'Early blight, powdery scab, and rhizoctonia-type foliar issues.',
      icon: Icons.spa_outlined,
    ),
    _ProblemInfo(
      label: 'Pest',
      ukContext: 'Aphids, leaf damage from insects, and Colorado beetle risk.',
      icon: Icons.pest_control_outlined,
    ),
    _ProblemInfo(
      label: 'Nematode',
      ukContext: 'Potato cyst nematode (PCN) — leaf signs are limited; soil tests help.',
      icon: Icons.grain_outlined,
    ),
    _ProblemInfo(
      label: 'Healthy',
      ukContext: 'No obvious disease class detected on the scanned leaf.',
      icon: Icons.eco_outlined,
    ),
  ];

  static const _ukResources = [
    _UkResource(
      name: 'AHDB Potatoes',
      url: 'https://ahdb.org.uk/potatoes',
      description: 'UK potato research, varieties, and best practice.',
    ),
    _UkResource(
      name: 'RHS — Grow Potatoes',
      url: 'https://www.rhs.org.uk/vegetables/potatoes/grow-your-own',
      description: 'Growing advice for home and allotment growers.',
    ),
    _UkResource(
      name: 'DEFRA',
      url: 'https://www.gov.uk/government/organisations/department-for-environment-food-rural-affairs',
      description: 'Department for Environment, Food & Rural Affairs.',
    ),
    _UkResource(
      name: 'UK Plant Health Service',
      url: 'https://planthealthportal.defra.gov.uk/',
      description: 'Report regulated pests and plant health concerns.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgroScanTheme.background,
      appBar: AppBar(
        title: const Text('UK Crop Support'),
        backgroundColor: AgroScanTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          children: [
            const AgroHeroChip(
              label: 'Built for UK growers',
              value: 'Potato',
              icon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 20),
            Text(
              'AgroScan is currently trained on potato leaf images. '
              'Use this guide to understand what the scanner can detect and '
              'where to find UK-specific support.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            const AgroSectionTitle('Supported Crop'),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AgroScanTheme.accentSoft,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'AVAILABLE NOW',
                            style: TextStyle(
                              color: AgroScanTheme.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Potato',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AgroScanTheme.text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '3,076 field photos · 7 problem classes · UK-relevant guidance',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'More UK crops (tomato, wheat, and others) will be added '
                      'after new training data is collected.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const AgroSectionTitle('Detectable Problems'),
            const SizedBox(height: 8),
            Text(
              'These match the labels returned after a leaf scan.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            for (final problem in _detectableProblems)
              AgroDetailCard(
                title: problem.label,
                body: problem.ukContext,
                icon: problem.icon,
              ),
            const SizedBox(height: 12),
            const AgroSectionTitle('UK Growing Notes'),
            const SizedBox(height: 12),
            const AgroDetailCard(
              title: 'Season',
              body: 'Maincrop planting: March–April. Harvest typically '
                  'September–October depending on variety and region.',
              icon: Icons.calendar_month_outlined,
            ),
            const AgroDetailCard(
              title: 'Climate',
              body: 'Wet UK summers increase late blight (Phytophthora) risk. '
                  'Monitor weather and inspect leaves regularly during humid periods.',
              icon: Icons.cloud_outlined,
            ),
            const AgroDetailCard(
              title: 'Soil',
              body: 'Potatoes prefer well-drained loam with pH around 5.5–6.0. '
                  'Use Soil Guidance to look up Potato conditions stored in Firestore.',
              icon: Icons.terrain_outlined,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const SoilConditionPage(initialPlantName: 'Potato'),
                      ),
                    ),
                    icon: const Icon(Icons.grass_outlined),
                    label: const Text('Soil Guidance'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TfModel()),
                    ),
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Scan Leaf'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const AgroSectionTitle('UK Resources'),
            const SizedBox(height: 12),
            for (final resource in _ukResources)
              _ResourceLinkCard(resource: resource),
            const SizedBox(height: 16),
            const AgroInfoBanner(
              icon: Icons.info_outline_rounded,
              text:
                  'AgroScan does not replace a qualified agronomist or plant clinic. '
                  'Use official UK sources for regulated pest reporting and commercial decisions.',
            ),
          ],
        ),
      ),
    );
  }
}

class _ProblemInfo {
  const _ProblemInfo({
    required this.label,
    required this.ukContext,
    required this.icon,
  });

  final String label;
  final String ukContext;
  final IconData icon;
}

class _UkResource {
  const _UkResource({
    required this.name,
    required this.url,
    required this.description,
  });

  final String name;
  final String url;
  final String description;
}

class _ResourceLinkCard extends StatelessWidget {
  const _ResourceLinkCard({required this.resource});

  final _UkResource resource;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Clipboard.setData(ClipboardData(text: resource.url));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Link copied: ${resource.url}')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AgroScanTheme.accentSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.link_rounded, color: AgroScanTheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resource.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AgroScanTheme.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      resource.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      resource.url,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AgroScanTheme.primaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.copy_rounded,
                  size: 18, color: AgroScanTheme.mutedText),
            ],
          ),
        ),
      ),
    );
  }
}
