import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/api/library/search_library.dart';
import 'package:yaabsa/components/common/inputs/styled_form_fields.dart';
import 'package:yaabsa/models/queue_source.dart';
import 'package:yaabsa/provider/common/collection_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/common/library_search_provider.dart';
import 'package:yaabsa/provider/common/playlist_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';

class _AutocompleteTextEditingController extends TextEditingController {
  void refreshOptions() {
    final current = value;
    value = current.copyWith(text: '${current.text}\u200B');
    value = current;
  }
}

class SmartDownloadSourceEditor extends ConsumerStatefulWidget {
  const SmartDownloadSourceEditor({super.key});

  @override
  ConsumerState<SmartDownloadSourceEditor> createState() => _SmartDownloadSourceEditorState();
}

class _SmartDownloadSourceEditorState extends ConsumerState<SmartDownloadSourceEditor> {
  final _searchController = _AutocompleteTextEditingController();
  final _searchFocusNode = FocusNode();
  final _thresholdController = TextEditingController(text: '30');
  ListeningDownloadTrigger _listeningTrigger = ListeningDownloadTrigger.minutes;
  MediaSourceType _type = MediaSourceType.podcast;
  bool _descending = true;
  String? _libraryId;
  String? _selectedSourceId;
  String? _selectedSourceName;
  String _searchQuery = '';
  bool _autocompleteRefreshScheduled = false;
  bool _refreshingAutocomplete = false;
  String? _listIndexKey;
  Object? _listIndexError;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _thresholdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final libraries = ref.watch(userLibrariesProvider).value ?? const [];
    final selectedAllLibraries = _type.supportsAllLibraries && _libraryId == allLibrariesSourceId;
    final selectedLibraryId = selectedAllLibraries
        ? allLibrariesSourceId
        : libraries.where((library) => library.id == _libraryId).firstOrNull?.id ?? libraries.firstOrNull?.id;
    if (_libraryId != selectedLibraryId) {
      _libraryId = selectedLibraryId;
    }
    final selectedLibrary = libraries.where((library) => library.id == selectedLibraryId).firstOrNull;
    final availableSourceTypes = _sourceTypesForLibrary(selectedLibrary?.mediaType);
    if (!availableSourceTypes.contains(_type)) {
      _type = availableSourceTypes.first;
      _searchController.clear();
      _searchQuery = '';
      _selectedSourceId = null;
      _selectedSourceName = null;
    }
    final userId = ref.watch(currentUserProvider).value?.id;
    final indexKey = '$userId:$selectedLibraryId:${_type.name}';
    if (_listIndexKey != indexKey) {
      _listIndexKey = indexKey;
      _listIndexError = null;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted || _listIndexKey != indexKey || selectedLibraryId == null) {
          return;
        }

