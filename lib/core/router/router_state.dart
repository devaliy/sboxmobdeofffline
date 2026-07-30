import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/db_providers.dart';

/// Coarse auth state the router guard branches on. `unknown` is the
/// splash-screen state while a cached session is being checked. Driven by
/// [AuthController] (M3) — see `features/auth/application/auth_controller.dart`.
enum AuthStatus { unknown, loggedOut, loggedIn }

final authStatusProvider = StateProvider<AuthStatus>((ref) => AuthStatus.unknown);

/// Whether the signed-in account's device has at least one Study or
/// Assessment pack installed — the spec's "content gate" (Section 6). A
/// real derived query over `installed_study_packs` / `installed_
/// assessment_packs` (M4) — content is device-scoped (spec Section 3.1),
/// so this is deliberately not per-account.
final contentInstalledProvider = Provider<bool>((ref) {
  final study = ref.watch(installedStudyPacksProvider).valueOrNull ?? const [];
  final assessment = ref.watch(installedAssessmentPacksProvider).valueOrNull ?? const [];
  return study.isNotEmpty || assessment.isNotEmpty;
});
