import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

/// The base surface used everywhere in the app instead of a raw [Card]:
/// rounded, theme-aware shadow, and an optional press-scale + glow
/// treatment when [onTap] is provided so every tappable card in the app
/// feels alive without each screen hand-rolling its own animation.
class GlowCard extends StatefulWidget {
  const GlowCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.color,
    this.borderRadius,
    this.glow = false,
    this.border,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;

  /// When true, uses the theme's colored glow shadow instead of the
  /// neutral card shadow — reserve for the one or two hero elements per
  /// screen, not every card, or "glowing" stops meaning anything.
  final bool glow;
  final BorderSide? border;

  @override
  State<GlowCard> createState() => _GlowCardState();
}

class _GlowCardState extends State<GlowCard> {
  bool _pressed = false;

  void _setPressed(bool v) {
    if (widget.onTap == null) return;
    setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(AppRadius.lg);
    final shadow = widget.glow ? context.glow.glowShadow : context.glow.cardShadow;
    final scheme = Theme.of(context).colorScheme;
    final side = widget.border ??
        BorderSide(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.outlineDark
              : AppColors.outlineLight,
        );

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: DecoratedBox(
          // Shadow-only wrapper — the fill color lives on the Material
          // below so ListTile/InkWell descendants get correct ink-splash
          // painting (a plain colored Container between them and their
          // Material ancestor would silently hide the splash).
          decoration: BoxDecoration(borderRadius: radius, boxShadow: shadow),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            child: Material(
              color: widget.color ?? scheme.surface,
              shape: RoundedRectangleBorder(borderRadius: radius, side: side),
              clipBehavior: Clip.antiAlias,
              child: Padding(padding: widget.padding, child: widget.child),
            ),
          ),
        ),
      ),
    );
  }
}
