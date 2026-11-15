import 'package:flutter/widget_previews.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_data.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_named_entity.dart';
import 'package:yaabsa/api/library/request/library_filter.dart';
import 'package:yaabsa/components/app/library/library_filter_sheet.dart';
import 'package:yaabsa/components/app/library/library_sort_sheet.dart';
import 'package:yaabsa/components/common/list_management_header.dart';
import 'package:yaabsa/features/library/widgets/library_item_card.dart';
import 'package:yaabsa/features/library/widgets/managed_list_detail_frame.dart';
import 'package:yaabsa/util/globals.dart';

import 'preview_theme.dart';

@Preview(name: 'Library sorting / phone', size: Size(390, 844), wrapper: yaabsaPreviewLight)
@Preview(name: 'Library sorting / desktop', size: Size(800, 760), wrapper: yaabsaPreviewLight)
@Preview(name: 'Library sorting / dark', size: Size(390, 844), wrapper: yaabsaPreviewDark)
@Preview(name: 'Library sorting / AMOLED', size: Size(390, 844), wrapper: yaabsaPreviewAmoled)
Widget librarySortSheetPreview() => const LibrarySortSheet(
  libraryMediaType: 'book',
  activeFilter: null,
  activeSort: 'media.metadata.title',
  activeSortDesc: 0,
);

@Preview(name: 'Library filters / phone', size: Size(390, 844), wrapper: yaabsaPreviewLight)
@Preview(name: 'Library filters / desktop', size: Size(800, 900), wrapper: yaabsaPreviewLight)
@Preview(name: 'Library filters / dark', size: Size(390, 844), wrapper: yaabsaPreviewDark)
@Preview(name: 'Library filters / AMOLED', size: Size(390, 844), wrapper: yaabsaPreviewAmoled)
Widget libraryFilterSheetPreview() => LibraryFilterSheet(
  libraryMediaType: 'book',
  activeFilter: LibraryFilter.grouped(LibraryFilterGroup.authors, 'author-14').queryValue,
  filterData: _previewFilterData,
);

@Preview(name: 'Collection detail / phone', size: Size(390, 844), wrapper: yaabsaPreviewLight)
@Preview(name: 'Playlist detail / desktop', size: Size(1280, 800), wrapper: yaabsaPreviewLight)
@Preview(name: 'Collection detail / dark', size: Size(390, 844), wrapper: yaabsaPreviewDark)
@Preview(name: 'Playlist detail / AMOLED', size: Size(1280, 800), wrapper: yaabsaPreviewAmoled)
Widget managedListDetailPreview() => const ManagedListDetailPreview();

@Preview(name: 'Collection and playlist headers / phone', size: Size(390, 320), wrapper: yaabsaPreviewLight)
@Preview(name: 'Collection and playlist headers / phone dark', size: Size(390, 320), wrapper: yaabsaPreviewDark)
@Preview(name: 'Collection and playlist headers / phone AMOLED', size: Size(390, 320), wrapper: yaabsaPreviewAmoled)
@Preview(name: 'Collection and playlist headers / breakpoint', size: Size(512, 320), wrapper: yaabsaPreviewLight)
@Preview(name: 'Collection and playlist headers / desktop', size: Size(800, 320), wrapper: yaabsaPreviewLight)
Widget managedListLandingHeaderPreview() => const ManagedListLandingHeaderPreview();

