import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/player/common/bookmarks_button.dart';
import 'package:yaabsa/components/player/common/sleep_timer_button.dart';
import 'package:yaabsa/components/player/common/speed_slider.dart';
import 'package:yaabsa/components/player/common/volume_slider.dart';
import 'package:yaabsa/screens/player/chapter_quick_picker.dart';
import 'package:yaabsa/screens/player/layout/player_presentation_config.dart';
import 'package:yaabsa/screens/player/queue_quick_picker.dart';

class MobilePlayerActionDock extends ConsumerWidget {
  const MobilePlayerActionDock({
    super.key,
    required this.leftAction,
    required this.rightAction,
    required this.hasChapters,
  });

  final PlayerActionType? leftAction;
  final PlayerActionType? rightAction;
  final bool hasChapters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compactLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;
    return Padding(
      padding: EdgeInsets.fromLTRB(28, 0, 28, compactLandscape ? 4 : 8),
      child: SizedBox(
        height: compactLandscape ? 48 : 56,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: _QuickActionControl(action: leftAction, hasChapters: hasChapters),
              ),
            ),
            IconButton(
              tooltip: 'Show player actions',
              onPressed: () => _showActionsSheet(context, ref),
              icon: const Icon(Icons.keyboard_arrow_up_rounded),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: _QuickActionControl(action: rightAction, hasChapters: hasChapters),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isEnabled(PlayerActionType action) {
    return action != PlayerActionType.chapter || hasChapters;
  }

  void _showAction(BuildContext context, WidgetRef ref, PlayerActionType action) {
    if (!_isEnabled(action)) {
      return;
    }

    switch (action) {
      case PlayerActionType.speed:
        showPlaybackSpeedSheet(context);
      case PlayerActionType.bookmarks:
        showPlayerBookmarksSheet(context);
      case PlayerActionType.chapter:
        showChapterQuickPicker(context);
      case PlayerActionType.volume:
        showPlayerVolumeSheet(context);
      case PlayerActionType.sleepTimer:
        showSleepTimerSheet(context, ref);
      case PlayerActionType.queue:
        showQueueQuickPicker(context);
    }
  }

  void _showActionsSheet(BuildContext context, WidgetRef ref) {
    final sheetActions = PlayerActionType.values;

    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.22),
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      constraints: const BoxConstraints(maxWidth: 560),
      builder: (sheetContext) {
        final colors = Theme.of(sheetContext).colorScheme;
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surfaceContainer.withValues(alpha: 0.45),
                border: Border(top: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.7))),
              ),
              child: _MobilePlayerActionsSheet(
                actions: sheetActions,
                hasChapters: hasChapters,
                onSelected: (action) {
                  Navigator.of(sheetContext).pop();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (context.mounted) {
                      _showAction(context, ref, action);
                    }
                  });
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _QuickActionControl extends StatelessWidget {
  const _QuickActionControl({required this.action, required this.hasChapters});

  final PlayerActionType? action;
  final bool hasChapters;

  @override
  Widget build(BuildContext context) {
    final action = this.action;
    if (action == null) {
      return const SizedBox.shrink();
    }

    final colors = Theme.of(context).colorScheme;
    final cardShaped = action == PlayerActionType.speed || action == PlayerActionType.sleepTimer;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.42),
        borderRadius: cardShaped ? BorderRadius.circular(16) : BorderRadius.circular(999),
      ),
      child: switch (action) {
        PlayerActionType.speed => const SpeedSlider(),
        PlayerActionType.bookmarks => const BookmarksButton(),
        PlayerActionType.chapter => ChapterQuickPicker(enabled: hasChapters),
        PlayerActionType.volume => const VolumeSlider(),
        PlayerActionType.sleepTimer => const SleepTimerButton(),
        PlayerActionType.queue => const QueueQuickPicker(),
      },
    );
  }
}

class _MobilePlayerActionsSheet extends StatelessWidget {
  const _MobilePlayerActionsSheet({required this.actions, required this.hasChapters, required this.onSelected});

  final List<PlayerActionType> actions;
  final bool hasChapters;
  final ValueChanged<PlayerActionType> onSelected;

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;
    final maxHeight = MediaQuery.sizeOf(context).height * (isLandscape ? 0.82 : 0.7);

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            if (actions.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'No additional actions are enabled.',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              )
            else
              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: actions.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 72,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    final action = actions[index];
                    final enabled = action != PlayerActionType.chapter || hasChapters;
                    return Material(
                      color: Theme.of(context).colorScheme.surfaceContainerLow.withValues(alpha: 0.58),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: enabled ? () => onSelected(action) : null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(action.icon, color: enabled ? null : Theme.of(context).disabledColor),
                              const SizedBox(height: 4),
                              Text(
                                action.label,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: enabled
                                    ? Theme.of(context).textTheme.labelLarge
                                    : Theme.of(
                                        context,
                                      ).textTheme.labelLarge?.copyWith(color: Theme.of(context).disabledColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
