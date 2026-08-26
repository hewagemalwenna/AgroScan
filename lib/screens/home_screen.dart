import 'package:agroscan/screens/responsible_advice_screen.dart';
import 'package:agroscan/screens/soilcondition_screen.dart';
import 'package:agroscan/screens/storing_screen.dart';
import 'package:agroscan/screens/tfmodel.dart';
import 'package:agroscan/screens/uk_crop_support_screen.dart';
import 'package:agroscan/tools/app_theme.dart';
import 'package:agroscan/widgets/agro_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final name = _displayName(user);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _greeting(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: AgroScanTheme.heroGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AgroScanTheme.softShadow,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        name.characters.first.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              sliver: SliverToBoxAdapter(
                child: _ScanHero(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TfModel()),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: AgroSectionTitle('Crop Care Tools'),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.86,
                children: [
                  _FeatureCard(
                    icon: Icons.note_add_outlined,
                    title: 'Crop Records',
                    description: 'Log pesticide use and crop-care activity.',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const StoringPage()),
                    ),
                  ),
                  _FeatureCard(
                    icon: Icons.grass_outlined,
                    title: 'Soil Guidance',
                    description: 'Review suitable growing conditions.',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SoilConditionPage(),
                      ),
                    ),
                  ),
                  _FeatureCard(
                    icon: Icons.location_on_outlined,
                    title: 'UK Crop Support',
                    description: 'UK potato guidance, detectable problems, and resources.',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UkCropSupportScreen(),
                      ),
                    ),
                  ),
                  _FeatureCard(
                    icon: Icons.verified_user_outlined,
                    title: 'Responsible Advice',
                    description: 'Model limits, scan tips, and when to seek help.',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ResponsibleAdviceScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _displayName(User? user) {
    final suppliedName = user?.displayName?.trim();
    if (suppliedName != null && suppliedName.isNotEmpty) return suppliedName;
    final email = user?.email;
    if (email != null && email.contains('@')) return email.split('@').first;
    return 'Grower';
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}

class _ScanHero extends StatelessWidget {
  const _ScanHero({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(28),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            gradient: AgroScanTheme.heroGradient,
            borderRadius: BorderRadius.circular(28),
            boxShadow: AgroScanTheme.softShadow,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Scan a Leaf in Seconds',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Photograph a leaf to check for possible disease.',
                  style: TextStyle(
                    color: Colors.white.withAlpha(210),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_alt_outlined,
                          color: AgroScanTheme.primary, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Start Scan',
                        style: TextStyle(
                          color: AgroScanTheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded,
                          color: AgroScanTheme.primary, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AgroScanTheme.surface,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AgroScanTheme.border),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AgroScanTheme.accentSoft,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(icon, color: AgroScanTheme.primary),
                    ),
                    if (onTap != null)
                      const Icon(Icons.arrow_outward_rounded,
                          size: 18, color: AgroScanTheme.mutedText),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AgroScanTheme.text,
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: Text(
                    description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          height: 1.35,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
