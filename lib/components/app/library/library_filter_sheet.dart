import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_data.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_named_entity.dart';
import 'package:yaabsa/api/library/request/library_filter.dart';
import 'package:yaabsa/components/common/expressive_expandable_card.dart';
import 'package:yaabsa/features/library/widgets/library_control_sheet.dart';
import 'package:yaabsa/ui/components/feedback/feedback_panel.dart';
import 'package:yaabsa/ui/components/inputs/search_field.dart';
import 'package:yaabsa/util/l10n.dart';

class LibraryFilterSheet extends StatelessWidget {
  const LibraryFilterSheet({
    super.key,
    required this.libraryMediaType,
    required this.activeFilter,
    required this.filterData,
    this.includeSpecialFilters = true,
  });

  final String libraryMediaType;
  final String? activeFilter;
  final LibraryFilterData? filterData;
  final bool includeSpecialFilters;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isBookLibrary = libraryMediaType == 'book';
    final sections = <_FilterSectionData>[
      if (includeSpecialFilters) _buildSpecialSection(l10n),
      _buildStringSection(
        title: l10n.fieldGenres,
        group: LibraryFilterGroup.genres,
        values: filterData?.genres ?? const <String>[],
      ),
      _buildStringSection(
        title: l10n.fieldTags,
        group: LibraryFilterGroup.tags,
        values: filterData?.tags ?? const <String>[],
      ),
      _buildStringSection(
        title: l10n.headingLanguages,
        group: LibraryFilterGroup.languages,
        values: filterData?.languages ?? const <String>[],
      ),
      if (isBookLibrary)
        _buildNamedSection(
          l10n: l10n,
          title: l10n.fieldAuthors,
          group: LibraryFilterGroup.authors,
          values: filterData?.authors ?? const <LibraryFilterNamedEntity>[],
        ),
      if (isBookLibrary)
        _buildNamedSection(
          l10n: l10n,
          title: l10n.fieldSeries,
          group: LibraryFilterGroup.series,
          values: filterData?.series ?? const <LibraryFilterNamedEntity>[],
          includeNoSeriesOption: true,
        ),
      if (isBookLibrary)
        _buildStringSection(
          title: l10n.fieldNarrators,
          group: LibraryFilterGroup.narrators,
          values: filterData?.narrators ?? const <String>[],
        ),
      if (isBookLibrary) _buildProgressSection(l10n),
      if (isBookLibrary) _buildTracksSection(l10n),
      if (isBookLibrary) _buildMissingSection(l10n),
    ];

    final visibleSections = sections.where((section) => section.options.isNotEmpty).toList(growable: false);

    final hasActiveFilter = activeFilter != null && activeFilter!.isNotEmpty;

    return LibraryControlSheet(
      title: l10n.actionFilter,
      headerAction: hasActiveFilter
          ? TextButton.icon(
              onPressed: () => Navigator.of(context).pop(''),
              icon: const Icon(Icons.filter_alt_off_rounded),
              label: Text(l10n.actionClear),
            )
          : null,
      child: visibleSections.isEmpty
          ? YaabsaFeedbackPanel(
              icon: Icons.filter_list_off_rounded,
              title: l10n.statusNoFilterOptionsAvailable,
              message: l10n.messageNoLibraryFilterValues,
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
              itemCount: visibleSections.length,
              itemBuilder: (context, index) {
                final section = visibleSections[index];
                return _FilterSection(
                  section: section,
                  activeFilter: activeFilter,
                  onSelect: (queryValue) => Navigator.of(context).pop(queryValue),
                );
              },
            ),
    );
  }

  _FilterSectionData _buildSpecialSection(AppLocalizations l10n) {
    return _FilterSectionData(
      title: l10n.headingSpecialFilters,
      options: [
        _FilterOption(label: l10n.navIssues, queryValue: 'issues'),
        _FilterOption(label: l10n.filterOpenFeeds, queryValue: 'feed-open'),
      ],
    );
  }

  _FilterSectionData _buildProgressSection(AppLocalizations l10n) {
    final values = LibraryProgressFilterValue.values
        .map(
          (value) => _FilterOption(
            label: switch (value) {
              LibraryProgressFilterValue.finished => l10n.statusFinished,
              LibraryProgressFilterValue.notStarted => l10n.statusNotStarted,
              LibraryProgressFilterValue.notFinished => l10n.statusNotFinished,
              LibraryProgressFilterValue.inProgress => l10n.statusInProgress,
            },
            queryValue: LibraryFilter.progress(value).queryValue,
          ),
        )
        .toList(growable: false);

    return _FilterSectionData(title: l10n.fieldProgress, options: values);
  }

  _FilterSectionData _buildMissingSection(AppLocalizations l10n) {
    final values = LibraryMissingFilterValue.values
        .map(
          (value) => _FilterOption(
            label: switch (value) {
              LibraryMissingFilterValue.asin => l10n.fieldAsin,
              LibraryMissingFilterValue.isbn => l10n.fieldIsbn,
              LibraryMissingFilterValue.subtitle => l10n.fieldSubtitle,
              LibraryMissingFilterValue.authors => l10n.fieldAuthors,
              LibraryMissingFilterValue.publishedYear => l10n.fieldPublishedYear,
              LibraryMissingFilterValue.series => l10n.fieldSeries,
              LibraryMissingFilterValue.description => l10n.fieldDescription,
              LibraryMissingFilterValue.genres => l10n.fieldGenres,
              LibraryMissingFilterValue.tags => l10n.fieldTags,
              LibraryMissingFilterValue.narrators => l10n.fieldNarrators,
              LibraryMissingFilterValue.publisher => l10n.fieldPublisher,
              LibraryMissingFilterValue.language => l10n.fieldLanguage,
            },
            queryValue: LibraryFilter.missing(value).queryValue,
          ),
        )
        .toList(growable: false);

    return _FilterSectionData(title: l10n.headingMissingMetadata, options: values);
  }

  _FilterSectionData _buildTracksSection(AppLocalizations l10n) {
    final values = LibraryTracksFilterValue.values
        .map(
          (value) => _FilterOption(
            label: switch (value) {
              LibraryTracksFilterValue.single => l10n.filterSingleTrack,
              LibraryTracksFilterValue.multi => l10n.filterMultipleTracks,
            },
            queryValue: LibraryFilter.tracks(value).queryValue,
          ),
        )
        .toList(growable: false);

    return _FilterSectionData(title: l10n.fieldTracks, options: values);
  }

  _FilterSectionData _buildStringSection({
    required String title,
    required LibraryFilterGroup group,
    required List<String> values,
  }) {
    final options =
        values
            .where((value) => value.trim().isNotEmpty)
            .toSet()
            .map((value) => _FilterOption(label: value, queryValue: LibraryFilter.grouped(group, value).queryValue))
            .toList(growable: false)
          ..sort((a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));

    return _FilterSectionData(title: title, options: options);
  }

  _FilterSectionData _buildNamedSection({
    required AppLocalizations l10n,
    required String title,
    required LibraryFilterGroup group,
    required List<LibraryFilterNamedEntity> values,
    bool includeNoSeriesOption = false,
  }) {
    final options =
        values
            .where((value) => value.id.trim().isNotEmpty && value.name.trim().isNotEmpty)
            .map(
              (value) =>
                  _FilterOption(label: value.name, queryValue: LibraryFilter.grouped(group, value.id).queryValue),
            )
            .toList(growable: true)
          ..sort((a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));

    if (includeNoSeriesOption) {
      options.insert(
        0,
        _FilterOption(
          label: l10n.statusNoSeriesFilterOption,
          queryValue: LibraryFilter.grouped(LibraryFilterGroup.series, 'no-series').queryValue,
        ),
      );
    }

    return _FilterSectionData(title: title, options: options);
  }
}

