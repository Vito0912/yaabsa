import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:yaabsa/components/common/cover_placeholder.dart';
import 'package:yaabsa/components/player/common/control_button.dart';
import 'package:yaabsa/util/audio_handler/bg_audio_handler.dart';

class PlayBarIdleContent extends StatelessWidget {
  const PlayBarIdleContent({
    super.key,
    required this.snapshot,
    required this.isMobile,
    required this.requestHeaders,
    required this.attachedToBottom,
    required this.mobileCoverSize,
    required this.mobileCoverRadius,
    required this.desktopCoverWidth,
    required this.desktopCoverRadius,
  });

  final LastPlayedMiniPlayerSnapshot snapshot;
  final bool isMobile;
  final Map<String, String> requestHeaders;
  final bool attachedToBottom;
  final double mobileCoverSize;
  final double mobileCoverRadius;
  final double desktopCoverWidth;
  final double desktopCoverRadius;

  @override
  Widget build(BuildContext context) {
    final coverRadius = attachedToBottom ? 0.0 : desktopCoverRadius;

    if (isMobile) {
      return Row(
        children: [
          SizedBox(
            width: mobileCoverSize,
            height: mobileCoverSize,
            child: _PlayBarIdleCover(
              coverUri: snapshot.cover,
              borderRadius: mobileCoverRadius,
              requestHeaders: requestHeaders,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: _PlayBarIdleInfo(snapshot: snapshot)),
          const ControlButton(),
        ],
      );
    }

    return Row(
      children: [
        SizedBox(
          width: desktopCoverWidth,
          height: desktopCoverWidth,
          child: _PlayBarIdleCover(coverUri: snapshot.cover, borderRadius: coverRadius, requestHeaders: requestHeaders),
        ),
        const SizedBox(width: 10),
        Expanded(child: _PlayBarIdleInfo(snapshot: snapshot)),
        const ControlButton(),
      ],
    );
  }
}

class _PlayBarIdleInfo extends StatelessWidget {
  const _PlayBarIdleInfo({required this.snapshot});

  final LastPlayedMiniPlayerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final subtitleParts = <String>[
      if (snapshot.subtitle != null && snapshot.subtitle!.trim().isNotEmpty) snapshot.subtitle!.trim(),
      if (snapshot.author != null && snapshot.author!.trim().isNotEmpty) snapshot.author!.trim(),
    ];

    final subtitle = subtitleParts.join(' - ');

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          snapshot.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
        ),
        if (subtitle.isNotEmpty)
          Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _PlayBarIdleCover extends StatelessWidget {
  const _PlayBarIdleCover({required this.coverUri, required this.borderRadius, required this.requestHeaders});

  final Uri? coverUri;
  final double borderRadius;
  final Map<String, String> requestHeaders;

  ImageProvider<Object>? _imageProvider() {
    final uri = coverUri;
    if (uri == null) {
      return null;
    }

    if (uri.scheme == 'file') {
      return FileImage(File(uri.toFilePath()));
    }

    return NetworkImage(uri.toString(), headers: requestHeaders.isEmpty ? null : requestHeaders);
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = _imageProvider();
    if (imageProvider == null) {
      return CoverPlaceholder(borderRadius: borderRadius);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image(
        image: imageProvider,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.low,
        errorBuilder: (context, error, stackTrace) => CoverPlaceholder(borderRadius: borderRadius),
      ),
    );
  }
}
