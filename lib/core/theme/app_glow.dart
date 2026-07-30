import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Glow, gradient and elevation tokens — the "elevated beyond the mockups"
/// half of the design system. Registered on [ThemeData.extensions] so any
/// widget can do `Theme.of(context).extension<AppGlowTheme>()!`.
@immutable
class AppGlowTheme extends ThemeExtension<AppGlowTheme> {
  const AppGlowTheme({
    required this.primaryGradient,
    required this.heroGradient,
    required this.cardShadow,
    required this.glowShadow,
    required this.floatingShadow,
  });

  final Gradient primaryGradient;
  final Gradient heroGradient;
  final List<BoxShadow> cardShadow;
  final List<BoxShadow> glowShadow;
  final List<BoxShadow> floatingShadow;

  static const _primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.signalOrangeLight, AppColors.signalOrange, AppColors.signalOrangeDeep],
    stops: [0, 0.55, 1],
  );

  static const _heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.inkNavyDeep, AppColors.brandBlue],
  );

  static AppGlowTheme light() => AppGlowTheme(
        primaryGradient: _primaryGradient,
        heroGradient: _heroGradient,
        cardShadow: [
          BoxShadow(
            color: AppColors.inkNavy.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
        glowShadow: [
          BoxShadow(
            color: AppColors.signalOrange.withValues(alpha: 0.35),
            blurRadius: 28,
            spreadRadius: -4,
            offset: const Offset(0, 10),
          ),
        ],
        floatingShadow: [
          BoxShadow(
            color: AppColors.inkNavy.withValues(alpha: 0.14),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      );

  static AppGlowTheme dark() => AppGlowTheme(
        primaryGradient: _primaryGradient,
        heroGradient: _heroGradient,
        cardShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
        glowShadow: [
          BoxShadow(
            color: AppColors.signalOrange.withValues(alpha: 0.45),
            blurRadius: 32,
            spreadRadius: -2,
            offset: const Offset(0, 10),
          ),
        ],
        floatingShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.55),
            blurRadius: 36,
            offset: const Offset(0, 18),
          ),
        ],
      );

  @override
  AppGlowTheme copyWith({
    Gradient? primaryGradient,
    Gradient? heroGradient,
    List<BoxShadow>? cardShadow,
    List<BoxShadow>? glowShadow,
    List<BoxShadow>? floatingShadow,
  }) {
    return AppGlowTheme(
      primaryGradient: primaryGradient ?? this.primaryGradient,
      heroGradient: heroGradient ?? this.heroGradient,
      cardShadow: cardShadow ?? this.cardShadow,
      glowShadow: glowShadow ?? this.glowShadow,
      floatingShadow: floatingShadow ?? this.floatingShadow,
    );
  }

  @override
  ThemeExtension<AppGlowTheme> lerp(ThemeExtension<AppGlowTheme>? other, double t) {
    if (other is! AppGlowTheme) return this;
    return t < 0.5 ? this : other;
  }
}
