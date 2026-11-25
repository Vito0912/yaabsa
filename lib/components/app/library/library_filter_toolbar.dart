import 'package:material_ui/material_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_data.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_named_entity.dart';
import 'package:yaabsa/api/library/request/library_filter.dart';
import 'package:yaabsa/api/library/request/library_sort.dart';
import 'package:yaabsa/components/app/library/library_filter_sheet.dart';
import 'package:yaabsa/components/app/library/library_sort_sheet.dart';
import 'package:yaabsa/ui/components/buttons/sort_button.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/components/buttons/yaabsa_button.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/l10n.dart';

class LibraryFilterToolbar extends StatelessWidget {
  const LibraryFilterToolbar({
    super.key,
    required this.libraryMediaType,
    required this.activeFilter,
    required this.activeSort,
    required this.activeSortDesc,
    required this.filterDataAsync,
    required this.onFilterSelected,
    required this.onSortSelected,
    required this.onClearFilter,
    this.title,
    this.onBack,
  });

  final String libraryMediaType;
  final String? activeFilter;
  final String? activeSort;
  final int? activeSortDesc;
  final AsyncValue<LibraryFilterData?> filterDataAsync;
  final Future<void> Function(String filterQuery) onFilterSelected;
  final Future<void> Function(LibrarySortSelection sortSelection) onSortSelected;
  final Future<void> Function() onClearFilter;
  final String? title;
  final VoidCallback? onBack;

  static const double _maxButtonWidth = 200.0;

