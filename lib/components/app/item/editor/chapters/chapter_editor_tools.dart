import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/json/value_parsers.dart';
import 'package:yaabsa/components/app/item/editor/chapters/chapter_editor_draft.dart';
import 'package:yaabsa/components/common/list_management_dialogs.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

typedef ChapterAddOptions = ({String title, int count, double start, double interval});
typedef ChapterLookupChoice = ({List<ChapterEditorValue> chapters, bool titlesOnly});

Future<String?> showChapterUnsavedDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        title: Text(context.l10n.confirmSaveChapterChanges),
        content: Text(context.l10n.warningChapterEditsNotSaved),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop('cancel'), child: Text(context.l10n.actionKeepEditing)),
          TextButton(
            onPressed: () => Navigator.of(context).pop('discard'),
            child: Text(context.l10n.actionDiscardEdits),
          ),
          FilledButton(onPressed: () => Navigator.of(context).pop('save'), child: Text(context.l10n.actionSave)),
        ],
      );
    },
  );
}

Future<ChapterAddOptions?> showChapterAddDialog(BuildContext context, {required double initialStart}) {
  return showDialog<ChapterAddOptions>(
    context: context,
    builder: (context) => _ChapterAddDialog(initialStart: initialStart),
  );
}

Future<double?> showChapterShiftDialog(BuildContext context, {required int selectedCount}) {
  return showDialog<double>(
    context: context,
    builder: (context) => _ChapterShiftDialog(selectedCount: selectedCount),
  );
}

Future<ChapterLookupChoice?> showChapterLookupDialog(
  BuildContext context, {
  required String asin,
  required int chapterCount,
  required double duration,
}) {
  return showDialog<ChapterLookupChoice>(
    context: context,
    builder: (context) => _ChapterLookupDialog(asin: asin, chapterCount: chapterCount, duration: duration),
  );
}

class _ChapterAddDialog extends StatefulWidget {
  const _ChapterAddDialog({required this.initialStart});

  final double initialStart;

  @override
  State<_ChapterAddDialog> createState() => _ChapterAddDialogState();
}

class _ChapterAddDialogState extends State<_ChapterAddDialog> {
  final _form = GlobalKey<FormState>();
  late final _title = TextEditingController(text: currentAppLocalizations().chapterTitlePatternExample);
  final _count = TextEditingController(text: '1');
  final _interval = TextEditingController(text: '60');
  late final _start = TextEditingController(text: formatChapterTime(widget.initialStart));

  @override
  void dispose() {
    _title.dispose();
    _count.dispose();
    _interval.dispose();
    _start.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_form.currentState?.validate() ?? false)) {
      return;
    }

    Navigator.of(context).pop<ChapterAddOptions>((
      title: _title.text.trim(),
      count: int.parse(_count.text),
      start: parseChapterTime(_start.text)!,
      interval: double.parse(_interval.text),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      title: Text(context.l10n.actionAddChapters),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StyledTextFormField(
                  controller: _title,
                  autofocus: true,
                  label: context.l10n.fieldTitle,
                  helperText: context.l10n.hintChapterTitlePattern,
                  validator: (value) => value == null || value.trim().isEmpty ? context.l10n.errorEnterTitle : null,
                ),
                const SizedBox(height: 12),
                StyledTextFormField(
                  controller: _count,
                  keyboardType: TextInputType.number,
                  label: context.l10n.fieldChapterCount,
                  validator: (value) {
                    final count = int.tryParse(value ?? '');
                    return count == null || count < 1 || count > 5000 ? context.l10n.errorChapterCountRange : null;
                  },
                ),
                const SizedBox(height: 12),
                StyledTextFormField(
                  controller: _start,
                  label: context.l10n.fieldStartTime,
                  helperText: context.l10n.hintChapterTimeFormat,
                  validator: (value) =>
                      parseChapterTime(value ?? '') == null ? context.l10n.errorValidChapterStart : null,
                ),
                const SizedBox(height: 12),
                StyledTextFormField(
                  controller: _interval,
                  label: context.l10n.fieldChapterIntervalSeconds,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onFieldSubmitted: (_) => _submit(),
                  validator: (value) {
                    final interval = double.tryParse(value ?? '');
                    return interval == null || !interval.isFinite || interval <= 0
                        ? context.l10n.errorPositiveInterval
                        : null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(context.l10n.actionCancel)),
        FilledButton(onPressed: _submit, child: Text(context.l10n.actionAdd)),
      ],
    );
  }
}

class _ChapterShiftDialog extends StatefulWidget {
  const _ChapterShiftDialog({required this.selectedCount});

  final int selectedCount;

  @override
  State<_ChapterShiftDialog> createState() => _ChapterShiftDialogState();
}

class _ChapterShiftDialogState extends State<_ChapterShiftDialog> {
  final _amount = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  void _submit() {
    final value = double.tryParse(_amount.text);
    if (value == null || !value.isFinite || value == 0) {
      setState(() {
        _error = context.l10n.errorChapterTimeShiftRequired;
      });
      return;
    }

    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      title: Text(context.l10n.headingShiftChapterTimes),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.selectedCount > 0
                  ? context.l10n.promptShiftSelectedChapters(widget.selectedCount)
                  : context.l10n.promptShiftAllChapters,
            ),
            const SizedBox(height: 12),
            StyledTextField(
              controller: _amount,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
              label: context.l10n.fieldSeconds,
              hintText: context.l10n.hintChapterTimeShift,
              errorText: _error,
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(context.l10n.actionCancel)),
        FilledButton(onPressed: _submit, child: Text(context.l10n.actionApply)),
      ],
    );
  }
}

