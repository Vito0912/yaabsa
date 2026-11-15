import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/buttons/sort_button.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/globals.dart';

class SeriesDetailHeader extends StatelessWidget {
  const SeriesDetailHeader({
    required this.onBack,
    required this.onSortPressed,
    required this.sortLabel,
    super.key,
    this.title,
    this.subtitle,
    this.isTitleLoading = false,
    this.hasTitleError = false,
    this.isSortBusy = false,
  });

  final VoidCallback onBack;
  final VoidCallback onSortPressed;
  final String sortLabel;
  final String? title;
  final String? subtitle;
  final bool isTitleLoading;
  final bool hasTitleError;
  final bool isSortBusy;

  @override
  Widget build(BuildContext context) {
    final resolvedSubtitle = subtitle?.trim();
    final hasSubtitle = resolvedSubtitle != null && resolvedSubtitle.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back_rounded), tooltip: 'Back'),
              const SizedBox(width: 6),
              Expanded(
                child: _SeriesDetailTitle(title: title, isLoading: isTitleLoading, hasError: hasTitleError),
              ),
              const SizedBox(width: 4),
              YaabsaSortButton(
                label: sortLabel,
                tooltip: 'Sort: $sortLabel',
                onPressed: onSortPressed,
                iconOnly: context.isMobile,
                isLoading: isSortBusy,
              ),
            ],
          ),
          if (hasSubtitle)
            Padding(
              padding: const EdgeInsets.fromLTRB(58, 0, 0, 0),
              child: Text(
                resolvedSubtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }
}

class _SeriesDetailTitle extends StatelessWidget {
  const _SeriesDetailTitle({required this.title, required this.isLoading, required this.hasError});

  final String? title;
  final bool isLoading;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final resolvedTitle = title?.trim();
    if (resolvedTitle != null && resolvedTitle.isNotEmpty) {
      return Text(
        resolvedTitle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleMedium,
      );
    }

    if (isLoading) {
      return const Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(width: 20, height: 20, child: YaabsaCircularProgressIndicator(strokeWidth: 2.2)),
      );
    }

    if (hasError) {
      return Text(
        'Series details could not be loaded.',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleMedium,
      );
    }

    return const SizedBox.shrink();
  }
}
