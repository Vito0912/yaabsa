import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_data.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_named_entity.dart';
import 'package:yaabsa/api/library/request/library_filter.dart';
import 'package:yaabsa/components/common/expressive_expandable_card.dart';
import 'package:yaabsa/features/library/widgets/library_control_sheet.dart';
import 'package:yaabsa/ui/components/feedback/feedback_panel.dart';
import 'package:yaabsa/ui/components/inputs/search_field.dart';

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
    final isBookLibrary = libraryMediaType == 'book';
    final sections = <_FilterSectionData>[
      if (includeSpecialFilters) _buildSpecialSection(),
      _buildStringSection(
        title: 'Genres',
        group: LibraryFilterGroup.genres,
        values: filterData?.genres ?? const <String>[],
      ),
      _buildStringSection(title: 'Tags', group: LibraryFilterGroup.tags, values: filterData?.tags ?? const <String>[]),
      _buildStringSection(
        title: 'Languages',
        group: LibraryFilterGroup.languages,
        values: filterData?.languages ?? const <String>[],
      ),
      if (isBookLibrary)
        _buildNamedSection(
          title: 'Authors',
          group: LibraryFilterGroup.authors,
          values: filterData?.authors ?? const <LibraryFilterNamedEntity>[],
        ),
      if (isBookLibrary)
        _buildNamedSection(
          title: 'Series',
          group: LibraryFilterGroup.series,
          values: filterData?.series ?? const <LibraryFilterNamedEntity>[],
          includeNoSeriesOption: true,
        ),
      if (isBookLibrary)
        _buildStringSection(
          title: 'Narrators',
          group: LibraryFilterGroup.narrators,
          values: filterData?.narrators ?? const <String>[],
        ),
      if (isBookLibrary) _buildProgressSection(),
      if (isBookLibrary) _buildTracksSection(),
      if (isBookLibrary) _buildMissingSection(),
    ];

    final visibleSections = sections.where((section) => section.options.isNotEmpty).toList(growable: false);

    final hasActiveFilter = activeFilter != null && activeFilter!.isNotEmpty;

    return LibraryControlSheet(
      title: 'Filter',
      headerAction: hasActiveFilter
          ? TextButton.icon(
              onPressed: () => Navigator.of(context).pop(''),
              icon: const Icon(Icons.filter_alt_off_rounded),
              label: const Text('Clear'),
            )
          : null,
      child: visibleSections.isEmpty
          ? const YaabsaFeedbackPanel(
              icon: Icons.filter_list_off_rounded,
              title: 'No filter options available',
              message: 'This library does not have any filter values yet.',
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

  _FilterSectionData _buildSpecialSection() {
    return _FilterSectionData(
      title: 'Special',
      options: const [
        _FilterOption(label: 'Issues', queryValue: 'issues'),
        _FilterOption(label: 'Feed Open', queryValue: 'feed-open'),
      ],
    );
  }

  _FilterSectionData _buildProgressSection() {
    final values = LibraryProgressFilterValue.values
        .map(
          (value) => _FilterOption(
            label: _humanizeValue(value.wireValue),
            queryValue: LibraryFilter.progress(value).queryValue,
          ),
        )
        .toList(growable: false);

    return _FilterSectionData(title: 'Progress', options: values);
  }

  _FilterSectionData _buildMissingSection() {
    final values = LibraryMissingFilterValue.values
        .map(
          (value) => _FilterOption(
            label: _humanizeValue(value.wireValue),
            queryValue: LibraryFilter.missing(value).queryValue,
          ),
        )
        .toList(growable: false);

    return _FilterSectionData(title: 'Missing Metadata', options: values);
  }

  _FilterSectionData _buildTracksSection() {
    final values = LibraryTracksFilterValue.values
        .map(
          (value) =>
              _FilterOption(label: _humanizeValue(value.wireValue), queryValue: LibraryFilter.tracks(value).queryValue),
        )
        .toList(growable: false);

    return _FilterSectionData(title: 'Tracks', options: values);
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
          label: 'No series',
          queryValue: LibraryFilter.grouped(LibraryFilterGroup.series, 'no-series').queryValue,
        ),
      );
    }

    return _FilterSectionData(title: title, options: options);
  }

  static String _humanizeValue(String value) {
    if (value.isEmpty) return value;

    final split = value
        .replaceAll('-', ' ')
        .replaceAll('_', ' ')
        .split(' ')
        .where((segment) => segment.isNotEmpty)
        .toList(growable: false);

    return split.map((segment) => '${segment[0].toUpperCase()}${segment.substring(1)}').join(' ');
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
    final colorScheme = theme.colorScheme;
    final cardColor = _isExpanded ? colorScheme.surfaceContainerHigh : colorScheme.surfaceContainerLow;
    final borderColor = _isExpanded ? colorScheme.primary : colorScheme.outlineVariant.withValues(alpha: 0.48);

    return ExpressiveExpandableCard(
      title: widget.section.title,
      subtitle: selectedLabel != null ? 'Selected: $selectedLabel' : '${widget.section.options.length} options',
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
              label: 'Search options',
              hintText: 'Search this section',
              onChanged: (value) {
                setState(() {
                  _search = value.trim();
                });
              },
            ),
          ),
        if (filteredOptions.isEmpty)
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('No matching options')),
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
