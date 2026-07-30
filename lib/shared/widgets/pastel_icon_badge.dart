import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

/// The rounded pastel icon tile seen throughout the mockups (Home
/// resource cards, subject chips). Tint automatically flips to a
/// dark-mode-safe variant.
class PastelIconBadge extends StatelessWidget {
  const PastelIconBadge({
    super.key,
    required this.icon,
    required this.hue,
    this.size = 44,
  });

  final IconData icon;
  final PastelHue hue;
  final double size;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: hue.tint(brightness),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Icon(icon, color: hue.foreground, size: size * 0.5),
    );
  }
}
