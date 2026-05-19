import 'package:flutter/material.dart';

import 'package:yaabsa/generated/l10n.dart';

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
      return Material(
        type: MaterialType.transparency,
        child: DropdownButton<int>(
          value: itemsPerPage,
          onChanged: (isLoading || onItemsPerPageChanged == null)
              ? null
              : (value) {
                  if (value == null) {
                    return;
                  }
                  onItemsPerPageChanged!(value);
                },
          items: options
              .map((option) => DropdownMenuItem<int>(value: option, child: Text(option.toString())))
              .toList(growable: false),
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
                  Expanded(
                    child: Text(
                      S.current.componentsSessionsListeningSessionsPaginationControlsTotal(total),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(S.current.componentsSessionsListeningSessionsPaginationControlsPage(currentPage, clampedPages)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    S.current.componentsSessionsListeningSessionsPaginationControlsPerPage,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 6),
                  buildPerPageSelector(),
                  const Spacer(),
                  IconButton(
                    tooltip: S.current.componentsSessionsListeningSessionsPaginationControlsPreviousPage,
                    onPressed: isLoading ? null : onPrevious,
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                  IconButton(
                    tooltip: S.current.componentsSessionsListeningSessionsPaginationControlsNextPage,
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
            Expanded(
              child: Text(
                S.current.componentsSessionsListeningSessionsPaginationControlsTotal(total),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              S.current.componentsSessionsListeningSessionsPaginationControlsPerPage,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(width: 6),
            buildPerPageSelector(),
            const SizedBox(width: 12),
            Text(
              S.current.componentsSessionsListeningSessionsPaginationControlsPage(currentPage, clampedPages),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: S.current.componentsSessionsListeningSessionsPaginationControlsPreviousPage,
              onPressed: isLoading ? null : onPrevious,
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            IconButton(
              tooltip: S.current.componentsSessionsListeningSessionsPaginationControlsNextPage,
              onPressed: isLoading ? null : onNext,
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        );
      },
    );
  }
}
