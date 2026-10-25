import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/list/collection.dart';
import 'package:yaabsa/components/app/item/book_list_membership_dialog.dart';
import 'package:yaabsa/provider/common/collection_provider.dart';
import 'package:yaabsa/util/collection_membership.dart';

Future<void> showBookCollectionMembershipDialog({required BuildContext context, required LibraryItem item}) async {
  if (item.libraryId == null || item.libraryId!.isEmpty) return;
  final saved = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => BookCollectionMembershipDialog(item: item),
  );
  if (saved == true && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Collection memberships updated.')));
  }
}

class BookCollectionMembershipDialog extends ConsumerWidget {
  const BookCollectionMembershipDialog({super.key, required this.item});

  final LibraryItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryId = item.libraryId!;
    return BookListMembershipDialog<Collection>(
      entries: ref.watch(collectionsProvider(libraryId)).whenData((state) {
        if (state.error != null) throw state.error!;
        return state.items.where((entry) => entry.libraryId == libraryId).toList(growable: false);
      }),
      allowed: ref.watch(collectionMembershipEditingAllowedProvider),
      plural: 'collections',
      bookTitle: item.title,
      id: (entry) => entry.id,
      name: (entry) => entry.name,
      membership: (entry) => switch (collectionMembership(entry, item.id)) {
        CollectionMembership.present => true,
        CollectionMembership.absent => false,
        CollectionMembership.unknown => null,
      },
      disabledReason: (entry) {
        if (collectionMembership(entry, item.id) == CollectionMembership.unknown) {
          return 'Membership unknown. Reload collections before editing.';
        }
        if (!hasCompleteCollectionBooks(entry)) return 'Full book list unavailable. Reload collections before editing.';
        if (collectionMembership(entry, item.id) == CollectionMembership.present &&
            !canRemoveCollectionMembership(entry, item.id)) {
          return 'This is the only book. Collections cannot be empty.';
        }
        return null;
      },
      onReload: () => ref.read(collectionsProvider(libraryId).notifier).refresh(requireServer: true),
      onSave: (original, selected) => ref
          .read(collectionsProvider(libraryId).notifier)
          .updateBookMemberships(bookId: item.id, original: original, selectedIds: selected),
    );
  }
}
