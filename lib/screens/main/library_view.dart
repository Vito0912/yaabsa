import 'package:buchshelfly/components/common/library_item_widget.dart';
import 'package:buchshelfly/provider/common/library_item_provider.dart';
import 'package:buchshelfly/provider/common/library_provider.dart';
import 'package:buchshelfly/provider/core/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LibraryView extends HookConsumerWidget {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLibrary = ref.watch(selectedLibraryProvider);
    if (selectedLibrary == null) {
      return const Center(
        child: Text(
          'No library selected. Please select a library via the switcher.',
        ),
      );
    }
    final String libraryId = selectedLibrary.id;

    final scrollController = useScrollController();

    final libraryItemsStateAsync = ref.watch(
      libraryItemNotifierProvider(libraryId),
    );

    useEffect(() {
      void onScroll() {
        if (!scrollController.hasClients) return;

        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 300) {
          final currentStateSnapshot = ref.read(
            libraryItemNotifierProvider(libraryId),
          );
          final notifier = ref.read(
            libraryItemNotifierProvider(libraryId).notifier,
          );

          final state = currentStateSnapshot.value;

          if (state != null && state.hasNextPage && !state.isLoadingNextPage) {
            notifier.fetchNextPage();
          }
        }
      }

      scrollController.addListener(onScroll);

      return () => scrollController.removeListener(onScroll);
    }, [scrollController, libraryId, ref]);

    final api = ref.read(absApiProvider);

    return libraryItemsStateAsync.when(
      data: (state) {
        final items = state.items;

        if (items.isEmpty && !state.hasNextPage && !state.isLoadingNextPage) {
          return const Center(child: Text('No items found in this library.'));
        }

        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final crossAxisCount = (constraints.maxWidth ~/ 200).clamp(1, 10);

            return AlignedGridView.count(
              controller: scrollController,
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              itemCount:
                  items.length +
                  ((state.hasNextPage || state.isLoadingNextPage) ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == items.length) {
                  if (state.isLoadingNextPage) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }

                return LibraryItemWidget(
                  items[index],
                  api!,
                  showProgress: true,
                );
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (err, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error loading items: $err',
                textAlign: TextAlign.center,
              ),
            ),
          ),
    );
  }
}
