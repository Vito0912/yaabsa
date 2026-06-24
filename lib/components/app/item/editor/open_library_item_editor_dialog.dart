import 'package:flutter/material.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_data.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/components/app/item/editor/library_item_edit_overlay.dart';

Future<void> openSingleLibraryItemEditorDialog({
  required BuildContext context,
  required LibraryItem item,
  required LibraryFilterData? filterData,
  LibraryItemEditorTab initialTab = LibraryItemEditorTab.details,
}) async {
  await showGeneralDialog<void>(
    context: context,
    barrierLabel: 'Edit item',
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            LibraryItemEditOverlay(
              orderedItemIds: [item.id],
              currentItemId: item.id,
              filterData: filterData,
              initialTab: initialTab,
              onSelectItem: (_) {},
              onClose: () {
                if (Navigator.of(dialogContext).canPop()) {
                  Navigator.of(dialogContext).pop();
                }
              },
              onItemSaved: (_, _) async {},
            ),
          ],
        ),
      );
    },
  );
}
