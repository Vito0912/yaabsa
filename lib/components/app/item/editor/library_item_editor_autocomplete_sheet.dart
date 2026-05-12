import 'package:flutter/material.dart';
import 'package:yaabsa/components/app/item/editor/library_item_editor_field_container.dart';

class LibraryItemEditorAutocompleteSheet extends StatelessWidget {
  const LibraryItemEditorAutocompleteSheet({super.key, required this.suggestions});

  final List<Widget> suggestions;

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: LibraryItemEditorFieldContainer(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Wrap(spacing: 6, runSpacing: 6, children: suggestions),
      ),
    );
  }
}
