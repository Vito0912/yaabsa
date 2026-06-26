// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_data.dart';
import 'package:yaabsa/api/library_items/author.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/request/update_library_item_media_request.dart';
import 'package:yaabsa/api/library_items/series.dart';
import 'package:yaabsa/api/search/search_provider_option.dart';
import 'package:yaabsa/components/app/item/match/manual_match/manual_match_collapsed_search_bar.dart';
import 'package:yaabsa/components/app/item/match/manual_match/manual_match_editor_pane.dart';
import 'package:yaabsa/components/app/item/match/manual_match/manual_match_last_configuration.dart';
import 'package:yaabsa/components/app/item/match/manual_match/manual_match_models.dart';
import 'package:yaabsa/components/app/item/match/manual_match/manual_match_results_pane.dart';
import 'package:yaabsa/components/app/item/match/manual_match/manual_match_search_card.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/common/upload_providers.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/setting_key.dart';

Future<bool> showLibraryItemManualMatchDialog({
  required BuildContext context,
  required LibraryItem item,
  LibraryFilterData? filterData,
}) {
  if (context.isMobile) {
    return _showLibraryItemManualMatchDialogMobile(context: context, item: item, filterData: filterData);
  }

  return _showLibraryItemManualMatchDialogDesktop(context: context, item: item, filterData: filterData);
}

Future<bool> _showLibraryItemManualMatchDialogMobile({
  required BuildContext context,
  required LibraryItem item,
  LibraryFilterData? filterData,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.97,
        child: LibraryItemManualMatchDialog(item: item, filterData: filterData, isFullScreen: true),
      );
    },
  );
  return result == true;
}

Future<bool> _showLibraryItemManualMatchDialogDesktop({
  required BuildContext context,
  required LibraryItem item,
  LibraryFilterData? filterData,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return Dialog(
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180, maxHeight: 880),
          child: LibraryItemManualMatchDialog(item: item, filterData: filterData),
        ),
      );
    },
  );
  return result == true;
}

class LibraryItemManualMatchDialog extends StatelessWidget {
  const LibraryItemManualMatchDialog({
    super.key,
    required this.item,
    required this.filterData,
    this.isFullScreen = false,
  });

  final LibraryItem item;
  final LibraryFilterData? filterData;
  final bool isFullScreen;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
          ),
          child: Row(
            children: [
              Spacer(),
              IconButton(
                tooltip: 'Close',
                onPressed: () => Navigator.of(context).pop(false),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
        ),
        Expanded(
          child: LibraryItemManualMatchView(item: item, filterData: filterData, isFullScreen: isFullScreen),
        ),
      ],
    );
  }
}

class LibraryItemManualMatchView extends ConsumerStatefulWidget {
  const LibraryItemManualMatchView({
    super.key,
    required this.item,
    required this.filterData,
    required this.isFullScreen,
    this.onMatched,
    this.onCancel,
  });

  final LibraryItem item;
  final LibraryFilterData? filterData;
  final bool isFullScreen;
  final ValueChanged<bool>? onMatched;
  final VoidCallback? onCancel;

  @override
  ConsumerState<LibraryItemManualMatchView> createState() => _LibraryItemManualMatchViewState();
}

class _LibraryItemManualMatchViewState extends ConsumerState<LibraryItemManualMatchView> {
  final Random _random = Random();

  late final TextEditingController _titleController;
  late final TextEditingController _authorController;
  late final String _searchMediaType;

  final Set<String> _selectedProviders = <String>{};
  final Map<ManualMatchField, TextEditingController> _fieldControllers = <ManualMatchField, TextEditingController>{};
  final Map<ManualMatchField, bool?> _boolFieldValues = <ManualMatchField, bool?>{};
  final Map<ManualMatchField, ManualListApplyMode> _listModes = <ManualMatchField, ManualListApplyMode>{};
  Set<ManualMatchField> _enabledFields = <ManualMatchField>{};

  List<ManualMatchResult> _results = const <ManualMatchResult>[];
  ManualMatchResult? _selectedResult;
  bool _searchCollapsedOnMobile = false;
  int _mobilePaneIndex = 0;
  bool _searching = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();

