import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

Future<T> runWithLoadingSnackBar<T>({
  required BuildContext context,
  required String message,
  required Future<T> Function() action,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.removeCurrentSnackBar();
  var isClosed = false;
  final controller = messenger.showSnackBar(
    SnackBar(
      duration: const Duration(days: 1),
      content: Row(
        children: [
          const SizedBox(width: 18, height: 18, child: YaabsaCircularProgressIndicator(strokeWidth: 2.2)),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
    ),
  );

  controller.closed.then((_) => isClosed = true);

  try {
    return await action();
  } finally {
    if (messenger.mounted && !isClosed) {
      controller.close();
      await controller.closed;
    }
  }
}
