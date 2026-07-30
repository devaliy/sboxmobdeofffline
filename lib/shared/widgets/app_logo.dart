import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/theme.dart';

const String kSuccessBoxLogoAsset = 'sboxscreens/SuccessBOX-Logo.png';

/// Static brand lockup (logo + wordmark). The source asset is only
/// 212x56px, so [width] is capped to keep upscaling imperceptible —
/// use [AppMonogram] instead when a larger mark is needed (splash, auth
/// hero panels).
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.width = 150});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      kSuccessBoxLogoAsset,
      width: width.clamp(0, 260),
      filterQuality: FilterQuality.high,
    );
  }
}

/// Vector monogram derived from the generated app-icon art — crisp at any
/// size, used where the mockups show a large logo mark (splash, onboarding
/// carousel) that the low-res source PNG can't support cleanly.
class AppMonogram extends StatelessWidget {
  const AppMonogram({super.key, this.size = 96, this.glow = true});

  final double size;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final bars = <_Bar>[
      const _Bar(heightFactor: 0.55, colorT: 0.0),
      const _Bar(heightFactor: 0.85, colorT: 0.5),
      const _Bar(heightFactor: 0.68, colorT: 1.0),
    ];

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          if (glow)
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.signalOrange.withValues(alpha: 0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(bottom: size * 0.14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final bar in bars) ...[
                  Container(
                    width: size * 0.17,
                    height: size * bar.heightFactor * 0.5,
                    margin: EdgeInsets.symmetric(horizontal: size * 0.02),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(size * 0.1),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.lerp(AppColors.signalOrangeLight, AppColors.signalOrangeDeep, bar.colorT)!,
                          AppColors.signalOrange,
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar {
  const _Bar({required this.heightFactor, required this.colorT});
  final double heightFactor;
  final double colorT;
}

/// Entrance animation for the splash screen: monogram glow-pulses in, then
/// the wordmark fades up beneath it.
class AnimatedLogoIntro extends StatelessWidget {
  const AnimatedLogoIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppMonogram(size: 96)
            .animate()
            .scale(begin: const Offset(0.6, 0.6), curve: Curves.elasticOut, duration: 900.ms)
            .fadeIn(duration: 400.ms),
        const SizedBox(height: AppSpacing.xl),
        const AppLogo(width: 168)
            .animate(delay: 300.ms)
            .fadeIn(duration: 500.ms)
            .moveY(begin: 12, end: 0, curve: Curves.easeOutCubic),
      ],
    );
  }
}