class _ChapterLookupDialog extends ConsumerStatefulWidget {
  const _ChapterLookupDialog({required this.asin, required this.chapterCount, required this.duration});

  final String asin;
  final int chapterCount;
  final double duration;

  @override
  ConsumerState<_ChapterLookupDialog> createState() => _ChapterLookupDialogState();
}

class _ChapterLookupDialogState extends ConsumerState<_ChapterLookupDialog> {
  late final _asin = TextEditingController(text: widget.asin.trim());
  final _cancelToken = CancelToken();
  var _region = 'US';
  var _loading = false;
  var _titlesOnly = false;
  List<ChapterEditorValue>? _chapters;
  double? _runtime;
  String? _error;

  @override
  void dispose() {
    _cancelToken.cancel();
    _asin.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final api = ref.read(absApiProvider);
    if (api == null || _asin.text.trim().isEmpty || _loading) {
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _chapters = null;
    });

    try {
      final data = await api.getLibraryItemApi().searchChapters(
        asin: _asin.text.trim(),
        region: _region,
        cancelToken: _cancelToken,
      );
      if (!mounted) {
        return;
      }

      final entries = data['chapters'];
      final chapters = <ChapterEditorValue>[];
      if (entries is List) {
        for (final entry in entries.whereType<Map>()) {
          final startMs = jsonDoubleFromDynamic(entry['startOffsetMs']);
          final title = jsonStringFromDynamic(entry['title']);
          if (startMs == null || !startMs.isFinite || startMs < 0 || title == null) {
            setState(() {
              _error = context.l10n.errorInvalidChapterLookupData;
            });
            return;
          }
          chapters.add((start: startMs / 1000, title: title));
        }
      }
      if (chapters.isEmpty) {
        setState(() {
          _error = context.l10n.statusNoChaptersFoundForSearch;
        });
        return;
      }

      setState(() {
        _chapters = chapters;
        _runtime = jsonDoubleFromDynamic(data['runtimeLengthSec']);
        _titlesOnly = false;
      });
    } catch (error) {
      if (!mounted || _cancelToken.isCancelled) {
        return;
      }
      setState(() {
        final l10n = context.l10n;
        final fallback = l10n.errorOperationFailed(l10n.operationLookupChapters, error.toString());
        _error = listManagementErrorMessage(error, fallback: fallback);
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final chapters = _chapters;
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      title: Text(context.l10n.actionFindChapters),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: StyledTextField(
                      controller: _asin,
                      enabled: !_loading,
                      autofocus: true,
                      label: context.l10n.fieldAsin,
                      onSubmitted: (_) => _search(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 100,
                    child: YaabsaDropdownField<String>(
                      value: _region,
                      enabled: !_loading,
                      label: context.l10n.fieldRegion,
                      items: [
                        for (final region in const ['US', 'CA', 'UK', 'AU', 'FR', 'DE', 'JP', 'IT', 'IN', 'ES'])
                          DropdownMenuItem(value: region, child: Text(region)),
                      ],
                      onChanged: _loading
                          ? null
                          : (value) {
                              setState(() {
                                _region = value ?? 'US';
                              });
                            },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _loading ? null : _search,
                icon: const Icon(Icons.search_rounded),
                label: Text(_loading ? context.l10n.statusSearching : context.l10n.actionSearch),
              ),
              if (_loading) const YaabsaLinearProgressIndicator(),
              if (_error != null) Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              if (chapters != null) ...[
                const SizedBox(height: 12),
                Text(context.l10n.chapterLookupSummary(chapters.length, widget.chapterCount)),
                if (_runtime != null)
                  Text(
                    context.l10n.chapterDurationComparison(
                      formatChapterTime(_runtime!),
                      formatChapterTime(widget.duration),
                    ),
                  ),
                const SizedBox(height: 8),
                SizedBox(
                  height: math.min(240, chapters.length * 48).toDouble(),
                  child: ListView.builder(
                    itemCount: chapters.length,
                    itemExtent: 48,
                    itemBuilder: (context, index) {
                      final chapter = chapters[index];
                      return Row(
                        children: [
                          SizedBox(width: 110, child: Text(formatChapterTime(chapter.start))),
                          Expanded(child: Text(chapter.title, maxLines: 1, overflow: TextOverflow.ellipsis)),
                        ],
                      );
                    },
                  ),
                ),
                if (chapters.length == widget.chapterCount && widget.chapterCount > 0)
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(context.l10n.optionApplyChapterTitlesOnly),
                    subtitle: Text(context.l10n.descriptionKeepChapterTimes),
                    value: _titlesOnly,
                    onChanged: (value) {
                      setState(() {
                        _titlesOnly = value ?? false;
                      });
                    },
                  ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(context.l10n.actionCancel)),
        FilledButton(
          onPressed: chapters == null || _loading
              ? null
              : () => Navigator.of(context).pop<ChapterLookupChoice>((chapters: chapters, titlesOnly: _titlesOnly)),
          child: Text(context.l10n.actionApplyToDraft),
        ),
      ],
    );
  }
}
