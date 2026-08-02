import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/network/endpoints.dart';
import '../../../core/reference/ng_classes.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/sync/sync_worker.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/utils/format_bytes.dart';
import '../../../shared/widgets/widgets.dart';
import '../../auth/application/auth_controller.dart';
import '../../auth/application/logout_flow.dart';
import '../../home/application/home_providers.dart';
import '../../setup/application/setup_controller.dart';
import '../../study_center/application/reader_prefs.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final user = ref.watch(currentUserProvider);
    final wifiOnly = ref.watch(wifiOnlyDownloadsProvider);
    final studyBytes = ref.watch(studyStorageUsedProvider).valueOrNull ?? 0;
    final assessmentBytes = ref.watch(assessmentStorageUsedProvider).valueOrNull ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xxl, AppSpacing.xxl, AppSpacing.xxl, AppSpacing.huge * 2,
        ),
        children: [
          GlowCard(
            glow: true,
            onTap: () => context.push(AppRoutes.profile),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.brandBlue,
                  child: Text(
                    user == null ? '?' : user.firstName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.fullName ?? 'Loading…',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        user == null
                            ? ''
                            : [
                                user.email,
                                if (classOptionByIdOrNull(user.currentClassId) case final c?) c.name,
                              ].join(' · '),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (user?.studentLinkCode != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Link code: ${user!.studentLinkCode}',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const _SyncSection(),
          const SizedBox(height: AppSpacing.xxl),
          GlowCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Dark mode'),
                  value: isDark,
                  onChanged: (v) => ref.read(themeModeProvider.notifier).state =
                      v ? ThemeMode.dark : ThemeMode.light,
                ),
                const Divider(),
                const _FontSizeSetting(),
                const Divider(),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Wi-Fi-only downloads'),
                  subtitle: const Text('Applies to new content in Setup'),
                  value: wifiOnly,
                  onChanged: (v) {
                    ref.read(wifiOnlyDownloadsProvider.notifier).state = v;
                    saveWifiOnlyPreference(v);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          GlowCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.download_for_offline_outlined),
                  title: const Text('Manage downloaded content'),
                  subtitle: Text(
                    'Study: ${formatBytes(studyBytes)} · Assessment: ${formatBytes(assessmentBytes)}',
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push(AppRoutes.setup),
                ),
                // Dev-only QA aid (spec Section 10) — never a real
                // destination, so it's unreachable outside debug builds
                // rather than just unlinked (Phase 8: "remove debug-only
                // screens").
                if (kDebugMode) ...[
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.palette_outlined),
                    title: const Text('Design system showcase (debug)'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push(AppRoutes.devShowcase),
                  ),
                ],
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.logout_rounded),
                  title: const Text('Log out'),
                  onTap: () => runLogoutFlow(context, ref),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Reading font size (spec Section 9) — the same preference the Reader's
/// own +/- control (M6) reads/writes, just exposed here too so it's
/// discoverable without opening a book first.
class _FontSizeSetting extends ConsumerStatefulWidget {
  const _FontSizeSetting();

  @override
  ConsumerState<_FontSizeSetting> createState() => _FontSizeSettingState();
}

class _FontSizeSettingState extends ConsumerState<_FontSizeSetting> {
  @override
  void initState() {
    super.initState();
    loadReaderFontSize().then((value) {
      if (mounted) ref.read(readerFontSizeProvider.notifier).state = value;
    });
  }

  void _setSize(double value) {
    ref.read(readerFontSizeProvider.notifier).state = value;
    saveReaderFontSize(value);
  }

  @override
  Widget build(BuildContext context) {
    final size = ref.watch(readerFontSizeProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          const Icon(Icons.text_fields_rounded),
          const SizedBox(width: AppSpacing.lg),
          const Expanded(child: Text('Reading font size')),
          IconButton(
            tooltip: 'Smaller',
            icon: const Icon(Icons.text_decrease_rounded),
            onPressed: size > kMinReaderFontSize ? () => _setSize(size - 1) : null,
          ),
          Text('${size.round()}', style: Theme.of(context).textTheme.labelLarge),
          IconButton(
            tooltip: 'Larger',
            icon: const Icon(Icons.text_increase_rounded),
            onPressed: size < kMaxReaderFontSize ? () => _setSize(size + 1) : null,
          ),
        ],
      ),
    );
  }
}

