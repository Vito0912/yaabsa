import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/app/item/item_detail_components.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/util/collection_membership.dart';

ItemMetadataRowData buildBookCollectionsMetadataRow(
  BuildContext context, {
  required AsyncValue<BookCollectionMemberships> collections,
  required VoidCallback onRetry,
}) {
  if (collections.isLoading && !collections.hasValue) {
    return const ItemMetadataRowData(label: 'Collections', value: 'Loading collections…');
  }
  final state = collections.value;
  final hasError = collections.hasError || state?.error != null;
  final unknown = state?.hasUnknown ?? false;
  final values = (state?.items ?? [])
      .map(
        (collection) => ItemLinkValue(
          label: collection.name,
          onTap: () => context.push(
            Uri(
              pathSegments: ['', 'collection', collection.id],
              queryParameters: {'libraryId': collection.libraryId},
            ).toString(),
            extra: MultiBookEntryData.fromCollection(collection),
          ),
        ),
      )
      .toList();
  if (hasError || state == null) {
    values.add(ItemLinkValue(label: 'Could not load collections. Retry', onTap: onRetry));
  } else if (unknown) {
    values.add(ItemLinkValue(label: 'Some memberships are unknown. Retry', onTap: onRetry));
  } else if (values.isEmpty) {
    return const ItemMetadataRowData(label: 'Collections', value: 'No collections');
  }
  return ItemMetadataRowData(label: 'Collections', values: values);
}
