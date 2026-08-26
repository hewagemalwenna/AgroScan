import 'package:agroscan/tools/app_theme.dart';
import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  const SquareTile({
    super.key,
    required this.imagePath,
    required this.onTap,
    this.label,
  });

  final String imagePath;
  final VoidCallback? onTap;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: AgroScanTheme.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AgroScanTheme.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(imagePath, height: 22, width: 22),
                if (label != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    label!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AgroScanTheme.text,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
