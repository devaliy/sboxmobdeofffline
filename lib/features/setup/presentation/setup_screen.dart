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
class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final Set<String> _selected = {};
  int? _selectedClassId;

  @override
  void initState() {
    super.initState();
    loadWifiOnlyPreference().then((value) {
      if (mounted) ref.read(wifiOnlyDownloadsProvider.notifier).state = value;
    });
  }

  void _toggleSelected(ManifestPackEntry pack, bool value) {
    setState(() {
      final key = packStateKey(pack);
      if (value) {
        _selected.add(key);
      } else {
        _selected.remove(key);
      }
    });
  }

  Future<void> _downloadSelected(List<ManifestPackEntry> allPacks) async {
    final toDownload = allPacks.where((p) => _selected.contains(packStateKey(p))).toList();
    setState(() => _selected.clear());
    for (final pack in toDownload) {
      await ref.read(setupControllerProvider).download(pack);
    }
  }

  Future<void> _confirmRemove(ManifestPackEntry pack) async {
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

  @override
  Widget build(BuildContext context) {
    final manifestAsync = ref.watch(contentManifestProvider);
    final user = ref.watch(currentUserProvider);
    final hasContent = ref.watch(contentInstalledProvider);

    _selectedClassId ??= user?.currentClassId;

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
                    _StudyPanel(
                      packs: manifest.studyPacks,
                      selected: _selected,
                      selectedClassId: _selectedClassId,
                      onClassChanged: (id) => setState(() => _selectedClassId = id),
                      onToggleSelected: _toggleSelected,
                      onRemove: _confirmRemove,
                    ),
                    _AssessmentPanel(
                      packs: manifest.assessmentPacks,
                      selected: _selected,
                      onToggleSelected: _toggleSelected,
                      onRemove: _confirmRemove,
                    ),
                  ],
                ),
              ),
              _BottomBar(
                allPacks: manifest.packs,
                selectedKeys: _selected,
                hasContent: hasContent,
                onDownload: () => _downloadSelected(manifest.packs),
              ),
            ],
          ),
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

class _StudyPanel extends ConsumerWidget {
  const _StudyPanel({
    required this.packs,
    required this.selected,
    required this.selectedClassId,
    required this.onClassChanged,
    required this.onToggleSelected,
    required this.onRemove,
  });

  final List<ManifestPackEntry> packs;
  final Set<String> selected;
  final int? selectedClassId;
  final ValueChanged<int> onClassChanged;
  final void Function(ManifestPackEntry, bool) onToggleSelected;
  final ValueChanged<ManifestPackEntry> onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classIdsWithContent = packs.map((p) => p.parentScopeId).whereType<int>().toSet();
    final visiblePacks = packs.where((p) => p.parentScopeId == selectedClassId).toList();
    final installedPacks = ref.watch(installedStudyPacksProvider).valueOrNull ?? const [];
    final installedScopeIds = installedPacks.map((p) => p.scopeId).toSet();
    final states = ref.watch(packDownloadStatesProvider);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        DropdownButtonFormField<int>(
          initialValue: selectedClassId,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Class'),
          items: [
            for (final c in kClassOptions)
              DropdownMenuItem(
                value: c.id,
                enabled: classIdsWithContent.contains(c.id),
                child: Text(c.name, overflow: TextOverflow.ellipsis),
              ),
          ],
          onChanged: (v) {
            if (v != null) onClassChanged(v);
          },
        ),
        const SizedBox(height: AppSpacing.xl),
        if (visiblePacks.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: AppSpacing.xxxl),
            child: EmptyState(
              icon: Icons.menu_book_outlined,
              title: 'No books for this class yet',
              message: 'Pick a different class, or check back later.',
            ),
          )
        else
          for (final pack in visiblePacks)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: PackCard(
                pack: pack,
                installed: installedScopeIds.contains(pack.scopeId),
                selected: selected.contains(packStateKey(pack)),
                downloadState: states[packStateKey(pack)],
                onToggleSelected: (v) => onToggleSelected(pack, v),
                onRetry: () => ref.read(setupControllerProvider).download(pack),
                onRemove: () => onRemove(pack),
              ),
            ),
      ],
    );
  }
}

class _AssessmentPanel extends ConsumerWidget {
  const _AssessmentPanel({
    required this.packs,
    required this.selected,
    required this.onToggleSelected,
    required this.onRemove,
  });

  final List<ManifestPackEntry> packs;
  final Set<String> selected;
  final void Function(ManifestPackEntry, bool) onToggleSelected;
  final ValueChanged<ManifestPackEntry> onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final installedPacks = ref.watch(installedAssessmentPacksProvider).valueOrNull ?? const [];
    final installedScopeIds = installedPacks.map((p) => p.scopeId).toSet();
    final states = ref.watch(packDownloadStatesProvider);

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
        for (final pack in packs)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: PackCard(
              pack: pack,
              installed: installedScopeIds.contains(pack.scopeId),
              selected: selected.contains(packStateKey(pack)),
              downloadState: states[packStateKey(pack)],
              onToggleSelected: (v) => onToggleSelected(pack, v),
              onRetry: () => ref.read(setupControllerProvider).download(pack),
              onRemove: () => onRemove(pack),
            ),
          ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.allPacks,
    required this.selectedKeys,
    required this.hasContent,
    required this.onDownload,
  });

  final List<ManifestPackEntry> allPacks;
  final Set<String> selectedKeys;
  final bool hasContent;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    final selectedPacks = allPacks.where((p) => selectedKeys.contains(packStateKey(p))).toList();
    final totalBytes = selectedPacks.fold<int>(0, (sum, p) => sum + p.sizeBytes);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedPacks.isNotEmpty)
              GradientButton(
                label: 'Download ${selectedPacks.length} selected (${formatBytes(totalBytes)})',
                icon: Icons.download_rounded,
                onPressed: onDownload,
              )
            else if (hasContent)
              GradientButton(
                label: 'Continue',
                icon: Icons.arrow_forward_rounded,
                onPressed: () => context.go(AppRoutes.home),
              ),
          ],
        ),
      ),
    );
  }
}
