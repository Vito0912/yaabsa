import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:yaabsa/api/library_items/library_item.dart';

class ItemDescription extends StatefulWidget {
  const ItemDescription({super.key, required this.item, this.useCard = true});

  final LibraryItem item;
  final bool useCard;

  @override
  State<ItemDescription> createState() => _ItemDescriptionState();
}

class _ItemDescriptionState extends State<ItemDescription> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final description = widget.item.media?.bookMedia?.metadata.description;

    if (description != null && description.trim().isNotEmpty) {
      final preview = _plainTextPreview(description);

      final content = Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DESCRIPTION', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 6),
            if (_expanded)
              SelectionArea(
                child: Html(
                  data: description,
                  shrinkWrap: true,
                  style: {
                    'html': Style(margin: Margins.zero, padding: HtmlPaddings.zero),
                    'body': Style(
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                      fontSize: FontSize((Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14)),
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    'p': Style(margin: Margins.zero, padding: HtmlPaddings.zero),
                  },
                ),
              )
            else
              Text(
                preview,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              child: Text(_expanded ? 'Show less' : 'Show more'),
            ),
          ],
        ),
      );

      if (!widget.useCard) {
        return content;
      }

      return Card(elevation: 0, clipBehavior: Clip.antiAlias, child: content);
    }
    return const SizedBox.shrink();
  }
}

String _plainTextPreview(String htmlText) {
  final withoutTags = htmlText.replaceAll(RegExp(r'<[^>]*>'), ' ');
  final normalizedSpaces = withoutTags.replaceAll(RegExp(r'\s+'), ' ').trim();
  return normalizedSpaces;
}
