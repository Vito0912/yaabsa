import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/util/subtitles/subtitle_loader.dart';
import 'package:yaabsa/util/subtitles/subtitle_parser.dart';

class SubtitleReadingModeView extends ConsumerStatefulWidget {
  const SubtitleReadingModeView({super.key});

  static const String routeName = '/subtitles/continuous';

  @override
  ConsumerState<SubtitleReadingModeView> createState() => _SubtitleReadingModeViewState();
}

class _SubtitleReadingModeViewState extends ConsumerState<SubtitleReadingModeView> {
  static const int _cueRenderRadius = 100;
  static const int _cueRenderHysteresis = 28;

  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _paragraphKeys = <int, GlobalKey>{};

  String? _renderWindowKey;
  int _renderStartCueIndex = 0;
  int _renderEndCueIndex = -1;
  int _currentRenderStartParagraphIndex = 0;
  int _currentVisibleParagraphCount = 0;

  int? _lastCenteredParagraphIndex;
  int? _pendingCenteredParagraphIndex;
  bool _hasAttemptedPreScrollForPendingCenter = false;
  int _centerRetryCount = 0;
  bool _hasScheduledCenter = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider).asData?.value;
    final userId = currentUser?.id;

    final settingsManager = ref.read(settingsManagerProvider.notifier);
    ref.watch(userSettingsWatcherProvider);

    final subtitlesEnabled = settingsManager.getUserSetting<bool>(
      userId,
      SettingKeys.subtitlesEnabled,
      defaultValue: defaultSettings[SettingKeys.subtitlesEnabled] as bool? ?? true,
    );
    final readAlongEnabled = settingsManager.getUserSetting<bool>(
      userId,
      SettingKeys.subtitleReadAlong,
      defaultValue: defaultSettings[SettingKeys.subtitleReadAlong] as bool? ?? true,
    );
    if (!subtitlesEnabled) {
      return const Center(child: Text('Subtitles are disabled in player settings.'));
    }

    return StreamBuilder(
      stream: audioHandler.mediaItemStream.stream,
      initialData: audioHandler.currentMediaItem,
      builder: (context, mediaSnapshot) {
        final media = mediaSnapshot.data;
        if (media == null) {
          return const Center(child: Text('Start playback to use continuous subtitle reading mode.'));
        }

        final subtitleFuture = loadSubtitleDocumentForItem(
          ref: ref,
          itemId: media.itemId,
          episodeId: media.episodeId,
          userId: userId,
        );

        return FutureBuilder<LoadedSubtitleDocument?>(
          future: subtitleFuture,
          builder: (context, subtitleSnapshot) {
            if (subtitleSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final loaded = subtitleSnapshot.data;
            if (loaded == null) {
              return const Center(child: Text('No subtitles available for this title.'));
            }

            final document = loaded.document;
            final paragraphLayout = _SubtitleParagraphLayoutCache.layoutFor(loaded);

            return StreamBuilder<Duration>(
              stream: audioHandler.positionStream,
              initialData: audioHandler.position,
              builder: (context, positionSnapshot) {
                final position = positionSnapshot.data ?? Duration.zero;
                var cueIndex = document.cueIndexAt(position);
                if (cueIndex < 0) {
                  cueIndex = document.nearestCueIndex(position);
                }

                if (cueIndex < 0 || cueIndex >= document.cues.length) {
                  return const Center(child: Text('Waiting for subtitle cue...'));
                }

                final activeParagraphIndex = paragraphLayout.cueToParagraphIndex[cueIndex];
                final renderWindowKey = '${media.itemId}::${media.episodeId ?? ''}::${loaded.source.cacheKey}';
                _updateRenderWindow(windowKey: renderWindowKey, cueIndex: cueIndex, cueCount: document.cues.length);

                final renderStartCueIndex = _renderStartCueIndex.clamp(0, document.cues.length - 1);
                final renderEndCueIndex = _renderEndCueIndex.clamp(renderStartCueIndex, document.cues.length - 1);
                final renderStartParagraphIndex = paragraphLayout.cueToParagraphIndex[renderStartCueIndex];
                final renderEndParagraphIndex = paragraphLayout.cueToParagraphIndex[renderEndCueIndex];
                _currentRenderStartParagraphIndex = renderStartParagraphIndex;
                _currentVisibleParagraphCount = renderEndParagraphIndex - renderStartParagraphIndex + 1;

                _pruneParagraphKeys(renderStartParagraphIndex, renderEndParagraphIndex);
                _scheduleParagraphCentering(paragraphIndex: activeParagraphIndex);

                return _ParagraphScroller(
                  scrollController: _scrollController,
                  paragraphs: paragraphLayout.paragraphs,
                  document: document,
                  currentPosition: position,
                  readAlongEnabled: readAlongEnabled,
                  activeCueIndex: cueIndex,
                  activeParagraphIndex: activeParagraphIndex,
                  renderStartParagraphIndex: renderStartParagraphIndex,
                  renderEndParagraphIndex: renderEndParagraphIndex,
                  paragraphKeyBuilder: _keyForParagraph,
                );
              },
            );
          },
        );
      },
    );
  }

  GlobalKey _keyForParagraph(int paragraphIndex) {
    return _paragraphKeys.putIfAbsent(paragraphIndex, () => GlobalKey());
  }

  void _updateRenderWindow({required String windowKey, required int cueIndex, required int cueCount}) {
    if (cueCount <= 0) {
      return;
    }

    final shouldReset =
        _renderWindowKey != windowKey ||
        _renderEndCueIndex < _renderStartCueIndex ||
        cueIndex < _renderStartCueIndex ||
        cueIndex > _renderEndCueIndex;
    if (shouldReset) {
      _renderWindowKey = windowKey;
      _setRenderWindow(cueIndex: cueIndex, cueCount: cueCount);
      _lastCenteredParagraphIndex = null;
      _pendingCenteredParagraphIndex = null;
      _hasAttemptedPreScrollForPendingCenter = false;
      _centerRetryCount = 0;
      return;
    }

    final nearStart = cueIndex <= _renderStartCueIndex + _cueRenderHysteresis;
    final nearEnd = cueIndex >= _renderEndCueIndex - _cueRenderHysteresis;
    if (nearStart || nearEnd) {
      _setRenderWindow(cueIndex: cueIndex, cueCount: cueCount);
    }
  }

  void _setRenderWindow({required int cueIndex, required int cueCount}) {
    _renderStartCueIndex = max(0, cueIndex - _cueRenderRadius);
    _renderEndCueIndex = min(cueCount - 1, cueIndex + _cueRenderRadius);
  }

  void _pruneParagraphKeys(int renderStartParagraphIndex, int renderEndParagraphIndex) {
    final minKeep = renderStartParagraphIndex - 8;
    final maxKeep = renderEndParagraphIndex + 8;
    _paragraphKeys.removeWhere((paragraphIndex, _) => paragraphIndex < minKeep || paragraphIndex > maxKeep);
  }

  void _scheduleParagraphCentering({required int paragraphIndex}) {
    if (_lastCenteredParagraphIndex == paragraphIndex && _pendingCenteredParagraphIndex == null) {
      return;
    }

    _pendingCenteredParagraphIndex = paragraphIndex;
    _hasAttemptedPreScrollForPendingCenter = false;

    if (_hasScheduledCenter) {
      return;
    }

    _hasScheduledCenter = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _hasScheduledCenter = false;
      _performScheduledCentering();
    });
  }

  void _performScheduledCentering() {
    if (!mounted) {
      return;
    }

    final paragraphIndex = _pendingCenteredParagraphIndex;
    if (paragraphIndex == null) {
      return;
    }

    final paragraphContext = _keyForParagraph(paragraphIndex).currentContext;
    if (paragraphContext != null) {
      _pendingCenteredParagraphIndex = null;
      _centerRetryCount = 0;
      _lastCenteredParagraphIndex = paragraphIndex;

      Scrollable.ensureVisible(
        paragraphContext,
        alignment: 0.5,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOutCubic,
      );
      return;
    }

    if (!_hasAttemptedPreScrollForPendingCenter && _scrollController.hasClients && _currentVisibleParagraphCount > 1) {
      final localIndex = max(0, paragraphIndex - _currentRenderStartParagraphIndex);
      final ratio = localIndex / (_currentVisibleParagraphCount - 1);
      final maxExtent = _scrollController.position.maxScrollExtent;
      final targetOffset = (ratio * maxExtent).clamp(0.0, maxExtent);

      _hasAttemptedPreScrollForPendingCenter = true;
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    }

    if (_centerRetryCount >= 6) {
      _pendingCenteredParagraphIndex = null;
      _centerRetryCount = 0;
      return;
    }

    _centerRetryCount += 1;
    _hasScheduledCenter = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _hasScheduledCenter = false;
      _performScheduledCentering();
    });
  }
}

