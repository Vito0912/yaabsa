import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaabsa/components/changelog/changelog_release_card.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/aaos_service.dart';
import 'package:yaabsa/util/changelog.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/setting_key.dart';

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
          _errorMessage = 'Could not save your preference. Please try again.';
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
        _errorMessage = 'Could not open GitHub Sponsors. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final padding = context.isMobile ? 16.0 : 24.0;

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
              padding: EdgeInsets.fromLTRB(padding, padding, padding, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.releases == null ? 'Changelog' : 'What’s new',
                          style: theme.textTheme.headlineSmall,
                        ),
                        Text('Yaabsa ${packageInfo.version}', style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
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
                          const Text('Could not load the changelog.'),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _releases = _loadReleases();
                              });
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Try again'),
                          ),
                        ],
                      ),
                    );
                  }

                  final releases = snapshot.data;
                  if (releases == null) {
                    return const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
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
                        if (widget.releases != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              'Explore what’s changed since your last version.',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        if (releases.isEmpty) const Text('No release notes are available for this version yet.'),
                        for (final (index, release) in releases.indexed)
                          ChangelogReleaseCard(release: release, initiallyExpanded: index == 0),
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
                      TextButton.icon(
                        onPressed: _sponsor,
                        style: TextButton.styleFrom(foregroundColor: colors.onSurfaceVariant),
                        icon: const Icon(Icons.favorite_outline),
                        label: const Text('Sponsor'),
                      ),
                      Wrap(
                        alignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          Tooltip(
                            message: 'You can always open the changelog in Settings.',
                            child: SizedBox(
                              width: 200,
                              child: CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                controlAffinity: ListTileControlAffinity.leading,
                                dense: true,
                                title: const Text('Don’t show again'),
                                value: _disabled,
                                onChanged: _saving ? null : _setDisabled,
                              ),
                            ),
                          ),
                          FilledButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Done')),
                        ],
                      ),
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
