/// One 4/8pt spacing scale — every gap/padding in the app should reference
/// one of these instead of a magic number.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;
  static const double massive = 56;
}

/// One corner-radius scale.
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 28;
  static const double pill = 999;
}

/// Responsive breakpoints — branch by width, never by platform check, per
/// the spec's "one design system, two densities" principle.
abstract final class AppBreakpoints {
  /// Below this width: mobile single-column + bottom nav.
  /// At/above: desktop/tablet two-pane + top nav rail.
  static const double desktop = 900;
}
