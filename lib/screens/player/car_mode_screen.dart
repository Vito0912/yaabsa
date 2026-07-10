import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/common/cover_placeholder.dart';
import 'package:yaabsa/components/common/cover_zoom_view.dart';
import 'package:yaabsa/components/player/common/jump_button.dart';
import 'package:yaabsa/components/player/common/seek_bar.dart';
import 'package:yaabsa/components/player/common/stop_button.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/setting_key.dart';

class CarModeScreen extends ConsumerWidget {
  const CarModeScreen({super.key});

  double _resolveCoverSize({required BoxConstraints constraints, required double reservedHeight}) {
    final sideMargin = constraints.maxWidth >= 1200
        ? 44.0
        : constraints.maxWidth >= 900
        ? 28.0
        : 12.0;
    final byWidth = constraints.maxWidth - (sideMargin * 2);
    final byHeight = constraints.maxHeight - reservedHeight;
    final preferred = byWidth < byHeight ? byWidth : byHeight;
    final maxCover = constraints.maxWidth >= 1400
        ? 560.0
        : constraints.maxWidth >= 1000
        ? 500.0
        : 440.0;
    return preferred.clamp(0.0, maxCover).toDouble();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(absApiProvider);
    final fastForwardVal = ref.watch(globalSettingByKeyProvider(SettingKeys.fastForwardInterval)).asData?.value;
    final rewindVal = ref.watch(globalSettingByKeyProvider(SettingKeys.rewindInterval)).asData?.value;
    final fastForwardSeconds = SettingsParser.decodeValue<int>(fastForwardVal, 10);
    final rewindSeconds = SettingsParser.decodeValue<int>(rewindVal, 10);

    return Scaffold(
      appBar: AppBar(title: const Text('Car Mode'), actions: const [StopButton()]),
      body: StreamBuilder<InternalMedia?>(
        stream: audioHandler.mediaItemStream.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final media = snapshot.data!;

          return LayoutBuilder(
            builder: (context, viewportConstraints) {
              final horizontalPadding = viewportConstraints.maxWidth >= 1400
                  ? 24.0
                  : viewportConstraints.maxWidth >= 900
                  ? 12.0
                  : 8.0;
              final verticalPadding = viewportConstraints.maxHeight < 430 ? 10.0 : 16.0;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final compactLayout = constraints.maxHeight < 430;
                    final topGap = compactLayout ? 8.0 : 12.0;
                    final seekGap = compactLayout ? 12.0 : 20.0;
                    final bottomGap = compactLayout ? 8.0 : 18.0;
                    final sideControlSize = compactLayout ? 82.0 : 96.0;
                    final sideControlIconSize = compactLayout ? 38.0 : 46.0;
                    final playControlSize = compactLayout ? 98.0 : 116.0;
                    final playControlIconSize = compactLayout ? 48.0 : 56.0;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, topConstraints) {
                              final topHeight = topConstraints.maxHeight;
                              final compactTop = topHeight < 220;
                              final ultraCompactTop = topHeight < 130;
                              final showAuthor = !ultraCompactTop;
                              final titleStyle = Theme.of(context).textTheme.headlineMedium;
                              final authorStyle = Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);
                              final coverToTitleGap = ultraCompactTop
                                  ? 6.0
                                  : compactTop
                                  ? 10.0
                                  : 20.0;
                              final titleToAuthorGap = ultraCompactTop
                                  ? 0.0
                                  : compactTop
                                  ? 4.0
                                  : 8.0;
                              final reservedHeight = ultraCompactTop
                                  ? 30.0
                                  : compactTop
                                  ? 62.0
                                  : 100.0;
                              final coverSize = _resolveCoverSize(
                                constraints: topConstraints,
                                reservedHeight: reservedHeight,
                              );

                              return Center(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    width: topConstraints.maxWidth,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (coverSize > 0.0) _CarModeCoverArt(api: api, media: media, size: coverSize),
                                        if (coverSize > 0.0) SizedBox(height: coverToTitleGap),
                                        Text(
                                          media.title,
                                          maxLines: ultraCompactTop ? 1 : 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: titleStyle,
                                        ),
                                        if (showAuthor) SizedBox(height: titleToAuthorGap),
                                        if (showAuthor)
                                          Text(
                                            media.author ?? 'Unknown Author',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: authorStyle,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: topGap),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: const SeekBar(
                            trackHeight: 20.0,
                            timeLabelsBelow: true,
                            timeLabelFontSize: 24.0,
                            previewLabelFontSize: 30.0,
                          ),
                        ),
                        SizedBox(height: seekGap),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _CarControl(
                              icon: JumpIcon(rewind: true, durationSeconds: rewindSeconds, size: sideControlIconSize),
                              onPressed: () => audioHandler.rewind(),
                              iconSize: sideControlIconSize,
                              minimumSize: sideControlSize,
                            ),
                            _CarPlayPauseControl(iconSize: playControlIconSize, minimumSize: playControlSize),
                            _CarControl(
                              icon: JumpIcon(
                                rewind: false,
                                durationSeconds: fastForwardSeconds,
                                size: sideControlIconSize,
                              ),
                              onPressed: () => audioHandler.fastForward(),
                              iconSize: sideControlIconSize,
                              minimumSize: sideControlSize,
                            ),
                          ],
                        ),
                        SizedBox(height: bottomGap),
                      ],
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _CarModeCoverArt extends StatelessWidget {
  const _CarModeCoverArt({required this.api, required this.media, required this.size});

  final ABSApi? api;
  final InternalMedia media;
  final double size;

  @override
  Widget build(BuildContext context) {
    const fallback = CoverPlaceholder(borderRadius: 14);
    final currentApi = api;
    final requestHeaders = currentApi == null
        ? const <String, String>{}
        : normalizeImageRequestHeaders(currentApi.dio.options.headers);
    final imageProvider = coverImageProviderFromUri(media.cover, requestHeaders: requestHeaders);

    return SizedBox(
      width: size,
      height: size,
      child: imageProvider == null
          ? fallback
          : ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    openCoverZoomView(
                      context,
                      coverUri: media.cover!,
                      requestHeaders: requestHeaders,
                      semanticsLabel: media.title,
                    );
                  },
                  child: Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.low,
                    errorBuilder: (context, error, stackTrace) => fallback,
                  ),
                ),
              ),
            ),
    );
  }
}

class _CarControl extends StatelessWidget {
  const _CarControl({required this.icon, required this.onPressed, required this.iconSize, required this.minimumSize});

  final Widget icon;
  final VoidCallback onPressed;
  final double iconSize;
  final double minimumSize;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: onPressed,
      icon: icon,
      iconSize: iconSize,
      style: IconButton.styleFrom(minimumSize: Size.square(minimumSize)),
    );
  }
}

class _CarPlayPauseControl extends StatelessWidget {
  const _CarPlayPauseControl({required this.iconSize, required this.minimumSize});

  final double iconSize;
  final double minimumSize;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: audioHandler.playerControlStateStream,
      initialData: audioHandler.playerControlState,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final isPlaying = playerState?.playing ?? false;
        return IconButton.filled(
          onPressed: () {
            if (isPlaying) {
              audioHandler.pause();
            } else {
              audioHandler.play();
            }
          },
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          iconSize: iconSize,
          style: IconButton.styleFrom(minimumSize: Size.square(minimumSize)),
        );
      },
    );
  }
}
