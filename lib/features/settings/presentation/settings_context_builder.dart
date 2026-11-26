import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/features/settings/model/settings_availability.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/aaos_service.dart';
import 'package:yaabsa/util/l10n.dart';

/// Builds a reactive [SettingsContext] subscribed to user, AAOS, and settings providers.
SettingsContext watchSettingsContext(BuildContext context, WidgetRef ref, {required bool isAaos}) {
  ref.watch(settingsManagerProvider);
  ref.watch(userSettingsWatcherProvider);

  final cache = ref.read(settingsCacheProvider);
  final currentUser = ref.watch(currentUserProvider).asData?.value;

  return SettingsContext.fromEnvironment(
    l10n: context.l10n,
    isAaos: isAaos,
    currentUser: currentUser,
    readRawGlobal: (key) => cache.get<String>(key),
    readRawUser: (userId, key) => cache.get<String>(userId, key),
  );
}

class SettingsContextScope extends ConsumerWidget {
  const SettingsContextScope({super.key, required this.builder});

  final Widget Function(BuildContext context, WidgetRef ref, SettingsContext settingsContext) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<AaosTelemetryState>(
      stream: AaosService.instance.stream,
      initialData: AaosService.instance.currentState,
      builder: (context, snapshot) {
        final aaosState = snapshot.data ?? AaosService.instance.currentState;
        final settingsContext = watchSettingsContext(context, ref, isAaos: aaosState.isAutomotiveDevice);

        return builder(context, ref, settingsContext);
      },
    );
  }
}
