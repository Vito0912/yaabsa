import 'dart:async';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/settings/settings_button.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_slider.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/download_destination.dart';
import 'package:yaabsa/util/globals.dart' show downloadHandler;
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

class DownloadSettings extends ConsumerStatefulWidget {
  const DownloadSettings({super.key});

  static const String routeName = '/settings/downloads';

  @override
  ConsumerState<DownloadSettings> createState() => _DownloadSettingsState();
}

class _DownloadSettingsState extends ConsumerState<DownloadSettings> {
  bool _isPicking = false;
  late final Future<String> _defaultLocationFuture;

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    _defaultLocationFuture = defaultDownloadLocationDescription();
  }

  Future<void> _pickLocation(String userId) async {
    if (!supportsCustomDownloadLocation || _isPicking) return;

    final l10n = context.l10n;
    setState(() => _isPicking = true);
    try {
      String? nextValue;
      if (!kIsWeb && Platform.isAndroid) {
        final pickedUri = await FileDownloader().uri.pickDirectory(
          startLocation: SharedStorage.downloads,
          persistedUriPermission: true,
        );
        nextValue = pickedUri?.toString();
      } else if (!kIsWeb && (Platform.isLinux || Platform.isWindows)) {
        final directoryUri = await FilePicker.pickDirectory(dialogTitle: l10n.actionChooseFolder);
        final directoryPath = directoryUri?.toFilePath();
        if (directoryPath != null && directoryPath.trim().isNotEmpty) {
          nextValue = encodeDesktopDownloadLocation(directoryPath);
        }
      }
      if (nextValue == null) return;
      await ref
          .read(settingsManagerProvider.notifier)
          .setUserSetting<String>(userId, SettingKeys.downloadPath, nextValue);
      _showMessage(l10n.statusDownloadLocationUpdated);
    } catch (e) {
      _showMessage(l10n.errorOperationFailed(l10n.operationSaveDownloadLocation, e.toString()));
    } finally {
      if (mounted) setState(() => _isPicking = false);
    }
  }

  Future<void> _resetToDefaultLocation(String userId) async {
    if (_isPicking) return;

    final l10n = context.l10n;
    setState(() => _isPicking = true);
    try {
      await ref.read(settingsManagerProvider.notifier).setUserSetting<String>(userId, SettingKeys.downloadPath, '');
      _showMessage(l10n.statusUsingDefaultDownloadLocation);
    } finally {
      if (mounted) setState(() => _isPicking = false);
    }
  }

  Future<void> _handleLocationAction(String userId, {required bool hasCustomLocation}) async {
    if (!supportsCustomDownloadLocation || _isPicking) return;
    if (!hasCustomLocation) {
      await _pickLocation(userId);
      return;
    }
    final selectedAction = await showModalBottomSheet<_LocationAction>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.folder_open),
              title: Text(context.l10n.actionChooseFolder),
              onTap: () => Navigator.of(context).pop(_LocationAction.choose),
            ),
            ListTile(
              leading: const Icon(Icons.restart_alt_rounded),
              title: Text(context.l10n.actionUseDefaultLocation),
              onTap: () => Navigator.of(context).pop(_LocationAction.useDefault),
            ),
          ],
        ),
      ),
    );
    if (selectedAction == _LocationAction.choose) await _pickLocation(userId);
    if (selectedAction == _LocationAction.useDefault) await _resetToDefaultLocation(userId);
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(appDatabaseProvider);
    return SettingsPageScaffold(
      title: context.l10n.navDownloads,
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        ref
            .watch(currentUserProvider)
            .when(
              data: (user) {
                if (user == null) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(context.l10n.promptSignInToManageSettings),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SettingsNavigationSection(
                      title: context.l10n.headingDownloadBehavior,
                      topPadding: 8,
                      items: [
                        SettingsNavigationItem(
                          icon: Icons.download_for_offline_rounded,
                          title: context.l10n.settingSmartDownloads,
                          onTap: () => context.push('/settings/library/smart-downloads'),
                        ),
                      ],
                      settings: [
                        StreamBuilder<UserSettingEntry?>(
                          stream: db.watchUserSetting(user.id, SettingKeys.downloadPath),
                          builder: (context, snapshot) {
                            final fallback = ref
                                .read(settingsManagerProvider.notifier)
                                .getUserSetting<String>(user.id, SettingKeys.downloadPath, defaultValue: '');
                            final raw = snapshot.data?.value ?? fallback;
                            final custom = parseDownloadLocationSetting(raw) != null;
                            return FutureBuilder<String>(
                              future: _defaultLocationFuture,
                              builder: (context, locationSnapshot) => SettingButton(
                                label: context.l10n.settingDownloadLocation,
                                description: custom
                                    ? formatDownloadLocationForDisplay(raw)
                                    : (locationSnapshot.data ?? context.l10n.statusLoading),
                                buttonText: custom ? context.l10n.actionChange : context.l10n.actionChoose,
                                buttonIcon: Icons.folder_open,
                                onPressed: supportsCustomDownloadLocation
                                    ? () => _handleLocationAction(user.id, hasCustomLocation: custom)
                                    : null,
                                isLoading: _isPicking,
                              ),
                            );
                          },
                        ),
                        StreamBuilder<UserSettingEntry?>(
                          stream: db.watchUserSetting(user.id, SettingKeys.downloadTypePreference),
                          builder: (context, snapshot) {
                            final fallback = ref
                                .read(settingsManagerProvider.notifier)
                                .getUserSetting<String>(
                                  user.id,
                                  SettingKeys.downloadTypePreference,
                                  defaultValue: 'askEveryTime',
                                );
                            final value = SettingsParser.decodeValue<String>(snapshot.data?.value, fallback);
                            return SettingDropdown<String>.remote(
                              label: context.l10n.settingDownloadPreference,
                              description: context.l10n.settingDownloadPreferenceDescription,
                              value: value,
                              values: const ['askEveryTime', 'audiobook', 'ebook', 'both'],
                              valueLabels: [
                                context.l10n.optionAskEveryTime,
                                context.l10n.optionAudiobookOnly,
                                context.l10n.optionEbookOnly,
                                context.l10n.optionBoth,
                              ],
                              onValueChanged: (newValue) => ref
                                  .read(settingsManagerProvider.notifier)
                                  .setUserSetting<String>(user.id, SettingKeys.downloadTypePreference, newValue),
                            );
                          },
                        ),
                        SettingSwitchTile(
                          label: context.l10n.settingDownloadAllAudioFiles,
                          settingKey: SettingKeys.downloadAllAudioFiles,
                          userId: user.id,
                          subtitle: context.l10n.settingDownloadAllAudioFilesDescription,
                        ),
                        SettingSwitchTile(
                          label: context.l10n.settingDownloadOnlyOnWiFi,
                          settingKey: SettingKeys.downloadOnlyOnWifi,
                          userId: user.id,
                          subtitle: context.l10n.settingDownloadOnlyOnWiFiDescription,
                          onChanged: (_) => unawaited(downloadHandler.applyDownloadSettings()),
                        ),
                        SettingSlider<int>(
                          label: context.l10n.settingMaximumParallelDownloads,
                          values: const <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                          valueLabels: List<String>.generate(10, (index) {
                            final fileCount = index + 1;
                            return context.l10n.fileCount(fileCount);
                          }),
                          settingKey: SettingKeys.downloadMaxParallel,
                          userId: user.id,
                          onChanged: (_) => unawaited(downloadHandler.applyDownloadSettings()),
                        ),
                      ],
                    ),
                  ],
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: YaabsaCircularProgressIndicator()),
              ),
              error: (error, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text(context.l10n.errorOperationFailed(context.l10n.operationLoadSettings, error.toString())),
              ),
            ),
      ],
    );
  }
}

enum _LocationAction { choose, useDefault }
