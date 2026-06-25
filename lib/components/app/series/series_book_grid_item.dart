import 'package:flutter/material.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/common/library_item_widget.dart';

class SeriesBookGridItem extends StatelessWidget {
  const SeriesBookGridItem({
    required this.item,
    required this.api,
    required this.seriesId,
    super.key,
    this.onPlay,
    this.selectionMode = false,
    this.isSelected = false,
    this.enableHoverSelection = false,
    this.onToggleSelection,
    this.onEnterSelectionMode,
    this.canEdit = false,
    this.onEdit,
  });

  final LibraryItem item;
  final ABSApi api;
  final String seriesId;
  final VoidCallback? onPlay;
  final bool selectionMode;
  final bool isSelected;
  final bool enableHoverSelection;
  final VoidCallback? onToggleSelection;
  final VoidCallback? onEnterSelectionMode;
  final bool canEdit;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final sequence = _resolveSeriesSequenceForItem(item: item, seriesId: seriesId);
    final sequenceBadge = sequence == null ? null : '#$sequence';

    return LibraryItemWidget(
      item,
      api,
      showProgress: true,
      squareCover: true,
      sequenceBadge: sequenceBadge,
      onPlay: onPlay,
      selectionMode: selectionMode,
      isSelected: isSelected,
      enableHoverSelection: enableHoverSelection,
      onToggleSelection: onToggleSelection,
      onEnterSelectionMode: onEnterSelectionMode,
      canEdit: canEdit,
      onEdit: onEdit,
    );
  }

  static String? _resolveSeriesSequenceForItem({required LibraryItem item, required String seriesId}) {
    final seriesEntries = item.media?.bookMedia?.metadata.series;
    if (seriesEntries != null && seriesEntries.isNotEmpty) {
      for (final entry in seriesEntries) {
        final sequence = entry.sequence?.trim();
        if (entry.id == seriesId && sequence != null && sequence.isNotEmpty) {
          return sequence;
        }
      }

      if (seriesEntries.length == 1) {
        final singleSequence = seriesEntries.first.sequence?.trim();
        if (singleSequence != null && singleSequence.isNotEmpty) {
          return singleSequence;
        }
      }
    }

    final fallback = item.seriesPosition?.trim();
    if (fallback == null || fallback.isEmpty) {
      return null;
    }

    return fallback;
  }
}
