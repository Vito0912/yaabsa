import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_named_entity.dart';
import 'package:yaabsa/api/library/request/library_filter.dart';
import 'package:yaabsa/api/library/search_library_author.dart';
import 'package:yaabsa/components/common/author_card.dart';
import 'package:yaabsa/provider/common/library_filter_data_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/common/library_search_provider.dart';
import 'package:yaabsa/screens/main/library_view.dart';
import 'package:yaabsa/util/globals.dart';

class AuthorDetailView extends ConsumerWidget {
  const AuthorDetailView({super.key, required this.authorId});

  final String authorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLibrary = ref.watch(selectedLibraryProvider);
    if (selectedLibrary == null) {
      return const Center(child: Text('No library selected. Please select a library via the switcher.'));
    }

    if (selectedLibrary.mediaType != 'book') {
      return const Center(child: Text('Authors are available only for book libraries.'));
    }

    final libraryId = selectedLibrary.id;
    final filterData = ref.watch(libraryFilterDataProvider(libraryId)).value;
    final fallbackAuthor = _findAuthorById(filterData?.authors, authorId);

    final searchAsync = fallbackAuthor == null
        ? const AsyncValue<SearchLibraryAuthor?>.data(null)
        : ref.watch(_authorDetailsProvider(_AuthorLookupInput(authorId: authorId, query: fallbackAuthor.name)));

    final resolvedAuthor = searchAsync.value;
    final title = resolvedAuthor?.name ?? fallbackAuthor?.name ?? authorId;
    final description = resolvedAuthor?.description;
    final subtitle = resolvedAuthor == null || resolvedAuthor.numBooks <= 0
        ? null
        : '${resolvedAuthor.numBooks} ${resolvedAuthor.numBooks == 1 ? 'book' : 'books'}';
    final authorFilter = LibraryFilter.grouped(LibraryFilterGroup.authors, authorId).queryValue;

    return Column(
      children: [
        _AuthorTopSection(
          authorId: authorId,
          title: title,
          subtitle: subtitle,
          description: description,
          isLoadingDetails: searchAsync.isLoading && !searchAsync.hasValue,
        ),
        Expanded(child: LibraryView(initialFilter: authorFilter)),
      ],
    );
  }
}

class _AuthorTopSection extends StatelessWidget {
  const _AuthorTopSection({
    required this.authorId,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.isLoadingDetails,
  });

  final String authorId;
  final String title;
  final String? subtitle;
  final String? description;
  final bool isLoadingDetails;

  @override
  Widget build(BuildContext context) {
    final imageSize = context.isDesktop
        ? 112.0
        : context.isTablet
        ? 98.0
        : 80.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                    return;
                  }

                  context.go('/?tab=authors&intent=${DateTime.now().microsecondsSinceEpoch}');
                },
                icon: const Icon(Icons.arrow_back_rounded),
                tooltip: 'Back',
              ),
              const SizedBox(width: 6),
              AuthorImage(authorId: authorId, width: imageSize, height: imageSize, borderRadius: 14),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ],
                    if (description != null && description!.trim().isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        description!.trim(),
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: context.isMobile ? 4 : 6,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ] else if (isLoadingDetails) ...[
                      const SizedBox(height: 8),
                      const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.2)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final _authorDetailsProvider = FutureProvider.autoDispose.family<SearchLibraryAuthor?, _AuthorLookupInput>((
  ref,
  input,
) async {
  final searchResult = await ref.watch(librarySearchProvider(input.query).future);
  final candidates = searchResult?.authors;
  if (candidates == null || candidates.isEmpty) {
    return null;
  }

  for (final candidate in candidates) {
    if (candidate.id == input.authorId) {
      return candidate;
    }
  }

  final targetName = input.query.toLowerCase();
  for (final candidate in candidates) {
    if (candidate.name.toLowerCase() == targetName) {
      return candidate;
    }
  }

  return candidates.first;
});

class _AuthorLookupInput {
  const _AuthorLookupInput({required this.authorId, required this.query});

  final String authorId;
  final String query;

  @override
  bool operator ==(Object other) {
    return other is _AuthorLookupInput && other.authorId == authorId && other.query == query;
  }

  @override
  int get hashCode => Object.hash(authorId, query);
}

LibraryFilterNamedEntity? _findAuthorById(List<LibraryFilterNamedEntity>? authors, String authorId) {
  if (authors == null) {
    return null;
  }

  for (final author in authors) {
    if (author.id == authorId) {
      return author;
    }
  }

  return null;
}
