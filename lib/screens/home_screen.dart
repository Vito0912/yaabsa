import 'package:buchshelfly/components/app/library_switcher.dart';
import 'package:buchshelfly/components/app/user_switcher.dart';
import 'package:buchshelfly/components/common/library_item_widget.dart';
import 'package:buchshelfly/provider/common/library_item_provider.dart';
import 'package:buchshelfly/provider/common/library_provider.dart';
import 'package:buchshelfly/provider/core/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLibraryAsyncValue = ref.watch(selectedLibraryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Items PoC'),
        actions: const [UserSwitcher(), LibrarySwitcher()],
      ),
      body: Builder(
        builder: (BuildContext context) {
          if (selectedLibraryAsyncValue == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (selectedLibrary == null) {
            return const Center(
              child: Text(
                'No library selected or available. Please select a library via the switcher.',
              ),
            );
          }
          return LibraryItemsView(libraryId: selectedLibraryAsyncValue.id);
        },
      ),
    );
  }
}

class LibraryItemsView extends ConsumerStatefulWidget {
  final String libraryId;
  const LibraryItemsView({super.key, required this.libraryId});

  @override
  ConsumerState<LibraryItemsView> createState() => _LibraryItemsViewState();
}

class _LibraryItemsViewState extends ConsumerState<LibraryItemsView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _filterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentFilter =
          ref.read(libraryItemNotifierProvider(widget.libraryId)).value?.filter;
      if (currentFilter != null) {
        _filterController.text = currentFilter;
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      final notifier = ref.read(
        libraryItemNotifierProvider(widget.libraryId).notifier,
      );
      final state =
          ref.read(libraryItemNotifierProvider(widget.libraryId)).value;
      if (state != null && state.hasNextPage && !state.isLoadingNextPage) {
        notifier.fetchNextPage();
      }
    }
  }

  @override
  void didUpdateWidget(covariant LibraryItemsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.libraryId != oldWidget.libraryId) {
      _filterController.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final currentFilter =
            ref
                .read(libraryItemNotifierProvider(widget.libraryId))
                .value
                ?.filter;
        if (currentFilter != null) {
          _filterController.text = currentFilter;
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final libraryItemsStateAsync = ref.watch(
      libraryItemNotifierProvider(widget.libraryId),
    );
    final libraryItemNotifier = ref.read(
      libraryItemNotifierProvider(widget.libraryId).notifier,
    );
    final api = ref.read(absApiProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _filterController,
                decoration: InputDecoration(
                  labelText: 'Filter by name (e.g., title contains...)',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _filterController.clear();
                      libraryItemNotifier.clearFilter();
                    },
                  ),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    libraryItemNotifier.setFilter(
                      'media.metadata.title:$value',
                    );
                  } else {
                    libraryItemNotifier.clearFilter();
                  }
                },
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed:
                        () => libraryItemNotifier.setSort(
                          'media.metadata.title',
                          newDesc: 0,
                        ),
                    child: const Text('Sort Title (A-Z)'),
                  ),
                  ElevatedButton(
                    onPressed:
                        () => libraryItemNotifier.setSort(
                          'media.metadata.title',
                          newDesc: 1,
                        ),
                    child: const Text('Sort Title (Z-A)'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed:
                        () =>
                            libraryItemNotifier.setSort('addedAt', newDesc: 1),
                    child: const Text('Sort Added (Newest)'),
                  ),
                  ElevatedButton(
                    onPressed:
                        () =>
                            libraryItemNotifier.setSort('addedAt', newDesc: 0),
                    child: const Text('Sort Added (Oldest)'),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: libraryItemsStateAsync.when(
            data: (state) {
              if (state.items.isEmpty &&
                  !state.hasNextPage &&
                  !state.isLoadingNextPage) {
                return RefreshIndicator(
                  onRefresh: () => libraryItemNotifier.refresh(),
                  child: LayoutBuilder(
                    builder:
                        (context, constraints) => SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: const Center(
                              child: Text(
                                'No items match your criteria. Pull to refresh.',
                              ),
                            ),
                          ),
                        ),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () => libraryItemNotifier.refresh(),
                child: GridView.builder(
                  controller: _scrollController,
                  itemCount:
                      state.items.length +
                      (state.hasNextPage || state.isLoadingNextPage ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == state.items.length) {
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
                    return LibraryItemWidget(state.items[index], api!);
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error:
                (err, stack) => RefreshIndicator(
                  onRefresh: () => libraryItemNotifier.refresh(),
                  child: LayoutBuilder(
                    builder:
                        (context, constraints) => SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'Error loading items: $err\nPull to refresh.',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                  ),
                ),
          ),
        ),
      ],
    );
  }
}
