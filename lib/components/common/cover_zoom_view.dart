import 'dart:io' show File;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:yaabsa/components/common/cover_placeholder.dart';

import 'package:yaabsa/generated/l10n.dart';

Map<String, String> normalizeImageRequestHeaders(Map<String, dynamic>? headers) {
  if (headers == null || headers.isEmpty) {
    return const <String, String>{};
  }

  final normalized = <String, String>{};
  headers.forEach((key, value) {
    if (value == null) {
      return;
    }
    normalized[key] = value.toString();
  });

  return normalized;
}

ImageProvider<Object>? coverImageProviderFromUri(
  Uri? coverUri, {
  Map<String, String> requestHeaders = const <String, String>{},
}) {
  if (coverUri == null) {
    return null;
  }

  if (coverUri.scheme == 'file') {
    return FileImage(File(coverUri.toFilePath()));
  }

  final headers = requestHeaders.isEmpty ? null : requestHeaders;
  return NetworkImage(coverUri.toString(), headers: headers);
}

Future<void> openCoverZoomView(
  BuildContext context, {
  required Uri coverUri,
  Map<String, String> requestHeaders = const <String, String>{},
  String? semanticsLabel,
}) async {
  final imageProvider = coverImageProviderFromUri(coverUri, requestHeaders: requestHeaders);
  if (imageProvider == null) {
    return;
  }

  await showGeneralDialog<void>(
    context: context,
    useRootNavigator: true,
    barrierDismissible: true,
    barrierLabel: 'Dismiss cover zoom view',
    barrierColor: Colors.black.withValues(alpha: 0.42),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, animation, secondaryAnimation) {
      return _CoverZoomView(imageProvider: imageProvider, semanticsLabel: semanticsLabel);
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: fade,
        child: ScaleTransition(scale: Tween<double>(begin: 0.96, end: 1).animate(fade), child: child),
      );
    },
  );
}

class _CoverZoomView extends StatelessWidget {
  const _CoverZoomView({required this.imageProvider, this.semanticsLabel});

  final ImageProvider<Object> imageProvider;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final coverEdge = math.min(constraints.maxWidth * 0.88, constraints.maxHeight * 0.84);

          return Stack(
            children: [
              Center(
                child: SizedBox(
                  width: coverEdge,
                  height: coverEdge,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 28,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: ColoredBox(
                        color: Colors.black.withValues(alpha: 0.18),
                        child: InteractiveViewer(
                          minScale: 1,
                          maxScale: 6,
                          child: Center(
                            child: Semantics(
                              image: true,
                              label: semanticsLabel ?? 'Book cover',
                              child: Image(
                                image: imageProvider,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.medium,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }

                                  final expectedBytes = loadingProgress.expectedTotalBytes;
                                  final progress = expectedBytes == null
                                      ? null
                                      : loadingProgress.cumulativeBytesLoaded / expectedBytes;

                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: progress,
                                      strokeWidth: 2.8,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const SizedBox(
                                    width: 240,
                                    height: 240,
                                    child: CoverPlaceholder(borderRadius: 14),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  tooltip: S.current.componentsCommonCoverZoomViewClose,
                  onPressed: () => Navigator.of(context).maybePop(),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withValues(alpha: 0.4),
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