        try {
          if (_type == MediaSourceType.playlist) {
            await ref.read(playlistsProvider(selectedLibraryId).notifier).ensureAllLoaded();
          } else if (_type == MediaSourceType.collection) {
            await ref.read(collectionsProvider(selectedLibraryId).notifier).ensureAllLoaded();
          }
        } catch (error) {
          if (mounted && _listIndexKey == indexKey) {
            setState(() {
              _listIndexError = error;
            });
          }
        }
      });
    }
    final availableSourceNames = <String, String>{};
    if (selectedLibraryId != null && _type == MediaSourceType.playlist) {
      for (final playlist in ref.watch(playlistsProvider(selectedLibraryId)).value?.items ?? const []) {
        availableSourceNames[playlist.id] = playlist.name;
      }
    } else if (selectedLibraryId != null && _type == MediaSourceType.collection) {
      for (final collection in ref.watch(collectionsProvider(selectedLibraryId)).value?.items ?? const []) {
        availableSourceNames[collection.id] = collection.name;
      }
    }

    final normalizedQuery = _searchQuery.trim();
    final searchAsync =
        normalizedQuery.isNotEmpty && (_type == MediaSourceType.podcast || _type == MediaSourceType.series)
        ? ref.watch(librarySearchProvider((query: normalizedQuery, limit: 3, libraryId: selectedLibraryId)))
        : null;
    final localSuggestions = availableSourceNames.entries
        .where(
          (entry) => normalizedQuery.isNotEmpty && entry.value.toLowerCase().contains(normalizedQuery.toLowerCase()),
        )
        .take(3)
        .toList(growable: false);
    final remoteSuggestions = _remoteSuggestions(searchAsync);
    final sourceSuggestions = [
      ...localSuggestions.map((entry) => (id: entry.key, name: entry.value)),
      ...remoteSuggestions,
    ];
    if (_type.requiresSearch) {
      _scheduleAutocompleteRefresh();
    }

    final threshold = int.tryParse(_thresholdController.text.trim());
    final maximumThreshold = _listeningTrigger == ListeningDownloadTrigger.progress ? 99 : 10000;
    final validThreshold = threshold != null && threshold > 0 && threshold <= maximumThreshold;
    final canAddSource =
        _libraryId?.trim().isNotEmpty == true &&
        (!_type.requiresSearch || _selectedSourceId?.trim().isNotEmpty == true) &&
        (_type != MediaSourceType.listeningThreshold || validThreshold);

    return AlertDialog(
      title: const Text('Add source'),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              YaabsaDropdownField<String>(
                label: 'Library',
                value: selectedLibraryId,
                items: [
                  if (_type.supportsAllLibraries)
                    const DropdownMenuItem(value: allLibrariesSourceId, child: Text('All')),
                  for (final library in libraries) DropdownMenuItem(value: library.id, child: Text(library.name)),
                ],
                onChanged: (value) => setState(() {
                  _libraryId = value;
                  _searchController.clear();
                  _searchQuery = '';
                  _selectedSourceId = null;
                  _selectedSourceName = null;
                }),
              ),
              const SizedBox(height: 16),
              YaabsaDropdownField<MediaSourceType>(
                label: 'Source type',
                value: _type,
                items: [
                  for (final type in availableSourceTypes) DropdownMenuItem(value: type, child: Text(type.label)),
                ],
                onChanged: (value) => setState(() {
                  _type = value ?? MediaSourceType.podcast;
                  if (_type.supportsAllLibraries) {
                    _libraryId = allLibrariesSourceId;
                  } else if (_libraryId == allLibrariesSourceId) {
                    _libraryId = libraries.firstOrNull?.id;
                  }

                  _searchController.clear();
                  _searchQuery = '';
                  _selectedSourceId = null;
                  _selectedSourceName = null;
                }),
              ),
              const SizedBox(height: 16),
              if (_type == MediaSourceType.listeningThreshold) ...[
                YaabsaDropdownField<ListeningDownloadTrigger>(
                  label: 'Download when',
                  value: _listeningTrigger,
                  items: const [
                    DropdownMenuItem(value: ListeningDownloadTrigger.minutes, child: Text('Listening time')),
                    DropdownMenuItem(value: ListeningDownloadTrigger.progress, child: Text('Book progress')),
                  ],
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    setState(() {
                      _listeningTrigger = value;
                      _thresholdController.text = value == ListeningDownloadTrigger.minutes ? '30' : '10';
                    });
                  },
                ),
                const SizedBox(height: 16),
                StyledTextField(
                  label: _listeningTrigger == ListeningDownloadTrigger.minutes
                      ? 'Minutes listened'
                      : 'Book progress (%)',
                  controller: _thresholdController,
                  keyboardType: TextInputType.number,
                  errorText: validThreshold ? null : 'Enter a whole number from 1 to $maximumThreshold',
                  onChanged: (_) {
                    setState(() {});
                  },
                ),
                if (_listeningTrigger == ListeningDownloadTrigger.minutes)
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text('Counts only playback on this device.'),
                    ),
                  ),
                const SizedBox(height: 16),
              ],
              if (_listIndexError != null)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _listIndexKey = null;
                    });
                  },
                  child: const Text('Could not load all sources. Retry'),
                ),
              if (_type.requiresSearch)
                RawAutocomplete<({String id, String name})>(
                  key: ValueKey('${_type.name}:${selectedLibraryId ?? ''}'),
                  textEditingController: _searchController,
                  focusNode: _searchFocusNode,
                  displayStringForOption: (suggestion) => suggestion.name,
                  optionsBuilder: (textEditingValue) {
                    final query = textEditingValue.text.trim().toLowerCase();
                    if (query.isEmpty) {
                      return const <({String id, String name})>[];
                    }
                    return sourceSuggestions;
                  },
                  onSelected: (suggestion) => setState(() {
                    _selectedSourceId = suggestion.id;
                    _selectedSourceName = suggestion.name;
                  }),
                  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                    return StyledTextField(
                      label: 'Search sources',
                      controller: controller,
                      focusNode: focusNode,
                      prefixIcon: const Icon(Icons.search_rounded),
                      textInputAction: TextInputAction.search,
                      onChanged: (value) {
                        if (_refreshingAutocomplete) {
                          return;
                        }
                        final isSelectedValue = _selectedSourceId != null && value.trim() == _selectedSourceName;
                        setState(() {
                          _searchQuery = value;
                          if (!isSelectedValue) {
                            _selectedSourceId = null;
                            _selectedSourceName = null;
                          }
                        });
                        _scheduleAutocompleteRefresh();
                      },
                      onSubmitted: (_) => onFieldSubmitted(),
                    );
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(10),
                        clipBehavior: Clip.antiAlias,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 220, minWidth: 280),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              final suggestion = options.elementAt(index);
                              return ListTile(
                                dense: true,
                                title: Text(suggestion.name),
                                onTap: () => onSelected(suggestion),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              if (searchAsync?.isLoading ?? false) const LinearProgressIndicator(),
              if (searchAsync?.hasError ?? false)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text('Source search failed. Try a different search term.'),
                  ),
                ),
              const SizedBox(height: 16),
              if (_type.requiresSearch)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Descending/feed direction'),
                  value: _descending,
                  onChanged: (value) => setState(() => _descending = value),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
        FilledButton(
          onPressed: canAddSource
              ? () {
                  final libraryId = _libraryId!.trim();
                  var sourceId = _type.requiresSearch ? _selectedSourceId!.trim() : libraryId;
                  if (_type == MediaSourceType.listeningThreshold) {
                    sourceId = '$libraryId::${_listeningTrigger.name}';
                  }

                  final libraryName = selectedAllLibraries ? 'All' : selectedLibrary?.name ?? libraryId;
                  var displayName = _type.requiresSearch ? _selectedSourceName : '${_type.label} ($libraryName)';
                  if (_type == MediaSourceType.listeningThreshold) {
                    final unit = _listeningTrigger == ListeningDownloadTrigger.progress ? '%' : ' min';
                    displayName = '$displayName · ${threshold ?? 30}$unit';
                  }

                  context.pop(
                    MediaSourceDescriptor(
                      type: _type,
                      sourceId: sourceId,
                      libraryId: libraryId,
                      displayName: displayName,
                      descending: _descending,
                      listeningTrigger: _listeningTrigger,
                      listeningThreshold: threshold ?? 30,
                    ),
                  );
                }
              : null,
          child: const Text('Add'),
        ),
      ],
    );
  }

  List<({String id, String name})> _remoteSuggestions(AsyncValue<SearchLibrary?>? searchAsync) {
    final result = searchAsync?.asData?.value;
    if (result == null) {
      return const <({String id, String name})>[];
    }

    if (_type == MediaSourceType.series) {
      return (result.series ?? const [])
          .take(3)
          .map((entry) => (id: entry.series.id, name: entry.series.name))
          .toList(growable: false);
    }

    return (result.podcast ?? const [])
        .where((entry) => entry.libraryItem != null)
        .take(3)
        .map((entry) => (id: entry.libraryItem!.id, name: entry.libraryItem!.title))
        .toList(growable: false);
  }

  void _scheduleAutocompleteRefresh() {
    if (_autocompleteRefreshScheduled) {
      return;
    }
    _autocompleteRefreshScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autocompleteRefreshScheduled = false;
      if (!mounted) {
        return;
      }
      _refreshingAutocomplete = true;
      _searchController.refreshOptions();
      _refreshingAutocomplete = false;
    });
  }

  List<MediaSourceType> _sourceTypesForLibrary(String? mediaType) {
    return switch (mediaType?.trim().toLowerCase()) {
      'podcast' => const [
        MediaSourceType.latestEpisodes,
        MediaSourceType.podcast,
        MediaSourceType.playlist,
        MediaSourceType.collection,
        MediaSourceType.continueListening,
        MediaSourceType.continueSeries,
        MediaSourceType.continueReading,
        MediaSourceType.listeningThreshold,
      ],
      'book' => const [
        MediaSourceType.series,
        MediaSourceType.playlist,
        MediaSourceType.collection,
        MediaSourceType.continueListening,
        MediaSourceType.continueSeries,
        MediaSourceType.continueReading,
        MediaSourceType.listeningThreshold,
      ],
      _ => MediaSourceType.values,
    };
  }
}
