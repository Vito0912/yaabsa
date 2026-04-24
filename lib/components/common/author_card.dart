import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/components/common/cover_loading_placeholder.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';

class AuthorCard extends StatelessWidget {
  const AuthorCard({
    super.key,
    required this.authorId,
    required this.name,
    this.subtitle,
    this.description,
    this.compact = false,
    this.onTap,
  });

  final String authorId;
  final String name;
  final String? subtitle;
  final String? description;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final imageSize = compact ? (context.isMobile ? 54.0 : 58.0) : (context.isMobile ? 64.0 : 72.0);
    final titleStyle = compact ? Theme.of(context).textTheme.bodyLarge : Theme.of(context).textTheme.titleMedium;
    final subtitleStyle = Theme.of(context).textTheme.bodySmall;

    final cardChild = Padding(
      padding: EdgeInsets.symmetric(horizontal: compact ? 10 : 12, vertical: compact ? 8 : 10),
      child: Row(
        children: [
          AuthorImage(authorId: authorId, width: imageSize, height: imageSize, borderRadius: 12),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(name, maxLines: 2, overflow: TextOverflow.ellipsis, style: titleStyle),
                if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!.trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: subtitleStyle?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ],
                if (description != null && description!.trim().isNotEmpty && !compact) ...[
                  const SizedBox(height: 4),
                  Text(
                    description!.trim(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: subtitleStyle?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ],
              ],
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 6),
            Icon(Icons.chevron_right_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ],
        ],
      ),
    );

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? cardChild : InkWell(onTap: onTap, child: cardChild),
    );
  }
}

class AuthorImage extends ConsumerWidget {
  const AuthorImage({
    super.key,
    required this.authorId,
    required this.width,
    required this.height,
    this.borderRadius = 14,
  });

  final String authorId;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (authorId.trim().isEmpty) {
      return _AuthorImagePlaceholder(width: width, height: height, borderRadius: borderRadius);
    }

    final api = ref.watch(absApiProvider);
    if (api == null) {
      return _AuthorImagePlaceholder(width: width, height: height, borderRadius: borderRadius);
    }

    final imageUri = _buildAuthorImageUri(
      basePath: api.basePathOverride,
      authorId: authorId,
      width: width,
      height: height,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUri.toString(),
        httpHeaders: Map<String, String>.from(api.dio.options.headers),
        width: width,
        height: height,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 120),
        fadeOutDuration: const Duration(milliseconds: 70),
        placeholder: (context, url) => const CoverLoadingPlaceholder(borderRadius: 0),
        errorWidget: (context, url, error) => _AuthorImagePlaceholder(width: width, height: height, borderRadius: 0),
      ),
    );
  }
}

Uri _buildAuthorImageUri({
  required String basePath,
  required String authorId,
  required double width,
  required double height,
}) {
  final queryParams = <String, String>{
    if (width > 0) 'width': width.round().toString(),
    if (height > 0) 'height': height.round().toString(),
  };
  final base = Uri.parse('$basePath/api/authors/$authorId/image');
  return queryParams.isEmpty ? base : base.replace(queryParameters: queryParams);
}

class _AuthorImagePlaceholder extends StatelessWidget {
  const _AuthorImagePlaceholder({required this.width, required this.height, required this.borderRadius});

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorScheme.surfaceContainerHighest, colorScheme.surfaceContainer],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.7)),
        ),
        child: Icon(Icons.person_outline_rounded, size: width * 0.45, color: colorScheme.onSurfaceVariant),
      ),
    );
  }
}