const LibraryFilterData _previewFilterData = LibraryFilterData(
  authors: [
    LibraryFilterNamedEntity(id: 'author-01', name: 'Mira Ellery'),
    LibraryFilterNamedEntity(id: 'author-02', name: 'Jonas Vale'),
    LibraryFilterNamedEntity(id: 'author-03', name: 'Elena Mar'),
    LibraryFilterNamedEntity(id: 'author-04', name: 'Amara Whitcomb'),
    LibraryFilterNamedEntity(id: 'author-05', name: 'Theo Ashford'),
    LibraryFilterNamedEntity(id: 'author-06', name: 'Nadia Calder'),
    LibraryFilterNamedEntity(id: 'author-07', name: 'Elliot Wren'),
    LibraryFilterNamedEntity(id: 'author-08', name: 'Sofia March'),
    LibraryFilterNamedEntity(id: 'author-09', name: 'Rowan Bell'),
    LibraryFilterNamedEntity(id: 'author-10', name: 'Iris North'),
    LibraryFilterNamedEntity(id: 'author-11', name: 'Julian Shore'),
    LibraryFilterNamedEntity(id: 'author-12', name: 'Maren Pike'),
    LibraryFilterNamedEntity(id: 'author-13', name: 'Tamsin Rowe'),
    LibraryFilterNamedEntity(id: 'author-14', name: 'Avery Montgomery'),
    LibraryFilterNamedEntity(id: 'author-15', name: 'Caleb Winter'),
  ],
  genres: ['Literary fiction', 'Mystery', 'Travel writing'],
  tags: ['Award winner', 'Narrated by author'],
  series: [
    LibraryFilterNamedEntity(id: 'series-01', name: 'The Tidemark Stories'),
    LibraryFilterNamedEntity(id: 'series-02', name: 'Field Notes'),
  ],
  narrators: ['Elena Mar', 'Jonas Vale'],
  languages: ['English', 'German'],
);

class ManagedListLandingHeaderPreview extends StatelessWidget {
  const ManagedListLandingHeaderPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListManagementHeader(createLabel: 'New collection', onCreate: _ignoreAction),
        const Divider(height: 1),
        ListManagementHeader(createLabel: 'New playlist', onCreate: _ignoreAction),
      ],
    );
  }
}

class ManagedListDetailPreview extends StatefulWidget {
  const ManagedListDetailPreview({super.key});

  @override
  State<ManagedListDetailPreview> createState() => _ManagedListDetailPreviewState();
}

class _ManagedListDetailPreviewState extends State<ManagedListDetailPreview> {
  late final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 700;
    final colorScheme = Theme.of(context).colorScheme;
    final title = isWide ? 'Weekend listening playlist' : 'The Tidemark collection';

    return ManagedListDetailFrame(
      title: title,
      description: isWide
          ? 'A rotating queue for long walks and quiet evenings.'
          : 'Coastal stories selected for a slower afternoon.',
      statusMessage: isWide ? 'One podcast episode is unavailable.' : null,
      emptyTitle: 'This list is empty',
      emptyMessage: 'Add books or episodes to see them here.',
      emptyIcon: isWide ? Icons.playlist_play_rounded : Icons.collections_bookmark_outlined,
      headerActions: isWide
          ? Wrap(
              spacing: 0,
              children: [
                IconButton(
                  onPressed: _ignoreAction,
                  tooltip: 'Play random item',
                  icon: const Icon(Icons.shuffle_rounded),
                ),
                IconButton(
                  onPressed: _ignoreAction,
                  tooltip: 'Playlist actions',
                  icon: const Icon(Icons.more_vert_rounded),
                ),
              ],
            )
          : IconButton(
              onPressed: _ignoreAction,
              tooltip: 'Collection actions',
              icon: const Icon(Icons.more_vert_rounded),
            ),
      scrollController: _scrollController,
      onRefresh: () async {},
      itemCount: 3,
      itemBuilder: (context, index) {
        final titles = ['The Distant Shore', 'Winter at Low Tide', 'Field Notes from the Coast'];
        final authors = ['Mira Ellery', 'Jonas Vale', 'Tamsin Rowe'];
        final swatches = [colorScheme.primaryContainer, colorScheme.tertiaryContainer, colorScheme.secondaryContainer];
        final foregrounds = [
          colorScheme.onPrimaryContainer,
          colorScheme.onTertiaryContainer,
          colorScheme.onSecondaryContainer,
        ];

        return LibraryItemCard(
          cover: _PreviewManagedListCover(
            title: titles[index],
            background: swatches[index],
            foreground: foregrounds[index],
          ),
          title: titles[index],
          subtitle: Text(authors[index], maxLines: 1, overflow: TextOverflow.ellipsis),
          isDesktop: context.isDesktop,
          onTap: _ignoreAction,
        );
      },
    );
  }
}

class _PreviewManagedListCover extends StatelessWidget {
  const _PreviewManagedListCover({required this.title, required this.background, required this.foreground});

  final String title;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.menu_book_rounded, color: foreground),
              const Spacer(),
              Text(
                title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: foreground),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _ignoreAction() {}