/// Sync status + manual "Sync now" (spec Section 1.6/8) — the one place
/// sync is ever *seen* rather than just felt, since a manual action
/// belongs somewhere findable even though it's silent everywhere else.
class _SyncSection extends ConsumerStatefulWidget {
  const _SyncSection();

  @override
  ConsumerState<_SyncSection> createState() => _SyncSectionState();
}

class _SyncSectionState extends ConsumerState<_SyncSection> {
  bool _syncing = false;
  DateTime? _lastSynced;

  @override
  void initState() {
    super.initState();
    _loadLastSynced();
  }

  /// Corroborates local `synced_at` timestamps with the server's own
  /// counts (API_DOCUMENTATION.md Section 5's `GET /sync/status`) —
  /// purely local state has nothing to show right after a reinstall even
  /// for an account with years of server-side history, so this is the
  /// more honest source whenever it's available.
  Future<void> _loadLastSynced() async {
    final db = ref.read(currentProgressDbProvider);
    final local = db == null ? null : await db.lastSyncedAt();

    DateTime? server;
    try {
      final status = await ref.read(syncEndpointsProvider).status();
      final timestamps = <String?>[
        (status['practice_attempts'] as Map?)?['last_received_at'] as String?,
        (status['reading_progress'] as Map?)?['last_received_at'] as String?,
      ].whereType<String>().map(DateTime.parse);
      if (timestamps.isNotEmpty) {
        server = timestamps.reduce((a, b) => a.isAfter(b) ? a : b);
      }
    } catch (_) {
      // Offline, or the endpoint erroring, is never worth surfacing here —
      // this is a corroborating signal, not the primary source of truth.
    }

    final candidates = <DateTime>[?local, ?server];
    final resolved = candidates.isEmpty ? null : candidates.reduce((a, b) => a.isAfter(b) ? a : b);
    if (mounted) setState(() => _lastSynced = resolved);
  }

  Future<void> _syncNow() async {
    setState(() => _syncing = true);
    await ref.read(syncWorkerProvider).flush();
    await _loadLastSynced();
    if (mounted) setState(() => _syncing = false);
  }

  String _describeLastSynced() {
    final at = _lastSynced;
    if (at == null) return 'Not synced yet';
    final elapsed = DateTime.now().toUtc().difference(at);
    if (elapsed.inMinutes < 1) return 'Last synced just now';
    if (elapsed.inMinutes < 60) return 'Last synced ${elapsed.inMinutes}m ago';
    if (elapsed.inHours < 24) return 'Last synced ${elapsed.inHours}h ago';
    return 'Last synced ${elapsed.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final pending = ref.watch(pendingSyncCountProvider).valueOrNull ?? 0;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlowCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Sync', style: textTheme.titleSmall),
                    const SizedBox(width: AppSpacing.sm),
                    Flexible(
                      child: pending == 0
                          ? const StatusPill(
                              label: 'Synced',
                              icon: Icons.check_circle_outline_rounded,
                              tone: StatusPillTone.success,
                            )
                          : StatusPill(
                              label: '$pending waiting',
                              tone: StatusPillTone.warning,
                              pulse: true,
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  _describeLastSynced(),
                  style: textTheme.bodySmall
                      ?.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
              ],
            ),
          ),
          // A bare Material button (unlike this app's own GradientButton)
          // can't tolerate the unbounded max-width every non-flex Row
          // child receives — Flexible gives it real, finite constraints
          // to size itself within while still hugging its own content.
          Flexible(
            child: OutlinedButton.icon(
              onPressed: _syncing ? null : _syncNow,
              icon: _syncing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.sync_rounded, size: 18),
              label: Text(_syncing ? 'Syncing…' : 'Sync now'),
            ),
          ),
        ],
      ),
    );
  }
}
