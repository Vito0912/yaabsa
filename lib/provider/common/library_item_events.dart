import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library_items/library_item.dart';

enum LibraryItemMutationType { added, updated, removed }

class LibraryItemMutation {
  const LibraryItemMutation({
    required this.sequence,
    required this.type,
    required this.itemId,
    this.item,
    this.libraryId,
    this.source = 'unknown',
  });

  final int sequence;
  final LibraryItemMutationType type;
  final String itemId;
  final LibraryItem? item;
  final String? libraryId;
  final String source;
}

final libraryItemMutationProvider = NotifierProvider<LibraryItemMutationNotifier, LibraryItemMutation?>(
  LibraryItemMutationNotifier.new,
);

class LibraryItemMutationNotifier extends Notifier<LibraryItemMutation?> {
  int _sequence = 0;

  @override
  LibraryItemMutation? build() => null;

  void emitAdded(LibraryItem item, {String source = 'unknown'}) {
    state = LibraryItemMutation(
      sequence: _sequence++,
      type: LibraryItemMutationType.added,
      itemId: item.id,
      item: item,
      libraryId: item.libraryId,
      source: source,
    );
  }

  void emitUpdated(LibraryItem item, {String source = 'unknown'}) {
    state = LibraryItemMutation(
      sequence: _sequence++,
      type: LibraryItemMutationType.updated,
      itemId: item.id,
      item: item,
      libraryId: item.libraryId,
      source: source,
    );
  }

  void emitRemoved({required String itemId, String? libraryId, LibraryItem? item, String source = 'unknown'}) {
    state = LibraryItemMutation(
      sequence: _sequence++,
      type: LibraryItemMutationType.removed,
      itemId: itemId,
      item: item,
      libraryId: libraryId,
      source: source,
    );
  }
}
