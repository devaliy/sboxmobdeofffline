import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _bookmarkedSubjectsKey = 'study_bookmarked_subjects';

Future<Set<int>> loadBookmarkedSubjectIds() async {
  final prefs = await SharedPreferences.getInstance();
  final stored = prefs.getStringList(_bookmarkedSubjectsKey) ?? const [];
  return stored.map(int.parse).toSet();
}

Future<void> _saveBookmarkedSubjectIds(Set<int> ids) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(_bookmarkedSubjectsKey, ids.map((id) => id.toString()).toList());
}

/// Bookmarked `library_subjects` ids — local-only (no server contract for
/// this), persisted the same way as the other lightweight device
/// preferences in this app (Wi-Fi-only downloads, reader font size): a
/// plain `SharedPreferences` value loaded once into a `StateProvider` that
/// [ReaderBookmarkController] toggles and re-persists on every change.
final bookmarkedSubjectsProvider = StateProvider<Set<int>>((ref) => const {});

class ReaderBookmarkController {
  ReaderBookmarkController(this._ref);
  final Ref _ref;

  Future<void> toggle(int subjectId) async {
    final current = Set<int>.from(_ref.read(bookmarkedSubjectsProvider));
    if (!current.remove(subjectId)) current.add(subjectId);
    _ref.read(bookmarkedSubjectsProvider.notifier).state = current;
    await _saveBookmarkedSubjectIds(current);
  }
}

final readerBookmarkControllerProvider =
    Provider<ReaderBookmarkController>((ref) => ReaderBookmarkController(ref));
