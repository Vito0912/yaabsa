import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_data.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_named_entity.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/components/app/item/editor/library_item_description_codec.dart';
import 'package:yaabsa/components/app/item/editor/library_item_edit_models.dart';
import 'package:yaabsa/components/app/item/editor/library_item_editor_field_container.dart';
import 'package:yaabsa/components/app/item/editor/library_item_editor_inputs.dart';
import 'package:yaabsa/components/common/inputs/string_chip_list_input.dart';
import 'package:yaabsa/components/common/inputs/styled_form_fields.dart';
import 'package:yaabsa/components/common/inputs/rich_text_quill_field.dart';
import 'package:yaabsa/util/globals.dart';

class LibraryItemEditorForm extends StatefulWidget {
  const LibraryItemEditorForm({
    super.key,
    required this.item,
    required this.isSaving,
    required this.onSave,
    this.filterData,
    this.onClose,
  });

  final LibraryItem item;
  final bool isSaving;
  final LibraryFilterData? filterData;
  final Future<void> Function(LibraryItemEditorDiff diff) onSave;
  final VoidCallback? onClose;

  @override
  State<LibraryItemEditorForm> createState() => _LibraryItemEditorFormState();
}

class _LibraryItemEditorFormState extends State<LibraryItemEditorForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _subtitleController;
  late final TextEditingController _podcastAuthorController;
  late final TextEditingController _publishedYearController;
  late final TextEditingController _publisherController;
  late final TextEditingController _isbnController;
  late final TextEditingController _asinController;
  late final TextEditingController _languageController;
  late final TextEditingController _releaseDateController;
  late final TextEditingController _feedUrlController;
  late final TextEditingController _itunesIdController;
  late String _podcastTypeValue;

  late QuillController _descriptionController;

  late LibraryItemEditorDraft _initialDraft;
  late String _initialDescriptionDeltaSignature;

  List<LibraryItemEditorNamedEntity> _authors = const <LibraryItemEditorNamedEntity>[];
  List<String> _narrators = const <String>[];
  List<LibraryItemEditorSeriesEntry> _series = const <LibraryItemEditorSeriesEntry>[];
  List<String> _genres = const <String>[];
  List<String> _tags = const <String>[];
  final Map<String, String> _pendingSeriesSequences = <String, String>{};
  bool _explicit = false;
  bool _abridged = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _subtitleController = TextEditingController();
    _podcastAuthorController = TextEditingController();
    _publishedYearController = TextEditingController();
    _publisherController = TextEditingController();
    _isbnController = TextEditingController();
    _asinController = TextEditingController();
    _languageController = TextEditingController();
    _releaseDateController = TextEditingController();
    _feedUrlController = TextEditingController();
    _itunesIdController = TextEditingController();
    _podcastTypeValue = 'episodic';

    _descriptionController = QuillController.basic();
    _loadItem(widget.item);
  }

  @override
  void didUpdateWidget(covariant LibraryItemEditorForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.id != widget.item.id) {
      _loadItem(widget.item);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _podcastAuthorController.dispose();
    _publishedYearController.dispose();
    _publisherController.dispose();
    _isbnController.dispose();
    _asinController.dispose();
    _languageController.dispose();
    _releaseDateController.dispose();
    _feedUrlController.dispose();
    _itunesIdController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _loadItem(LibraryItem item) {
    final draft = LibraryItemEditorDraft.fromLibraryItem(item);
    final descriptionDocument = quillDocumentFromHtml(draft.descriptionHtml);

    _descriptionController.dispose();
    _descriptionController = QuillController(
      document: descriptionDocument,
      selection: const TextSelection.collapsed(offset: 0),
    );

    _initialDescriptionDeltaSignature = jsonEncode(descriptionDocument.toDelta().toJson());
    _initialDraft = draft;

    _titleController.text = draft.title;
    _subtitleController.text = draft.subtitle;
    _podcastAuthorController.text = draft.podcastAuthor;
    _publishedYearController.text = draft.publishedYear;
    _publisherController.text = draft.publisher;
    _isbnController.text = draft.isbn;
    _asinController.text = draft.asin;
    _languageController.text = draft.language;
    _releaseDateController.text = draft.releaseDate;
    _feedUrlController.text = draft.feedUrl;
    _itunesIdController.text = draft.itunesId;
    _podcastTypeValue = _normalizedPodcastTypeValue(draft.podcastType);

    _authors = List<LibraryItemEditorNamedEntity>.from(draft.authors);
    _narrators = List<String>.from(draft.narrators);
    _series = List<LibraryItemEditorSeriesEntry>.from(draft.series);
    _genres = List<String>.from(draft.genres);
    _tags = List<String>.from(draft.tags);
    _explicit = draft.explicit;
    _abridged = draft.abridged;

    if (mounted) {
      setState(() {});
    }
  }

  LibraryItemEditorDraft _currentDraft() {
    return _initialDraft.copyWith(
      title: _titleController.text,
      subtitle: _subtitleController.text,
      authors: _authors,
      podcastAuthor: _podcastAuthorController.text,
      narrators: _narrators,
      series: _series,
      genres: _genres,
      tags: _tags,
      publishedYear: _publishedYearController.text,
      publisher: _publisherController.text,
      descriptionHtml: quillDocumentToHtml(_descriptionController.document),
      isbn: _isbnController.text,
      asin: _asinController.text,
      language: _languageController.text,
      explicit: _explicit,
      abridged: _abridged,
      releaseDate: _releaseDateController.text,
      feedUrl: _feedUrlController.text,
      itunesId: _itunesIdController.text,
      podcastType: _podcastTypeValue,
    );
  }

  Future<void> _submit({bool pop = false}) async {
    if (_initialDraft.isPodcast) {
      final releaseDate = _releaseDateController.text.trim();
      if (releaseDate.isNotEmpty && !_isValidIsoDate(releaseDate)) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Release date must be a valid date in the format YYYY-MM-DD.')));
        return;
      }

      final feedUrl = _feedUrlController.text.trim();
      if (feedUrl.isNotEmpty && !_isValidHttpUrl(feedUrl)) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Feed URL must be a valid HTTP or HTTPS URL.')));
        return;
      }
    }

    final currentDraft = _currentDraft();
    final currentDescriptionDeltaSignature = jsonEncode(_descriptionController.document.toDelta().toJson());
    final diff = buildLibraryItemEditorDiff(
      initial: _initialDraft,
      current: currentDraft,
      descriptionChanged: currentDescriptionDeltaSignature != _initialDescriptionDeltaSignature,
    );

    if (!diff.hasChanges) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No changes to save.')));
      return;
    }

    await widget.onSave(diff);
    if (pop && mounted) {
      widget.onClose?.call();
    }
  }

  bool _isValidIsoDate(String value) {
    final datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!datePattern.hasMatch(value)) {
      return false;
    }

    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      return false;
    }

    final normalized =
        '${parsed.year.toString().padLeft(4, '0')}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}';
    return normalized == value;
  }

  bool _isValidHttpUrl(String value) {
    final uri = Uri.tryParse(value);
    if (uri == null) {
      return false;
    }

    final hasValidScheme = uri.scheme == 'http' || uri.scheme == 'https';
    return hasValidScheme && uri.host.trim().isNotEmpty;
  }

  String _normalizedPodcastTypeValue(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'serial') {
      return 'serial';
    }
    return 'episodic';
  }

  String _sanitizeSeriesSequence(String value) => value.replaceAll(RegExp(r'\s+'), '');

  Future<String?> _promptSeriesSequence({String initialValue = ''}) async {
    if (!mounted) {
      return null;
    }

    final controller = TextEditingController(text: initialValue);
    try {
      final value = await showDialog<String>(
        context: context,
        builder: (dialogContext) {
          var completed = false;

          void complete(String value) {
            if (completed) {
              return;
            }
            completed = true;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!dialogContext.mounted) {
                return;
              }
              Navigator.of(dialogContext).pop(_sanitizeSeriesSequence(value));
            });
          }

          return AlertDialog(
            title: const Text('Series number'),
            content: TextField(
              controller: controller,
              autofocus: true,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Sequence',
                hintText: 'e.g. 1,2.5,03 (no spaces)',
                border: OutlineInputBorder(),
              ),
              onSubmitted: complete,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  complete(initialValue);
                },
                child: const Text('Skip'),
              ),
              FilledButton(
                onPressed: () {
                  complete(controller.text);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );

      return value;
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not open the series sequence prompt. Please try again.')));
      }
      return null;
    } finally {
      controller.dispose();
    }
  }

  Future<String?> _prepareSeriesValue(String value, List<String> currentValues) async {
    final normalizedName = value.trim();
    if (normalizedName.isEmpty) {
      return null;
    }

    final sequence = await _promptSeriesSequence();
    if (!mounted || sequence == null) {
      return null;
    }

    _pendingSeriesSequences[normalizedName.toLowerCase()] = sequence;
    return normalizedName;
  }

  String _seriesChipLabel(String seriesName) {
    final normalizedName = seriesName.trim().toLowerCase();
    for (final entry in _series) {
      if (entry.name.toLowerCase() != normalizedName) {
        continue;
      }

      final sequence = entry.sequence.trim();
      return sequence.isEmpty ? entry.name : '${entry.name} #$sequence';
    }

    return seriesName;
  }

  void _updateAuthorsFromNames(List<String> nextNames, List<LibraryFilterNamedEntity> suggestions) {
    final existingByLower = <String, LibraryItemEditorNamedEntity>{
      for (final entry in _authors) entry.name.toLowerCase(): entry,
    };
    final suggestionByLower = <String, LibraryFilterNamedEntity>{
      for (final entry in suggestions) entry.name.toLowerCase(): entry,
    };

    final nextAuthors = nextNames
        .map((rawName) => rawName.trim())
        .where((name) => name.isNotEmpty)
        .map((name) {
          final lowerName = name.toLowerCase();
          final existing = existingByLower[lowerName];
          if (existing != null) {
            return existing;
          }

          final matchedSuggestion = suggestionByLower[lowerName];
          if (matchedSuggestion != null) {
            return LibraryItemEditorNamedEntity(id: matchedSuggestion.id, name: matchedSuggestion.name);
          }

          return LibraryItemEditorNamedEntity(id: name, name: name);
        })
        .toList(growable: false);

    setState(() {
      _authors = nextAuthors;
    });
  }

  void _updateSeriesFromNames(List<String> nextNames, List<LibraryFilterNamedEntity> suggestions) {
    final existingByLower = <String, LibraryItemEditorSeriesEntry>{
      for (final entry in _series) entry.name.toLowerCase(): entry,
    };
    final suggestionByLower = <String, LibraryFilterNamedEntity>{
      for (final entry in suggestions) entry.name.toLowerCase(): entry,
    };

    final nextSeries = nextNames
        .map((rawName) => rawName.trim())
        .where((name) => name.isNotEmpty)
        .map((name) {
          final lowerName = name.toLowerCase();
          final existing = existingByLower[lowerName];
          if (existing != null) {
            return existing;
          }

          final matchedSuggestion = suggestionByLower[lowerName];
          final pendingSequence = _pendingSeriesSequences.remove(lowerName) ?? '';
          return LibraryItemEditorSeriesEntry(
            id: matchedSuggestion != null && matchedSuggestion.id.trim().isNotEmpty ? matchedSuggestion.id : name,
            name: name,
            sequence: pendingSequence,
          );
        })
        .toList(growable: false);

    setState(() {
      _series = nextSeries;
    });
  }

  Future<void> _editSeriesSequenceByName(String seriesName) async {
    final normalizedName = seriesName.trim().toLowerCase();
    final index = _series.indexWhere((entry) => entry.name.toLowerCase() == normalizedName);
    if (index < 0) {
      return;
    }

    final current = _series[index];
    final updated = await _promptSeriesSequence(initialValue: current.sequence);
    if (!mounted || updated == null) {
      return;
    }

    setState(() {
      final next = List<LibraryItemEditorSeriesEntry>.from(_series);
      next[index] = current.copyWith(sequence: updated);
      _series = next;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filterData = widget.filterData;
    final isPodcast = _initialDraft.isPodcast;

    final authorsSuggestions = filterData?.authors ?? const [];
    final seriesSuggestions = filterData?.series ?? const [];
    final genresSuggestions = filterData?.genres ?? const <String>[];
    final tagsSuggestions = filterData?.tags ?? const <String>[];
    final narratorsSuggestions = filterData?.narrators ?? const <String>[];
    final languageSuggestions = filterData?.languages ?? const <String>[];
    final publisherSuggestions = filterData?.publishers ?? const <String>[];

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
            children: [
              _buildCoreMetadataSection(
                context,
                isPodcast: isPodcast,
                languageSuggestions: languageSuggestions,
                publisherSuggestions: publisherSuggestions,
              ),
              const SizedBox(height: 6),
              Divider(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5), height: 1),
              const SizedBox(height: 6),
              _buildPeopleAndTaxonomySection(
                context,
                isPodcast: isPodcast,
                authorsSuggestions: authorsSuggestions,
                narratorsSuggestions: narratorsSuggestions,
                seriesSuggestions: seriesSuggestions,
                genresSuggestions: genresSuggestions,
                tagsSuggestions: tagsSuggestions,
              ),
              const SizedBox(height: 6),
              Divider(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5), height: 1),
              const SizedBox(height: 6),
              _buildDescriptionSection(context),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
          child: Row(
            children: [
              OutlinedButton.icon(
                onPressed: widget.isSaving ? null : widget.onClose,
                icon: const Icon(Icons.close_rounded),
                label: const Text('Close'),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: widget.isSaving ? null : _submit,
                icon: widget.isSaving
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2.2))
                    : const Icon(Icons.save_rounded),
                label: Text(widget.isSaving ? 'Saving...' : 'Save'),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: widget.isSaving ? null : () => _submit(pop: true),
                icon: widget.isSaving
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2.2))
                    : const Icon(Icons.save_rounded),
                label: Text(widget.isSaving ? 'Saving...' : 'Save & Close'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCoreMetadataSection(
    BuildContext context, {
    required bool isPodcast,
    required List<String> languageSuggestions,
    required List<String> publisherSuggestions,
  }) {
    final fields = <Widget>[
      StyledTextField(label: 'Title', controller: _titleController, onChanged: (_) => setState(() {})),
      if (!isPodcast)
        StyledTextField(label: 'Subtitle', controller: _subtitleController, onChanged: (_) => setState(() {})),
      if (isPodcast)
        StyledTextField(label: 'Author', controller: _podcastAuthorController, onChanged: (_) => setState(() {})),
      if (!isPodcast)
        StyledTextField(
          label: 'Published year',
          controller: _publishedYearController,
          keyboardType: TextInputType.number,
          onChanged: (_) => setState(() {}),
        ),
      if (!isPodcast)
        StyledTextField(
          label: 'Publisher',
          controller: _publisherController,
          hintText: publisherSuggestions.isEmpty ? null : publisherSuggestions.first,
          onChanged: (_) => setState(() {}),
        ),
      if (isPodcast)
        StyledTextField(
          label: 'Release date',
          controller: _releaseDateController,
          hintText: 'YYYY-MM-DD',
          onChanged: (_) => setState(() {}),
        ),
      StyledTextField(
        label: 'Language',
        controller: _languageController,
        hintText: languageSuggestions.isEmpty ? null : languageSuggestions.first,
        onChanged: (_) => setState(() {}),
      ),
      if (!isPodcast) StyledTextField(label: 'ISBN', controller: _isbnController, onChanged: (_) => setState(() {})),
      if (!isPodcast) StyledTextField(label: 'ASIN', controller: _asinController, onChanged: (_) => setState(() {})),
      if (isPodcast)
        StyledTextField(
          label: 'Feed URL',
          controller: _feedUrlController,
          hintText: 'https://example.com/feed.xml',
          onChanged: (_) => setState(() {}),
        ),
      if (isPodcast)
        StyledTextField(label: 'iTunes ID', controller: _itunesIdController, onChanged: (_) => setState(() {})),
      if (isPodcast)
        LibraryItemEditorPodcastTypeField(
          value: _podcastTypeValue,
          onChanged: (value) {
            setState(() {
              _podcastTypeValue = value;
            });
          },
        ),
      _MetadataFlagsField(
        explicit: _explicit,
        abridged: _abridged,
        showAbridged: !isPodcast,
        onExplicitChanged: (value) {
          setState(() {
            _explicit = value;
          });
        },
        onAbridgedChanged: (value) {
          setState(() {
            _abridged = value;
          });
        },
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Metadata', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),
        const SizedBox(height: 4),
        _ResponsiveEditorFields(children: fields),
      ],
    );
  }

  Widget _buildPeopleAndTaxonomySection(
    BuildContext context, {
    required bool isPodcast,
    required List<LibraryFilterNamedEntity> authorsSuggestions,
    required List<String> narratorsSuggestions,
    required List<LibraryFilterNamedEntity> seriesSuggestions,
    required List<String> genresSuggestions,
    required List<String> tagsSuggestions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isPodcast)
          _ResponsiveEditorFields(
            children: [
              StringChipListInput(
                label: 'Authors',
                values: _authors.map((entry) => entry.name).toList(growable: false),
                suggestions: authorsSuggestions.map((entry) => entry.name).toList(growable: false),
                onChanged: (next) => _updateAuthorsFromNames(next, authorsSuggestions),
              ),
              StringChipListInput(
                label: 'Narrators',
                values: _narrators,
                suggestions: narratorsSuggestions,
                onChanged: (next) {
                  setState(() {
                    _narrators = next;
                  });
                },
              ),
            ],
          ),
        if (!isPodcast) const SizedBox(height: 6),
        _ResponsiveEditorFields(
          children: [
            if (!isPodcast)
              StringChipListInput(
                label: 'Series',
                values: _series.map((entry) => entry.name).toList(growable: false),
                suggestions: seriesSuggestions.map((entry) => entry.name).toList(growable: false),
                hintText: 'Add series',
                chipLabelBuilder: _seriesChipLabel,
                onChipTap: _editSeriesSequenceByName,
                onTryAdd: _prepareSeriesValue,
                onChanged: (next) => _updateSeriesFromNames(next, seriesSuggestions),
              ),
            StringChipListInput(
              label: 'Genres',
              values: _genres,
              suggestions: genresSuggestions,
              onChanged: (next) {
                setState(() {
                  _genres = next;
                });
              },
            ),
            StringChipListInput(
              label: 'Tags',
              values: _tags,
              suggestions: tagsSuggestions,
              onChanged: (next) {
                setState(() {
                  _tags = next;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return RichTextQuillField(
      label: 'Description',
      controller: _descriptionController,
      editorHeight: context.isDesktop ? 250 : 200,
      placeholder: 'Write a formatted description...',
    );
  }
}

class _ResponsiveEditorFields extends StatelessWidget {
  const _ResponsiveEditorFields({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final twoColumns = context.isDesktop || (context.isTablet && constraints.maxWidth >= 720);
        final width = twoColumns ? (constraints.maxWidth - 8) / 2 : constraints.maxWidth;

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [for (final child in children) SizedBox(width: width, child: child)],
        );
      },
    );
  }
}

class _MetadataFlagsField extends StatelessWidget {
  const _MetadataFlagsField({
    required this.explicit,
    required this.abridged,
    required this.showAbridged,
    required this.onExplicitChanged,
    required this.onAbridgedChanged,
  });

  final bool explicit;
  final bool abridged;
  final bool showAbridged;
  final ValueChanged<bool> onExplicitChanged;
  final ValueChanged<bool> onAbridgedChanged;

  @override
  Widget build(BuildContext context) {
    return LibraryItemEditorFieldContainer(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Wrap(
        spacing: 12,
        runSpacing: 4,
        children: [
          _InlineSwitchField(label: 'Explicit', value: explicit, onChanged: onExplicitChanged),
          if (showAbridged) _InlineSwitchField(label: 'Abridged', value: abridged, onChanged: onAbridgedChanged),
        ],
      ),
    );
  }
}

class _InlineSwitchField extends StatelessWidget {
  const _InlineSwitchField({required this.label, required this.value, required this.onChanged});

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Switch.adaptive(value: value, onChanged: onChanged),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
