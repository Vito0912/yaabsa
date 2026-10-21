import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/changelog/changelog_dialog.dart';
import 'package:yaabsa/util/logger.dart';

class ChangelogStartupTrigger extends StatefulWidget {
  const ChangelogStartupTrigger({super.key});

  @override
  State<ChangelogStartupTrigger> createState() => _ChangelogStartupTriggerState();
}

class _ChangelogStartupTriggerState extends State<ChangelogStartupTrigger> with WidgetsBindingObserver {
  bool _started = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShow());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _maybeShow();
    }
  }

  Future<void> _maybeShow() async {
    if (_started || !mounted || WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
      return;
    }

    _started = true;

    try {
      await showStartupChangelog(context);
    } catch (error, stack) {
      logger('Changelog presentation failed: $error\n$stack', tag: 'Changelog', level: InfoLevel.warning);
    }
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
