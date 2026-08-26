import 'package:agroscan/tools/app_theme.dart';
import 'package:agroscan/widgets/agro_ui.dart';
import 'package:agroscan/widgets/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DarkMode extends StatelessWidget {
  const DarkMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgroScanTheme.background,
      appBar: AppBar(
        title: const Text('Appearance'),
        backgroundColor: AgroScanTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Consumer<UiProvider>(
          builder: (context, notifier, _) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
              children: [
                Text(
                  'Choose how AgroScan looks on your device.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                Card(
                  child: SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 6,
                    ),
                    secondary: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AgroScanTheme.accentSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        notifier.isDark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        color: AgroScanTheme.primary,
                      ),
                    ),
                    title: const Text(
                      'Dark Theme',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text('Reduce glare in low-light conditions'),
                    value: notifier.isDark,
                    activeTrackColor: AgroScanTheme.primary.withAlpha(80),
                    thumbColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return AgroScanTheme.primary;
                      }
                      return AgroScanTheme.border;
                    }),
                    onChanged: (_) => notifier.changeTheme(),
                  ),
                ),
                const SizedBox(height: 16),
                const AgroInfoBanner(
                  icon: Icons.palette_outlined,
                  text:
                      'Light mode is optimised for field use in daylight. Dark mode '
                      'support will expand in future releases.',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
