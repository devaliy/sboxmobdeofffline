import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

const String kSuccessBoxLogoAsset = 'assets/branding/successbox_logo.png';

/// The real brand lockup (logo mark + wordmark), used everywhere a logo is
/// shown — there is no separate custom-drawn mark; this asset is it. The
/// source is only 212x56px, so [width] is capped to keep upscaling
/// imperceptible.
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

/// Splash-screen entrance: the real logo glow-scales in on the branded
/// dark backdrop.
class AnimatedLogoIntro extends StatelessWidget {
  const AnimatedLogoIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [Color(0x59FF7A1A), Colors.transparent],
            ),
          ),
        ),
        const AppLogo(width: 200)
            .animate()
            .scale(begin: const Offset(0.7, 0.7), curve: Curves.elasticOut, duration: 700.ms)
            .fadeIn(duration: 400.ms),
      ],
    );
  }
}
