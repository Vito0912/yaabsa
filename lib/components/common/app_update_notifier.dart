import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/app_update_checker.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/logger.dart';

final AppUpdateCoordinator _appUpdateCoordinator = AppUpdateCoordinator();

class AppUpdateStartupTrigger extends StatefulWidget {
  const AppUpdateStartupTrigger({super.key});

  @override
  State<AppUpdateStartupTrigger> createState() => _AppUpdateStartupTriggerState();
}

class _AppUpdateStartupTriggerState extends State<AppUpdateStartupTrigger> with WidgetsBindingObserver {
  bool _started = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeStart());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _maybeStart();
    }
  }

  Future<void> _maybeStart() async {
    if (_started || !mounted || WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
      return;
    }
    _started = true;

    try {
      final candidate = await _appUpdateCoordinator.attempt(hasConsent: _hasAppUpdateConsent);
      if (candidate == null || !mounted || WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
        return;
      }
      if (!await _hasAppUpdateConsent() || !mounted) {
        return;
      }

      await showAppUpdateDialog(context, candidate: candidate);
    } catch (e, s) {
      logger(
        'App update notification failed without affecting startup: $e\n$s',
        tag: 'AppUpdateNotifier',
        level: InfoLevel.warning,
      );
    }
  }

  Future<bool> _hasAppUpdateConsent() async {
    try {
      final settingsManager = containerRef.read(settingsManagerProvider.notifier);
      if (!settingsManager.isInitialized) return false;

      final cache = containerRef.read(settingsCacheProvider);
      if (!cache.isInitialized || cache.get<String>(appUpdateSettingKey) != 'true') {
        return false;
      }

      final stored = await containerRef.read(appDatabaseProvider).getGlobalSetting(appUpdateSettingKey);
      return stored?.value == 'true';
    } catch (e, s) {
      logger(
        'Treating app update consent as disabled because it could not be read: $e\n$s',
        tag: 'AppUpdateNotifier',
        level: InfoLevel.warning,
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

Future<void> showAppUpdateDialog(BuildContext context, {required AppUpdateCandidate candidate}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('New Yaabsa release'),
        content: Text('Version ${candidate.latestVersion} is available. You are using ${candidate.currentVersion}.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              unawaited(_openRelease(candidate.releaseUri));
            },
            child: const Text('View release'),
          ),
          FilledButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Later')),
        ],
      );
    },
  );
}

Future<void> _openRelease(Uri releaseUri) async {
  try {
    final launched = await launchUrl(releaseUri, mode: LaunchMode.externalApplication);
    if (!launched) {
      logger('Could not open the Yaabsa release page.', tag: 'AppUpdateNotifier', level: InfoLevel.warning);
    }
  } catch (e, s) {
    logger('Failed to open the Yaabsa release page: $e\n$s', tag: 'AppUpdateNotifier', level: InfoLevel.warning);
  }
}
