import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/common/additional_information_text.dart';
import 'package:yaabsa/components/common/author_card.dart';
import 'package:yaabsa/util/library_view_subtitles.dart';

class AuthorGridCard extends StatelessWidget {
  const AuthorGridCard({
    super.key,
    required this.authorId,
    required this.name,
    this.imagePath,
    this.subtitle,
    this.onTap,
  });

  final String authorId;
  final String name;
  final String? imagePath;
  final LibraryViewSubtitle? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
                return AuthorImage(
                  authorId: authorId,
                  imagePath: imagePath,
                  width: imageSize,
                  height: imageSize,
                  borderRadius: 16,
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(name, maxLines: 2, overflow: TextOverflow.ellipsis),
          if (subtitle != null && !subtitle!.isEmpty)
            AdditionalInformationText(
              subtitle: subtitle!,
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
