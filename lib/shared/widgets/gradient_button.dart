import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

/// Primary CTA across the app: pill shape, brand gradient, soft glow,
/// press-scale feedback, and a built-in loading state so screens never
/// hand-roll "disable button + show spinner" logic differently.
class GradientButton extends StatefulWidget {
  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.loading = false,
    this.expand = true,
    this.dense = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final bool expand;
  final bool dense;

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null || widget.loading;
    final height = widget.dense ? 44.0 : 56.0;
    final textTheme = Theme.of(context).textTheme;

    final button = AnimatedScale(
      scale: _pressed ? 0.96 : 1,
      duration: const Duration(milliseconds: 110),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: disabled && !widget.loading ? 0.5 : 1,
        duration: const Duration(milliseconds: 150),
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          decoration: BoxDecoration(
            gradient: context.glow.primaryGradient,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            boxShadow: disabled ? null : context.glow.glowShadow,
          ),
          child: Row(
            mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.loading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                )
              else if (widget.icon != null) ...[
                Icon(widget.icon, color: Colors.white, size: 20),
                const SizedBox(width: AppSpacing.sm),
              ],
              if (!widget.loading) ...[
                Flexible(
                  child: Text(
                    widget.label,
                    style: textTheme.labelLarge?.copyWith(color: Colors.white, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    return GestureDetector(
      onTapDown: disabled ? null : (_) => setState(() => _pressed = true),
      onTapCancel: disabled ? null : () => setState(() => _pressed = false),
      onTapUp: disabled ? null : (_) => setState(() => _pressed = false),
      onTap: disabled ? null : widget.onPressed,
      child: widget.expand ? button : IntrinsicWidth(child: button),
    );
  }
}
