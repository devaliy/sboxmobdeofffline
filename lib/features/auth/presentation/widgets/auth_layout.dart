import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/widgets.dart';

/// Shared responsive frame for Splash/Login/Register/Forgot-Password: a
/// glowing gradient hero (monogram + tagline) and a form area — split
/// left/right on desktop (matching the mockups' auth split-panel), stacked
/// top/bottom on mobile. One layout, two densities, per spec Section 1.8.
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
                SizedBox(height: 220, child: hero),
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
              padding: const EdgeInsets.all(AppSpacing.xxxl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppMonogram(size: compact ? 56 : 88)
                      .animate()
                      .scale(begin: const Offset(0.7, 0.7), curve: Curves.elasticOut, duration: 700.ms)
                      .fadeIn(),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'SuccessBOX',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                  ),
                  if (!compact) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      tagline,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                    ).animate(delay: 200.ms).fadeIn(duration: 500.ms).moveY(begin: 10, end: 0),
                  ],
                ],
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
