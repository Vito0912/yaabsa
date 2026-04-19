import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_data.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_named_entity.dart';
import 'package:yaabsa/api/library/request/library_filter.dart';
import 'package:yaabsa/api/library/request/library_sort.dart';
import 'package:yaabsa/components/app/library/library_filter_sheet.dart';
import 'package:yaabsa/components/app/library/library_sort_sheet.dart';

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
  });

  final String libraryMediaType;
  final String? activeFilter;
  final String? activeSort;
  final int? activeSortDesc;
  final AsyncValue<LibraryFilterData?> filterDataAsync;
  final Future<void> Function(String filterQuery) onFilterSelected;
  final Future<void> Function(LibrarySortSelection sortSelection) onSortSelected;
  final Future<void> Function() onClearFilter;

  @override
  Widget build(BuildContext context) {
    final activeFilterLabel = _resolveActiveFilterLabel(activeFilter, filterDataAsync.value);
    final activeSortLabel = buildLibrarySortLabel(
      libraryMediaType: libraryMediaType,
      activeFilter: activeFilter,
      activeSort: activeSort,
      activeDesc: activeSortDesc,
    );

    final filterButtonLabel = activeFilterLabel == null ? 'Filter' : 'Filter: ${_truncateLabel(activeFilterLabel)}';
    final sortButtonLabel = 'Sort: ${_truncateLabel(activeSortLabel)}';

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
            OutlinedButton.icon(
              onPressed: () => _openFilterSheet(context),
              icon: filterDataAsync.isLoading
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.filter_alt_rounded),
              label: Text(filterButtonLabel),
            ),
            OutlinedButton.icon(
              onPressed: () => _openSortSheet(context),
              icon: const Icon(Icons.sort_rounded),
              label: Text(sortButtonLabel),
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

  static String? _resolveActiveFilterLabel(String? filter, LibraryFilterData? filterData) {
    if (filter == null || filter.isEmpty) {
      return null;
    }

    if (filter == 'issues') {
      return 'Special: Issues';
    }

    if (filter == 'feed-open') {
      return 'Special: Feed Open';
    }

    final parsed = parseGroupedLibraryFilterQuery(filter);
    if (parsed == null) {
      return filter;
    }

    final valueLabel = switch (parsed.group) {
      LibraryFilterGroup.authors => _resolveNamedValue(parsed.value, filterData?.authors),
      LibraryFilterGroup.series when parsed.value == 'no-series' => 'No series',
      LibraryFilterGroup.series => _resolveNamedValue(parsed.value, filterData?.series),
      LibraryFilterGroup.progress => _humanizeValue(parsed.value),
      LibraryFilterGroup.missing => _humanizeValue(parsed.value),
      LibraryFilterGroup.tracks => _humanizeValue(parsed.value),
      _ => parsed.value,
    };

    return '${parsed.group.displayName}: $valueLabel';
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
