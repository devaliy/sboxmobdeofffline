import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/db_providers.dart';
import '../../../core/reference/ng_classes.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/router/router_state.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/utils/format_bytes.dart';
import '../../../shared/widgets/widgets.dart';
import '../../auth/application/auth_controller.dart';
import '../application/setup_controller.dart';
import '../domain/content_pack_manifest.dart';
import 'widgets/pack_card.dart';

/// "Get your content" — the spec's central onboarding centerpiece
/// (Section 7), not an apologetic loading bar. Two independent
/// Study/Assessment panels, live size totals, Wi-Fi-only gating, and
/// per-pack progress. Also reused later as Settings' "Manage downloaded
/// content" — this screen has no notion of "first run", it just always
/// reflects what's installed vs. available.
///
/// Both panels default to one action — "download everything relevant" —
/// rather than a manual multi-select: Study is already scoped to the
/// signed-in student's own class (every book in it is relevant by
/// definition), and Assessment has no cheaper unit to offer (the manifest
/// carries no category info pre-download — see `_AssessmentPanel`'s doc
/// comment). Individual cards stay tappable as a "just this one"
/// shortcut/retry, not a checkbox.
class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  @override
  void initState() {
    super.initState();
    loadWifiOnlyPreference().then((value) {
      if (mounted) ref.read(wifiOnlyDownloadsProvider.notifier).state = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final manifestAsync = ref.watch(contentManifestProvider);
    final hasContent = ref.watch(contentInstalledProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Get your content')),
      body: manifestAsync.when(
        loading: () => ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: const [ShimmerCard(), SizedBox(height: AppSpacing.md), ShimmerCard()],
        ),
        error: (error, _) => EmptyState(
          icon: Icons.wifi_off_rounded,
          title: 'Couldn\'t load content list',
          message: '$error',
          actionLabel: 'Retry',
          onAction: () => ref.invalidate(contentManifestProvider),
        ),
        data: (manifest) => DefaultTabController(
          length: 2,
          child: Column(
            children: [
              _WifiOnlyBanner(),
              const _StorageUsedLine(),
              const TabBar(tabs: [Tab(text: 'Study Center'), Tab(text: 'Assessment')]),
              Expanded(
                child: TabBarView(
                  children: [
                    _StudyPanel(packs: manifest.studyPacks),
                    _AssessmentPanel(packs: manifest.assessmentPacks),
                  ],
                ),
              ),
              if (hasContent) _ContinueBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContinueBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: GradientButton(
          label: 'Continue',
          icon: Icons.arrow_forward_rounded,
          onPressed: () => context.go(AppRoutes.home),
        ),
      ),
    );
  }
}

class _StorageUsedLine extends ConsumerWidget {
  const _StorageUsedLine();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studyBytes = ref.watch(studyStorageUsedProvider).valueOrNull ?? 0;
    final assessmentBytes = ref.watch(assessmentStorageUsedProvider).valueOrNull ?? 0;
    if (studyBytes == 0 && assessmentBytes == 0) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.sm, AppSpacing.xl, 0),
      child: Text(
        'Storage used — Study: ${formatBytes(studyBytes)} · Assessment: ${formatBytes(assessmentBytes)}',
        style: textTheme.labelSmall?.copyWith(color: mutedColor),
      ),
    );
  }
}

