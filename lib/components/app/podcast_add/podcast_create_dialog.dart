import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/settings/yaabsa_switch_tile.dart';
import 'package:path/path.dart' as p;
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/api/library/library_folder.dart';
import 'package:yaabsa/api/podcast/podcast_feed.dart';
import 'package:yaabsa/api/podcast/podcast_search_result.dart';
import 'package:yaabsa/api/podcast/request/create_podcast_request.dart';
import 'package:yaabsa/components/app/item/editor/library_item_editor_field_container.dart';
import 'package:yaabsa/components/app/item/editor/library_item_editor_inputs.dart';
import 'package:yaabsa/components/common/inputs/string_chip_list_input.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/ui/components/media/yaabsa_cover_image.dart';
import 'package:yaabsa/util/l10n.dart';

Future<CreatePodcastRequest?> showPodcastCreateDialog({
  required BuildContext context,
  required Library library,
  required PodcastFeed feed,
  PodcastSearchResult? searchResult,
  String? rssFeedOverride,
}) {
  return showDialog<CreatePodcastRequest>(
    context: context,
    builder: (context) {
      return _PodcastCreateDialog(
        library: library,
        feed: feed,
        searchResult: searchResult,
        rssFeedOverride: rssFeedOverride,
      );
    },
  );
}

class _PodcastCreateDialog extends StatefulWidget {
  const _PodcastCreateDialog({required this.library, required this.feed, this.searchResult, this.rssFeedOverride});

  final Library library;
  final PodcastFeed feed;
  final PodcastSearchResult? searchResult;
  final String? rssFeedOverride;

  @override
  State<_PodcastCreateDialog> createState() => _PodcastCreateDialogState();
}

