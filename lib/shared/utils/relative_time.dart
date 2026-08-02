import 'package:intl/intl.dart';

/// "Just now" / "5m ago" / "3h ago" / "2d ago", falling back to a plain
/// date past a week — used anywhere a timestamp is shown as a preview
/// (notifications, SuccessAI conversation list) rather than a full
/// datetime.
String relativeTime(DateTime dt) {
  final diff = DateTime.now().toUtc().difference(dt.toUtc());
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return DateFormat.yMMMd().format(dt);
}
