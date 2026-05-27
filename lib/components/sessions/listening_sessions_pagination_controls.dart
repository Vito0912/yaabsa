import 'package:flutter/material.dart';
import 'package:yaabsa/components/common/inputs/expressive_dropdown.dart';

class ListeningSessionsPaginationControls extends StatelessWidget {
  const ListeningSessionsPaginationControls({
    required this.page,
    required this.numPages,
    required this.total,
    required this.itemsPerPage,
    super.key,
    this.pageSizeOptions = const <int>[20, 50, 100],
    this.isLoading = false,
    this.onItemsPerPageChanged,
    this.onPrevious,
    this.onNext,
  });

  final int page;
  final int numPages;
  final int total;
  final int itemsPerPage;
  final List<int> pageSizeOptions;
  final bool isLoading;
  final ValueChanged<int>? onItemsPerPageChanged;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final clampedPages = numPages <= 0 ? 1 : numPages;
    final currentPage = page + 1;
    final options = List<int>.from(pageSizeOptions);
    if (!options.contains(itemsPerPage)) {
      options.add(itemsPerPage);
    }

    options.sort((left, right) => left.compareTo(right));

    Widget buildPerPageSelector() {
      return SizedBox(
        width: 96,
        child: YaabsaExpressiveDropdown<int>(
          value: itemsPerPage,
          enabled: !isLoading && onItemsPerPageChanged != null,
          options: options
              .map((option) => YaabsaDropdownOption<int>(value: option, label: option.toString()))
              .toList(growable: false),
          onChanged: (value) {
            if (value == null) {
              return;
            }
            onItemsPerPageChanged?.call(value);
          },
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 760;

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: Text('Total: $total', overflow: TextOverflow.ellipsis)),
                  Text('Page $currentPage / $clampedPages'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Per page:', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(width: 6),
                  buildPerPageSelector(),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Previous page',
                    onPressed: isLoading ? null : onPrevious,
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                  IconButton(
                    tooltip: 'Next page',
                    onPressed: isLoading ? null : onNext,
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: Text('Total: $total', overflow: TextOverflow.ellipsis)),
            Text('Per page:', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(width: 6),
            buildPerPageSelector(),
            const SizedBox(width: 12),
            Text('Page $currentPage / $clampedPages', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Previous page',
              onPressed: isLoading ? null : onPrevious,
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            IconButton(
              tooltip: 'Next page',
              onPressed: isLoading ? null : onNext,
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        );
      },
    );
  }
}