    final metadata = widget.item.media?.bookMedia?.metadata;
    final initialTitle = metadata?.title ?? widget.item.title;
    final initialAuthor = metadata?.authors?.map((author) => author.name).join(', ') ?? widget.item.authorString ?? '';

    _titleController = TextEditingController(text: initialTitle.trim());
    _authorController = TextEditingController(text: initialAuthor.trim());
    _searchMediaType = widget.item.mediaType == 'podcast' ? 'podcast' : 'book';
    _loadSavedConfiguration();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    for (final controller in _fieldControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _syncInitialProviderSelection(List<String> providerValues, {String? preferredProvider}) {
    if (_selectedProviders.isNotEmpty || providerValues.isEmpty) {
      return;
    }

    var initialProvider = providerValues.first;
    final normalizedPreferredProvider = preferredProvider?.trim().toLowerCase();
    if (normalizedPreferredProvider != null && normalizedPreferredProvider.isNotEmpty) {
      for (final providerValue in providerValues) {
        if (providerValue.trim().toLowerCase() != normalizedPreferredProvider) {
          continue;
        }

        initialProvider = providerValue;
        break;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _selectedProviders.isNotEmpty) {
        return;
      }
      setState(() {
        _selectedProviders.add(initialProvider);
      });
    });
  }

  void _loadSavedConfiguration() {
    final currentUserId = ref.read(currentUserProvider).value?.id;
    if (currentUserId == null || currentUserId.isEmpty) {
      ManualMatchLastConfiguration.restoreFromRawSettingValue(null);
      return;
    }

    final settingsManager = ref.read(settingsManagerProvider.notifier);
    final rawConfiguration = settingsManager.getUserSetting<String>(
      currentUserId,
      SettingKeys.manualMatchLastConfiguration,
      defaultValue: '',
    );
    ManualMatchLastConfiguration.restoreFromRawSettingValue(rawConfiguration);
  }

  Future<void> _persistSavedConfiguration() async {
    final currentConfiguration = ManualMatchLastConfiguration.current;
    if (currentConfiguration == null) {
      return;
    }

    final currentUserId = ref.read(currentUserProvider).value?.id;
    if (currentUserId == null || currentUserId.isEmpty) {
      return;
    }

    try {
      await ref
          .read(settingsManagerProvider.notifier)
          .setUserSetting<String>(
            currentUserId,
            SettingKeys.manualMatchLastConfiguration,
            currentConfiguration.toRawSettingValue(),
          );
    } catch (error, stackTrace) {
      logger(
        'Failed to persist manual match configuration: $error\n$stackTrace',
        tag: 'ManualMatchDialog',
        level: InfoLevel.warning,
      );
    }
  }

  Future<void> _runSearch(List<SearchProviderOption> providers) async {
    if (_searching) {
      return;
    }

    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a title.')));
      return;
    }

    final selectedProviders = providers.where((provider) => _selectedProviders.contains(provider.value)).toList();
    if (selectedProviders.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select at least one provider.')));
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No API session available.')));
      return;
    }

    setState(() {
      _searching = true;
      _searchCollapsedOnMobile = false;
      _mobilePaneIndex = 0;
      _results = const <ManualMatchResult>[];
      _selectedResult = null;
      _enabledFields = <ManualMatchField>{};
      _boolFieldValues.clear();
      _listModes.clear();
    });

    final searchAuthor = _authorController.text.trim();
    final collected = <ManualMatchResult>[];

