import 'package:material_ui/material_ui.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:yaabsa/api/library_items/library_item.dart';

class ItemDescription extends StatefulWidget {
  const ItemDescription({super.key, required this.item, this.useCard = true, this.initiallyExpanded = false});

  final LibraryItem item;
  final bool useCard;
  final bool initiallyExpanded;

  @override
  State<ItemDescription> createState() => _ItemDescriptionState();
}

class _ItemDescriptionState extends State<ItemDescription> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final description = widget.item.media?.bookMedia?.metadata.description;

    if (description != null && description.trim().isNotEmpty) {
      final preview = _plainTextPreview(description);

      final content = Padding(
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final previewStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4);
            final painter = TextPainter(
              text: TextSpan(text: preview, style: previewStyle),
              textDirection: Directionality.of(context),
              textScaler: MediaQuery.textScalerOf(context),
              maxLines: 3,
            )..layout(maxWidth: constraints.maxWidth);
            final canExpand =
                painter.didExceedMaxLines ||
                RegExp(r'<(a|img|ul|ol|table)\b', caseSensitive: false).hasMatch(description);
            painter.dispose();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('About this book', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
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
                        'p': Style(margin: Margins.only(bottom: 12), padding: HtmlPaddings.zero),
                      },
                    ),
                  )
                else
                  Text(preview, maxLines: 3, overflow: TextOverflow.ellipsis, style: previewStyle),
                if (canExpand || _expanded) ...[
                  const SizedBox(height: 4),
                  TextButton.icon(
                    icon: Icon(_expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded),
                    onPressed: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    },
                    label: Text(_expanded ? 'Show less' : 'Read more'),
                  ),
                ],
              ],
            );
          },
        ),
      );

      if (!widget.useCard) {
        return content;
      }

      return Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        clipBehavior: Clip.antiAlias,
        child: content,
      );
    }
    return const SizedBox.shrink();
  }
}

String _plainTextPreview(String htmlText) {
  final spacedHtml = htmlText.replaceAll(RegExp(r'</(p|div|li|h[1-6])>|<br\s*/?>', caseSensitive: false), ' ');
  final withoutTags = html_parser.parseFragment(spacedHtml).text ?? '';
  final normalizedSpaces = withoutTags.replaceAll(RegExp(r'\s+'), ' ').trim();
  return normalizedSpaces;
}
