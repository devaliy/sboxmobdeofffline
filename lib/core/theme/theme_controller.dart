import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// App-wide theme mode. Lives in Riverpod (not local widget state) so any
/// screen — Settings' real toggle later, this M1 placeholder now — can
/// flip it. `shared_preferences` persistence is added when Settings (M9)
/// is built for real.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);
