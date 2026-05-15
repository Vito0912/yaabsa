import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/api/library/author_details.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/common/library_item_widget.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/layout_sizes.dart';

class AuthorDetailContent extends StatelessWidget {
  const AuthorDetailContent({super.key, required this.author, required this.api});

  final AuthorDetails author;
  final ABSApi api;

  @override
  Widget build(BuildContext context) {
    final books = author.libraryItems;
    final seriesGroups = author.series.where((series) => series.items.isNotEmpty).toList(growable: false);

    return LayoutBuilder(
      builder: (context, constraints) {
        final gridLayout = appCenteredGridLayout(constraints.maxWidth);

        return ListView(
          padding: EdgeInsets.fromLTRB(gridLayout.horizontalPadding, 8, gridLayout.horizontalPadding, 16),
          children: [
            _SectionHeader(
              title: 'Series',
              subtitle: '${seriesGroups.length} ${seriesGroups.length == 1 ? 'series' : 'series groups'}',
            ),
            const SizedBox(height: 8),
            if (seriesGroups.isEmpty)
              const _SectionEmptyState(message: 'No series found for this author.')
            else
              ...seriesGroups.map(
                (series) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _AuthorSeriesGroupSection(series: series, api: api),
                ),
              ),
            _SectionHeader(title: 'Books', subtitle: '${books.length} ${books.length == 1 ? 'book' : 'books'}'),
            const SizedBox(height: 8),
            if (books.isEmpty)
              const _SectionEmptyState(message: 'No books found for this author.')
            else
              _LibraryItemGrid(items: books, api: api, crossAxisCount: gridLayout.crossAxisCount),
          ],
        );
      },
    );
  }
}

class _AuthorSeriesGroupSection extends StatelessWidget {
  const _AuthorSeriesGroupSection({required this.series, required this.api});

  final AuthorSeriesGroup series;
  final ABSApi api;

  @override
  Widget build(BuildContext context) {
    final itemCount = series.items.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                series.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(width: 8),
            Text('$itemCount ${itemCount == 1 ? 'book' : 'books'}', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(width: 8),
            TextButton(onPressed: () => context.push('/series/${series.id}'), child: const Text('Open Series')),
          ],
        ),
        const SizedBox(height: 8),
        _LibraryItemHorizontalList(items: series.items, api: api, keyPrefix: series.id),
      ],
    );
  }
}

class _LibraryItemHorizontalList extends StatelessWidget {
  const _LibraryItemHorizontalList({required this.items, required this.api, this.keyPrefix});

  final List<LibraryItem> items;
  final ABSApi api;
  final String? keyPrefix;

  @override
  Widget build(BuildContext context) {
    final itemWidth = context.isDesktop
        ? 220.0
        : context.isTablet
        ? 196.0
        : 172.0;
    final listHeight = itemWidth + 132;

    return SizedBox(
      height: listHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: appGridSpacing),
        itemBuilder: (context, index) {
          final item = items[index];
          final keyBase = keyPrefix == null ? item.id : '$keyPrefix-${item.id}-$index';
          return SizedBox(
            width: itemWidth,
            child: KeyedSubtree(
              key: ValueKey<String>(keyBase),
              child: LibraryItemWidget(item, api, showProgress: true, squareCover: true),
            ),
          );
        },
      ),
    );
  }
}

class _LibraryItemGrid extends StatelessWidget {
  const _LibraryItemGrid({required this.items, required this.api, required this.crossAxisCount});

  final List<LibraryItem> items;
  final ABSApi api;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return AlignedGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: appGridSpacing,
      crossAxisSpacing: appGridSpacing,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return KeyedSubtree(
          key: ValueKey<String>(item.id),
          child: LibraryItemWidget(item, api, showProgress: true, squareCover: true),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(width: 8),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _SectionEmptyState extends StatelessWidget {
  const _SectionEmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
