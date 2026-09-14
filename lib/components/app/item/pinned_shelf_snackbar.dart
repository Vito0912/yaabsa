import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/provider/library/pinned_shelf_provider.dart';

void showPinnedShelfSnackBar({required BuildContext context, required PinnedShelfUndo undo}) {
  final messenger = ScaffoldMessenger.of(context);
  final providerContainer = ProviderScope.containerOf(context, listen: false);
  messenger.clearSnackBars();
  messenger.removeCurrentSnackBar();
  final snackBarController = messenger.showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(undo.wasPinned ? 'Removed from Pinned' : 'Added to Pinned'),
      action: SnackBarAction(
        label: 'Undo',
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not undo Pinned change: $error')));
    }
  }
}
