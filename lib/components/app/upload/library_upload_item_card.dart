import 'package:flutter/material.dart';
import 'package:yaabsa/components/app/upload/library_upload_models.dart';
import 'package:yaabsa/components/common/styled_form_fields.dart';
import 'package:yaabsa/util/byte_format.dart';

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
    return switch (widget.item.status) {
      UploadItemStatus.failed || UploadItemStatus.canceled => scheme.error,
      UploadItemStatus.warning => scheme.tertiary,
      _ => scheme.onSurfaceVariant,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.fromBorderSide(BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.4))),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 660;
              if (isCompact) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: YaabsaTextField(
                            label: 'Title',
                            controller: _titleController,
                            enabled: widget.enabled,
                            onChanged: (value) =>
                                widget.onChanged(widget.item.copyWith(title: value, clearMessage: true)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          tooltip: 'Remove upload item',
                          onPressed: widget.enabled ? widget.onRemove : null,
                          icon: const Icon(Icons.delete_outline_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(alignment: Alignment.centerLeft, child: _buildFetchMetadataButton(context)),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: YaabsaTextField(
                      label: 'Title',
                      controller: _titleController,
                      enabled: widget.enabled,
                      onChanged: (value) => widget.onChanged(widget.item.copyWith(title: value, clearMessage: true)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildFetchMetadataButton(context),
                  const SizedBox(width: 4),
                  IconButton(
                    tooltip: 'Remove upload item',
                    onPressed: widget.enabled ? widget.onRemove : null,
                    icon: const Icon(Icons.delete_outline_rounded),
                  ),
                ],
              );
            },
          ),
          if (widget.item.pendingMetadata != null) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Suggested: ${widget.item.pendingMetadata!.title} | ${widget.item.pendingMetadata!.author} | ${widget.item.pendingMetadata!.series}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Accept metadata suggestion',
                    onPressed: widget.enabled ? widget.onAcceptPendingMetadata : null,
                    icon: const Icon(Icons.check_rounded),
                  ),
                  IconButton(
                    tooltip: 'Reject metadata suggestion',
                    onPressed: widget.enabled ? widget.onRejectPendingMetadata : null,
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildAutocompleteField(
                  label: 'Author',
                  controller: _authorController,
                  focusNode: _authorFocusNode,
                  suggestions: widget.authorSuggestions,
                  onChanged: (value) => widget.onChanged(widget.item.copyWith(author: value, clearMessage: true)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAutocompleteField(
                  label: 'Series',
                  controller: _seriesController,
                  focusNode: _seriesFocusNode,
                  suggestions: widget.seriesSuggestions,
                  onChanged: (value) => widget.onChanged(widget.item.copyWith(series: value, clearMessage: true)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _isFileListExpanded = !_isFileListExpanded;
                  });
                },
                icon: Icon(_isFileListExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded),
                label: Text('Files (${widget.item.uploadFiles.length})'),
              ),
            ],
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
            LinearProgressIndicator(value: widget.item.progress.clamp(0, 1)),
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

  Widget _buildFetchMetadataButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: widget.canFetchMetadata ? widget.onFetchMetadata : null,
        icon: const Icon(Icons.cloud_download_outlined, size: 18),
        label: const Text('Fetch metadata'),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.34)),
          backgroundColor: colorScheme.surfaceContainer,
        ),
      ),
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
        return TextField(
          controller: textController,
          focusNode: textFocusNode,
          enabled: widget.enabled,
          onChanged: onChanged,
          decoration: yaabsaFieldDecoration(context, label: label),
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
