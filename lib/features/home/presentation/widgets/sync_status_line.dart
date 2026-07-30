import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../application/home_providers.dart';

/// Sync is felt, not seen (spec Section 1.6) — a calm one-line status,
/// never a blocking dialog. The actual flush worker is M8; today this
/// simply reflects whatever's sitting in the outbox.
class SyncStatusLine extends ConsumerWidget {
  const SyncStatusLine({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(pendingSyncCountProvider).valueOrNull ?? 0;

    if (pending == 0) {
      return const StatusPill(
        label: 'Synced',
        icon: Icons.check_circle_outline_rounded,
        tone: StatusPillTone.success,
      );
    }
    return StatusPill(
      label: '$pending result${pending == 1 ? '' : 's'} waiting to sync',
      tone: StatusPillTone.warning,
      pulse: true,
    );
  }
}
