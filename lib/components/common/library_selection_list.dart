import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/ui/components/cards/surface_card.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/components/lists/multi_select_list_card.dart';
import 'package:yaabsa/util/admin_item_metadata_tools.dart';
import 'package:yaabsa/util/l10n.dart';

class LibrarySelectionList extends ConsumerStatefulWidget {
  const LibrarySelectionList.multiSelect({
    super.key,
    this.libraries,
    required Set<String> this.selectedLibraryIds,
    required ValueChanged<Set<String>> this.onSelectionChanged,
    this.title,
    this.allowEmptyAllHint = false,
    this.mediaTypeFilter,
    this.enabled = true,
    this.maxHeight = 240,
    this.emptyMessage,
  }) : multiSelect = true,
       selectedLibraryId = null,
       onSelected = null;

  const LibrarySelectionList.singleSelect({
    super.key,
    this.libraries,
    required this.selectedLibraryId,
    required ValueChanged<String> this.onSelected,
    this.title,
    this.mediaTypeFilter,
    this.enabled = true,
    this.maxHeight = 240,
    this.emptyMessage,
  }) : multiSelect = false,
       selectedLibraryIds = null,
       onSelectionChanged = null,
       allowEmptyAllHint = false;

  final bool multiSelect;
  final List<Library>? libraries;
  final Set<String>? selectedLibraryIds;
  final ValueChanged<Set<String>>? onSelectionChanged;
  final String? selectedLibraryId;
  final ValueChanged<String>? onSelected;
  final String? title;
  final bool allowEmptyAllHint;
  final String? mediaTypeFilter;
  final bool enabled;
  final double maxHeight;
  final String? emptyMessage;

  @override
  ConsumerState<LibrarySelectionList> createState() => _LibrarySelectionListState();
}

class _LibrarySelectionListState extends ConsumerState<LibrarySelectionList> {
  bool _isLoading = false;
  String? _errorMessage;
  List<Library> _loadedLibraries = const <Library>[];

  @override
  void initState() {
    super.initState();
    _isLoading = widget.libraries == null;
    if (widget.libraries == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || widget.libraries != null) {
          return;
        }
        unawaited(_loadLibraries());
      });
    }
  }

  @override
  void didUpdateWidget(covariant LibrarySelectionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.libraries != null && widget.libraries == null) {
      _isLoading = true;
      _errorMessage = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || widget.libraries != null) {
          return;
        }
        unawaited(_loadLibraries());
      });
    }
  }

  Future<void> _loadLibraries() async {
    if (!mounted) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      final l10n = context.l10n;
      setState(() {
        _isLoading = false;
        _errorMessage = l10n.errorNoActiveApiClient;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final fetched = await fetchMetadataToolLibraries(api);
      if (!mounted) {
        return;
      }

      setState(() {
        _loadedLibraries = fetched;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      final l10n = context.l10n;
      setState(() {
        _errorMessage = l10n.errorOperationFailed(l10n.operationLoadLibraries, error.toString());
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<Library> _resolvedLibraries() {
    final source = widget.libraries ?? _loadedLibraries;
    final filter = widget.mediaTypeFilter?.trim().toLowerCase();
    if (filter == null || filter.isEmpty) {
      return source;
    }

    return source.where((library) => library.mediaType.trim().toLowerCase() == filter).toList(growable: false);
  }

  String _mediaTypeLabel(BuildContext context, String mediaType) {
    if (mediaType.trim().toLowerCase() == 'podcast') {
      return context.l10n.mediaTypePodcast;
    }

    return context.l10n.mediaTypeAudiobook;
  }

  IconData _iconForLibrary(Library library) {
    final iconName = library.icon.trim().toLowerCase();
    switch (iconName) {
      case 'podcast':
      case 'rss':
      case 'radio':
      case 'microphone-1':
      case 'microphone-2':
      case 'microphone-3':
        return Icons.podcasts_outlined;
      case 'music':
      case 'headphones':
        return Icons.headphones_outlined;
      case 'book-1':
      case 'books-1':
      case 'books-2':
      case 'audiobookshelf':
        return Icons.menu_book_outlined;
      case 'video':
        return Icons.video_library_outlined;
      default:
        if (library.mediaType.trim().toLowerCase() == 'podcast') {
          return Icons.podcasts_outlined;
        }
        return Icons.library_books_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    if (widget.libraries == null && _isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: YaabsaCircularProgressIndicator()),
      );
    }

    if (widget.libraries == null && _errorMessage != null) {
      return YaabsaSurfaceCard(
        borderColor: theme.colorScheme.error.withValues(alpha: 0.4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_errorMessage!, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error)),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _loadLibraries,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.actionRetry),
            ),
          ],
        ),
      );
    }

    final libraries = _resolvedLibraries();
    if (widget.multiSelect) {
      return _buildMultiSelect(context, libraries);
    }

    return _buildSingleSelect(context, libraries);
  }

  Widget _buildMultiSelect(BuildContext context, List<Library> libraries) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final selectedIds = widget.selectedLibraryIds ?? const <String>{};
    final options = libraries
        .map(
          (library) => YaabsaMultiSelectOption(
            id: library.id,
            label: library.name,
            subtitle: _mediaTypeLabel(context, library.mediaType),
          ),
        )
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        YaabsaMultiSelectListCard(
          title: widget.title ?? l10n.fieldTargetLibraries,
          options: options,
          selectedIds: selectedIds,
          onSelectionChanged: widget.onSelectionChanged!,
          enabled: widget.enabled,
          maxHeight: widget.maxHeight,
          emptyMessage: widget.emptyMessage ?? l10n.statusNoLibrariesFound,
        ),
        if (widget.allowEmptyAllHint && libraries.isNotEmpty && selectedIds.isEmpty) ...[
          const SizedBox(height: 6),
          Text(
            l10n.hintEmptyLibrarySelectionIncludesAll,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ],
    );
  }

  Widget _buildSingleSelect(BuildContext context, List<Library> libraries) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final title = widget.title;
    final emptyMessage = widget.emptyMessage ?? l10n.statusNoLibrariesFound;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null && title.trim().isNotEmpty) ...[
          Text(title, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
        ],
        if (libraries.isEmpty)
          YaabsaSurfaceCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Text(emptyMessage, style: theme.textTheme.bodyMedium),
          )
        else
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: widget.maxHeight),
            child: YaabsaSurfaceCard(
              padding: EdgeInsets.zero,
              borderRadius: 12,
              borderColor: colors.outlineVariant.withValues(alpha: 0.6),
              child: RadioGroup<String>(
                groupValue: widget.selectedLibraryId,
                onChanged: (value) {
                  if (!widget.enabled || value == null) {
                    return;
                  }
                  widget.onSelected!(value);
                },
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: libraries.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final library = libraries[index];
                    final isSelected = widget.selectedLibraryId == library.id;

                    return RadioListTile<String>(
                      dense: true,
                      enabled: widget.enabled,
                      value: library.id,
                      selected: isSelected,
                      selectedTileColor: colors.primaryContainer.withValues(alpha: 0.35),
                      controlAffinity: ListTileControlAffinity.trailing,
                      secondary: Icon(
                        _iconForLibrary(library),
                        color: isSelected ? colors.primary : colors.onSurfaceVariant,
                      ),
                      title: Text(library.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(_mediaTypeLabel(context, library.mediaType), maxLines: 1),
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}
