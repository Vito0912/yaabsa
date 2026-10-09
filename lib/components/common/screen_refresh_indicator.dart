import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/common/desktop_page_shortcuts.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';

class ScreenRefreshIndicator extends ConsumerWidget {
  const ScreenRefreshIndicator({super.key, required this.onRefresh, required this.child, this.enabled = true});

  final Future<void> Function() onRefresh;
  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DesktopPageShortcuts(
      onRefresh: enabled ? onRefresh : null,
      child: RefreshIndicator(
        onRefresh: () async {
          if (!enabled) return;
          await Future.wait<void>([
            ref.read(mediaProgressProvider.notifier).refreshAllProgress(),
            Future<void>.sync(onRefresh),
          ]);
        },
        child: child,
      ),
    );
  }
}
