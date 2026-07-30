import 'package:flutter/material.dart';

/// Parses a `#RRGGBB` or `#AARRGGBB` string (as authored on the content
/// backend, e.g. `library_books.color`) into a [Color]. Falls back to
/// [fallback] for anything malformed rather than throwing — this is
/// server-authored content, not a value the app controls.
Color parseHexColor(String? hex, {Color fallback = Colors.grey}) {
  if (hex == null || hex.isEmpty) return fallback;
  var normalized = hex.trim().replaceFirst('#', '');
  if (normalized.length == 6) normalized = 'FF$normalized';
  if (normalized.length != 8) return fallback;
  final value = int.tryParse(normalized, radix: 16);
  return value == null ? fallback : Color(value);
}
