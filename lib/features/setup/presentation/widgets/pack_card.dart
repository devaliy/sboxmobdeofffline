import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/utils/format_bytes.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../application/setup_controller.dart';
import '../../domain/content_pack_manifest.dart';

/// One downloadable pack, in every state it can be in: selectable,
/// downloading (with a live progress ring), installed, or failed with a
/// retry action. Reused by both the Study and Assessment panels.
class PackCard extends StatelessWidget {
  const PackCard({
    super.key,
    required this.pack,
    required this.installed,
    required this.selected,
    required this.downloadState,
    required this.onToggleSelected,
    required this.onRetry,
    this.onRemove,
  });

  final ManifestPackEntry pack;
  final bool installed;
  final bool selected;
  final PackDownloadState? downloadState;
  final ValueChanged<bool> onToggleSelected;
  final VoidCallback onRetry;

  /// Null when this card is shown outside "Manage downloaded content"
  /// (e.g. first-run Setup) — removal is a management-mode-only action.
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final phase = downloadState?.phase ?? PackPhase.idle;
    final busy = phase == PackPhase.downloading || phase == PackPhase.importing;

    return GlowCard(
      onTap: (installed || busy) ? null : () => onToggleSelected(!selected),
      border: selected
          ? const BorderSide(color: AppColors.signalOrange, width: 1.6)
          : null,
      child: Row(
        children: [
          _leading(phase),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pack.title, style: textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(
                  '${formatBytes(pack.sizeBytes)} · ${pack.itemCount} items',
                  style: textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
                if (phase == PackPhase.downloading && downloadState != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: LinearProgressIndicator(value: downloadState!.progress, minHeight: 6),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${formatBytes(downloadState!.received)} / ${formatBytes(downloadState!.total)}',
                    style: textTheme.labelSmall,
                  ),
                ] else if (phase == PackPhase.importing) ...[
                  const SizedBox(height: AppSpacing.sm),
                  const StatusPill(label: 'Importing…', tone: StatusPillTone.info, pulse: true),
                ] else if (phase == PackPhase.failed) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    downloadState?.error ?? 'Download failed',
                    style: textTheme.bodySmall?.copyWith(color: AppColors.danger),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _trailing(context, phase) ?? const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _leading(PackPhase phase) {
    if (installed) {
      return const PastelIconBadge(icon: Icons.check_circle_rounded, hue: AppColors.mint, size: 40);
    }
    if (phase == PackPhase.downloading || phase == PackPhase.importing) {
      return AnimatedProgressRing(progress: downloadState?.progress ?? 0, size: 40, strokeWidth: 4);
    }
    return PastelIconBadge(
      icon: selected ? Icons.check_circle_rounded : Icons.circle_outlined,
      hue: selected ? AppColors.coral : AppColors.sky,
      size: 40,
    );
  }

  Widget? _trailing(BuildContext context, PackPhase phase) {
    if (installed) {
      if (onRemove == null) {
        return Text('Installed', style: Theme.of(context).textTheme.labelSmall);
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('v${pack.version}', style: Theme.of(context).textTheme.labelSmall),
          IconButton(
            tooltip: 'Remove downloaded content',
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
            onPressed: onRemove,
          ),
        ],
      );
    }
    if (phase == PackPhase.failed) {
      return TextButton(onPressed: onRetry, child: const Text('Retry'));
    }
    return null;
  }
}
