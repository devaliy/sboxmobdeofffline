import 'package:flutter/material.dart';

/// Type scale: Poppins for display/headline/title/label (matches the
/// mockups' geometric rounded weight), Inter for body/long-form reading
/// (Study Center content). Both are bundled as real assets declared in
/// pubspec.yaml's `fonts:` section — plain `TextStyle(fontFamily: ...)`
/// resolves them directly via Flutter's normal font pipeline, which is
/// deliberate rather than calling the `google_fonts` package's
/// `GoogleFonts.poppins()`/`.inter()` helpers: those don't just use the
/// registered family name, they separately verify the bundled asset's
/// *filename* matches Google Fonts' own per-weight naming convention
/// (e.g. `Poppins-Regular.ttf`) and throw if it doesn't — which our
/// single-file bundled `Inter-Variable.ttf` fails despite being a
/// perfectly valid, correctly-registered font. Going straight through
/// `TextStyle` sidesteps that matching entirely and still guarantees zero
/// network fetches, since it never leaves the bundled-asset path.
abstract final class AppTypography {
  static TextTheme textTheme(Color onSurface) {
    const poppins = 'Poppins';
    const inter = 'Inter';

    final base = TextTheme(
      displayLarge: const TextStyle(
        fontFamily: poppins,
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 1.15,
        letterSpacing: -0.5,
      ),
      displayMedium: const TextStyle(
        fontFamily: poppins,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.18,
        letterSpacing: -0.4,
      ),
      headlineLarge: const TextStyle(
        fontFamily: poppins,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      headlineMedium: const TextStyle(
        fontFamily: poppins,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.22,
      ),
      headlineSmall: const TextStyle(
        fontFamily: poppins,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),
      titleLarge: const TextStyle(
        fontFamily: poppins,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      titleMedium: const TextStyle(
        fontFamily: poppins,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      titleSmall: const TextStyle(
        fontFamily: poppins,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      bodyLarge: const TextStyle(
        fontFamily: inter,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodyMedium: const TextStyle(
        fontFamily: inter,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodySmall: const TextStyle(
        fontFamily: inter,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.45,
      ),
      labelLarge: const TextStyle(
        fontFamily: poppins,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.1,
      ),
      labelMedium: const TextStyle(
        fontFamily: poppins,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.2,
      ),
      labelSmall: const TextStyle(
        fontFamily: poppins,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.3,
      ),
    );
    return base.apply(bodyColor: onSurface, displayColor: onSurface);
  }

  /// Second, humanist family reserved for long-form Study Center reading,
  /// used only inside the HTML reader's font-size-adjustable body text.
  static TextStyle readingBody({required double fontSize, required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: fontSize,
        height: 1.65,
        color: color,
      );
}
