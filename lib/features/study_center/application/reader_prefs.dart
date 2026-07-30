import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persisted font-size preference (spec Section 9: "font-size preference"
/// is one of Settings' listed options) — read here so it's shared between
/// the Reader's own +/- control and Settings (M9) without either owning it.
final readerFontSizeProvider = StateProvider<double>((ref) => 17.0);

const _fontSizePrefsKey = 'reader_font_size';
const double kMinReaderFontSize = 14.0;
const double kMaxReaderFontSize = 24.0;

Future<double> loadReaderFontSize() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getDouble(_fontSizePrefsKey) ?? 17.0;
}

Future<void> saveReaderFontSize(double value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setDouble(_fontSizePrefsKey, value);
}
