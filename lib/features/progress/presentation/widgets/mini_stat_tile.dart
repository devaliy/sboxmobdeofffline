import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/widgets.dart';

/// A single compact stat tile (total tests / highest score / passed /
/// failed) — the four extra numbers the user asked for beyond the
/// Report.png mockup itself.
class MiniStatTile extends StatelessWidget {
  const MiniStatTile({
    super.key,
    required this.icon,
    required this.hue,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final PastelHue hue;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GlowCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          PastelIconBadge(icon: icon, hue: hue),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
