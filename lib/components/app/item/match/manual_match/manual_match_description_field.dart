import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:yaabsa/components/app/item/editor/library_item_description_codec.dart';
import 'package:yaabsa/components/app/item/editor/library_item_editor_field_container.dart';

class ManualMatchDescriptionField extends StatefulWidget {
  const ManualMatchDescriptionField({
    super.key,
    required this.label,
    required this.textController,
    required this.saving,
    required this.onChanged,
  });

  final String label;
  final TextEditingController? textController;
  final bool saving;
  final ValueChanged<String> onChanged;

  @override
  State<ManualMatchDescriptionField> createState() => _ManualMatchDescriptionFieldState();
}

class _ManualMatchDescriptionFieldState extends State<ManualMatchDescriptionField> {
  late QuillController _quillController;
  String _lastSerializedHtml = '';
  bool _syncingFromExternalText = false;
  bool _syncingFromQuill = false;

  @override
  void initState() {
    super.initState();
    _quillController = _buildQuillController(widget.textController?.text ?? '');
    _lastSerializedHtml = widget.textController?.text ?? '';
    widget.textController?.addListener(_handleExternalTextChanged);
    _quillController.addListener(_handleQuillChanged);
  }

  @override
  void didUpdateWidget(covariant ManualMatchDescriptionField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.textController != widget.textController) {
      oldWidget.textController?.removeListener(_handleExternalTextChanged);
      widget.textController?.addListener(_handleExternalTextChanged);
      _replaceEditorDocument(widget.textController?.text ?? '');
      return;
    }

    final externalText = widget.textController?.text ?? '';
    if (!_syncingFromQuill && externalText != _lastSerializedHtml) {
      _replaceEditorDocument(externalText);
    }
  }

  @override
  void dispose() {
    widget.textController?.removeListener(_handleExternalTextChanged);
    _quillController.removeListener(_handleQuillChanged);
    _quillController.dispose();
    super.dispose();
  }

  QuillController _buildQuillController(String htmlText) {
    return QuillController(
      document: quillDocumentFromHtml(htmlText),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  void _replaceEditorDocument(String htmlText) {
    _syncingFromExternalText = true;
    _lastSerializedHtml = htmlText;

    _quillController.removeListener(_handleQuillChanged);
    _quillController.dispose();

    _quillController = _buildQuillController(htmlText);
    _quillController.addListener(_handleQuillChanged);

    if (mounted) {
      setState(() {});
    }

    _syncingFromExternalText = false;
  }

  void _handleExternalTextChanged() {
    if (_syncingFromQuill) {
      return;
    }

    final externalText = widget.textController?.text ?? '';
    if (externalText == _lastSerializedHtml) {
      return;
    }

    _replaceEditorDocument(externalText);
  }

  void _handleQuillChanged() {
    if (_syncingFromExternalText) {
      return;
    }

    final htmlText = quillDocumentToHtml(_quillController.document);
    if (htmlText == _lastSerializedHtml) {
      return;
    }

    _lastSerializedHtml = htmlText;
    _syncingFromQuill = true;

    if (widget.textController != null && widget.textController!.text != htmlText) {
      widget.textController!.text = htmlText;
    }

    widget.onChanged(htmlText);
    _syncingFromQuill = false;
  }

  @override
  Widget build(BuildContext context) {
    final outlineColor = Theme.of(context).colorScheme.outlineVariant;

    return IgnorePointer(
      ignoring: widget.saving,
      child: Opacity(
        opacity: widget.saving ? 0.75 : 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.label, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 4),
            LibraryItemEditorFieldContainer(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: QuillSimpleToolbar(
                      controller: _quillController,
                      config: const QuillSimpleToolbarConfig(
                        showDividers: false,
                        showFontFamily: false,
                        showFontSize: false,
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
                        showListCheck: false,
                        showCodeBlock: false,
                        showQuote: false,
                        showIndent: false,
                        showSearchButton: false,
                        showSubscript: false,
                        showSuperscript: false,
                        showLineHeightButton: false,
                      ),
                    ),
                  ),
                  Divider(height: 1, color: outlineColor),
                  SizedBox(
                    height: 170,
                    child: QuillEditor.basic(
                      controller: _quillController,
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
        ),
      ),
    );
  }
}
