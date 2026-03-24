import 'package:yaabsa/components/common/library_item_widget.dart';
import 'package:yaabsa/api/library/personalized_library.dart';
import 'package:yaabsa/api/library_items/author.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/series.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/library/personalized_library_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalizedView extends ConsumerWidget {
  const PersonalizedView({super.key});

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

    final personalizedLibraryAsyncValue = ref.watch(
      personalizedLibraryProvider(selectedLibrary.id),
    );

    return personalizedLibraryAsyncValue.when(
      data: (personalizedLibrary) {
        if (personalizedLibrary == null) {
          return const Center(child: Text('No personalized items found.'));
        }
        final api = ref.watch(absApiProvider);
        if (api == null) {
          return const Center(child: Text('No server connection available.'));
        }

        final sections = _buildSections(personalizedLibrary);
        if (sections.isEmpty) {
          return const Center(
            child: Text('No personalized sections available yet.'),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final horizontalPadding = width >= 1200
                ? 24.0
                : width >= 700
                ? 18.0
                : 10.0;
            final verticalPadding = width >= 1200 ? 22.0 : 14.0;
            final libraryTileWidth = _libraryItemTileWidth(width);

            return RefreshIndicator(
              onRefresh: () => ref
                  .read(
                    personalizedLibraryProvider(selectedLibrary.id).notifier,
                  )
                  .refresh(selectedLibrary.id, withLoading: false),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  verticalPadding,
                  horizontalPadding,
                  verticalPadding,
                ),
                itemCount: sections.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final section = sections[index];
                  return _SectionRow(
                    section: section,
                    api: api,
                    libraryTileWidth: libraryTileWidth,
                    viewportWidth: width,
                  );
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}

enum _ShelfEntityKind { libraryItem, series, author, episode }

class _SectionData {
  _SectionData({
    required this.title,
    required this.kind,
    required this.entities,
  });

  final String title;
  final _ShelfEntityKind kind;
  final List<Object> entities;
}

List<_SectionData> _buildSections(PersonalizedLibrary library) {
  final sections = <_SectionData>[];

  void addSection<T>(ShelfEntry<T>? shelf, _ShelfEntityKind kind) {
    if (shelf == null || shelf.entities.isEmpty) return;
    sections.add(
      _SectionData(
        title: shelf.label,
        kind: kind,
        entities: shelf.entities.cast<Object>(),
      ),
    );
  }

  addSection(library.continueListening, _ShelfEntityKind.libraryItem);
  addSection(library.continueSeries, _ShelfEntityKind.libraryItem);
  addSection(library.recentlyAdded, _ShelfEntityKind.libraryItem);
  addSection(library.discover, _ShelfEntityKind.libraryItem);
  addSection(library.listenAgain, _ShelfEntityKind.libraryItem);
  addSection(library.recentSeries, _ShelfEntityKind.series);
  addSection(library.newestAuthors, _ShelfEntityKind.author);
  addSection(library.newestEpisodes, _ShelfEntityKind.episode);

  return sections;
}

double _libraryItemTileWidth(double width) {
  if (width >= 1700) return 210;
  if (width >= 1400) return 190;
  if (width >= 1000) return 170;
  if (width >= 700) return 150;
  return 138;
}

class _SectionRow extends StatelessWidget {
  const _SectionRow({
    required this.section,
    required this.api,
    required this.libraryTileWidth,
    required this.viewportWidth,
  });

  final _SectionData section;
  final ABSApi api;
  final double libraryTileWidth;
  final double viewportWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
          child: Text(
            section.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _SectionList(
          section: section,
          api: api,
          libraryTileWidth: libraryTileWidth,
          viewportWidth: viewportWidth,
        ),
      ],
    );
  }
}

class _SectionList extends StatelessWidget {
  const _SectionList({
    required this.section,
    required this.api,
    required this.libraryTileWidth,
    required this.viewportWidth,
  });

  final _SectionData section;
  final ABSApi api;
  final double libraryTileWidth;
  final double viewportWidth;

  @override
  Widget build(BuildContext context) {
    final isLibraryItems = section.kind == _ShelfEntityKind.libraryItem;
    final rowHeight = isLibraryItems
        ? libraryTileWidth + 42.0
        : (viewportWidth >= 700 ? 112.0 : 96.0);

    return SizedBox(
      height: rowHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: section.entities.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final entity = section.entities[index];
          switch (section.kind) {
            case _ShelfEntityKind.libraryItem:
              return SizedBox(
                width: libraryTileWidth,
                child: LibraryItemWidget(
                  entity as LibraryItem,
                  api,
                  showProgress: true,
                  compact: true,
                  squareCover: true,
                ),
              );
            case _ShelfEntityKind.series:
              final series = entity as Series;
              return SizedBox(
                width: viewportWidth >= 1100 ? 280 : 240,
                child: _MetaCard(
                  icon: Icons.auto_stories_outlined,
                  title: series.name,
                  subtitle: series.numBooks != null
                      ? '${series.numBooks} books'
                      : null,
                ),
              );
            case _ShelfEntityKind.author:
              final author = entity as Author;
              return SizedBox(
                width: viewportWidth >= 1100 ? 260 : 220,
                child: _MetaCard(
                  icon: Icons.person_outline,
                  title: author.name,
                ),
              );
            case _ShelfEntityKind.episode:
              final episode = entity as Episode;
              return SizedBox(
                width: viewportWidth >= 1100 ? 320 : 270,
                child: _MetaCard(
                  icon: Icons.podcasts_outlined,
                  title: episode.title ?? 'Untitled episode',
                  subtitle: episode.subtitle,
                ),
              );
          }
        },
      ),
    );
  }
}

class _MetaCard extends StatelessWidget {
  const _MetaCard({required this.icon, required this.title, this.subtitle});

  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (subtitle != null && subtitle!.isNotEmpty)
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
