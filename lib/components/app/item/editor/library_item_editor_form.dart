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
  late final TextEditingController _itunesPageUrlController;
  late final TextEditingController _itunesIdController;
  late final TextEditingController _podcastTypeController;

  late QuillController _descriptionController;

  late LibraryItemEditorDraft _initialDraft;
  late String _initialDescriptionDeltaSignature;

  List<LibraryItemEditorNamedEntity> _authors = const <LibraryItemEditorNamedEntity>[];
  List<String> _narrators = const <String>[];
  List<LibraryItemEditorSeriesEntry> _series = const <LibraryItemEditorSeriesEntry>[];
  List<String> _genres = const <String>[];
  List<String> _tags = const <String>[];
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
    _itunesPageUrlController = TextEditingController();
    _itunesIdController = TextEditingController();
    _podcastTypeController = TextEditingController();

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
    _itunesPageUrlController.dispose();
    _itunesIdController.dispose();
    _podcastTypeController.dispose();
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
    _itunesPageUrlController.text = draft.itunesPageUrl;
    _itunesIdController.text = draft.itunesId;
    _podcastTypeController.text = draft.podcastType;

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
      itunesPageUrl: _itunesPageUrlController.text,
      itunesId: _itunesIdController.text,
      podcastType: _podcastTypeController.text,
    );
  }

  Future<void> _submit() async {
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
                label: Text(widget.isSaving ? 'Saving...' : 'Save changes'),
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
      LibraryItemEditorTextField(label: 'Title', controller: _titleController, onChanged: (_) => setState(() {})),
      if (!isPodcast)
        LibraryItemEditorTextField(
          label: 'Subtitle',
          controller: _subtitleController,
          onChanged: (_) => setState(() {}),
        ),
      if (isPodcast)
        LibraryItemEditorTextField(
          label: 'Author',
          controller: _podcastAuthorController,
          onChanged: (_) => setState(() {}),
        ),
      if (!isPodcast)
        LibraryItemEditorTextField(
          label: 'Published year',
          controller: _publishedYearController,
          keyboardType: TextInputType.number,
          onChanged: (_) => setState(() {}),
        ),
      if (!isPodcast)
        LibraryItemEditorTextField(
          label: 'Publisher',
          controller: _publisherController,
          hintText: publisherSuggestions.isEmpty ? null : publisherSuggestions.first,
          onChanged: (_) => setState(() {}),
        ),
      if (isPodcast)
        LibraryItemEditorTextField(
          label: 'Release date',
          controller: _releaseDateController,
          hintText: 'YYYY-MM-DD',
          onChanged: (_) => setState(() {}),
        ),
      LibraryItemEditorTextField(
        label: 'Language',
        controller: _languageController,
        hintText: languageSuggestions.isEmpty ? null : languageSuggestions.first,
        onChanged: (_) => setState(() {}),
      ),
      if (!isPodcast)
        LibraryItemEditorTextField(label: 'ISBN', controller: _isbnController, onChanged: (_) => setState(() {})),
      if (!isPodcast)
        LibraryItemEditorTextField(label: 'ASIN', controller: _asinController, onChanged: (_) => setState(() {})),
      if (isPodcast)
        LibraryItemEditorTextField(
          label: 'Feed URL',
          controller: _feedUrlController,
          onChanged: (_) => setState(() {}),
        ),
      if (isPodcast)
        LibraryItemEditorTextField(
          label: 'iTunes page URL',
          controller: _itunesPageUrlController,
          onChanged: (_) => setState(() {}),
        ),
      if (isPodcast)
        LibraryItemEditorTextField(
          label: 'iTunes ID',
          controller: _itunesIdController,
          onChanged: (_) => setState(() {}),
        ),
      if (isPodcast)
        LibraryItemEditorTextField(
          label: 'Podcast type',
          controller: _podcastTypeController,
          hintText: 'episodic or serial',
          onChanged: (_) => setState(() {}),
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
              LibraryItemEditorNamedEntityChips(
                label: 'Authors',
                values: _authors,
                suggestions: authorsSuggestions,
                onChanged: (next) {
                  setState(() {
                    _authors = next;
                  });
                },
              ),
              LibraryItemEditorStringChips(
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
              LibraryItemEditorSeriesList(
                values: _series,
                suggestions: seriesSuggestions,
                onChanged: (next) {
                  setState(() {
                    _series = next;
                  });
                },
              ),
            LibraryItemEditorStringChips(
              label: 'Genres',
              values: _genres,
              suggestions: genresSuggestions,
              onChanged: (next) {
                setState(() {
                  _genres = next;
                });
              },
            ),
            LibraryItemEditorStringChips(
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
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),
        const SizedBox(height: 4),
        LibraryItemEditorFieldContainer(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: QuillSimpleToolbar(
                        controller: _descriptionController,
                        config: const QuillSimpleToolbarConfig(
                          showDividers: false,
                          showFontFamily: false,
                          showFontSize: false,
                          showBoldButton: false,
                          showItalicButton: false,
                          showSmallButton: false,
                          showUnderLineButton: false,
                          showStrikeThrough: false,
                          showInlineCode: false,
                          showColorButton: false,
                          showBackgroundColorButton: false,
                          showClearFormat: false,
                          showAlignmentButtons: false,
                          showLeftAlignment: false,
                          showCenterAlignment: false,
                          showRightAlignment: false,
                          showJustifyAlignment: false,
                          showHeaderStyle: false,
                          showListNumbers: false,
                          showListBullets: false,
                          showListCheck: false,
                          showCodeBlock: false,
                          showQuote: false,
                          showIndent: false,
                          showLink: false,
                          showUndo: true,
                          showRedo: true,
                          showDirection: false,
                          showSearchButton: false,
                          showSubscript: false,
                          showSuperscript: false,
                          showLineHeightButton: false,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: QuillSimpleToolbar(
                            controller: _descriptionController,
                            config: const QuillSimpleToolbarConfig(
                              showDividers: false,
                              showFontFamily: false,
                              showFontSize: false,
                              showBoldButton: true,
                              showItalicButton: true,
                              showSmallButton: false,
                              showUnderLineButton: false,
                              showStrikeThrough: false,
                              showInlineCode: false,
                              showColorButton: false,
                              showBackgroundColorButton: false,
                              showClearFormat: false,
                              showAlignmentButtons: false,
                              showLeftAlignment: false,
                              showCenterAlignment: false,
                              showRightAlignment: false,
                              showJustifyAlignment: false,
                              showHeaderStyle: false,
                              showListNumbers: true,
                              showListBullets: true,
                              showListCheck: false,
                              showCodeBlock: false,
                              showQuote: false,
                              showIndent: false,
                              showLink: true,
                              showUndo: false,
                              showRedo: false,
                              showDirection: false,
                              showSearchButton: false,
                              showSubscript: false,
                              showSuperscript: false,
                              showLineHeightButton: false,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: colorScheme.outlineVariant),
              SizedBox(
                height: context.isDesktop ? 250 : 200,
                child: QuillEditor.basic(
                  controller: _descriptionController,
                  config: const QuillEditorConfig(
                    placeholder: 'Write a formatted description...',
                    padding: EdgeInsets.fromLTRB(8, 6, 8, 8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
