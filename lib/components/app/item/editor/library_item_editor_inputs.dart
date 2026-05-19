import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_named_entity.dart';
import 'package:yaabsa/components/app/item/editor/library_item_editor_autocomplete_sheet.dart';
import 'package:yaabsa/components/app/item/editor/library_item_editor_field_container.dart';
import 'package:yaabsa/components/app/item/editor/library_item_edit_models.dart';
import 'package:yaabsa/components/common/styled_form_fields.dart';

import 'package:yaabsa/generated/l10n.dart';

class LibraryItemEditorSectionCard extends StatelessWidget {
  const LibraryItemEditorSectionCard({super.key, required this.title, required this.child, this.subtitle});

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(color: colorScheme.surfaceContainer, borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

class LibraryItemEditorTextField extends StatelessWidget {
  const LibraryItemEditorTextField({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.maxLines = 1,
    this.keyboardType,
    this.onChanged,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final int maxLines;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return YaabsaTextField(
      label: label,
      controller: controller,
      hintText: hintText,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }
}

class LibraryItemEditorStringChips extends StatefulWidget {
  const LibraryItemEditorStringChips({
    super.key,
    required this.label,
    required this.values,
    required this.onChanged,
    this.suggestions = const <String>[],
    this.hintText,
  });

  final String label;
  final List<String> values;
  final List<String> suggestions;
  final ValueChanged<List<String>> onChanged;
  final String? hintText;

  @override
  State<LibraryItemEditorStringChips> createState() => _LibraryItemEditorStringChipsState();
}

class _LibraryItemEditorStringChipsState extends State<LibraryItemEditorStringChips> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addValue(String rawValue) {
    final trimmed = rawValue.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final existingLower = widget.values.map((entry) => entry.toLowerCase()).toSet();
    if (existingLower.contains(trimmed.toLowerCase())) {
      _controller.clear();
      return;
    }

    widget.onChanged(<String>[...widget.values, trimmed]);
    _controller.clear();
    setState(() {
      _query = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final showSuggestions = _query.trim().isNotEmpty;
    final filteredSuggestions = widget.suggestions
        .where((candidate) => candidate.trim().isNotEmpty)
        .where((candidate) => !widget.values.any((selected) => selected.toLowerCase() == candidate.toLowerCase()))
        .where((candidate) => candidate.toLowerCase().contains(_query.toLowerCase()))
        .take(8)
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 4),
        if (showSuggestions && filteredSuggestions.isNotEmpty)
          LibraryItemEditorAutocompleteSheet(
            suggestions: [
              for (final suggestion in filteredSuggestions)
                ActionChip(
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: BorderSide.none,
                  avatar: const Icon(Icons.add_rounded, size: 14),
                  label: Text(suggestion, style: Theme.of(context).textTheme.bodySmall),
                  onPressed: () => _addValue(suggestion),
                ),
            ],
          ),
        LibraryItemEditorFieldContainer(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final value in widget.values)
                InputChip(
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: BorderSide.none,
                  label: Text(value, style: Theme.of(context).textTheme.bodySmall),
                  onDeleted: () {
                    widget.onChanged(widget.values.where((entry) => entry != value).toList(growable: false));
                  },
                ),
              SizedBox(
                width: 150,
                child: TextField(
                  controller: _controller,
                  style: Theme.of(context).textTheme.bodySmall,
                  decoration: InputDecoration.collapsed(hintText: widget.hintText ?? 'Add value'),
                  onChanged: (value) {
                    setState(() {
                      _query = value;
                    });
                  },
                  onSubmitted: _addValue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LibraryItemEditorNamedEntityChips extends StatefulWidget {
  const LibraryItemEditorNamedEntityChips({
    super.key,
    required this.label,
    required this.values,
    required this.onChanged,
    this.suggestions = const <LibraryFilterNamedEntity>[],
    this.hintText,
  });

  final String label;
  final List<LibraryItemEditorNamedEntity> values;
  final List<LibraryFilterNamedEntity> suggestions;
  final ValueChanged<List<LibraryItemEditorNamedEntity>> onChanged;
  final String? hintText;

  @override
  State<LibraryItemEditorNamedEntityChips> createState() => _LibraryItemEditorNamedEntityChipsState();
}

class _LibraryItemEditorNamedEntityChipsState extends State<LibraryItemEditorNamedEntityChips> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addByLabel(String rawName) {
    final name = rawName.trim();
    if (name.isEmpty) {
      return;
    }

    final existingLower = widget.values.map((entry) => entry.name.toLowerCase()).toSet();
    if (existingLower.contains(name.toLowerCase())) {
      _controller.clear();
      return;
    }

    final matchedSuggestion = widget.suggestions.firstWhere(
      (entry) => entry.name.toLowerCase() == name.toLowerCase(),
      orElse: () => LibraryFilterNamedEntity(id: name, name: name),
    );

    widget.onChanged(<LibraryItemEditorNamedEntity>[
      ...widget.values,
      LibraryItemEditorNamedEntity(id: matchedSuggestion.id, name: matchedSuggestion.name),
    ]);
    _controller.clear();
    setState(() {
      _query = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final showSuggestions = _query.trim().isNotEmpty;
    final filteredSuggestions = widget.suggestions
        .where(
          (candidate) => !widget.values.any((selected) => selected.name.toLowerCase() == candidate.name.toLowerCase()),
        )
        .where((candidate) => candidate.name.toLowerCase().contains(_query.toLowerCase()))
        .take(8)
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 4),
        if (showSuggestions && filteredSuggestions.isNotEmpty)
          LibraryItemEditorAutocompleteSheet(
            suggestions: [
              for (final suggestion in filteredSuggestions)
                ActionChip(
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: BorderSide.none,
                  avatar: const Icon(Icons.person_add_alt_rounded, size: 14),
                  label: Text(suggestion.name, style: Theme.of(context).textTheme.bodySmall),
                  onPressed: () => _addByLabel(suggestion.name),
                ),
            ],
          ),
        LibraryItemEditorFieldContainer(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final entry in widget.values)
                InputChip(
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: BorderSide.none,
                  label: Text(entry.name, style: Theme.of(context).textTheme.bodySmall),
                  onDeleted: () {
                    widget.onChanged(widget.values.where((item) => item != entry).toList(growable: false));
                  },
                ),
              SizedBox(
                width: 150,
                child: TextField(
                  controller: _controller,
                  style: Theme.of(context).textTheme.bodySmall,
                  decoration: InputDecoration.collapsed(hintText: widget.hintText ?? 'Add value'),
                  onChanged: (value) {
                    setState(() {
                      _query = value;
                    });
                  },
                  onSubmitted: _addByLabel,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LibraryItemEditorSeriesList extends StatefulWidget {
  const LibraryItemEditorSeriesList({
    super.key,
    required this.values,
    required this.onChanged,
    this.suggestions = const <LibraryFilterNamedEntity>[],
  });

  final List<LibraryItemEditorSeriesEntry> values;
  final ValueChanged<List<LibraryItemEditorSeriesEntry>> onChanged;
  final List<LibraryFilterNamedEntity> suggestions;

  @override
  State<LibraryItemEditorSeriesList> createState() => _LibraryItemEditorSeriesListState();
}

class _LibraryItemEditorSeriesListState extends State<LibraryItemEditorSeriesList> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  String _sanitizeSequence(String value) => value.replaceAll(RegExp(r'\s+'), '');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String?> _promptSequence({String initialValue = ''}) async {
    if (!mounted) {
      return null;
    }

    final controller = TextEditingController(text: initialValue);
    try {
      final value = await showDialog<String>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(S.current.componentsAppItemEditorLibraryItemEditorInputsSeriesNumber),
            content: TextField(
              controller: controller,
              autofocus: true,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\x21-\x7E]'))],
              decoration: InputDecoration(
                labelText: S.current.componentsAppItemEditorLibraryItemEditorInputsSequence,
                hintText: S.current.componentsAppItemEditorLibraryItemEditorInputsEG12503,
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                Navigator.of(dialogContext).pop(_sanitizeSequence(value));
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(_sanitizeSequence(initialValue));
                },
                child: Text(S.current.componentsAppItemEditorLibraryItemEditorInputsSkip),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(_sanitizeSequence(controller.text));
                },
                child: Text(S.current.componentsAppItemEditorLibraryItemEditorInputsSave),
              ),
            ],
          );
        },
      );

      return value;
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.current.componentsAppItemEditorLibraryItemEditorInputsCouldNotOpenTheSeriesSequence),
          ),
        );
      }
      return null;
    } finally {
      controller.dispose();
    }
  }

  Future<void> _queueAddSeries(String value, {String? preferredId}) async {
    await Future<void>.delayed(Duration.zero);
    if (!mounted) {
      return;
    }
    await _addSeriesByName(value, preferredId: preferredId);
  }

  Future<void> _addSeriesByName(String rawName, {String? preferredId}) async {
    final name = rawName.trim();
    if (name.isEmpty) {
      return;
    }

    final existingLower = widget.values.map((entry) => entry.name.toLowerCase()).toSet();
    if (existingLower.contains(name.toLowerCase())) {
      _controller.clear();
      return;
    }

    final sequence = await _promptSequence();
    if (!mounted || sequence == null) {
      return;
    }

    final next = <LibraryItemEditorSeriesEntry>[
      ...widget.values,
      LibraryItemEditorSeriesEntry(
        id: preferredId?.trim().isNotEmpty ?? false ? preferredId!.trim() : name,
        name: name,
        sequence: sequence,
      ),
    ];
    widget.onChanged(next);
    _controller.clear();
    setState(() {
      _query = '';
    });
  }

  Future<void> _editSequenceAt(int index) async {
    final current = widget.values[index];
    final updated = await _promptSequence(initialValue: current.sequence);
    if (!mounted || updated == null) {
      return;
    }

    final next = List<LibraryItemEditorSeriesEntry>.from(widget.values);
    next[index] = current.copyWith(sequence: updated);
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final showSuggestions = _query.trim().isNotEmpty;
    final filteredSuggestions = widget.suggestions
        .where((candidate) => !widget.values.any((entry) => entry.name.toLowerCase() == candidate.name.toLowerCase()))
        .where((candidate) => candidate.name.toLowerCase().contains(_query.toLowerCase()))
        .take(8)
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.componentsAppItemEditorLibraryItemEditorInputsSeries,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 4),
        if (showSuggestions && filteredSuggestions.isNotEmpty)
          LibraryItemEditorAutocompleteSheet(
            suggestions: [
              for (final suggestion in filteredSuggestions)
                ActionChip(
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: BorderSide.none,
                  avatar: const Icon(Icons.add_rounded, size: 14),
                  label: Text(suggestion.name, style: Theme.of(context).textTheme.bodySmall),
                  onPressed: () {
                    _queueAddSeries(suggestion.name, preferredId: suggestion.id);
                  },
                ),
            ],
          ),
        LibraryItemEditorFieldContainer(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (var index = 0; index < widget.values.length; index++)
                InputChip(
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: BorderSide.none,
                  label: Text(
                    widget.values[index].sequence.trim().isEmpty
                        ? widget.values[index].name
                        : '${widget.values[index].name} #${widget.values[index].sequence.trim()}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  onPressed: () {
                    _editSequenceAt(index);
                  },
                  onDeleted: () {
                    final next = List<LibraryItemEditorSeriesEntry>.from(widget.values)..removeAt(index);
                    widget.onChanged(next);
                  },
                ),
              SizedBox(
                width: 150,
                child: TextField(
                  controller: _controller,
                  style: Theme.of(context).textTheme.bodySmall,
                  decoration: InputDecoration.collapsed(
                    hintText: S.current.componentsAppItemEditorLibraryItemEditorInputsAddSeries,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _query = value;
                    });
                  },
                  onSubmitted: (value) {
                    _queueAddSeries(value);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