class _PodcastCreateDialogState extends State<_PodcastCreateDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _authorController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _releaseDateController;
  late final TextEditingController _feedUrlController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _itunesIdController;
  late final TextEditingController _languageController;

  String? _selectedFolderId;
  String _podcastType = 'episodic';
  bool _explicit = false;
  bool _autoDownloadEpisodes = false;
  List<String> _genres = const <String>[];
  List<String> _genresSuggestions = const <String>[];

  List<LibraryFolder> get _folders => widget.library.folders ?? const <LibraryFolder>[];

  LibraryFolder? get _selectedFolder {
    final currentFolderId = _selectedFolderId;
    if (currentFolderId == null) {
      return null;
    }

    for (final folder in _folders) {
      if (folder.id == currentFolderId) {
        return folder;
      }
    }

    return null;
  }

  @override
  void initState() {
    super.initState();

    _selectedFolderId = _folders.isEmpty ? null : _folders.first.id;

    final seed = _PodcastCreateSeed.fromSources(
      feed: widget.feed,
      searchResult: widget.searchResult,
      rssFeedOverride: widget.rssFeedOverride,
    );

    _titleController = TextEditingController(text: seed.title);
    _authorController = TextEditingController(text: seed.author);
    _descriptionController = TextEditingController(text: seed.description);
    _releaseDateController = TextEditingController(text: seed.releaseDate);
    _feedUrlController = TextEditingController(text: seed.feedUrl);
    _imageUrlController = TextEditingController(text: seed.imageUrl);
    _itunesIdController = TextEditingController(text: seed.itunesId);
    _languageController = TextEditingController(text: seed.language);

    _podcastType = seed.type.trim().toLowerCase() == 'serial' ? 'serial' : 'episodic';
    _explicit = seed.explicit;
    _genres = List<String>.from(seed.genres);
    _genresSuggestions = seed.genreSuggestions;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _releaseDateController.dispose();
    _feedUrlController.dispose();
    _imageUrlController.dispose();
    _itunesIdController.dispose();
    _languageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selectedFolder = _selectedFolder;
    final imageUrl = _trimToNull(_imageUrlController.text);
    final pathPreview = selectedFolder == null
        ? null
        : p.join(selectedFolder.fullPath, _sanitizePathSegment(_titleController.text));

    return AlertDialog(
      title: Text(l10n.actionAddPodcast),
      content: SizedBox(
        width: 760,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: YaabsaCoverImage(
                  image: imageUrl == null ? null : NetworkImage(imageUrl),
                  width: 180,
                  height: 180,
                  borderRadius: BorderRadius.circular(12),
                  placeholder: const _DialogCoverFallback(),
                ),
              ),
              const SizedBox(height: 12),
              LibraryItemEditorSectionCard(
                title: l10n.headingMetadata,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CreateDialogResponsiveFields(
                      children: [
                        StyledTextField(
                          label: l10n.fieldRequired(l10n.fieldTitle),
                          controller: _titleController,
                          onChanged: (_) => setState(() {}),
                        ),
                        StyledTextField(label: l10n.fieldAuthor, controller: _authorController),
                        StyledTextField(label: l10n.fieldLanguage, controller: _languageController),
                        StyledTextField(
                          label: l10n.fieldRequired(l10n.fieldRssFeedUrl),
                          hintText: 'https://example.com/feed.xml',
                          controller: _feedUrlController,
                        ),
                        LibraryItemEditorPodcastTypeField(
                          value: _podcastType,
                          onChanged: (value) {
                            setState(() {
                              _podcastType = value.trim().toLowerCase() == 'serial' ? 'serial' : 'episodic';
                            });
                          },
                        ),
                        StringChipListInput(
                          label: l10n.fieldGenres,
                          values: _genres,
                          suggestions: _genresSuggestions,
                          hintText: l10n.hintAddGenre,
                          onChanged: (next) {
                            setState(() {
                              _genres = _compactStrings(next);
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    StyledTextField(label: l10n.fieldDescription, controller: _descriptionController, maxLines: 4),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              LibraryItemEditorSectionCard(
                title: l10n.headingStorage,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    YaabsaDropdownField<String>(
                      label: l10n.fieldRequired(l10n.fieldLibraryFolder),
                      value: _selectedFolderId,
                      items: _folders
                          .map((folder) => DropdownMenuItem<String>(value: folder.id, child: Text(folder.fullPath)))
                          .toList(growable: false),
                      onChanged: (value) {
                        setState(() {
                          _selectedFolderId = value;
                        });
                      },
                    ),
                    if (pathPreview != null) ...[
                      const SizedBox(height: 8),
                      LibraryItemEditorFieldContainer(
                        child: Text(pathPreview, style: Theme.of(context).textTheme.bodySmall),
                      ),
                    ],
                    const SizedBox(height: 8),
                    LibraryItemEditorFieldContainer(
                      child: Column(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: YaabsaSwitchTile.adaptive(
                              contentPadding: EdgeInsets.zero,
                              value: _explicit,
                              onChanged: (value) {
                                setState(() {
                                  _explicit = value;
                                });
                              },
                              title: Text(l10n.settingPodcastExplicitContent),
                            ),
                          ),
                          const Divider(height: 1),
                          Material(
                            color: Colors.transparent,
                            child: YaabsaSwitchTile.adaptive(
                              contentPadding: EdgeInsets.zero,
                              value: _autoDownloadEpisodes,
                              onChanged: (value) {
                                setState(() {
                                  _autoDownloadEpisodes = value;
                                });
                              },
                              title: Text(l10n.settingPodcastAutoDownloadEpisodes),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.actionCancel)),
        FilledButton.icon(
          onPressed: () {
            final request = _buildRequest();
            if (request == null) {
              return;
            }
            Navigator.of(context).pop(request);
          },
          icon: const Icon(Icons.add_rounded),
          label: Text(l10n.actionCreatePodcast),
        ),
      ],
    );
  }

  CreatePodcastRequest? _buildRequest() {
    final selectedFolder = _selectedFolder;
    if (selectedFolder == null) {
      _showValidationError(context.l10n.validationLibraryFolderRequired);
      return null;
    }

    final title = _titleController.text.trim();
    if (title.isEmpty) {
      _showValidationError(context.l10n.validationTitleRequired);
      return null;
    }

    final feedUrl = _feedUrlController.text.trim();
    if (feedUrl.isEmpty) {
      _showValidationError(context.l10n.validationRssFeedUrlRequired);
      return null;
    }

    if (!_isValidHttpUrl(feedUrl)) {
      _showValidationError(context.l10n.validationHttpUrlRequired);
      return null;
    }

    final releaseDate = _releaseDateController.text.trim();

    final path = p.join(selectedFolder.fullPath, _sanitizePathSegment(title));

    return CreatePodcastRequest(
      path: path,
      folderId: selectedFolder.id,
      libraryId: widget.library.id,
      media: CreatePodcastMedia(
        autoDownloadEpisodes: _autoDownloadEpisodes,
        metadata: CreatePodcastMetadata(
          title: title,
          author: _trimToNull(_authorController.text),
          description: _trimToNull(_descriptionController.text),
          releaseDate: releaseDate.isEmpty ? null : releaseDate,
          genres: _genres,
          feedUrl: feedUrl,
          imageUrl: _trimToNull(_imageUrlController.text),
          itunesId: _trimToNull(_itunesIdController.text),
          language: _trimToNull(_languageController.text),
          explicit: _explicit,
          type: _trimToNull(_podcastType),
        ),
      ),
    );
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  bool _isValidHttpUrl(String value) {
    final uri = Uri.tryParse(value);
    if (uri == null) {
      return false;
    }

    final hasValidScheme = uri.scheme == 'http' || uri.scheme == 'https';
    return hasValidScheme && uri.host.trim().isNotEmpty;
  }

  String _sanitizePathSegment(String value) {
    final withoutInvalidChars = value.replaceAll(RegExp(r'[<>:"/\\|?*]'), ' ').trim();
    final collapsedWhitespace = withoutInvalidChars.replaceAll(RegExp(r'\s+'), ' ');
    return collapsedWhitespace.isEmpty ? context.l10n.mediaTypePodcast : collapsedWhitespace;
  }
}

class _PodcastCreateSeed {
  const _PodcastCreateSeed({
    required this.title,
    required this.author,
    required this.description,
    required this.releaseDate,
    required this.feedUrl,
    required this.imageUrl,
    required this.itunesId,
    required this.language,
    required this.explicit,
    required this.type,
    required this.genres,
    required this.genreSuggestions,
  });

  final String title;
  final String author;
  final String description;
  final String releaseDate;
  final String feedUrl;
  final String imageUrl;
  final String itunesId;
  final String language;
  final bool explicit;
  final String type;
  final List<String> genres;
  final List<String> genreSuggestions;

  factory _PodcastCreateSeed.fromSources({
    required PodcastFeed feed,
    PodcastSearchResult? searchResult,
    String? rssFeedOverride,
  }) {
    final metadata = feed.metadata;
    final search = searchResult;

    final preferredGenres = (search?.genres.isNotEmpty == true)
        ? search!.genres
        : (metadata.categories.isNotEmpty ? metadata.categories : const <String>[]);

    return _PodcastCreateSeed(
      title: _firstNonEmpty([search?.title, metadata.title]),
      author: _firstNonEmpty([search?.artistName, metadata.author]),
      description: _firstNonEmpty([
        search?.descriptionPlain,
        search?.description,
        metadata.descriptionPlain,
        metadata.description,
      ]),
      releaseDate: _firstNonEmpty([search?.releaseDate, metadata.pubDate]),
      feedUrl: _firstNonEmpty([rssFeedOverride, search?.feedUrl, metadata.feedUrl]),
      imageUrl: _firstNonEmpty([search?.cover, metadata.image]),
      itunesId: _firstNonEmpty([search?.id]),
      language: _firstNonEmpty([search?.language, metadata.language]),
      explicit: search?.explicit ?? _explicitFromString(metadata.explicit) ?? false,
      type: _firstNonEmpty([search?.type, metadata.type, 'episodic']),
      genres: _compactStrings(preferredGenres),
      genreSuggestions: _compactStrings([...metadata.categories, if (search != null) ...search.genres]),
    );
  }
}

class _CreateDialogResponsiveFields extends StatelessWidget {
  const _CreateDialogResponsiveFields({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final twoColumns = constraints.maxWidth >= 720;
        final fieldWidth = twoColumns ? (constraints.maxWidth - 8) / 2 : constraints.maxWidth;

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [for (final child in children) SizedBox(width: fieldWidth, child: child)],
        );
      },
    );
  }
}

class _DialogCoverFallback extends StatelessWidget {
  const _DialogCoverFallback();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest),
      child: Center(
        child: Icon(Icons.podcasts_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 34),
      ),
    );
  }
}

String? _trimToNull(String? value) {
  final text = (value ?? '').trim();
  if (text.isEmpty) {
    return null;
  }

  return text;
}

String _firstNonEmpty(List<String?> values) {
  for (final value in values) {
    final text = (value ?? '').trim();
    if (text.isNotEmpty) {
      return text;
    }
  }

  return '';
}

List<String> _compactStrings(List<String> values) {
  final seen = <String>{};
  final items = <String>[];

  for (final value in values) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      continue;
    }

    final lower = trimmed.toLowerCase();
    if (!seen.add(lower)) {
      continue;
    }

    items.add(trimmed);
  }

  return items;
}

bool? _explicitFromString(String? value) {
  final text = value?.trim().toLowerCase();
  if (text == null || text.isEmpty) {
    return null;
  }

  if (text == 'yes' || text == 'true' || text == '1') {
    return true;
  }

  if (text == 'no' || text == 'false' || text == '0') {
    return false;
  }

  return null;
}
