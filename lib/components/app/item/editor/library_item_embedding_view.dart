import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yaabsa/api/library_items/audio_file.dart';
import 'package:yaabsa/api/library_items/chapter.dart';
import 'package:yaabsa/util/item_formatters.dart';

import 'package:yaabsa/generated/l10n.dart';

class LibraryItemEmbeddingView extends StatelessWidget {
  const LibraryItemEmbeddingView({
    super.key,
    required this.audioFiles,
    required this.chapters,
    required this.metadataObject,
    required this.isMetadataLoading,
    required this.isRequestInFlight,
    required this.isTaskRunning,
    required this.isTaskQueued,
    required this.backupAudioFiles,
    required this.forceEmbedChapters,
    required this.onBackupAudioFilesChanged,
    required this.onForceEmbedChaptersChanged,
    required this.onRefreshMetadataObject,
    required this.onStartEmbedding,
    this.infoMessage,
    this.errorMessage,
  });

  final List<AudioFile> audioFiles;
  final List<Chapter> chapters;
  final Map<String, dynamic>? metadataObject;
  final bool isMetadataLoading;
  final bool isRequestInFlight;
  final bool isTaskRunning;
  final bool isTaskQueued;
  final bool backupAudioFiles;
  final bool forceEmbedChapters;
  final ValueChanged<bool> onBackupAudioFilesChanged;
  final ValueChanged<bool> onForceEmbedChaptersChanged;
  final VoidCallback onRefreshMetadataObject;
  final VoidCallback onStartEmbedding;
  final String? infoMessage;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    if (audioFiles.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(S.current.componentsAppItemEditorLibraryItemEmbeddingViewNoAudioTracksAreAvailableFor),
        ),
      );
    }

    final metadataEntries = (metadataObject ?? const <String, dynamic>{}).entries.toList(growable: false)
      ..sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      children: [
        _EmbedActionCard(
          isRequestInFlight: isRequestInFlight,
          isTaskRunning: isTaskRunning,
          isTaskQueued: isTaskQueued,
          backupAudioFiles: backupAudioFiles,
          forceEmbedChapters: forceEmbedChapters,
          onBackupAudioFilesChanged: onBackupAudioFilesChanged,
          onForceEmbedChaptersChanged: onForceEmbedChaptersChanged,
          onRefreshMetadataObject: onRefreshMetadataObject,
          onStartEmbedding: onStartEmbedding,
          audioFileCount: audioFiles.length,
        ),
        if (errorMessage != null && errorMessage!.trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: _StatusCard(
              icon: Icons.error_outline,
              message: errorMessage!,
              color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.45),
              iconColor: Theme.of(context).colorScheme.error,
            ),
          ),
        if (infoMessage != null && infoMessage!.trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: _StatusCard(
              icon: Icons.info_outline,
              message: infoMessage!,
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.45),
              iconColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final panelWidth = constraints.maxWidth >= 980 ? (constraints.maxWidth - 12) / 2 : constraints.maxWidth;

            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: panelWidth,
                  child: _ToolPanel(
                    title: S.current.componentsAppItemEditorLibraryItemEmbeddingViewMetadataToEmbed,
                    child: isMetadataLoading
                        ? const Center(
                            child: Padding(padding: EdgeInsets.all(18), child: CircularProgressIndicator()),
                          )
                        : _MetadataRows(entries: metadataEntries),
                  ),
                ),
                SizedBox(
                  width: panelWidth,
                  child: _ToolPanel(
                    title: S.current.componentsAppItemEditorLibraryItemEmbeddingViewChaptersToEmbed,
                    child: _ChapterRows(chapters: chapters),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _EmbedActionCard extends StatelessWidget {
  const _EmbedActionCard({
    required this.isRequestInFlight,
    required this.isTaskRunning,
    required this.isTaskQueued,
    required this.backupAudioFiles,
    required this.forceEmbedChapters,
    required this.onBackupAudioFilesChanged,
    required this.onForceEmbedChaptersChanged,
    required this.onRefreshMetadataObject,
    required this.onStartEmbedding,
    required this.audioFileCount,
  });

  final bool isRequestInFlight;
  final bool isTaskRunning;
  final bool isTaskQueued;
  final bool backupAudioFiles;
  final bool forceEmbedChapters;
  final ValueChanged<bool> onBackupAudioFilesChanged;
  final ValueChanged<bool> onForceEmbedChaptersChanged;
  final VoidCallback onRefreshMetadataObject;
  final VoidCallback onStartEmbedding;
  final int audioFileCount;

  @override
  Widget build(BuildContext context) {
    final controlsLocked = isRequestInFlight || isTaskRunning || isTaskQueued;
    final startLabel = isRequestInFlight
        ? S.current.componentsAppItemEditorLibraryItemEmbeddingViewSubmitting
        : isTaskRunning
        ? S.current.componentsAppItemEditorLibraryItemEmbeddingViewRunning
        : isTaskQueued
        ? S.current.componentsAppItemEditorLibraryItemEmbeddingViewQueued
        : S.current.componentsAppItemEditorLibraryItemEmbeddingViewStartEmbed;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              S.current.componentsAppItemEditorLibraryItemEmbeddingViewEmbedding,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            SwitchListTile.adaptive(
              dense: true,
              contentPadding: EdgeInsets.zero,
              value: backupAudioFiles,
              onChanged: controlsLocked ? null : onBackupAudioFilesChanged,
              title: Text(S.current.componentsAppItemEditorLibraryItemEmbeddingViewBackupAudioFilesBeforeEmbedding),
            ),
            SwitchListTile.adaptive(
              dense: true,
              contentPadding: EdgeInsets.zero,
              value: forceEmbedChapters,
              onChanged: controlsLocked ? null : onForceEmbedChaptersChanged,
              title: Text(S.current.componentsAppItemEditorLibraryItemEmbeddingViewForceChapterEmbedding),
            ),
            Text(
              S.current.componentsAppItemEditorLibraryItemEmbeddingViewForcesChapterMarkersToBeRewritten,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: isRequestInFlight ? null : onRefreshMetadataObject,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(S.current.componentsAppItemEditorLibraryItemEmbeddingViewRefreshMetadata),
                ),
                FilledButton.icon(
                  onPressed: controlsLocked ? null : onStartEmbedding,
                  icon: controlsLocked
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2.1))
                      : const Icon(Icons.auto_fix_high_rounded),
                  label: Text(startLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolPanel extends StatelessWidget {
  const _ToolPanel({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _MetadataRows extends StatelessWidget {
  const _MetadataRows({required this.entries});

  final List<MapEntry<String, dynamic>> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(S.current.componentsAppItemEditorLibraryItemEmbeddingViewNoMetadataObjectReturnedByThe),
      );
    }

    return Column(
      children: [
        for (var i = 0; i < entries.length; i++)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: i.isOdd ? Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : null,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 130,
                  child: Text(
                    entries[i].key,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(_formatMetadataValue(entries[i].value), style: Theme.of(context).textTheme.bodySmall),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ChapterRows extends StatelessWidget {
  const _ChapterRows({required this.chapters});

  final List<Chapter> chapters;

  @override
  Widget build(BuildContext context) {
    if (chapters.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(S.current.componentsAppItemEditorLibraryItemEmbeddingViewNoChaptersAvailable),
      );
    }

    return Column(
      children: [
        for (var i = 0; i < chapters.length; i++)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: i.isOdd ? Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : null,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text(chapters[i].title, style: Theme.of(context).textTheme.bodySmall)),
                const SizedBox(width: 8),
                Text(_formatClock(chapters[i].start), style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(width: 8),
                Text(
                  S.current.componentsAppItemEditorLibraryItemEmbeddingViewText,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 8),
                Text(_formatClock(chapters[i].end), style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(width: 8),
                Text(
                  formatDurationLong(chapterDuration(chapters[i].start, chapters[i].end)),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.icon, required this.message, required this.color, required this.iconColor});

  final IconData icon;
  final String message;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}

String _formatMetadataValue(dynamic value) {
  if (value == null) {
    return '-';
  }

  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? '-' : trimmed;
  }

  if (value is num || value is bool) {
    return value.toString();
  }

  if (value is List) {
    if (value.isEmpty) {
      return '-';
    }

    return value
        .map((entry) => _formatMetadataValue(entry))
        .where((entry) => entry.trim().isNotEmpty && entry.trim() != '-')
        .join(', ');
  }

  if (value is Map) {
    return jsonEncode(value);
  }

  return value.toString();
}

String _formatClock(double seconds) {
  final totalSeconds = seconds.round();
  final duration = Duration(seconds: totalSeconds);
  final twoDigits = NumberFormat('00', Intl.getCurrentLocale());

  final hours = duration.inHours;
  final minutes = twoDigits.format(duration.inMinutes.remainder(60));
  final secs = twoDigits.format(duration.inSeconds.remainder(60));

  if (hours > 0) {
    return '$hours:$minutes:$secs';
  }

  return '${duration.inMinutes}:$secs';
}
