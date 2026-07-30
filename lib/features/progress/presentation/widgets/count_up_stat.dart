import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/widgets.dart';

/// A single stat (points, streak, attempts) that counts up from 0 whenever
/// [value] changes — the same `TweenAnimationBuilder` approach as
/// [AnimatedProgressRing], just for integers instead of a sweep angle.
class CountUpStat extends StatelessWidget {
  const CountUpStat({super.key, required this.value, required this.label, required this.icon, this.hue});

  final int value;
  final String label;
  final IconData icon;
  final Color? hue;

  @override
  Widget build(BuildContext context) {
    final color = hue ?? AppColors.signalOrange;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlowCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: AppSpacing.sm),
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: value),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, animatedValue, _) => Text(
              '$animatedValue',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
          ),
        ],
      ),
    );
  }
}
