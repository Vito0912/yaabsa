import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/components/common/scroll_to_top_button.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/common/playlist_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/layout_sizes.dart';

class PlaylistView extends HookConsumerWidget {
  const PlaylistView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final selectedLibrary = ref.watch(selectedLibraryProvider);

    if (selectedLibrary == null) {
      return const Center(child: Text('No library selected. Please select a library via the switcher.'));
    }

    final libraryId = selectedLibrary.id;
    final api = ref.watch(absApiProvider);
    if (api == null) {
      return const Center(child: Text('No server connection available.'));
    }

    final playlistStateAsync = ref.watch(playlistsProvider(libraryId));

    return playlistStateAsync.when(
      data: (state) {
        final playlists = state.items;
        if (playlists.isEmpty) {
          return const Center(child: Text('No playlists found in this library.'));
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final gridLayout = appCenteredGridLayout(constraints.maxWidth, tileWidth: appGridTileWidth * 1.5);

            return Stack(
              children: [
                Positioned.fill(
                  child: RefreshIndicator(
                    onRefresh: () => ref.read(playlistsProvider(libraryId).notifier).refresh(withLoading: false),
                    child: AlignedGridView.count(
                      controller: scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(gridLayout.horizontalPadding, 12, gridLayout.horizontalPadding, 16),
                      crossAxisCount: gridLayout.crossAxisCount,
                      mainAxisSpacing: appGridSpacing,
                      crossAxisSpacing: appGridSpacing,
                      itemCount: playlists.length,
                      itemBuilder: (context, index) {
                        final playlist = playlists[index];
                        final playlistEntry = MultiBookEntryData.fromPlaylist(playlist);

                        return MultiBookEntryWidget(
                          api: api,
                          entry: playlistEntry,
                          compact: constraints.maxWidth < 700,
                          squareCover: true,
                          coverHeight: appGridTileWidth,
                          showSubtitle: true,
                          maxBooksToShow: defaultMultiBookPreviewLimit,
                          onTap: () {
                            context.push('/playlist/${playlist.id}', extra: playlistEntry);
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
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error loading playlists: $error')),
    );
  }
}