  @override
  Widget build(BuildContext context) {
    final activeFilterLabel = resolveActiveFilterLabel(context.l10n, activeFilter, filterDataAsync.value);
    final activeSortLabel = buildLibrarySortLabel(
      libraryMediaType: libraryMediaType,
      activeFilter: activeFilter,
      activeSort: activeSort,
      activeDesc: activeSortDesc,
    );

    final filterButtonLabel = activeFilterLabel == null ? context.l10n.actionFilter : _truncateLabel(activeFilterLabel);
    final sortButtonLabel = _truncateLabel(activeSortLabel);
    final hasActiveFilter = activeFilter?.isNotEmpty ?? false;
    final colorScheme = Theme.of(context).colorScheme;

    if (title != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 12, 8),
        child: Row(
          children: [
            IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back_rounded), tooltip: context.l10n.actionBack),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                title!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(width: 4),
            YaabsaSortButton(
              label: activeSortLabel,
              tooltip: context.l10n.actionSortBy(activeSortLabel),
              onPressed: () => _openSortSheet(context),
              iconOnly: context.isMobile,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Align(
        alignment: Alignment.centerRight,
        child: Wrap(
          alignment: WrapAlignment.end,
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: _maxButtonWidth),
              child: Tooltip(
                message: activeFilterLabel ?? context.l10n.actionFilter,
                child: YaabsaButton.small(
                  onPressed: () => _openFilterSheet(context),
                  variant: YaabsaButtonVariant.outlined,
                  style: hasActiveFilter
                      ? ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(colorScheme.secondaryContainer),
                          foregroundColor: WidgetStatePropertyAll(colorScheme.onSecondaryContainer),
                          side: WidgetStatePropertyAll(BorderSide(color: colorScheme.primary)),
                        )
                      : null,
                  icon: filterDataAsync.isLoading
                      ? const SizedBox(width: 16, height: 16, child: YaabsaCircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.filter_alt_rounded),
                  label: Text(filterButtonLabel, overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: _maxButtonWidth),
              child: YaabsaSortButton(
                label: sortButtonLabel,
                tooltip: activeSortLabel,
                onPressed: () => _openSortSheet(context),
                iconOnly: false,
                maxLabelCharacters: 34,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _truncateLabel(String label, {int maxLength = 34}) {
    if (label.length <= maxLength) {
      return label;
    }

    return '${label.substring(0, maxLength - 1)}…';
  }

  Future<void> _openFilterSheet(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => LibraryFilterSheet(
        libraryMediaType: libraryMediaType,
        activeFilter: activeFilter,
        filterData: filterDataAsync.value,
      ),
    );

    if (!context.mounted || result == null) {
      return;
    }

    if (result.isEmpty) {
      await onClearFilter();
      return;
    }

    await onFilterSelected(result);
  }

  Future<void> _openSortSheet(BuildContext context) async {
    final result = await showModalBottomSheet<LibrarySortSelection>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => LibrarySortSheet(
        libraryMediaType: libraryMediaType,
        activeFilter: activeFilter,
        activeSort: activeSort,
        activeSortDesc: activeSortDesc,
      ),
    );

    if (!context.mounted || result == null) {
      return;
    }

    await onSortSelected(result);
  }

  static String? resolveActiveFilterLabel(
    AppLocalizations localizations,
    String? filter,
    LibraryFilterData? filterData,
  ) {
    if (filter == null || filter.isEmpty) {
      return null;
    }

    if (filter == 'issues') {
      return localizations.statusSpecialFilter(localizations.navIssues);
    }

    if (filter == 'feed-open') {
      return localizations.statusSpecialFilter(localizations.filterOpenFeeds);
    }

    final parsed = parseGroupedLibraryFilterQuery(filter);
    if (parsed == null) {
      return filter;
    }

    final groupLabel = switch (parsed.group) {
      LibraryFilterGroup.genres => localizations.fieldGenres,
      LibraryFilterGroup.tags => localizations.fieldTags,
      LibraryFilterGroup.series => localizations.fieldSeries,
      LibraryFilterGroup.authors => localizations.fieldAuthors,
      LibraryFilterGroup.progress => localizations.fieldProgress,
      LibraryFilterGroup.narrators => localizations.fieldNarrators,
      LibraryFilterGroup.missing => localizations.headingMissingMetadata,
      LibraryFilterGroup.languages => localizations.headingLanguages,
      LibraryFilterGroup.tracks => localizations.fieldTracks,
    };

    final valueLabel = switch (parsed.group) {
      LibraryFilterGroup.genres ||
      LibraryFilterGroup.tags ||
      LibraryFilterGroup.languages ||
      LibraryFilterGroup.narrators => parsed.value,
      LibraryFilterGroup.authors => _resolveNamedValue(parsed.value, filterData?.authors),
      LibraryFilterGroup.series when parsed.value == 'no-series' => localizations.statusNoSeriesFilterOption,
      LibraryFilterGroup.series => _resolveNamedValue(parsed.value, filterData?.series),
      LibraryFilterGroup.progress => _resolveProgressValue(localizations, parsed.value),
      LibraryFilterGroup.missing => _resolveMissingValue(localizations, parsed.value),
      LibraryFilterGroup.tracks => _resolveTracksValue(localizations, parsed.value),
    };

    return localizations.statusActiveFilter(groupLabel, valueLabel);
  }

  static String _resolveProgressValue(AppLocalizations localizations, String value) {
    return switch (value) {
      'finished' => localizations.statusFinished,
      'not-started' => localizations.statusNotStarted,
      'not-finished' => localizations.statusNotFinished,
      'in-progress' => localizations.statusInProgress,
      _ => _humanizeValue(value),
    };
  }

  static String _resolveMissingValue(AppLocalizations localizations, String value) {
    return switch (value) {
      'asin' => localizations.fieldAsin,
      'isbn' => localizations.fieldIsbn,
      'subtitle' => localizations.fieldSubtitle,
      'authors' => localizations.fieldAuthors,
      'publishedYear' => localizations.fieldPublishedYear,
      'series' => localizations.fieldSeries,
      'description' => localizations.fieldDescription,
      'genres' => localizations.fieldGenres,
      'tags' => localizations.fieldTags,
      'narrators' => localizations.fieldNarrators,
      'publisher' => localizations.fieldPublisher,
      'language' => localizations.fieldLanguage,
      _ => _humanizeValue(value),
    };
  }

  static String _resolveTracksValue(AppLocalizations localizations, String value) {
    return switch (value) {
      'single' => localizations.filterSingleTrack,
      'multi' => localizations.filterMultipleTracks,
      _ => _humanizeValue(value),
    };
  }

  static String _resolveNamedValue(String fallbackValue, List<LibraryFilterNamedEntity>? values) {
    if (values == null) {
      return fallbackValue;
    }

    final matched = values.where((value) => value.id == fallbackValue);
    if (matched.isEmpty) {
      return fallbackValue;
    }

    return matched.first.name;
  }

  static String _humanizeValue(String value) {
    final split = value
        .replaceAll('-', ' ')
        .replaceAll('_', ' ')
        .split(' ')
        .where((segment) => segment.isNotEmpty)
        .toList(growable: false);

    if (split.isEmpty) {
      return value;
    }

    return split.map((segment) => '${segment[0].toUpperCase()}${segment.substring(1)}').join(' ');
  }
}
