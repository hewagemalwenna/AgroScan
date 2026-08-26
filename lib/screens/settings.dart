import 'package:agroscan/screens/about_us.dart';
import 'package:agroscan/screens/profile_screen.dart';
import 'package:agroscan/screens/signin_screen.dart';
import 'package:agroscan/tools/app_theme.dart';
import 'package:agroscan/tools/firestore_seed.dart';
import 'package:agroscan/widgets/agro_ui.dart';
import 'package:agroscan/widgets/darkmode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'Signed-in AgroScan user';

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
          children: [
            Text(
              'Settings',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 27,
                      backgroundColor: AgroScanTheme.accentSoft,
                      foregroundColor: AgroScanTheme.primary,
                      child: Text(
                        email.characters.first.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your AgroScan account',
                            style: TextStyle(
                              color: AgroScanTheme.text,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AgroScanTheme.mutedText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const AgroSectionTitle('Account'),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.person_outline,
                    title: 'Profile',
                    subtitle: 'Review your account details',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditAccountScreen(),
                      ),
                    ),
                  ),
                  const Divider(height: 1, indent: 64),
                  _SettingsTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'Appearance',
                    subtitle: 'Choose light or dark mode',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DarkMode()),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const AgroSectionTitle('Information & Support'),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy And Responsible Use',
                    subtitle: 'How your data and scan results are handled',
                    onTap: () => _showPrivacyInformation(context),
                  ),
                  const Divider(height: 1, indent: 64),
                  _SettingsTile(
                    icon: Icons.groups_outlined,
                    title: 'About AgroScan',
                    subtitle: 'Project purpose and development team',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const AboutUsScreen(members: teamMembers),
                      ),
                    ),
                  ),
                  const Divider(height: 1, indent: 64),
                  _SettingsTile(
                    icon: Icons.cloud_upload_outlined,
                    title: 'Setup Default Data',
                    subtitle: 'Load Diseases treatments and Potato soil guidance',
                    onTap: () => _seedDiseaseTreatments(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => _signOut(context),
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFB3261E),
                side: const BorderSide(color: Color(0xFFE5B8B3)),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            const SizedBox(height: 14),
            const Center(
              child: Text(
                'AgroScan 1.0.0',
                style: TextStyle(
                  color: AgroScanTheme.mutedText,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    try {
      await GoogleSignIn().signOut();
    } catch (_) {
      // Email/password users may not have an active Google session.
    }
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SignInScreen()),
      (_) => false,
    );
  }

  void _showPrivacyInformation(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Privacy and responsible use'),
        content: const Text(
          'Plant images are analysed on the device. Account and crop-care '
          'records use Firebase services. Scan results are advisory and should '
          'not replace guidance from a qualified agricultural professional.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _seedDiseaseTreatments(BuildContext context) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await seedDefaultFirestoreData();
      if (!context.mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Disease treatments and Potato soil guidance loaded into Firestore.',
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context);
      final message = e.toString().toLowerCase().contains('permission')
          ? 'Firestore blocked the write. In Firebase Console → Firestore → Rules, '
              'allow authenticated writes to Diseases and Soil Condition (see firestore.rules in the project), '
              'Publish, sign in, then try again.'
          : 'Could not setup default data: $e';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 8)),
      );
    }
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AgroScanTheme.accentSoft,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AgroScanTheme.primary),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
