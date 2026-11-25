import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/upload/library_upload_models.dart';
import 'package:yaabsa/ui/components/cards/surface_card.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/util/byte_format.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

class LibraryUploadItemCard extends StatefulWidget {
  const LibraryUploadItemCard({
    super.key,
    required this.item,
    required this.enabled,
    required this.onChanged,
    required this.onRemove,
    required this.onFetchMetadata,
    required this.canFetchMetadata,
    required this.onAcceptPendingMetadata,
    required this.onRejectPendingMetadata,
    required this.authorSuggestions,
    required this.seriesSuggestions,
  });

  final UploadItemDraft item;
  final bool enabled;
  final bool canFetchMetadata;
  final ValueChanged<UploadItemDraft> onChanged;
  final VoidCallback onRemove;
  final VoidCallback onFetchMetadata;
  final VoidCallback onAcceptPendingMetadata;
  final VoidCallback onRejectPendingMetadata;
  final List<String> authorSuggestions;
  final List<String> seriesSuggestions;

  @override
  State<LibraryUploadItemCard> createState() => _LibraryUploadItemCardState();
}

class _LibraryUploadItemCardState extends State<LibraryUploadItemCard> {
  static const _minimumInlineContentWidth = 440.0;

  late final TextEditingController _titleController;
  late final TextEditingController _authorController;
  late final TextEditingController _seriesController;
  late final FocusNode _authorFocusNode;
  late final FocusNode _seriesFocusNode;

