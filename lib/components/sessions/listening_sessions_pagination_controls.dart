import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';
import 'package:yaabsa/ui/components/inputs/expressive_dropdown.dart';
import 'package:yaabsa/util/l10n.dart';

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

    Widget buildPageAction({required bool previous}) {
      final onPressed = previous ? onPrevious : onNext;

      return YaabsaActionIconButton(
        icon: previous ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
        tooltip: previous ? context.l10n.paginationPreviousPage : context.l10n.paginationNextPage,
        enabled: !isLoading && onPressed != null,
        iconSize: 20,
        buttonSize: 48,
        compact: false,
        variant: YaabsaActionButtonVariant.filledTonal,
        shape: YaabsaActionButtonShape.rounded,
        onPressed: isLoading ? null : onPressed,
      );
    }

    Widget buildPerPageSelector() {
      return SizedBox(
        width: 88,
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 760;

          if (compact) {
            final pageSizeLabel = Text(context.l10n.paginationPerPage, style: Theme.of(context).textTheme.bodyMedium);
            final pageSizeLabelPainter = TextPainter(
              text: TextSpan(text: context.l10n.paginationPerPage, style: Theme.of(context).textTheme.bodyMedium),
              textDirection: Directionality.of(context),
              textScaler: MediaQuery.textScalerOf(context),
              maxLines: 1,
            )..layout();
            final canKeepPageSizeLabelInline = constraints.maxWidth >= pageSizeLabelPainter.width + 6 + 88;
            final pageSizeControl = canKeepPageSizeLabelInline
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [pageSizeLabel, const SizedBox(width: 6), buildPerPageSelector()],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [pageSizeLabel, const SizedBox(height: 4), buildPerPageSelector()],
                  );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(context.l10n.paginationTotal(total), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(
                      context.l10n.paginationPage(currentPage, clampedPages),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    pageSizeControl,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildPageAction(previous: true),
                        const SizedBox(width: 4),
                        buildPageAction(previous: false),
                      ],
                    ),
                  ],
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text(context.l10n.paginationTotal(total), overflow: TextOverflow.ellipsis)),
              Text(context.l10n.paginationPerPage, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(width: 6),
              buildPerPageSelector(),
              const SizedBox(width: 12),
              Text(
                context.l10n.paginationPage(currentPage, clampedPages),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(width: 8),
              buildPageAction(previous: true),
              const SizedBox(width: 4),
              buildPageAction(previous: false),
            ],
          );
        },
      ),
    );
  }
}