class _FilterSection extends StatefulWidget {
  const _FilterSection({required this.section, required this.activeFilter, required this.onSelect});

  final _FilterSectionData section;
  final String? activeFilter;
  final ValueChanged<String> onSelect;

  @override
  State<_FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<_FilterSection> {
  String _search = '';
  late bool _isExpanded;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.section.options.any((option) => option.queryValue == widget.activeFilter);
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.section.options;
    String? selectedLabel;
    for (final option in options) {
      if (option.queryValue == widget.activeFilter) {
        selectedLabel = option.label;
        break;
      }
    }

    final filteredOptions = _search.isEmpty
        ? options
        : options.where((option) => option.label.toLowerCase().contains(_search.toLowerCase())).toList(growable: false);

    final showSearchField = options.length > 12;
    final denseListHeight = math.min(filteredOptions.length * 44.0, 240.0);
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final colorScheme = theme.colorScheme;
    final cardColor = _isExpanded ? colorScheme.surfaceContainerHigh : colorScheme.surfaceContainerLow;
    final borderColor = _isExpanded ? colorScheme.primary : colorScheme.outlineVariant.withValues(alpha: 0.48);

    return ExpressiveExpandableCard(
      title: widget.section.title,
      subtitle: selectedLabel != null
          ? l10n.statusSelectedFilterOption(selectedLabel)
          : l10n.statusFilterOptionCount(widget.section.options.length),
      icon: selectedLabel != null ? Icons.check_circle_rounded : null,
      margin: const EdgeInsets.only(bottom: 10),
      childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      initiallyExpanded: _isExpanded,
      onExpansionChanged: (expanded) {
        setState(() {
          _isExpanded = expanded;
        });
      },
      cardColor: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: borderColor),
      ),
      children: [
        if (showSearchField)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: YaabsaSearchField(
              controller: _searchController,
              label: l10n.fieldSearchOptions,
              hintText: l10n.hintSearchWithinOptions,
              onChanged: (value) {
                setState(() {
                  _search = value.trim();
                });
              },
            ),
          ),
        if (filteredOptions.isEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(l10n.statusNoMatchingOptions)),
          )
        else if (filteredOptions.length <= 8)
          LayoutBuilder(
            builder: (context, constraints) {
              final maxChipWidth = math.max(120.0, constraints.maxWidth - 24);

              return Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: filteredOptions
                      .map(
                        (option) => ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: maxChipWidth),
                          child: ChoiceChip(
                            label: Text(option.label, maxLines: 1, overflow: TextOverflow.ellipsis),
                            selected: option.queryValue == widget.activeFilter,
                            onSelected: (_) => widget.onSelect(option.queryValue),
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
              );
            },
          )
        else
          SizedBox(
            height: denseListHeight,
            child: ListView.separated(
              itemCount: filteredOptions.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final option = filteredOptions[index];
                final isSelected = option.queryValue == widget.activeFilter;

                return ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  selected: isSelected,
                  selectedTileColor: colorScheme.secondaryContainer,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  title: Text(option.label),
                  trailing: isSelected ? Icon(Icons.check_rounded, color: colorScheme.primary) : null,
                  onTap: () => widget.onSelect(option.queryValue),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _FilterSectionData {
  const _FilterSectionData({required this.title, required this.options});

  final String title;
  final List<_FilterOption> options;
}

class _FilterOption {
  const _FilterOption({required this.label, required this.queryValue});

  final String label;
  final String queryValue;
}
