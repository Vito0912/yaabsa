import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yaabsa/models/internal_download.dart';

class DownloadCoverThumbnail extends StatelessWidget {
  const DownloadCoverThumbnail({super.key, required this.download, this.size = 44});

  final InternalDownload download;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final coverPath = _resolveLocalCoverPath(download.coverPath);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: size,
        height: size,
        child: coverPath == null
            ? Container(
                color: colorScheme.surfaceContainerHighest,
                child: Icon(Icons.library_books_outlined, color: colorScheme.onSurfaceVariant),
              )
            : Image.file(
                File(coverPath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: colorScheme.surfaceContainerHighest,
                    child: Icon(Icons.library_books_outlined, color: colorScheme.onSurfaceVariant),
                  );
                },
              ),
      ),
    );
  }

  String? _resolveLocalCoverPath(String? rawPath) {
    if (rawPath == null) {
      return null;
    }

    final trimmed = rawPath.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final parsed = Uri.tryParse(trimmed);
    if (parsed == null || parsed.scheme.isEmpty) {
      return trimmed;
    }

    if (parsed.scheme == 'file') {
      try {
        return parsed.toFilePath(windows: Platform.isWindows);
      } catch (_) {
        return null;
      }
    }

    return null;
  }
}
