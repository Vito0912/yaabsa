import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/wear/wear_preferences_provider.dart';
import 'package:yaabsa/provider/wear/wear_sign_in_provider.dart';
import 'package:yaabsa/screens/wear/components/wear_browse_scaffold.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/setting_key.dart';

class WearSettingsScreen extends ConsumerStatefulWidget {
  const WearSettingsScreen({super.key});

  @override
  ConsumerState<WearSettingsScreen> createState() => _WearSettingsScreenState();
}

class _WearSettingsScreenState extends ConsumerState<WearSettingsScreen> {
  bool _saving = false;
  String? _error;

  Future<void> _save<T>(String key, T value) async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(settingsManagerProvider.notifier).setGlobalSetting(key, value);
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = wearRequestError(error);
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Future<void> _choose<T>({
    required String title,
    required String key,
    required List<T> options,
    required T current,
    required String Function(T) label,
  }) async {
    final selected = await Navigator.of(context).push<T>(
      MaterialPageRoute(
        builder: (context) => WearBrowseScaffold(
          title: title,
          itemCount: options.length,
          itemBuilder: (context, index) {
            final option = options[index];
            return WearBrowseButton(
              title: label(option),
              primary: option == current,
              icon: option == current ? Icons.check : null,
              onPressed: () => Navigator.of(context).pop(option),
            );
          },
        ),
      ),
    );
    if (selected != null && mounted) {
      await _save(key, selected);
    }
  }

  Widget _toggle({required String title, required String key, required bool value, required IconData icon}) {
    return Semantics(
      toggled: value,
      child: WearBrowseButton(
        title: title,
        titleLines: 2,
        subtitle: value ? context.l10n.statusOn : context.l10n.statusOff,
        icon: icon,
        trailing: Icon(
          value ? Icons.check_circle_rounded : Icons.circle_outlined,
          size: 24,
          color: value ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        onPressed: _saving ? null : () => _save(key, !value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final preferences = ref.watch(wearPreferencesProvider);
    final children = <Widget>[
      WearBrowseButton(
        title: context.l10n.playbackSpeed,
        subtitle: context.l10n.playbackSpeedMultiplier(preferences.speed),
        icon: Icons.speed,
        onPressed: _saving
            ? null
            : () => _choose<double>(
                title: context.l10n.playbackSpeed,
                key: SettingKeys.playbackSpeed,
                options: const [0.5, 0.75, 1, 1.25, 1.5, 1.75, 2, 2.5, 3],
                current: preferences.speed,
                label: (value) => context.l10n.playbackSpeedMultiplier(value),
              ),
      ),
      WearBrowseButton(
        title: context.l10n.fieldRewindInterval,
        subtitle: context.l10n.durationSeconds(preferences.rewindSeconds),
        icon: Icons.replay,
        onPressed: _saving
            ? null
            : () => _choose<int>(
                title: context.l10n.fieldRewindInterval,
                key: SettingKeys.rewindInterval,
                options: const [5, 10, 15, 30, 60],
                current: preferences.rewindSeconds,
                label: (value) => context.l10n.durationSeconds(value),
              ),
      ),
      WearBrowseButton(
        title: context.l10n.fieldFastForwardInterval,
        subtitle: context.l10n.durationSeconds(preferences.forwardSeconds),
        icon: Icons.fast_forward,
        onPressed: _saving
            ? null
            : () => _choose<int>(
                title: context.l10n.fieldFastForwardInterval,
                key: SettingKeys.fastForwardInterval,
                options: const [5, 10, 15, 30, 60],
                current: preferences.forwardSeconds,
                label: (value) => context.l10n.durationSeconds(value),
              ),
      ),
      _toggle(
        title: context.l10n.wearCoverBackground,
        key: SettingKeys.wearCoverBackground,
        value: preferences.coverBackground,
        icon: Icons.image_outlined,
      ),
      _toggle(
        title: context.l10n.wearAmbientTitleAndAuthor,
        key: SettingKeys.wearAmbientMetadata,
        value: preferences.ambientMetadata,
        icon: Icons.watch_outlined,
      ),
      _toggle(
        title: context.l10n.wearCoverGrid,
        key: SettingKeys.wearCoverGrid,
        value: preferences.coverGrid,
        icon: Icons.grid_view_rounded,
      ),
      _toggle(
        title: context.l10n.wearFlatScrolling,
        key: SettingKeys.wearFlatScrolling,
        value: preferences.flatScrolling,
        icon: Icons.view_agenda_outlined,
      ),
      _toggle(
        title: context.l10n.wearItemProgress,
        key: SettingKeys.wearItemProgress,
        value: preferences.itemProgress,
        icon: Icons.timelapse,
      ),
      if (_error != null) Text(_error!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
    ];
    return WearBrowseScaffold(
      title: context.l10n.navSettings,
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}
