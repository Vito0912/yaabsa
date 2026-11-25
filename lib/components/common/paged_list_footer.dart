import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

class PagedListFooter extends StatelessWidget {
  const PagedListFooter({super.key, required this.loading, required this.onLoadMore, this.error});

  final bool loading;
  final Object? error;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Center(
        child: loading
            ? const YaabsaCircularProgressIndicator()
            : TextButton.icon(
                onPressed: onLoadMore,
                icon: Icon(error == null ? Icons.expand_more_rounded : Icons.refresh_rounded),
                label: Text(error == null ? context.l10n.actionLoadMore : context.l10n.errorLoadMoreRetry),
              ),
      ),
    );
  }
}
