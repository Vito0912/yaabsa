import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/components/common/author_card.dart';
import 'package:yaabsa/components/common/scroll_to_top_button.dart';
import 'package:yaabsa/provider/common/library_filter_data_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/util/globals.dart';

class AuthorsView extends HookConsumerWidget {
  const AuthorsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final selectedLibrary = ref.watch(selectedLibraryProvider);

    if (selectedLibrary == null) {
      return const Center(child: Text('No library selected. Please select a library via the switcher.'));
    }

    if (selectedLibrary.mediaType != 'book') {
      return const Center(child: Text('Authors are available only for book libraries.'));
    }

    final libraryId = selectedLibrary.id;
    final filterDataAsync = ref.watch(libraryFilterDataProvider(libraryId));

    return filterDataAsync.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: (filterData) {
        final authors =
            filterData?.authors
                .where((author) => author.id.trim().isNotEmpty && author.name.trim().isNotEmpty)
                .toList(growable: false) ??
            const [];
        final sortedAuthors = [...authors]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

        if (sortedAuthors.isEmpty) {
          return const Center(child: Text('No authors found in this library.'));
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
                  itemCount: sortedAuthors.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: context.isMobile ? 3.5 : 3.8,
                  ),
                  itemBuilder: (context, index) {
                    final author = sortedAuthors[index];
                    return AuthorCard(
                      authorId: author.id,
                      name: author.name,
                      onTap: () {
                        context.push('/author/${author.id}');
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
      error: (error, stackTrace) => Center(child: Text('Error loading authors: $error')),
    );
  }
}
