import 'package:agroscan/tools/app_theme.dart';
import 'package:flutter/material.dart';

class AgroBrandHeader extends StatelessWidget {
  const AgroBrandHeader({
    super.key,
    this.subtitle,
    this.compact = false,
  });

  final String? subtitle;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final logoSize = compact ? 52.0 : 72.0;

    return Column(
      children: [
        Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            gradient: AgroScanTheme.heroGradient,
            borderRadius: BorderRadius.circular(compact ? 16 : 20),
            boxShadow: AgroScanTheme.softShadow,
          ),
          child: const Icon(Icons.eco_rounded, color: Colors.white, size: 36),
        ),
        SizedBox(height: compact ? 12 : 18),
        Text(
          'AgroScan',
          style: TextStyle(
            fontSize: compact ? 26 : 32,
            fontWeight: FontWeight.w800,
            color: AgroScanTheme.text,
            letterSpacing: -0.8,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }
}

class AgroSectionTitle extends StatelessWidget {
  const AgroSectionTitle(this.title, {super.key, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        if (action != null) action!,
      ],
    );
  }
}

class AgroAuthShell extends StatelessWidget {
  const AgroAuthShell({
    super.key,
    required this.child,
    this.showBack = false,
    this.title,
  });

  final Widget child;
  final bool showBack;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AgroScanTheme.authGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (showBack)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(Icons.arrow_back_rounded),
                      style: IconButton.styleFrom(
                        backgroundColor: AgroScanTheme.surface,
                        foregroundColor: AgroScanTheme.text,
                      ),
                    ),
                  ),
                if (title != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    title!,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Crop care for modern growers',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 28),
                ] else ...[
                  const SizedBox(height: 16),
                  const AgroBrandHeader(
                    subtitle: 'Your crop care companion',
                  ),
                  const SizedBox(height: 32),
                ],
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AgroScanTheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AgroScanTheme.border),
                    boxShadow: AgroScanTheme.softShadow,
                  ),
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AgroInfoBanner extends StatelessWidget {
  const AgroInfoBanner({
    super.key,
    required this.icon,
    required this.text,
    this.color,
  });

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tone = color ?? AgroScanTheme.primary;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tone.withAlpha(20),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: tone.withAlpha(40)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: tone, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: tone, height: 1.4, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

/// Standard inner page: themed app bar + scrollable body on brand background.
class AgroPageScaffold extends StatelessWidget {
  const AgroPageScaffold({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.actions,
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgroScanTheme.background,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AgroScanTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: actions,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          children: [
            if (subtitle != null) ...[
              Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),
            ],
            body,
          ],
        ),
      ),
    );
  }
}

class AgroHeroChip extends StatelessWidget {
  const AgroHeroChip({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AgroScanTheme.heroGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AgroScanTheme.softShadow,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(36),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 14),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withAlpha(210),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AgroDetailCard extends StatelessWidget {
  const AgroDetailCard({
    super.key,
    required this.title,
    required this.body,
    required this.icon,
  });

  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AgroScanTheme.accentSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AgroScanTheme.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AgroScanTheme.text,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              body,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AgroScanTheme.text,
                    height: 1.55,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class AgroFormField extends StatelessWidget {
  const AgroFormField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.icon,
    this.keyboardType,
    this.readOnly = false,
    this.maxLines = 1,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final IconData? icon;
  final TextInputType? keyboardType;
  final bool readOnly;
  final int maxLines;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AgroScanTheme.mutedText,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          maxLines: maxLines,
          keyboardType: keyboardType,
          onSubmitted: onSubmitted,
          style: const TextStyle(color: AgroScanTheme.text),
          decoration: InputDecoration(
            hintText: hint ?? label,
            prefixIcon: icon != null
                ? Icon(icon, color: AgroScanTheme.mutedText, size: 22)
                : null,
          ),
        ),
      ],
    );
  }
}

class AgroEmptyState extends StatelessWidget {
  const AgroEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AgroScanTheme.accentSoft,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: AgroScanTheme.primary, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AgroScanTheme.text,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AgroLogCard extends StatelessWidget {
  const AgroLogCard({
    super.key,
    required this.plantType,
    required this.moisture,
    required this.nutrient,
    required this.pesticide,
  });

  final String plantType;
  final dynamic moisture;
  final dynamic nutrient;
  final dynamic pesticide;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AgroScanTheme.accentSoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.grass_rounded,
                      color: AgroScanTheme.primary, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    plantType.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AgroScanTheme.text,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _MetricRow(label: 'Moisture', value: moisture.toString()),
            _MetricRow(label: 'Nutrients', value: nutrient.toString()),
            _MetricRow(label: 'Pesticide volume', value: pesticide.toString()),
          ],
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AgroScanTheme.text,
            ),
          ),
        ],
      ),
    );
  }
}
