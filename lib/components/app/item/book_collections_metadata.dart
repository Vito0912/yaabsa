import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/app/item/item_detail_components.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/util/collection_membership.dart';
import 'package:yaabsa/util/l10n.dart';

ItemMetadataRowData buildBookCollectionsMetadataRow(
  BuildContext context, {
  required AsyncValue<BookCollectionMemberships> collections,
  required VoidCallback onRetry,
  VoidCallback? onLoadMore,
}) {
  final localizations = context.l10n;

  if (collections.isLoading && !collections.hasValue) {
    return ItemMetadataRowData(label: localizations.navCollections, value: localizations.statusLoadingContent);
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
    values.add(
      ItemLinkValue(label: localizations.errorLoadNamedItemsRetry(localizations.entityCollections), onTap: onRetry),
    );
  } else if (unknown) {
    values.add(
      ItemLinkValue(label: localizations.statusNamedItemsUnknown(localizations.entityCollections), onTap: onRetry),
    );
  }
  if (state?.hasMore ?? false) {
    values.add(
      ItemLinkValue(
        label: state!.isLoadingMore ? localizations.statusLoadingContent : localizations.actionLoadMore,
        onTap: state.isLoadingMore ? null : onLoadMore,
      ),
    );
  } else if (!hasError && !unknown && values.isEmpty) {
    return ItemMetadataRowData(
      label: localizations.navCollections,
      value: localizations.statusNoNamedItems(localizations.entityCollections),
    );
  }
  return ItemMetadataRowData(label: localizations.navCollections, values: values);
}
