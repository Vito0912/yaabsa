import 'dart:ui' show ImageFilter;

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/common/cover_zoom_view.dart';
import 'package:yaabsa/components/player/common/cover_palette_builder.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/screens/player/components/mobile_player_action_dock.dart';
import 'package:yaabsa/screens/player/components/player_action_bar.dart';
import 'package:yaabsa/screens/player/components/player_cover_component.dart';
import 'package:yaabsa/screens/player/components/player_media_info_component.dart';
import 'package:yaabsa/screens/player/components/player_playback_controls_component.dart';
import 'package:yaabsa/screens/player/components/player_seek_bar_component.dart';
import 'package:yaabsa/screens/player/components/player_subtitles_component.dart';
import 'package:yaabsa/screens/player/desktop_player_side_panel.dart';
import 'package:yaabsa/screens/player/layout/player_layout_config.dart';
import 'package:yaabsa/screens/player/layout/player_presentation_config.dart';
import 'package:yaabsa/util/globals.dart';

class PlayerAdaptiveView extends StatelessWidget {
  const PlayerAdaptiveView({
    super.key,
    required this.api,
    required this.media,
    required this.hasChapters,
    required this.preset,
    required this.transportMode,
    required this.actions,
    required this.mobileLeftAction,
    required this.mobileRightAction,
    required this.coverSize,
    required this.immersiveColors,
    required this.onNavigationBarColorChanged,
  });

  final ABSApi? api;
  final InternalMedia media;
  final bool hasChapters;
  final PlayerAdaptivePreset preset;
  final PlayerTransportMode transportMode;
  final List<PlayerActionType> actions;
  final PlayerActionType? mobileLeftAction;
  final PlayerActionType? mobileRightAction;
  final PlayerCoverSize coverSize;
  final bool immersiveColors;
  final ValueChanged<Color> onNavigationBarColorChanged;

  bool get _minimalistic => preset == PlayerAdaptivePreset.minimalistic;
  bool get _compactCover => coverSize.resolveCompact(preset);