  bool _isFileListExpanded = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item.title);
    _authorController = TextEditingController(text: widget.item.author);
    _seriesController = TextEditingController(text: widget.item.series);
    _authorFocusNode = FocusNode();
    _seriesFocusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant LibraryUploadItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.title != widget.item.title && _titleController.text != widget.item.title) {
      _titleController.text = widget.item.title;
    }
    if (oldWidget.item.author != widget.item.author && _authorController.text != widget.item.author) {
      _authorController.text = widget.item.author;
    }
    if (oldWidget.item.series != widget.item.series && _seriesController.text != widget.item.series) {
      _seriesController.text = widget.item.series;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _seriesController.dispose();
    _authorFocusNode.dispose();
    _seriesFocusNode.dispose();
    super.dispose();
  }

  Color _messageColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final message = widget.item.message?.toLowerCase() ?? '';
    final isMetadataLookupError =
        message.contains('metadata lookup failed') || message.contains('no metadata result found');

    return switch (widget.item.status) {
      UploadItemStatus.failed => scheme.error,
      _ when isMetadataLookupError => scheme.error,
      UploadItemStatus.warning => scheme.tertiary,
      _ => scheme.onSurfaceVariant,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final minimumInlineContentWidth = _minimumInlineContentWidth * textScale;
    final titleField = StyledTextField(
      label: context.l10n.fieldTitle,
      controller: _titleController,
      enabled: widget.enabled,
      onChanged: (value) => widget.onChanged(widget.item.copyWith(title: value, clearMessage: true)),
    );
    final removeButton = YaabsaDeleteIconButton(
      tooltip: context.l10n.actionRemove,
      onPressed: widget.enabled ? widget.onRemove : null,
    );

    return YaabsaSurfaceCard(
      borderColor: colorScheme.outlineVariant.withValues(alpha: 0.55),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = !constraints.maxWidth.isFinite || constraints.maxWidth < minimumInlineContentWidth;
              if (isCompact) {
                return Column(
                  key: const ValueKey<String>('uploadItemHeaderStacked'),
                  children: [
                    Row(
                      children: [
                        Expanded(child: titleField),
                        const SizedBox(width: 8),
                        removeButton,
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(alignment: Alignment.centerLeft, child: _buildFetchMetadataButton()),
                  ],
                );
              }

              return Row(
                key: const ValueKey<String>('uploadItemHeaderInline'),
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: titleField),
                  const SizedBox(width: 8),
                  _buildFetchMetadataButton(),
                  const SizedBox(width: 4),
                  removeButton,
                ],
              );
            },
          ),
          if (widget.item.pendingMetadata != null) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.l10n.uploadSuggestedMetadata, style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(height: 2),
                        Text(
                          widget.item.pendingMetadata!.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          [
                            widget.item.pendingMetadata!.author,
                            widget.item.pendingMetadata!.series,
                          ].where((value) => value.trim().isNotEmpty).join(' • '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  YaabsaActionIconButton(
                    icon: Icons.check_rounded,
                    tooltip: context.l10n.actionAccept,
                    onPressed: widget.enabled ? widget.onAcceptPendingMetadata : null,
                    tone: YaabsaActionTone.primary,
                  ),
                  YaabsaActionIconButton(
                    icon: Icons.close_rounded,
                    tooltip: context.l10n.actionReject,
                    onPressed: widget.enabled ? widget.onRejectPendingMetadata : null,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final authorField = _buildAutocompleteField(
                label: context.l10n.fieldAuthor,
                controller: _authorController,
                focusNode: _authorFocusNode,
                suggestions: widget.authorSuggestions,
                onChanged: (value) => widget.onChanged(widget.item.copyWith(author: value, clearMessage: true)),
              );
              final seriesField = _buildAutocompleteField(
                label: context.l10n.fieldSeries,
                controller: _seriesController,
                focusNode: _seriesFocusNode,
                suggestions: widget.seriesSuggestions,
                onChanged: (value) => widget.onChanged(widget.item.copyWith(series: value, clearMessage: true)),
              );

              if (!constraints.maxWidth.isFinite || constraints.maxWidth < minimumInlineContentWidth) {
                return Column(
                  key: const ValueKey<String>('uploadItemMetadataFieldsStacked'),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [authorField, const SizedBox(height: 8), seriesField],
                );
              }

              return Row(
                key: const ValueKey<String>('uploadItemMetadataFieldsInline'),
                children: [
                  Expanded(child: authorField),
                  const SizedBox(width: 8),
                  Expanded(child: seriesField),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _isFileListExpanded = !_isFileListExpanded;
              });
            },
            icon: Icon(_isFileListExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded),
            label: Text(context.l10n.fileCount(widget.item.uploadFiles.length)),
          ),
          if (_isFileListExpanded)
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 130),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.item.uploadFiles.length,
                itemBuilder: (context, index) {
                  final file = widget.item.uploadFiles[index];
                  return Text(file.relativePath, style: Theme.of(context).textTheme.bodySmall);
                },
              ),
            ),
          if (widget.item.status == UploadItemStatus.uploading) ...[
            const SizedBox(height: 8),
            YaabsaLinearProgressIndicator(value: widget.item.progress.clamp(0, 1)),
            const SizedBox(height: 4),
            Text(
              '${formatByteProgress(transferredBytes: widget.item.uploadedBytes, totalBytes: widget.item.totalBytes)} | ${formatByteRate(widget.item.uploadSpeedBytesPerSecond)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
          if (widget.item.message != null && widget.item.message!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              widget.item.message!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: _messageColor(context)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFetchMetadataButton() {
    return OutlinedButton.icon(
      onPressed: widget.canFetchMetadata ? widget.onFetchMetadata : null,
      icon: const Icon(Icons.cloud_download_outlined),
      label: Text(context.l10n.uploadFetchMetadata),
    );
  }

  Widget _buildAutocompleteField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required List<String> suggestions,
    required ValueChanged<String> onChanged,
  }) {
    return RawAutocomplete<String>(
      textEditingController: controller,
      focusNode: focusNode,
      optionsBuilder: (textEditingValue) {
        if (!widget.enabled || suggestions.isEmpty) {
          return const Iterable<String>.empty();
        }

        final query = textEditingValue.text.trim().toLowerCase();
        if (query.isEmpty) {
          return suggestions.take(10);
        }

        return suggestions.where((option) => option.toLowerCase().contains(query)).take(10);
      },
      onSelected: onChanged,
      fieldViewBuilder: (context, textController, textFocusNode, onFieldSubmitted) {
        return StyledTextField(
          controller: textController,
          focusNode: textFocusNode,
          enabled: widget.enabled,
          onChanged: onChanged,
          label: label,
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 180, minWidth: 220),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 4),
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return InkWell(
                    onTap: () => onSelected(option),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Text(option, style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
