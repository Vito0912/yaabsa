import 'package:buchshelfly/provider/common/library_item_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryItemView extends ConsumerWidget {
  const LibraryItemView(this.itemId, {super.key});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(libraryItemNotifierProvider(itemId));
    return Placeholder();
  }
}
