import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/app_update_checker.dart';
import 'package:yaabsa/util/app_update_state.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/logger.dart';

const String _latestReleasePageUrl = 'https://github.com/Vito0912/yaabsa/releases/latest';

enum AppUpdateDialogAction { later, skipVersion }

class AppUpdateStartupTrigger extends StatefulWidget {
  const AppUpdateStartupTrigger({super.key});

  @override
  State<AppUpdateStartupTrigger> createState() => _AppUpdateStartupTriggerState();
}

class _AppUpdateStartupTriggerState extends State<AppUpdateStartupTrigger> {
  static Future<({AppUpdateCoordinator coordinator, AppUpdateCheckResult? result})>? _pendingCheck;
  static bool _resultHandled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(_handleUpdateCheck());
      }
    });
  }

  Future<void> _handleUpdateCheck() async {
    try {
      final pending = _pendingCheck ??= _startUpdateCheck();
      final (:coordinator, :result) = await pending;

      if (!mounted || _resultHandled) {
        return;
      }
      _resultHandled = true;

      if (result == null || !coordinator.shouldNotify(result)) {
        return;
      }

      final latestVersion = result.latestVersion;
      if (latestVersion == null) {
        return;
      }

      final action = await showAppUpdateDialog(
        context,
        currentVersion: result.currentVersion,
        latestVersion: latestVersion,
      );

      if (action == AppUpdateDialogAction.skipVersion) {
        await coordinator.skipVersion(latestVersion);
      }
    } catch (e, s) {
      logger(
        'App update notification check failed without affecting startup: $e\n$s',
        tag: 'AppUpdateNotifier',
        level: InfoLevel.warning,
      );
    }
  }

  static Future<({AppUpdateCoordinator coordinator, AppUpdateCheckResult? result})> _startUpdateCheck() async {
    final settingsManager = containerRef.read(settingsManagerProvider.notifier);
    final coordinator = AppUpdateCoordinator(
      checker: const AppUpdateChecker(),
      stateStore: SettingsManagerAppUpdateStateStore(settingsManager),
    );
    final result = await coordinator.checkIfDue(packageInfo.version);
    return (coordinator: coordinator, result: result);
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

Future<void> _openLatestRelease() async {
  try {
    final launched = await launchUrl(Uri.parse(_latestReleasePageUrl), mode: LaunchMode.externalApplication);
    if (!launched) {
      logger('Could not open the latest Yaabsa release page.', tag: 'AppUpdateNotifier', level: InfoLevel.warning);
    }
  } catch (e, s) {
    logger('Failed to open the latest Yaabsa release page: $e\n$s', tag: 'AppUpdateNotifier', level: InfoLevel.warning);
  }
}

Future<AppUpdateDialogAction?> showAppUpdateDialog(
  BuildContext context, {
  required String currentVersion,
  required String latestVersion,
}) {
  return showDialog<AppUpdateDialogAction>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('New Yaabsa release'),
        content: Text(
          'Version $latestVersion has been released. You are using $currentVersion.\n\n'
          'Store availability may lag behind upstream releases.',
        ),
        actions: [
          TextButton(onPressed: () => unawaited(_openLatestRelease()), child: const Text('View release')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(AppUpdateDialogAction.skipVersion),
            child: const Text('Skip this version'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(AppUpdateDialogAction.later),
            child: const Text('Later'),
          ),
        ],
      );
    },
  );
}
