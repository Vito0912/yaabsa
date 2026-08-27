import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/util/local_cover_path.dart';

class LocalCoverImage extends StatefulWidget {
  const LocalCoverImage({
    super.key,
    required this.coverPath,
    required this.cacheKey,
    required this.placeholder,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final String coverPath;
  final String cacheKey;
  final Widget placeholder;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  State<LocalCoverImage> createState() => _LocalCoverImageState();
}

class _LocalCoverImageState extends State<LocalCoverImage> {
  late Future<String?> _resolvedCoverPath;

  @override
  void initState() {
    super.initState();
    _resolveCoverPath();
  }

  @override
  void didUpdateWidget(covariant LocalCoverImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.coverPath != widget.coverPath || oldWidget.cacheKey != widget.cacheKey) {
      _resolveCoverPath();
    }
  }

  void _resolveCoverPath() {
    _resolvedCoverPath = resolveDisplayCoverPath(widget.coverPath, cacheKey: widget.cacheKey);
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return widget.placeholder;
    }

    return FutureBuilder<String?>(
      future: _resolvedCoverPath,
      builder: (context, snapshot) {
        final coverPath = snapshot.data;
        if (coverPath == null || coverPath.isEmpty) {
          return widget.placeholder;
        }

        return Image.file(
          File(coverPath),
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          errorBuilder: (context, error, stackTrace) => widget.placeholder,
        );
      },
    );
  }
}
