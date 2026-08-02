import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/widgets.dart';

/// Shared responsive frame for Splash/Login/Register/Forgot-Password: a
/// glowing gradient hero (a floating card carrying the real logo + brand
/// illustration + tagline) and a form area — split left/right on desktop
/// (matching the mockups' auth split-panel), stacked top/bottom on mobile.
/// One layout, two densities, per spec Section 1.8.
class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.tagline,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String tagline;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= AppBreakpoints.desktop;
          final hero = _Hero(tagline: tagline, compact: !isDesktop);
          final form = _FormArea(title: title, subtitle: subtitle, child: child);

          if (isDesktop) {
            return Row(
              children: [
                Expanded(flex: 5, child: hero),
                Expanded(flex: 6, child: Center(child: form)),
              ],
            );
          }

          return SafeArea(
            child: Column(
              children: [
                // Sized by its own content, not a fixed box — a hard-coded
                // height here is exactly what silently clipped the hero
                // card before (spec Section 9's text-scale requirement
                // makes this a real risk, not just a hypothetical one).
                hero,
                Expanded(child: SingleChildScrollView(child: form)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.tagline, required this.compact});
  final String tagline;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(gradient: context.glow.primaryGradient),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -40,
            child: _glowCircle(120),
          ),
          Positioned(
            bottom: -60,
            left: -30,
            child: _glowCircle(160),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(compact ? AppSpacing.xl : AppSpacing.xxxl),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.xxl),
                    boxShadow: const [
                      BoxShadow(color: Color(0x33000000), blurRadius: 24, offset: Offset(0, 12)),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppLogo(width: compact ? 130 : 160)
                          .animate()
                          .scale(begin: const Offset(0.85, 0.85), curve: Curves.easeOutBack, duration: 600.ms)
                          .fadeIn(),
                      SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),
                      Image.asset(
                        'assets/branding/learning_illustration.png',
                        width: compact ? 150 : 220,
                      ).animate(delay: 150.ms).fadeIn(duration: 500.ms).moveY(begin: 12, end: 0),
                      if (!compact) ...[
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          tagline,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.inkNavy.withValues(alpha: 0.75)),
                        ).animate(delay: 300.ms).fadeIn(duration: 500.ms).moveY(begin: 10, end: 0),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glowCircle(double size) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.08),
        ),
      );
}

class _FormArea extends StatelessWidget {
  const _FormArea({required this.title, required this.subtitle, required this.child});
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Text(title, style: textTheme.headlineMedium).animate().fadeIn().moveY(begin: 8, end: 0),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              style: textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            child,
          ],
        ),
      ),
    );
  }
}
