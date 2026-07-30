import 'package:flutter/material.dart';

/// Brand palette, sampled and elevated from the SuccessBOX mockups
/// (sboxscreens/, desktopscreens/) and the source logo. This is the single
/// source of truth for color — nothing outside `core/theme` should hardcode
/// a hex value.
abstract final class AppColors {
  // Ink / navy — dark surfaces, headers, primary text-on-light.
  static const Color inkNavy = Color(0xFF232842);
  static const Color inkNavyDeep = Color(0xFF181B2E);
  static const Color inkNavyDeeper = Color(0xFF12142A);

  // Brand blue — logo wordmark, links, secondary accent.
  static const Color brandBlue = Color(0xFF2E4C9A);
  static const Color brandBlueLight = Color(0xFF4E6FC7);

  // Signal orange — primary CTA, active states, the logo's "flame".
  static const Color signalOrange = Color(0xFFFF7A1A);
  static const Color signalOrangeLight = Color(0xFFFFA24C);
  static const Color signalOrangeDeep = Color(0xFFE85D04);

  // Semantic.
  static const Color success = Color(0xFF2FBF71);
  static const Color warning = Color(0xFFF5B301);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Neutrals.
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF6F7FB);
  static const Color surfaceDark = Color(0xFF1E2238);
  static const Color backgroundDark = Color(0xFF14162A);
  static const Color outlineLight = Color(0xFFE3E6F0);
  static const Color outlineDark = Color(0xFF33385A);
  static const Color textMutedLight = Color(0xFF6B7089);
  static const Color textMutedDark = Color(0xFF9BA0C0);

  // Pastel resource-tile hues (Home quick actions, subject chips), each
  // with a light-surface tint and a saturated foreground/icon tone, plus a
  // dark-mode-safe deep tint so contrast holds in both themes.
  static const PastelHue coral = PastelHue(
    tintLight: Color(0xFFFDE3E1),
    tintDark: Color(0xFF3A2430),
    foreground: Color(0xFFF2665A),
  );
  static const PastelHue sky = PastelHue(
    tintLight: Color(0xFFDBF2F8),
    tintDark: Color(0xFF1C3542),
    foreground: Color(0xFF1F9DBF),
  );
  static const PastelHue lavender = PastelHue(
    tintLight: Color(0xFFE6E0FB),
    tintDark: Color(0xFF2C2A50),
    foreground: Color(0xFF7C6AE8),
  );
  static const PastelHue sunflower = PastelHue(
    tintLight: Color(0xFFFCF0CE),
    tintDark: Color(0xFF3E3420),
    foreground: Color(0xFFE0A419),
  );
  static const PastelHue mint = PastelHue(
    tintLight: Color(0xFFD9F5E6),
    tintDark: Color(0xFF1C3A2C),
    foreground: Color(0xFF23A870),
  );
  static const PastelHue rose = PastelHue(
    tintLight: Color(0xFFFBE1EE),
    tintDark: Color(0xFF3A2434),
    foreground: Color(0xFFDD5A97),
  );
}

/// A tint/foreground pairing used for pastel resource tiles and subject
/// chips, with light and dark-mode-safe variants baked in.
class PastelHue {
  const PastelHue({
    required this.tintLight,
    required this.tintDark,
    required this.foreground,
  });

  final Color tintLight;
  final Color tintDark;
  final Color foreground;

  Color tint(Brightness brightness) =>
      brightness == Brightness.dark ? tintDark : tintLight;
}
