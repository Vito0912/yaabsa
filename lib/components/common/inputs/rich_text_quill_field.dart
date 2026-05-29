import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class RichTextQuillField extends StatefulWidget {
  const RichTextQuillField({
    super.key,
    required this.label,
    required this.controller,
    this.helperText,
    this.placeholder = 'Write formatted text...',
    this.editorHeight = 220,
    this.enabled = true,
    this.onChanged,
  });

  final String label;
  final QuillController controller;
  final String? helperText;
  final String placeholder;
  final double editorHeight;
  final bool enabled;
  final VoidCallback? onChanged;

  @override
  State<RichTextQuillField> createState() => _RichTextQuillFieldState();
}

class _RichTextQuillFieldState extends State<RichTextQuillField> {
  void _handleControllerChanged() {
    widget.onChanged?.call();
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant RichTextQuillField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleControllerChanged);
      widget.controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    super.dispose();
  }

  Widget _buildToolbarRow() {
    return Row(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: QuillSimpleToolbar(
            controller: widget.controller,
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
                controller: widget.controller,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),
        if (widget.helperText != null && widget.helperText!.trim().isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            widget.helperText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ],
        const SizedBox(height: 4),
        Opacity(
          opacity: widget.enabled ? 1 : 0.72,
          child: IgnorePointer(
            ignoring: !widget.enabled,
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.75)),
              ),
              child: Column(
                children: [
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), child: _buildToolbarRow()),
                  Divider(height: 1, color: colorScheme.outlineVariant),
                  SizedBox(
                    height: widget.editorHeight,
                    child: QuillEditor.basic(
                      controller: widget.controller,
                      config: QuillEditorConfig(
                        placeholder: widget.placeholder,
                        padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
