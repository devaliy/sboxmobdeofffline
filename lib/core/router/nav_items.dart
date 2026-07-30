import 'package:flutter/material.dart';

/// The five main destinations (spec Section 6's bottom nav / left rail),
/// shared between the mobile bottom nav and desktop top nav so they can
/// never drift out of sync.
///
/// Icons: Material Symbols (built into Flutter core) — the spec's other
/// sanctioned choice (Section 5) after `lucide_icons` turned out to be
/// incompatible with the current Flutter SDK (it subclasses `IconData`,
/// which newer Flutter seals as `final`).
class NavItem {
  const NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

const List<NavItem> kMainNavItems = [
  NavItem(icon: Icons.home_rounded, label: 'Home'),
  NavItem(icon: Icons.menu_book_rounded, label: 'Study'),
  NavItem(icon: Icons.assignment_rounded, label: 'Practice'),
  NavItem(icon: Icons.insights_rounded, label: 'Progress'),
  NavItem(icon: Icons.settings_rounded, label: 'Settings'),
];