    for (final provider in selectedProviders) {
      if (collected.length >= 15) {
        break;
      }

      try {
        final response = await api.getUploadApi().searchMetadata(
          mediaType: _searchMediaType,
          title: title,
          author: searchAuthor.isEmpty ? null : searchAuthor,
          provider: provider.value,
          fallbackTitleOnly: true,
          libraryItemId: widget.item.id,
        );

        final rawResults = extractManualMatchResultMaps(response.data);
        final parsed = rawResults
            .map(
              (entry) => ManualMatchResult.fromMap(entry, providerValue: provider.value, providerLabel: provider.text),
            )
            .where((entry) => entry.hasMeaningfulData)
            .toList(growable: false);

        var addedForProvider = 0;
        for (final entry in parsed) {
          if (addedForProvider >= 10 || collected.length >= 15) {
            break;
          }
          collected.add(entry);
          addedForProvider++;
        }
      } catch (_) {
        // Keep trying remaining providers if one provider fails.
      }
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _results = collected;
      _searching = false;
      _searchCollapsedOnMobile = context.isMobile && collected.isNotEmpty;
    });

    if (collected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No match results found.')));
    }
  }

  void _selectResult(ManualMatchResult result) {
    final availableFields = result.availableFields.toSet();
    final savedConfiguration = ManualMatchLastConfiguration.current;
    final preferredEnabled = savedConfiguration == null
        ? availableFields
        : savedConfiguration.enabledFields.where(availableFields.contains).toSet();
    final initialEnabled = preferredEnabled.isEmpty ? availableFields : preferredEnabled;

    _seedEditableValues(result, availableFields);

    setState(() {
      _selectedResult = result;
      _enabledFields = initialEnabled;
      if (context.isMobile) {
        _mobilePaneIndex = 1;
      }
      _listModes
        ..clear()
        ..addAll(<ManualMatchField, ManualListApplyMode>{
          for (final field in manualListFields)
            if (availableFields.contains(field))
              field: savedConfiguration?.listModes[field] ?? ManualListApplyMode.overwrite,
        });
    });
  }

  Future<void> _saveSelection() async {
    if (_saving) {
      return;
    }

    if (_selectedResult == null) {
      return;
    }

    if (_enabledFields.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select at least one field to apply.')));
      return;
    }

    final request = _buildUpdateRequest();
    if (request == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No writable values were selected from this match result.')));
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No API session available.')));
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final response = await api.getLibraryItemApi().updateLibraryItemMedia(widget.item.id, request: request);

      if (!mounted) {
        return;
      }

      final updated = response.data?.updated ?? false;
      ref.invalidate(libraryItemProvider(widget.item.id));
      ManualMatchLastConfiguration.save(enabledFields: _enabledFields, listModes: _listModes);
      await _persistSavedConfiguration();

      final message = updated ? 'Item metadata updated from manual match.' : 'No updates were necessary.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      if (widget.onMatched != null) {
        widget.onMatched!(updated);
      } else {
        Navigator.of(context).pop(updated);
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save manual match: $error')));
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  UpdateLibraryItemMediaRequest? _buildUpdateRequest() {
    String? title;
    String? subtitle;
    List<Author>? authors;
    List<String>? narrators;
    String? description;
    String? publisher;
    String? publishedYear;
    List<Series>? series;
    List<String>? genres;
    List<String>? tags;
    String? language;
    String? isbn;
    String? asin;
    bool? explicit;
    bool? abridged;
    String? url;

    if (_enabledFields.contains(ManualMatchField.title)) {
      title = _normalizeText(_fieldControllers[ManualMatchField.title]?.text);
    }
    if (_enabledFields.contains(ManualMatchField.subtitle)) {
      subtitle = _normalizeText(_fieldControllers[ManualMatchField.subtitle]?.text);
    }
    if (_enabledFields.contains(ManualMatchField.authors)) {
      final parsedAuthors = extractStringList(_fieldControllers[ManualMatchField.authors]?.text);
      if (parsedAuthors.isNotEmpty) {
        final mode = _listModes[ManualMatchField.authors] ?? ManualListApplyMode.overwrite;
        authors = _buildAuthorPatch(parsedAuthors, mode: mode);
      }
    }
    if (_enabledFields.contains(ManualMatchField.narrators)) {
      final parsedNarrators = extractStringList(_fieldControllers[ManualMatchField.narrators]?.text);
      if (parsedNarrators.isNotEmpty) {
        final mode = _listModes[ManualMatchField.narrators] ?? ManualListApplyMode.overwrite;
        narrators = _mergeStringLists(_currentListForField(ManualMatchField.narrators), parsedNarrators, mode: mode);
      }
    }
    if (_enabledFields.contains(ManualMatchField.description)) {
      description = _normalizeText(_fieldControllers[ManualMatchField.description]?.text);
    }
    if (_enabledFields.contains(ManualMatchField.publisher)) {
      publisher = _normalizeText(_fieldControllers[ManualMatchField.publisher]?.text);
    }
    if (_enabledFields.contains(ManualMatchField.publishedYear)) {
      publishedYear = _normalizeText(_fieldControllers[ManualMatchField.publishedYear]?.text);
    }
    if (_enabledFields.contains(ManualMatchField.series)) {
      final parsedSeries = _parseSeriesInput(_fieldControllers[ManualMatchField.series]?.text);
      if (parsedSeries.isNotEmpty) {
        final mode = _listModes[ManualMatchField.series] ?? ManualListApplyMode.overwrite;
        series = _buildSeriesPatch(parsedSeries, mode: mode);
      }
    }
    if (_enabledFields.contains(ManualMatchField.genres)) {
      final parsedGenres = extractStringList(_fieldControllers[ManualMatchField.genres]?.text);
      if (parsedGenres.isNotEmpty) {
        final mode = _listModes[ManualMatchField.genres] ?? ManualListApplyMode.overwrite;
        genres = _mergeStringLists(_currentListForField(ManualMatchField.genres), parsedGenres, mode: mode);
      }
    }
    if (_enabledFields.contains(ManualMatchField.tags)) {
      final parsedTags = extractStringList(_fieldControllers[ManualMatchField.tags]?.text);
      if (parsedTags.isNotEmpty) {
        final mode = _listModes[ManualMatchField.tags] ?? ManualListApplyMode.overwrite;
        tags = _mergeStringLists(_currentListForField(ManualMatchField.tags), parsedTags, mode: mode);
      }
    }
    if (_enabledFields.contains(ManualMatchField.language)) {
      language = _normalizeText(_fieldControllers[ManualMatchField.language]?.text);
    }
    if (_enabledFields.contains(ManualMatchField.isbn)) {
      isbn = _normalizeText(_fieldControllers[ManualMatchField.isbn]?.text);
    }
    if (_enabledFields.contains(ManualMatchField.asin)) {
      asin = _normalizeText(_fieldControllers[ManualMatchField.asin]?.text);
    }
    if (_enabledFields.contains(ManualMatchField.explicit)) {
      explicit = _boolFieldValues[ManualMatchField.explicit];
    }
    if (_enabledFields.contains(ManualMatchField.abridged)) {
      abridged = _boolFieldValues[ManualMatchField.abridged];
    }
    if (_enabledFields.contains(ManualMatchField.cover)) {
      url = _normalizeText(_fieldControllers[ManualMatchField.cover]?.text);
    }

    final metadataPatch = UpdateLibraryItemMediaMetadataPatch(
      title: title,
      subtitle: subtitle,
      authors: authors,
      narrators: narrators,
      description: description,
      publisher: publisher,
      publishedYear: publishedYear,
      series: series,
      genres: genres,
      language: language,
      isbn: isbn,
      asin: asin,
      explicit: explicit,
      abridged: abridged,
    );

    final metadata = metadataPatch.toJson().isEmpty ? null : metadataPatch;
    final request = UpdateLibraryItemMediaRequest(metadata: metadata, tags: tags, url: url);
    if (request.toJson().isEmpty) {
      return null;
    }
    return request;
  }

  List<Author>? _buildAuthorPatch(List<String> incomingAuthors, {required ManualListApplyMode mode}) {
    if (incomingAuthors.isEmpty) {
      return null;
    }

    final currentAuthors = widget.item.media?.bookMedia?.metadata.authors ?? const <Author>[];
    if (mode == ManualListApplyMode.overwrite) {
      return incomingAuthors.map((name) => Author(id: _generateId(), name: name)).toList(growable: false);
    }

    final normalizedCurrentNames = currentAuthors
        .map((author) => author.name.trim())
        .where((name) => name.isNotEmpty)
        .toList();
    final currentByLower = <String, Author>{
      for (final author in currentAuthors)
        if (author.name.trim().isNotEmpty) author.name.trim().toLowerCase(): author,
    };

    final mergedNames = _mergeStringLists(normalizedCurrentNames, incomingAuthors, mode: ManualListApplyMode.add);
    return mergedNames
        .map((name) => currentByLower[name.toLowerCase()] ?? Author(id: _generateId(), name: name))
        .toList(growable: false);
  }

  List<Series>? _buildSeriesPatch(List<ManualMatchSeriesEntry> incomingSeries, {required ManualListApplyMode mode}) {
    if (incomingSeries.isEmpty) {
      return null;
    }

    if (mode == ManualListApplyMode.overwrite) {
      return incomingSeries
          .map((entry) => Series(id: _generateId(), name: entry.name, sequence: _normalizeText(entry.sequence)))
          .toList(growable: false);
    }

    final currentSeries = widget.item.media?.bookMedia?.metadata.series ?? const <Series>[];
    final seen = <String>{};
    final merged = <Series>[];

    for (final current in currentSeries) {
      final key = _seriesKey(current.name, current.sequence);
      if (seen.add(key)) {
        merged.add(current);
      }
    }

    for (final incoming in incomingSeries) {
      final key = _seriesKey(incoming.name, incoming.sequence);
      if (!seen.add(key)) {
        continue;
      }
      merged.add(Series(id: _generateId(), name: incoming.name, sequence: _normalizeText(incoming.sequence)));
    }

    return merged;
  }

  List<String> _mergeStringLists(List<String> current, List<String> incoming, {required ManualListApplyMode mode}) {
    if (mode == ManualListApplyMode.overwrite) {
      return _normalizeStringList(incoming);
    }

    final merged = <String>[];
    final seen = <String>{};

    for (final value in [...current, ...incoming]) {
      final normalized = value.trim();
      if (normalized.isEmpty) {
        continue;
      }
      final key = normalized.toLowerCase();
      if (!seen.add(key)) {
        continue;
      }
      merged.add(normalized);
    }

    return merged;
  }

  List<String> _normalizeStringList(List<String> values) {
    final normalized = <String>[];
    final seen = <String>{};
    for (final raw in values) {
      final value = raw.trim();
      if (value.isEmpty) {
        continue;
      }
      final key = value.toLowerCase();
      if (!seen.add(key)) {
        continue;
      }
      normalized.add(value);
    }
    return normalized;
  }

  String _seriesKey(String name, String? sequence) {
    final normalizedName = name.trim().toLowerCase();
    final normalizedSequence = (sequence ?? '').trim().toLowerCase();
    return '$normalizedName#$normalizedSequence';
  }

  String _generateId() => 'new-${DateTime.now().microsecondsSinceEpoch}-${_random.nextInt(1000000)}';

  String? _normalizeText(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }
    return normalized;
  }

  void _seedEditableValues(ManualMatchResult result, Set<ManualMatchField> availableFields) {
    final staleControllerFields = _fieldControllers.keys.where((field) => !availableFields.contains(field)).toList();
    for (final field in staleControllerFields) {
      _fieldControllers.remove(field)?.dispose();
    }

    _boolFieldValues.removeWhere((field, _) => !availableFields.contains(field));

    for (final field in availableFields) {
      if (_isBooleanField(field)) {
        _boolFieldValues[field] = _defaultBoolValueForField(result, field);
        continue;
      }

      final controller = _fieldControllers.putIfAbsent(field, TextEditingController.new);
      controller.text = _defaultTextValueForField(result, field);
    }
  }

  bool _isBooleanField(ManualMatchField field) {
    return field == ManualMatchField.explicit || field == ManualMatchField.abridged;
  }

  String _defaultTextValueForField(ManualMatchResult result, ManualMatchField field) {
    switch (field) {
      case ManualMatchField.cover:
        return result.coverUrl ?? '';
      case ManualMatchField.title:
        return result.title;
      case ManualMatchField.subtitle:
        return result.subtitle ?? '';
      case ManualMatchField.authors:
        return result.authors.join(', ');
      case ManualMatchField.narrators:
        return result.narrators.join(', ');
      case ManualMatchField.description:
        return result.description ?? '';
      case ManualMatchField.publisher:
        return result.publisher ?? '';
      case ManualMatchField.publishedYear:
        return result.publishedYear ?? '';
      case ManualMatchField.series:
        return result.seriesEntries
            .map((entry) => entry.sequence?.isNotEmpty == true ? '${entry.name} #${entry.sequence}' : entry.name)
            .join(', ');
      case ManualMatchField.genres:
        return result.genres.join(', ');
      case ManualMatchField.tags:
        return result.tags.join(', ');
      case ManualMatchField.language:
        return result.language ?? '';
      case ManualMatchField.isbn:
        return result.isbn ?? '';
      case ManualMatchField.asin:
        return result.asin ?? '';
      case ManualMatchField.explicit:
      case ManualMatchField.abridged:
        return '';
    }
  }

  bool? _defaultBoolValueForField(ManualMatchResult result, ManualMatchField field) {
    switch (field) {
      case ManualMatchField.explicit:
        return result.explicit;
      case ManualMatchField.abridged:
        return result.abridged;
      case ManualMatchField.cover:
      case ManualMatchField.title:
      case ManualMatchField.subtitle:
      case ManualMatchField.authors:
      case ManualMatchField.narrators:
      case ManualMatchField.description:
      case ManualMatchField.publisher:
      case ManualMatchField.publishedYear:
      case ManualMatchField.series:
      case ManualMatchField.genres:
      case ManualMatchField.tags:
      case ManualMatchField.language:
      case ManualMatchField.isbn:
      case ManualMatchField.asin:
        return null;
    }
  }

  List<ManualMatchSeriesEntry> _parseSeriesInput(String? raw) {
    final text = raw?.trim();
    if (text == null || text.isEmpty) {
      return const <ManualMatchSeriesEntry>[];
    }

    final entries = <ManualMatchSeriesEntry>[];
    final seen = <String>{};

    for (final token in text.split(',')) {
      final candidate = token.trim();
      if (candidate.isEmpty) {
        continue;
      }

      final hashIndex = candidate.lastIndexOf('#');
      String name = candidate;
      String? sequence;

      if (hashIndex > 0 && hashIndex < candidate.length - 1) {
        name = candidate.substring(0, hashIndex).trim();
        sequence = candidate.substring(hashIndex + 1).trim();
      }

      final normalizedName = name.trim();
      if (normalizedName.isEmpty) {
        continue;
      }

      final normalizedSequence = _normalizeText(sequence);
      final key = '${normalizedName.toLowerCase()}#${(normalizedSequence ?? '').toLowerCase()}';
      if (!seen.add(key)) {
        continue;
      }

      entries.add(ManualMatchSeriesEntry(name: normalizedName, sequence: normalizedSequence));
    }

    return entries;
  }

  String? _currentCoverUrl() {
    if (!widget.item.hasCover) {
      return null;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      return null;
    }

    return api.getLibraryItemApi().getCoverUri(widget.item.id, item: widget.item).toString();
  }

  Widget _buildCurrentCoverPreview() {
    final api = ref.read(absApiProvider);

    if (api == null || !widget.item.hasCover) {
      return _coverPreviewFallback(icon: Icons.image_not_supported_rounded);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 80,
        height: 80,
        child: api.getLibraryItemApi().getLibraryItemCover(
          widget.item.id,
          item: widget.item,
          width: 160.0,
          height: 160.0,
        ),
      ),
    );
  }

  Widget _coverPreviewFallback({required IconData icon}) {
    return Container(
      width: 80,
      height: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Icon(icon, size: 22, color: Theme.of(context).colorScheme.onSurfaceVariant),
    );
  }

  List<String> _currentListForField(ManualMatchField field) {
    final metadata = widget.item.media?.bookMedia?.metadata;
    switch (field) {
      case ManualMatchField.authors:
        return metadata?.authors?.map((author) => author.name).whereType<String>().toList(growable: false) ??
            const <String>[];
      case ManualMatchField.narrators:
        return metadata?.narrators ?? const <String>[];
      case ManualMatchField.series:
        return metadata?.series
                ?.map((entry) => entry.sequence?.isNotEmpty == true ? '${entry.name} #${entry.sequence}' : entry.name)
                .toList(growable: false) ??
            const <String>[];
      case ManualMatchField.genres:
        return metadata?.genres ?? const <String>[];
      case ManualMatchField.tags:
        return widget.item.media?.bookMedia?.tags ?? const <String>[];
      case ManualMatchField.cover:
      case ManualMatchField.title:
      case ManualMatchField.subtitle:
      case ManualMatchField.description:
      case ManualMatchField.publisher:
      case ManualMatchField.publishedYear:
      case ManualMatchField.language:
      case ManualMatchField.isbn:
      case ManualMatchField.asin:
      case ManualMatchField.explicit:
      case ManualMatchField.abridged:
        return const <String>[];
    }
  }

  String? _currentValueSummary(ManualMatchField field) {
    final metadata = widget.item.media?.bookMedia?.metadata;
    switch (field) {
      case ManualMatchField.cover:
        return _currentCoverUrl();
      case ManualMatchField.title:
        return _normalizeText(metadata?.title);
      case ManualMatchField.subtitle:
        return _normalizeText(metadata?.subtitle);
      case ManualMatchField.authors:
        final authors = metadata?.authors
            ?.map((entry) => entry.name)
            .where((entry) => entry.trim().isNotEmpty)
            .toList();
        if (authors == null || authors.isEmpty) {
          return null;
        }
        return authors.join(', ');
      case ManualMatchField.narrators:
        final narrators = metadata?.narrators;
        if (narrators == null || narrators.isEmpty) {
          return null;
        }
        return narrators.join(', ');
      case ManualMatchField.description:
        return _normalizeText(metadata?.description);
      case ManualMatchField.publisher:
        return _normalizeText(metadata?.publisher);
      case ManualMatchField.publishedYear:
        return _normalizeText(metadata?.publishedYear);
      case ManualMatchField.series:
        final series = metadata?.series;
        if (series == null || series.isEmpty) {
          return null;
        }
        return series
            .map((entry) => entry.sequence?.isNotEmpty == true ? '${entry.name} #${entry.sequence}' : entry.name)
            .join(', ');
      case ManualMatchField.genres:
        final genres = metadata?.genres;
        if (genres == null || genres.isEmpty) {
          return null;
        }
        return genres.join(', ');
      case ManualMatchField.tags:
        final tags = widget.item.media?.bookMedia?.tags;
        if (tags == null || tags.isEmpty) {
          return null;
        }
        return tags.join(', ');
      case ManualMatchField.language:
        return _normalizeText(metadata?.language);
      case ManualMatchField.isbn:
        return _normalizeText(metadata?.isbn);
      case ManualMatchField.asin:
        return _normalizeText(metadata?.asin);
      case ManualMatchField.explicit:
        return metadata?.explicit == null ? null : (metadata!.explicit! ? 'Yes' : 'No');
      case ManualMatchField.abridged:
        return metadata?.abridged == null ? null : (metadata!.abridged! ? 'Yes' : 'No');
    }
  }

  void _toggleField(ManualMatchField field, bool enabled) {
    setState(() {
      if (enabled) {
        _enabledFields.add(field);
      } else {
        _enabledFields.remove(field);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedLibrary = ref.watch(selectedLibraryProvider);
    final userLibraries = ref.watch(userLibrariesProvider).value;
    final providersAsync = ref.watch(uploadMetadataProvidersProvider(_searchMediaType));

    final providerValues =
        providersAsync.asData?.value.map((provider) => provider.value).toList(growable: false) ?? const <String>[];

    String? defaultProviderValue;
    final itemLibraryId = widget.item.libraryId;
    if (itemLibraryId != null && itemLibraryId.isNotEmpty) {
      if (selectedLibrary?.id == itemLibraryId) {
        defaultProviderValue = selectedLibrary?.provider;
      }

      if ((defaultProviderValue == null || defaultProviderValue.isEmpty) && userLibraries != null) {
        for (final library in userLibraries) {
          if (library.id != itemLibraryId) {
            continue;
          }

          defaultProviderValue = library.provider;
          break;
        }
      }
    }

    defaultProviderValue ??= selectedLibrary?.provider;
    _syncInitialProviderSelection(providerValues, preferredProvider: defaultProviderValue);

    final selectedResult = _selectedResult;
    final availableFields = selectedResult?.availableFields ?? const <ManualMatchField>[];
    final allFieldsSelected = availableFields.isNotEmpty && _enabledFields.length == availableFields.length;
    final showCollapsedSearch = context.isMobile && _searchCollapsedOnMobile && _results.isNotEmpty && !_searching;
    final searchSection = showCollapsedSearch
        ? ManualMatchCollapsedSearchBar(
            title: _titleController.text,
            author: _authorController.text,
            selectedProviderCount: _selectedProviders.length,
            onExpand: () {
              setState(() {
                _searchCollapsedOnMobile = false;
              });
            },
          )
        : ManualMatchSearchCard(
            titleController: _titleController,
            authorController: _authorController,
            searching: _searching,
            providersAsync: providersAsync,
            selectedProviderValues: _selectedProviders,
            onProviderSelectionChanged: (nextSelection) {
              setState(() {
                _selectedProviders
                  ..clear()
                  ..addAll(nextSelection);
              });
            },
            onSearch: () => _runSearch(providersAsync.value ?? const <SearchProviderOption>[]),
          );

    return Padding(
      padding: EdgeInsets.fromLTRB(12, context.isMobile ? 8 : 12, 12, context.isMobile ? 10 : 14),
      child: Column(
        children: [
          searchSection,
          const SizedBox(height: 10),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWideLayout = constraints.maxWidth >= 900;
                final resultsPane = ManualMatchResultsPane(
                  searching: _searching,
                  results: _results,
                  selectedResult: _selectedResult,
                  onSelectResult: _selectResult,
                );
                final editorPane = ManualMatchEditorPane(
                  selectedResult: selectedResult,
                  availableFields: availableFields,
                  enabledFields: _enabledFields,
                  allFieldsSelected: allFieldsSelected,
                  listModes: _listModes,
                  saving: _saving,
                  onToggleAll: (enabled) {
                    setState(() {
                      if (enabled) {
                        _enabledFields = availableFields.toSet();
                      } else {
                        _enabledFields = <ManualMatchField>{};
                      }
                    });
                  },
                  onToggleField: _toggleField,
                  onChangeListMode: (field, mode) {
                    setState(() {
                      _listModes[field] = mode;
                    });
                  },
                  controllerForField: (field) => _fieldControllers[field],
                  boolValueForField: (field) => _boolFieldValues[field],
                  onChangeFieldText: (field, _) {
                    setState(() {});
                  },
                  onChangeBoolValue: (field, value) {
                    setState(() {
                      _boolFieldValues[field] = value;
                    });
                  },
                  currentSummaryForField: _currentValueSummary,
                  buildCurrentCoverPreview: _buildCurrentCoverPreview,
                );

                if (context.isMobile) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ToggleButtons(
                        isSelected: <bool>[_mobilePaneIndex == 0, _mobilePaneIndex == 1],
                        onPressed: (index) {
                          setState(() {
                            _mobilePaneIndex = index;
                          });
                        },
                        children: const [
                          Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Candidates')),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Selection')),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(child: _mobilePaneIndex == 0 ? resultsPane : editorPane),
                    ],
                  );
                }

                if (isWideLayout) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: resultsPane),
                      const SizedBox(width: 10),
                      Expanded(flex: 3, child: editorPane),
                    ],
                  );
                }

                return Column(
                  children: [
                    Expanded(flex: 5, child: resultsPane),
                    const SizedBox(height: 10),
                    Expanded(flex: 5, child: editorPane),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _saving ? null : (widget.onCancel ?? () => Navigator.of(context).pop(false)),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: _saving || _selectedResult == null ? null : _saveSelection,
                icon: _saving
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2.2))
                    : const Icon(Icons.save_rounded),
                label: Text(_saving ? 'Saving...' : 'Save matched fields'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