  @override
  Widget build(BuildContext context) {
    final headers = api == null ? const <String, String>{} : normalizeImageRequestHeaders(api!.dio.options.headers);
    final coverProvider = coverImageProviderFromUri(media.cover, requestHeaders: headers);
    final backgroundProvider = !immersiveColors || coverProvider == null
        ? null
        : ResizeImage.resizeIfNeeded(96, 96, coverProvider);
    return CoverPaletteBuilder(
      coverUri: immersiveColors ? media.cover : null,
      requestHeaders: headers,
      builder: (context, palette) {
        final colors = Theme.of(context).colorScheme;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final coverSurface = immersiveColors
            ? Color.alphaBlend(
                (palette?.primary ?? colors.primaryContainer).withValues(alpha: isDark ? 0.5 : 0.22),
                colors.surface,
              )
            : colors.surface;
        final systemBarBrightness = ThemeData.estimateBrightnessForColor(coverSurface);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onNavigationBarColorChanged(coverSurface);
        });

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: systemBarBrightness == Brightness.dark ? Brightness.light : Brightness.dark,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent,
            systemNavigationBarIconBrightness: systemBarBrightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
            systemNavigationBarContrastEnforced: false,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              ColoredBox(color: colors.surface),
              if (immersiveColors && backgroundProvider != null)
                RepaintBoundary(
                  child: ClipRect(
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                      child: Opacity(
                        opacity: isDark ? 0.5 : 0.25,
                        child: Image(image: backgroundProvider, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              ColoredBox(
                color: immersiveColors ? coverSurface.withValues(alpha: isDark ? 0.68 : 0.78) : coverSurface,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return switch (resolveAdaptivePlayerLayout(context, constraints)) {
                      AdaptivePlayerLayout.compactPortrait => _buildPortrait(context, constraints),
                      AdaptivePlayerLayout.compactLandscape => _buildLandscape(context, constraints),
                      AdaptivePlayerLayout.medium => _buildMedium(context, constraints),
                      AdaptivePlayerLayout.expanded => _buildExpanded(context, constraints),
                    };
                  },
                ),
              ),
              if (context.isMobile && _minimalistic)
                Positioned(
                  left: MediaQuery.paddingOf(context).left,
                  right: MediaQuery.paddingOf(context).right,
                  bottom: MediaQuery.paddingOf(context).bottom,
                  child: MobilePlayerActionDock(
                    leftAction: mobileLeftAction,
                    rightAction: mobileRightAction,
                    hasChapters: hasChapters,
                  ),
                ),
              if (_showMobileFullActionBar(context))
                Positioned(
                  left: MediaQuery.paddingOf(context).left + 16,
                  right: MediaQuery.paddingOf(context).right + 16,
                  bottom: MediaQuery.paddingOf(context).bottom + 4,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    heightFactor: 1,
                    child: PlayerActionBar(actions: actions, hasChapters: hasChapters, grouped: true),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  bool _showMobileFullActionBar(BuildContext context) {
    return context.isMobile && !_minimalistic && actions.isNotEmpty;
  }

  Widget _buildPortrait(BuildContext context, BoxConstraints constraints) {
    final safePadding = MediaQuery.paddingOf(context);
    final horizontalPadding = _minimalistic ? 20.0 : 24.0;
    final leftPadding = horizontalPadding + safePadding.left;
    final rightPadding = horizontalPadding + safePadding.right;
    final topPadding = safePadding.top;
    final bottomPadding = safePadding.bottom + (_minimalistic || _showMobileFullActionBar(context) ? 68.0 : 16.0);
    final maxArtworkSize = (constraints.maxWidth - leftPadding - rightPadding).clamp(
      0.0,
      _compactCover ? 280.0 : 360.0,
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(leftPadding, topPadding, rightPadding, bottomPadding),
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 5,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxArtworkSize, maxHeight: maxArtworkSize),
              child: AspectRatio(
                aspectRatio: 1,
                child: _Artwork(api: api, media: media, size: maxArtworkSize, compact: _compactCover),
              ),
            ),
          ),
          SizedBox(height: _minimalistic ? 10 : 16),
          _MediaDetails(media: media, centered: true, compact: _minimalistic, dense: true),
          SizedBox(height: _minimalistic ? 10 : 16),
          _PlaybackPanel(
            transportMode: transportMode,
            actions: actions,
            hasChapters: hasChapters,
            compact: _minimalistic,
          ),
        ],
      ),
    );
  }

  Widget _buildLandscape(BuildContext context, BoxConstraints constraints) {
    final safePadding = MediaQuery.paddingOf(context);
    final topPadding = safePadding.top;
    final reservedBottom = context.isMobile && _minimalistic
        ? 52.0
        : _showMobileFullActionBar(context)
        ? 60.0
        : 8.0;
    final bottomPadding = safePadding.bottom + reservedBottom;
    final artworkSize = (constraints.maxHeight - topPadding - bottomPadding).clamp(120.0, 280.0);

    return Padding(
      padding: EdgeInsets.fromLTRB(20 + safePadding.left, topPadding, 20 + safePadding.right, bottomPadding),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: _compactCover ? 4 : 5,
            child: Center(
              child: _Artwork(api: api, media: media, size: artworkSize, compact: _compactCover),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 6,
            child: LayoutBuilder(
              builder: (context, panelConstraints) {
                final panel = Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _MediaDetails(media: media, centered: false, compact: true, dense: context.isMobile),
                    const SizedBox(height: 8),
                    _PlaybackPanel(
                      transportMode: transportMode,
                      actions: actions,
                      hasChapters: hasChapters,
                      compact: true,
                    ),
                  ],
                );
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: panelConstraints.maxHeight),
                    child: Align(alignment: Alignment.centerLeft, child: panel),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedium(BuildContext context, BoxConstraints constraints) {
    final safePadding = MediaQuery.paddingOf(context);
    final topPadding = safePadding.top;
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                28 + safePadding.left,
                topPadding,
                28 + safePadding.right,
                20 + safePadding.bottom,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: 1,
                      child: _Artwork(
                        api: api,
                        media: media,
                        size: (constraints.maxWidth * (_compactCover ? 0.28 : 0.34)).clamp(
                          220.0,
                          _compactCover ? 320.0 : 390.0,
                        ),
                        compact: _compactCover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 44),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _MediaDetails(media: media, centered: false, compact: _minimalistic),
                        const SizedBox(height: 28),
                        _PlaybackPanel(
                          transportMode: transportMode,
                          actions: actions,
                          hasChapters: hasChapters,
                          compact: _minimalistic,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpanded(BuildContext context, BoxConstraints constraints) {
    final safePadding = MediaQuery.paddingOf(context);
    final topPadding = safePadding.top;
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1340),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                40 + safePadding.left,
                topPadding,
                40 + safePadding.right,
                28 + safePadding.bottom,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: 1,
                      child: _Artwork(
                        api: api,
                        media: media,
                        size: (constraints.maxHeight * (_compactCover ? 0.44 : 0.56)).clamp(
                          280.0,
                          _compactCover ? 350.0 : 430.0,
                        ),
                        compact: _compactCover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 64),
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _MediaDetails(media: media, centered: false, compact: _minimalistic),
                        const SizedBox(height: 30),
                        _PlaybackPanel(
                          transportMode: transportMode,
                          actions: actions,
                          hasChapters: hasChapters,
                          compact: _minimalistic,
                          showActionLabels: false,
                          actionOverrides: <PlayerActionType, VoidCallback>{
                            PlayerActionType.bookmarks: () => showDesktopPlayerSidePanel(
                              context,
                              type: DesktopPlayerPanelType.bookmarks,
                              media: media,
                            ),
                            if (hasChapters)
                              PlayerActionType.chapter: () => showDesktopPlayerSidePanel(
                                context,
                                type: DesktopPlayerPanelType.chapters,
                                media: media,
                              ),
                            PlayerActionType.queue: () =>
                                showDesktopPlayerSidePanel(context, type: DesktopPlayerPanelType.queue, media: media),
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Artwork extends StatelessWidget {
  const _Artwork({required this.api, required this.media, required this.size, required this.compact});

  final ABSApi? api;
  final InternalMedia media;
  final double size;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(compact ? 24 : 32),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.2),
            blurRadius: compact ? 20 : 34,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: PlayerCoverComponent(api: api, media: media, fitMode: PlayerCoverFitMode.width),
    );
  }
}

class _MediaDetails extends StatelessWidget {
  const _MediaDetails({required this.media, required this.centered, required this.compact, this.dense = false});

  final InternalMedia media;
  final bool centered;
  final bool compact;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return PlayerMediaInfoComponent(
      media: media,
      showAuthor: true,
      showNarrator: false,
      showSeries: true,
      textAlignMode: centered ? PlayerMetadataTextAlign.center : PlayerMetadataTextAlign.start,
      fontScale: dense ? 0.95 : (compact ? 1 : 1.22),
      titleMaxLines: 3,
      detailMaxLines: 2,
    );
  }
}

class _PlaybackPanel extends StatelessWidget {
  const _PlaybackPanel({
    required this.transportMode,
    required this.actions,
    required this.hasChapters,
    required this.compact,
    this.showActionLabels = false,
    this.actionOverrides = const <PlayerActionType, VoidCallback>{},
  });

  final PlayerTransportMode transportMode;
  final List<PlayerActionType> actions;
  final bool hasChapters;
  final bool compact;
  final bool showActionLabels;
  final Map<PlayerActionType, VoidCallback> actionOverrides;

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final seekTrackHeight = isDesktop ? (compact ? 8.0 : 9.0) : (compact ? 6.0 : 7.0);
    final seekLabelFontSize = isDesktop ? (compact ? 14.0 : 15.0) : (compact ? 12.0 : 13.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        PlayerSubtitlesComponent(compact: context.isMobile),
        PlayerSeekBarComponent(
          timePlacement: PlayerSeekTimePlacement.below,
          trackHeight: seekTrackHeight,
          timeLabelFontSize: seekLabelFontSize,
          showCurrentChapterBetweenTimeLabels: true,
        ),
        SizedBox(height: compact ? 14 : 22),
        PlayerTransportControlsComponent(transportMode: transportMode),
        if (!context.isMobile && actions.isNotEmpty) ...<Widget>[
          SizedBox(height: compact ? 14 : 22),
          PlayerActionBar(
            actions: actions,
            hasChapters: hasChapters,
            showLabels: showActionLabels,
            grouped: !showActionLabels,
            actionOverrides: actionOverrides,
            spacing: showActionLabels ? 8 : 6,
          ),
        ],
      ],
    );
  }
}
