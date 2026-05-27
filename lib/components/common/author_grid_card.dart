import 'package:flutter/material.dart';
import 'package:yaabsa/components/common/author_card.dart';

class AuthorGridCard extends StatelessWidget {
  const AuthorGridCard({super.key, required this.authorId, required this.name, this.subtitle, this.onTap});

  final String authorId;
  final String name;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final subtitleText = subtitle?.trim();

    final cardContent = Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final imageSize = constraints.maxWidth;
                return AuthorImage(authorId: authorId, width: imageSize, height: imageSize, borderRadius: 16);
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(name, maxLines: 2, overflow: TextOverflow.ellipsis),
          if (subtitleText != null && subtitleText.isNotEmpty)
            Text(
              subtitleText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
        ],
      ),
    );

    return onTap == null
        ? cardContent
        : InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16), child: cardContent);
  }
}
