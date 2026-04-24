import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/components/common/narrator_card.dart';
import 'package:yaabsa/components/common/scroll_to_top_button.dart';
import 'package:yaabsa/provider/common/library_filter_data_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/util/globals.dart';

class NarratorsView extends HookConsumerWidget {
  const NarratorsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final selectedLibrary = ref.watch(selectedLibraryProvider);

    if (selectedLibrary == null) {
      return const Center(child: Text('No library selected. Please select a library via the switcher.'));
    }

    if (selectedLibrary.mediaType != 'book') {
      return const Center(child: Text('Narrators are available only for book libraries.'));
    }

    final libraryId = selectedLibrary.id;
    final filterDataAsync = ref.watch(libraryFilterDataProvider(libraryId));

    return filterDataAsync.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: (filterData) {
        final narrators =
            filterData?.narrators
                .map((name) => name.trim())
                .where((name) => name.isNotEmpty)
                .toSet()
                .toList(growable: false) ??
            const [];
        final sortedNarrators = [...narrators]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

        if (sortedNarrators.isEmpty) {
          return const Center(child: Text('No narrators found in this library.'));
        }

        final horizontalPadding = context.isDesktop
            ? 24.0
            : context.isTablet
            ? 16.0
            : 10.0;
        final crossAxisCount = context.isDesktop
            ? 3
            : context.isTablet
            ? 2
            : 1;

        return Stack(
          children: [
            Positioned.fill(
              child: RefreshIndicator(
                onRefresh: () => ref.refresh(libraryFilterDataProvider(libraryId).future),
                child: GridView.builder(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(horizontalPadding, 12, horizontalPadding, 16),
                  itemCount: sortedNarrators.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: context.isMobile ? 3.5 : 3.8,
                  ),
                  itemBuilder: (context, index) {
                    final narratorName = sortedNarrators[index];
                    return NarratorCard(
                      name: narratorName,
                      onTap: () {
                        final encodedName = Uri.encodeComponent(narratorName);
                        context.push('/narrator/$encodedName');
                      },
                    );
                  },
                ),
              ),
            ),
            ScrollToTopButton(controller: scrollController),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error loading narrators: $error')),
    );
  }
}
