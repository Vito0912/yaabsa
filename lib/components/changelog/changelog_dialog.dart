import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaabsa/components/changelog/changelog_release_card.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/aaos_service.dart';
import 'package:yaabsa/util/changelog.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

Future<void>? _startupPresentation;

Future<void> showStartupChangelog(BuildContext context) {
  return _startupPresentation ??= _showStartupChangelog(context);
}

Future<void> _showStartupChangelog(BuildContext context) async {
  if (Changelog.pendingReleases.isEmpty || AaosService.instance.currentState.isAutomotiveDevice) {
    return;
  }

  await showChangelogDialog(context, releases: Changelog.pendingReleases);
  await containerRef
      .read(settingsManagerProvider.notifier)
      .setGlobalSetting(SettingKeys.changelogLastVersion, packageInfo.version);
  Changelog.pendingReleases = const [];
}

Future<void> showChangelogDialog(BuildContext context, {List<ChangelogRelease>? releases}) {
  return showDialog<void>(
    context: context,
    builder: (context) => ChangelogDialog(releases: releases),
  );
}

class ChangelogDialog extends StatefulWidget {
  const ChangelogDialog({super.key, this.releases});

  final List<ChangelogRelease>? releases;

  @override
  State<ChangelogDialog> createState() => _ChangelogDialogState();
}

class _ChangelogDialogState extends State<ChangelogDialog> {
  final ScrollController _scrollController = ScrollController();

  late Future<List<ChangelogRelease>> _releases;
  late bool _disabled;
  bool _saving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _releases = _loadReleases();
    _disabled = containerRef
        .read(settingsManagerProvider.notifier)
        .getGlobalSetting<bool>(SettingKeys.changelogDisabled, defaultValue: false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<ChangelogRelease>> _loadReleases() async {
    final releases = widget.releases ?? await Changelog.load();
    return releases.where((release) {
      return !Changelog.isNewerVersion(release.version, packageInfo.version);
    }).toList();
  }

  Future<void> _setDisabled(bool? value) async {
    if (value == null) {
      return;
    }

    setState(() {
      _saving = true;
      _errorMessage = null;
    });

    try {
      await containerRef.read(settingsManagerProvider.notifier).setGlobalSetting(SettingKeys.changelogDisabled, value);
      if (mounted) {
        setState(() {
          _disabled = value;
        });
      }
    } catch (error, stack) {
      logger('Could not save changelog preference: $error\n$stack', tag: 'Changelog', level: InfoLevel.warning);
      if (mounted) {
        setState(() {
          _errorMessage = context.l10n.changelogErrorSavePreference;
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

  Future<void> _sponsor() async {
    try {
      final opened = await launchUrl(
        Uri.parse('https://github.com/sponsors/Vito0912'),
        mode: LaunchMode.externalApplication,
      );
      if (opened) {
        return;
      }
    } catch (error, stack) {
      logger('Could not open Sponsors: $error\n$stack', tag: 'Changelog', level: InfoLevel.warning);
    }

    if (mounted) {
      setState(() {
        _errorMessage = context.l10n.changelogErrorSponsorOpen;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final padding = context.isMobile ? 8.0 : 12.0;

    return Dialog(
      insetPadding: EdgeInsets.all(context.isMobile ? 12 : 32),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 680, maxHeight: MediaQuery.sizeOf(context).height * 0.88),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, padding, padding, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.releases == null ? context.l10n.changelogTitle : context.l10n.changelogWhatsNew,
                          style: theme.textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: context.l10n.actionClose,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Flexible(
              child: FutureBuilder<List<ChangelogRelease>>(
                future: _releases,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(context.l10n.changelogErrorLoad),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _releases = _loadReleases();
                              });
                            },
                            icon: const Icon(Icons.refresh),
                            label: Text(context.l10n.actionRetry),
                          ),
                        ],
                      ),
                    );
                  }

                  final releases = snapshot.data;
                  if (releases == null) {
                    return const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: YaabsaCircularProgressIndicator()),
                    );
                  }

                  return Scrollbar(
                    controller: _scrollController,
                    child: ListView(
                      controller: _scrollController,
                      primary: false,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 8),
                      children: [
                        if (releases.isEmpty) Text(context.l10n.changelogNoReleaseNotes),
                        for (final (index, release) in releases.indexed)
                          ChangelogReleaseCard(
                            release: release,
                            initiallyExpanded: index == 0,
                            onSponsor: index == 0 ? _sponsor : null,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(_errorMessage!, style: TextStyle(color: colors.error)),
                    ),
                  OverflowBar(
                    alignment: MainAxisAlignment.spaceBetween,
                    overflowAlignment: OverflowBarAlignment.end,
                    overflowSpacing: 8,
                    children: [
                      SizedBox(
                        width: 200,
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          dense: true,
                          title: Text(context.l10n.changelogDontShowAgain),
                          value: _disabled,
                          onChanged: _saving ? null : _setDisabled,
                        ),
                      ),
                      FilledButton(onPressed: () => Navigator.of(context).pop(), child: Text(context.l10n.actionDone)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