class _WifiOnlyBanner extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wifiOnly = ref.watch(wifiOnlyDownloadsProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.md, AppSpacing.xl, 0),
      child: GlowCard(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        child: Row(
          children: [
            const Icon(Icons.wifi_rounded, size: 18),
            const SizedBox(width: AppSpacing.sm),
            const Expanded(child: Text('Wi-Fi-only downloads')),
            Switch(
              value: wifiOnly,
              onChanged: (v) {
                ref.read(wifiOnlyDownloadsProvider.notifier).state = v;
                saveWifiOnlyPreference(v);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// A "download all" button that's live-derived from reactive state rather
/// than needing its own StatefulWidget: while any pack in [packs] is
/// downloading/importing, the button disables itself — re-tapping mid-batch
/// would start a second overlapping sequential loop over the same pending
/// set, racing the first loop's eventual call to the same packs.
class _DownloadAllButton extends StatelessWidget {
  const _DownloadAllButton({
    required this.pending,
    required this.busy,
    required this.onDownloadAll,
  });

  final List<ManifestPackEntry> pending;
  final bool busy;
  final VoidCallback onDownloadAll;

  @override
  Widget build(BuildContext context) {
    if (pending.isEmpty) return const SizedBox.shrink();
    final totalBytes = pending.fold<int>(0, (sum, p) => sum + p.sizeBytes);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: GradientButton(
        label: busy
            ? 'Downloading…'
            : 'Download all ${pending.length} (${formatBytes(totalBytes)})',
        icon: Icons.download_rounded,
        loading: busy,
        onPressed: busy ? null : onDownloadAll,
      ),
    );
  }
}

class _StudyPanel extends ConsumerWidget {
  const _StudyPanel({required this.packs});

  final List<ManifestPackEntry> packs;

  Future<void> _downloadAll(WidgetRef ref, List<ManifestPackEntry> pending) async {
    final controller = ref.read(setupControllerProvider);
    for (final pack in pending) {
      await controller.download(pack);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Study content is scoped to the signed-in student's own class — not a
    // manual picker. A student only ever sees (and can download in one
    // tap) books for the class their account is actually enrolled in.
    final classId = ref.watch(currentUserProvider)?.currentClassId;
    final className = classOptionByIdOrNull(classId)?.name;
    final visiblePacks = packs.where((p) => p.parentScopeId == classId).toList();
    final installedPacks = ref.watch(installedStudyPacksProvider).valueOrNull ?? const [];
    final installedScopeIds = installedPacks.map((p) => p.scopeId).toSet();
    final states = ref.watch(packDownloadStatesProvider);
    final pending = visiblePacks.where((p) => !installedScopeIds.contains(p.scopeId)).toList();
    final busy = states.values.any(
      (s) => s.phase == PackPhase.downloading || s.phase == PackPhase.importing,
    );

    if (classId == null) {
      return const EmptyState(
        icon: Icons.school_outlined,
        title: 'No class on your account',
        message: 'Set a class in Settings -> Edit profile to see Study content for it.',
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        if (className != null) ...[
          Text('Showing books for $className', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: AppSpacing.lg),
        ],
        if (visiblePacks.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: AppSpacing.xxxl),
            child: EmptyState(
              icon: Icons.menu_book_outlined,
              title: 'No books for your class yet',
              message: 'Check back later — new content is added regularly.',
            ),
          )
        else ...[
          _DownloadAllButton(
            pending: pending,
            busy: busy,
            onDownloadAll: () => _downloadAll(ref, pending),
          ),
          for (final pack in visiblePacks)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: PackCard(
                pack: pack,
                installed: installedScopeIds.contains(pack.scopeId),
                downloadState: states[packStateKey(pack)],
                onDownload: () => ref.read(setupControllerProvider).download(pack),
                onRemove: () => _confirmRemove(context, ref, pack),
              ),
            ),
        ],
      ],
    );
  }
}

/// All installed Assessment subjects, one "download all" action for the
/// whole catalog. Not grouped by category: the manifest carries no
/// category info at all (every assessment entry's `parent_scope_id` is
/// `null` in production) — a subject's categories only exist inside its
/// own pack.json, which means downloading it, so there's no cheaper
/// pre-download unit than "subject" to group by. Getting real category
/// grouping here would need the backend's manifest to expose each
/// subject's category id(s) up front.
class _AssessmentPanel extends ConsumerWidget {
  const _AssessmentPanel({required this.packs});

  final List<ManifestPackEntry> packs;

  Future<void> _downloadAll(WidgetRef ref, List<ManifestPackEntry> pending) async {
    final controller = ref.read(setupControllerProvider);
    for (final pack in pending) {
      await controller.download(pack);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final installedPacks = ref.watch(installedAssessmentPacksProvider).valueOrNull ?? const [];
    final installedScopeIds = installedPacks.map((p) => p.scopeId).toSet();
    final states = ref.watch(packDownloadStatesProvider);
    final pending = packs.where((p) => !installedScopeIds.contains(p.scopeId)).toList();
    final busy = states.values.any(
      (s) => s.phase == PackPhase.downloading || s.phase == PackPhase.importing,
    );

    if (packs.isEmpty) {
      return const EmptyState(
        icon: Icons.assignment_outlined,
        title: 'No subjects available yet',
        message: 'Check back later for practice/CBT content.',
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        _DownloadAllButton(
          pending: pending,
          busy: busy,
          onDownloadAll: () => _downloadAll(ref, pending),
        ),
        for (final pack in packs)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: PackCard(
              pack: pack,
              installed: installedScopeIds.contains(pack.scopeId),
              downloadState: states[packStateKey(pack)],
              onDownload: () => ref.read(setupControllerProvider).download(pack),
              onRemove: () => _confirmRemove(context, ref, pack),
            ),
          ),
      ],
    );
  }
}

Future<void> _confirmRemove(BuildContext context, WidgetRef ref, ManifestPackEntry pack) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Remove downloaded content?'),
      content: Text(
        '"${pack.title}" will be deleted from this device and needs to be downloaded again to use offline.',
      ),
      actions: [
        TextButton(onPressed: () => context.pop(false), child: const Text('Cancel')),
        TextButton(
          onPressed: () => context.pop(true),
          child: const Text('Remove', style: TextStyle(color: AppColors.danger)),
        ),
      ],
    ),
  );
  if (confirmed == true) {
    await ref.read(setupControllerProvider).remove(pack);
  }
}
