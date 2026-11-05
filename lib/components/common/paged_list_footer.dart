import 'package:material_ui/material_ui.dart';

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
            ? const CircularProgressIndicator()
            : TextButton.icon(
                onPressed: onLoadMore,
                icon: Icon(error == null ? Icons.expand_more_rounded : Icons.refresh_rounded),
                label: Text(error == null ? 'Load more' : 'Could not load more. Retry'),
              ),
      ),
    );
  }
}
