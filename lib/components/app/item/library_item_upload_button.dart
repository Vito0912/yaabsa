import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/upload/item_upload_destination.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/features/upload/library_upload_panel.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';

class LibraryItemUploadButton extends ConsumerWidget {
  const LibraryItemUploadButton({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final api = ref.watch(absApiProvider);
    if (user == null || !user.permissions.upload || api == null) {
      return const SizedBox.shrink();
    }

    final item = ref.watch(libraryItemProvider(itemId)).value;
    final libraries = ref.watch(userLibrariesProvider).value;
    if (item == null || libraries == null) {
      return const SizedBox.shrink();
    }

    final library = libraries.where((library) => library.id == item.libraryId).firstOrNull;
    if (library == null) {
      return const SizedBox.shrink();
    }

    final destination = ItemUploadDestination.resolve(
      item: item,
      library: library,
      serverWatcherDisabled: user.setting?.scannerDisableWatcher == true,
    );
    final isAdmin = user.type == 'root' || user.type == 'admin';
    if (destination == null || (destination.requiresScan && !isAdmin)) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (context) => LibraryItemUploadDialog(library: library, destination: destination),
            );
          },
          icon: const Icon(Icons.upload_file_rounded),
          label: const Text('Add files'),
        ),
      ),
    );
  }
}

class LibraryItemUploadDialog extends StatelessWidget {
  const LibraryItemUploadDialog({super.key, required this.library, required this.destination});

  final Library library;
  final ItemUploadDestination destination;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      constraints: const BoxConstraints.tightFor(width: 900),
      scrollable: true,
      semanticLabel: 'Add files',
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      content: LibraryUploadPanel(
        selectedLibrary: library,
        itemDestination: destination,
        embeddedInDialog: true,
        onUploadComplete: () => Navigator.of(context).pop(),
        onClose: () => Navigator.of(context).pop(),
      ),
      actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
    );
  }
}
