import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

enum StatusPillTone { neutral, success, warning, danger, info }

/// The small, calm status indicator used for sync state ("Synced just
/// now" / "3 results waiting to sync"), pack version tags, and similar
/// ambient text — never a blocking dialog, per spec Section 1.6.
class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    this.icon,
    this.tone = StatusPillTone.neutral,
    this.pulse = false,
  });

  final String label;
  final IconData? icon;
  final StatusPillTone tone;

  /// Subtle breathing-dot animation — reserve for "actively syncing".
  final bool pulse;

  Color _color(BuildContext context) {
    switch (tone) {
      case StatusPillTone.success:
        return AppColors.success;
      case StatusPillTone.warning:
        return AppColors.warning;
      case StatusPillTone.danger:
        return AppColors.danger;
      case StatusPillTone.info:
        return AppColors.info;
      case StatusPillTone.neutral:
        return Theme.of(context).brightness == Brightness.dark
            ? AppColors.textMutedDark
            : AppColors.textMutedLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pulse)
            _PulsingDot(color: color)
          else if (icon != null)
            Icon(icon, size: 13, color: color),
          if (pulse || icon != null) const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              label,
              style: textTheme.labelSmall?.copyWith(color: color),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot({required this.color});
  final Color color;

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.35, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}