class _ParagraphScroller extends StatelessWidget {
  const _ParagraphScroller({
    required this.scrollController,
    required this.paragraphs,
    required this.document,
    required this.currentPosition,
    required this.readAlongEnabled,
    required this.activeCueIndex,
    required this.activeParagraphIndex,
    required this.renderStartParagraphIndex,
    required this.renderEndParagraphIndex,
    required this.paragraphKeyBuilder,
  });

  final ScrollController scrollController;
  final List<_SubtitleParagraph> paragraphs;
  final ParsedSubtitleDocument document;
  final Duration currentPosition;
  final bool readAlongEnabled;
  final int activeCueIndex;
  final int activeParagraphIndex;
  final int renderStartParagraphIndex;
  final int renderEndParagraphIndex;
  final GlobalKey Function(int paragraphIndex) paragraphKeyBuilder;

  @override
  Widget build(BuildContext context) {
    final visibleParagraphCount = max(0, renderEndParagraphIndex - renderStartParagraphIndex + 1);
    final baseTextStyle =
        Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.52) ?? const TextStyle(fontSize: 16, height: 1.52);
    final colorScheme = Theme.of(context).colorScheme;
    final inactiveParagraphStyle = baseTextStyle.copyWith(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.72));
    final inactiveCueStyle = baseTextStyle.copyWith(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8));
    final activeCueStyle = baseTextStyle.copyWith(color: colorScheme.onSurface);
    final activeWordStyle = baseTextStyle.copyWith(
      color: colorScheme.primary,
      backgroundColor: colorScheme.primary.withValues(alpha: 0.2),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final verticalPadding = (constraints.maxHeight * 0.46).clamp(96.0, 280.0);

        return ListView.builder(
          controller: scrollController,
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16, verticalPadding, 16, verticalPadding),
          itemCount: visibleParagraphCount,
          itemBuilder: (context, localIndex) {
            final paragraphIndex = renderStartParagraphIndex + localIndex;
            final paragraph = paragraphs[paragraphIndex];
            final isActive = paragraphIndex == activeParagraphIndex;

            final spans = isActive
                ? _buildActiveParagraphSpans(
                    paragraph: paragraph,
                    document: document,
                    activeCueIndex: activeCueIndex,
                    currentPosition: currentPosition,
                    readAlongEnabled: readAlongEnabled,
                    inactiveCueStyle: inactiveCueStyle,
                    activeCueStyle: activeCueStyle,
                    activeWordStyle: activeWordStyle,
                  )
                : <InlineSpan>[TextSpan(text: paragraph.text, style: inactiveParagraphStyle)];

            return KeyedSubtree(
              key: paragraphKeyBuilder(paragraphIndex),
              child: Padding(
                padding: EdgeInsets.only(top: paragraph.startsAfterParagraphBreak ? 20 : 8, bottom: 8),
                child: Text.rich(
                  TextSpan(style: inactiveParagraphStyle, children: spans),
                  textAlign: TextAlign.left,
                  softWrap: true,
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<InlineSpan> _buildActiveParagraphSpans({
    required _SubtitleParagraph paragraph,
    required ParsedSubtitleDocument document,
    required int activeCueIndex,
    required Duration currentPosition,
    required bool readAlongEnabled,
    required TextStyle inactiveCueStyle,
    required TextStyle activeCueStyle,
    required TextStyle activeWordStyle,
  }) {
    final spans = <InlineSpan>[];

    for (var index = 0; index < paragraph.cues.length; index++) {
      final cue = paragraph.cues[index];
      if (index > 0) {
        spans.add(TextSpan(text: cue.startsNewLine == true ? '\n' : ' ', style: inactiveCueStyle));
      }

      final cueData = document.cues[cue.cueIndex];
      final isActiveCue = cue.cueIndex == activeCueIndex;
      if (!isActiveCue) {
        spans.add(TextSpan(text: cue.text, style: inactiveCueStyle));
        continue;
      }

      if (!readAlongEnabled || cueData.segments.isEmpty) {
        spans.add(TextSpan(text: cue.text, style: activeCueStyle));
        continue;
      }

      final readAlongSpans = _buildReadAlongCueSpans(
        cueData: cueData,
        currentPosition: currentPosition,
        activeCueStyle: activeCueStyle,
        activeWordStyle: activeWordStyle,
      );
      if (readAlongSpans.isEmpty) {
        spans.add(TextSpan(text: cue.text, style: activeCueStyle));
      } else {
        spans.addAll(readAlongSpans);
      }
    }

    return spans;
  }

  List<InlineSpan> _buildReadAlongCueSpans({
    required ParsedSubtitleCue cueData,
    required Duration currentPosition,
    required TextStyle activeCueStyle,
    required TextStyle activeWordStyle,
  }) {
    final spans = <InlineSpan>[];

    for (final segment in cueData.segments) {
      final text = segment.text.replaceAll('\n', ' ');
      if (text.isEmpty) {
        continue;
      }

      final isActiveWord = currentPosition >= segment.start && currentPosition < segment.end;
      spans.add(TextSpan(text: text, style: isActiveWord ? activeWordStyle : activeCueStyle));
    }

    return spans;
  }
}

class _SubtitleParagraphLayout {
  const _SubtitleParagraphLayout({required this.paragraphs, required this.cueToParagraphIndex});

  final List<_SubtitleParagraph> paragraphs;
  final List<int> cueToParagraphIndex;
}

class _SubtitleParagraph {
  const _SubtitleParagraph({
    required this.startCueIndex,
    required this.endCueIndex,
    required this.startsAfterParagraphBreak,
    required this.text,
    required this.cues,
  });

  final int startCueIndex;
  final int endCueIndex;
  final bool startsAfterParagraphBreak;
  final String text;
  final List<_SubtitleParagraphCue> cues;
}

class _SubtitleParagraphCue {
  const _SubtitleParagraphCue({required this.cueIndex, required this.text, this.startsNewLine = false});

  final int cueIndex;
  final String text;
  final bool? startsNewLine;
}

class _SubtitleParagraphLayoutCache {
  static final LinkedHashMap<String, _SubtitleParagraphLayout> _cache =
      LinkedHashMap<String, _SubtitleParagraphLayout>();

  static _SubtitleParagraphLayout layoutFor(LoadedSubtitleDocument loaded) {
    final key = loaded.source.cacheKey;
    final cached = _cache.remove(key);
    if (cached != null) {
      _cache[key] = cached;
      return cached;
    }

    final created = _build(loaded.document);
    _cache[key] = created;
    while (_cache.length > 30) {
      _cache.remove(_cache.keys.first);
    }
    return created;
  }

  static _SubtitleParagraphLayout _build(ParsedSubtitleDocument document) {
    final cues = document.cues;
    if (cues.isEmpty) {
      return const _SubtitleParagraphLayout(paragraphs: <_SubtitleParagraph>[], cueToParagraphIndex: <int>[]);
    }

    const lineBreakThreshold = Duration(milliseconds: 500);
    const paragraphBreakThreshold = Duration(milliseconds: 1000);

    final paragraphs = <_SubtitleParagraph>[];
    final cueToParagraph = List<int>.filled(cues.length, 0, growable: false);

    var paragraphStartCue = 0;
    var startsAfterParagraphBreak = false;
    for (var index = 1; index < cues.length; index++) {
      final gap = cues[index].start - cues[index - 1].end;
      if (gap > paragraphBreakThreshold) {
        final paragraph = _buildParagraph(
          cues,
          paragraphStartCue,
          index - 1,
          startsAfterParagraphBreak: startsAfterParagraphBreak,
          lineBreakThreshold: lineBreakThreshold,
          paragraphBreakThreshold: paragraphBreakThreshold,
        );
        final paragraphIndex = paragraphs.length;
        paragraphs.add(paragraph);
        for (var cueIndex = paragraph.startCueIndex; cueIndex <= paragraph.endCueIndex; cueIndex++) {
          cueToParagraph[cueIndex] = paragraphIndex;
        }
        paragraphStartCue = index;
        startsAfterParagraphBreak = true;
      }
    }

    final tailParagraph = _buildParagraph(
      cues,
      paragraphStartCue,
      cues.length - 1,
      startsAfterParagraphBreak: startsAfterParagraphBreak,
      lineBreakThreshold: lineBreakThreshold,
      paragraphBreakThreshold: paragraphBreakThreshold,
    );
    final tailParagraphIndex = paragraphs.length;
    paragraphs.add(tailParagraph);
    for (var cueIndex = tailParagraph.startCueIndex; cueIndex <= tailParagraph.endCueIndex; cueIndex++) {
      cueToParagraph[cueIndex] = tailParagraphIndex;
    }

    return _SubtitleParagraphLayout(paragraphs: paragraphs, cueToParagraphIndex: cueToParagraph);
  }

  static _SubtitleParagraph _buildParagraph(
    List<ParsedSubtitleCue> cues,
    int startCueIndex,
    int endCueIndex, {
    required bool startsAfterParagraphBreak,
    required Duration lineBreakThreshold,
    required Duration paragraphBreakThreshold,
  }) {
    final textBuffer = StringBuffer();
    final paragraphCues = <_SubtitleParagraphCue>[];

    for (var index = startCueIndex; index <= endCueIndex; index++) {
      final cueText = _normalizeInlineWhitespace(cues[index].text.replaceAll('\n', ' '));
      final startsNewLine =
          index > startCueIndex &&
          (cues[index].start - cues[index - 1].end) >= lineBreakThreshold &&
          (cues[index].start - cues[index - 1].end) <= paragraphBreakThreshold;
      paragraphCues.add(_SubtitleParagraphCue(cueIndex: index, text: cueText, startsNewLine: startsNewLine));

      if (cueText.isEmpty) {
        continue;
      }

      if (textBuffer.isNotEmpty) {
        textBuffer.write(startsNewLine ? '\n' : ' ');
      }
      textBuffer.write(cueText);
    }

    return _SubtitleParagraph(
      startCueIndex: startCueIndex,
      endCueIndex: endCueIndex,
      startsAfterParagraphBreak: startsAfterParagraphBreak,
      text: textBuffer.toString().trim(),
      cues: paragraphCues,
    );
  }

  static String _normalizeInlineWhitespace(String input) {
    return input.replaceAll(RegExp(r'[ \t]+'), ' ').trim();
  }
}
