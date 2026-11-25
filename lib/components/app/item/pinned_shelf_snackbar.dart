import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/provider/library/pinned_shelf_provider.dart';
import 'package:yaabsa/util/l10n.dart';

void showPinnedShelfSnackBar({required BuildContext context, required PinnedShelfUndo undo}) {
  final messenger = ScaffoldMessenger.of(context);
  final providerContainer = ProviderScope.containerOf(context, listen: false);
  final localizations = context.l10n;
  messenger.clearSnackBars();
  messenger.removeCurrentSnackBar();
  final snackBarController = messenger.showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(undo.wasPinned ? localizations.statusPinnedShelfRemoved : localizations.statusPinnedShelfAdded),
      action: SnackBarAction(
        label: localizations.actionUndo,
        onPressed: () {
          unawaited(_undoPinnedShelfChange(context: context, providerContainer: providerContainer, undo: undo));
        },
      ),
    ),
  );
  final closeTimer = Timer(const Duration(seconds: 3), snackBarController.close);
  unawaited(snackBarController.closed.whenComplete(closeTimer.cancel));
}

Future<void> _undoPinnedShelfChange({
  required BuildContext context,
  required ProviderContainer providerContainer,
  required PinnedShelfUndo undo,
}) async {
  try {
    await providerContainer.read(pinnedShelfControllerProvider.notifier).undo(undo);
    providerContainer.invalidate(pinnedShelfContainsProvider);
    providerContainer.invalidate(pinnedShelfItemsProvider);
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.errorUndoPinnedShelfChangeFailed(error.toString()))));
    }
  }
}
