import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/inputs/expressive_dropdown.dart';
import 'package:yaabsa/ui/components/settings/settings_switch_presentation.dart';
import 'package:yaabsa/screens/player/layout/player_layout_config.dart';
import 'package:yaabsa/screens/player/player_empty_state_mode.dart';
import 'package:yaabsa/util/l10n.dart';

class PlayerComponentSettingsSheet extends StatefulWidget {
  const PlayerComponentSettingsSheet({
    super.key,
    required this.componentType,
    required this.profile,
    required this.onChanged,
  });

  final PlayerComponentType componentType;
  final PlayerLayoutProfile profile;
  final ValueChanged<PlayerLayoutProfile> onChanged;

  @override
  State<PlayerComponentSettingsSheet> createState() => _PlayerComponentSettingsSheetState();
}

class _PlayerComponentSettingsSheetState extends State<PlayerComponentSettingsSheet> {
  late PlayerLayoutProfile _profile;

  @override
  void initState() {
    super.initState();
    _profile = widget.profile;
  }

  PlayerComponentPlacement get _placement => _profile.placementFor(widget.componentType);

  String _formatSettingDecimal(BuildContext context, double value) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return NumberFormat.decimalPatternDigits(locale: locale, decimalDigits: 1).format(value);
  }

  void _setProfile(PlayerLayoutProfile nextProfile) {
    setState(() {
      _profile = nextProfile;
    });
    widget.onChanged(nextProfile);
  }

  void _updatePlacement(PlayerComponentPlacement nextPlacement) {
    _setProfile(_profile.upsertPlacement(nextPlacement));
  }

  void _toggleUtilityVisibility(PlayerUtilityType utility, bool enabled) {
    final hidden = <PlayerUtilityType>{..._profile.hiddenUtilities};
    if (enabled) {
      hidden.remove(utility);
    } else {
      hidden.add(utility);
    }

    _setProfile(_profile.copyWith(hiddenUtilities: hidden.toList(growable: false)));
  }

  void _moveUtility(int index, int delta) {
    final nextIndex = index + delta;
    if (nextIndex < 0 || nextIndex >= _profile.utilityOrder.length) {
      return;
    }

    final nextOrder = List<PlayerUtilityType>.from(_profile.utilityOrder);
    final item = nextOrder.removeAt(index);
    nextOrder.insert(nextIndex, item);
    _setProfile(_profile.copyWith(utilityOrder: nextOrder));
  }

  @override
  Widget build(BuildContext context) {
    final placement = _placement;
    final maxScale = widget.componentType == PlayerComponentType.controls ? 1.0 : 1.8;
    final scale = placement.scale.clamp(0.6, maxScale).toDouble();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                context.l10n.headingNamedSettings(widget.componentType.label(context.l10n)),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              SettingsSwitchPresentation(
                value: placement.cardStyle,
                label: context.l10n.settingUseCardStyle,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                onChanged: (bool value) {
                  _updatePlacement(placement.copyWith(cardStyle: value));
                },
              ),
              const SizedBox(height: 6),
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        context.l10n.metadataFieldValue(context.l10n.fieldScale, context.l10n.settingScaleValue(scale)),
                      ),
                      Slider(
                        value: scale,
                        min: 0.6,
                        max: maxScale,
                        divisions: ((maxScale - 0.6) * 20).round(),
                        label: context.l10n.settingScaleValue(scale),
                        onChanged: (double value) {
                          _updatePlacement(placement.copyWith(scale: value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.componentType == PlayerComponentType.mediaInfo) ...<Widget>[
                const SizedBox(height: 10),
                SettingsSwitchPresentation(
                  value: placement.showAuthor,
                  label: context.l10n.settingShowField(context.l10n.fieldAuthor),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  onChanged: (bool value) {
                    _updatePlacement(placement.copyWith(showAuthor: value));
                  },
                ),
                SettingsSwitchPresentation(
                  value: placement.showNarrator,
                  label: context.l10n.settingShowField(context.l10n.fieldNarrator),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  onChanged: (bool value) {
                    _updatePlacement(placement.copyWith(showNarrator: value));
                  },
                ),
                SettingsSwitchPresentation(
                  value: placement.showSeries,
                  label: context.l10n.settingShowField(context.l10n.navSeries),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  onChanged: (bool value) {
                    _updatePlacement(placement.copyWith(showSeries: value));
                  },
                ),
                const SizedBox(height: 8),
                YaabsaExpressiveDropdownField<PlayerMetadataTextAlign>(
                  value: placement.textAlign,
                  decoration: InputDecoration(labelText: context.l10n.fieldTextAlignment),
                  options: PlayerMetadataTextAlign.values
                      .map(
                        (mode) =>
                            YaabsaDropdownOption<PlayerMetadataTextAlign>(value: mode, label: mode.label(context.l10n)),
                      )
                      .toList(growable: false),
                  onChanged: (PlayerMetadataTextAlign? mode) {
                    if (mode == null) {
                      return;
                    }
                    _updatePlacement(placement.copyWith(textAlign: mode));
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  context.l10n.metadataFieldValue(
                    context.l10n.fieldFontScale,
                    context.l10n.settingScaleValue(placement.mediaInfoFontScale),
                  ),
                ),
                Slider(
                  value: placement.mediaInfoFontScale.clamp(0.75, 1.6),
                  min: 0.75,
                  max: 1.6,
                  divisions: 17,
                  label: context.l10n.settingScaleValue(placement.mediaInfoFontScale),
                  onChanged: (double value) {
                    _updatePlacement(placement.copyWith(mediaInfoFontScale: value));
                  },
                ),
              ],
              if (widget.componentType == PlayerComponentType.cover) ...<Widget>[
                const SizedBox(height: 10),
                YaabsaExpressiveDropdownField<PlayerCoverFitMode>(
                  value: placement.coverFitMode,
                  decoration: InputDecoration(labelText: context.l10n.fieldCoverFitMode),
                  options: PlayerCoverFitMode.values
                      .map(
                        (mode) =>
                            YaabsaDropdownOption<PlayerCoverFitMode>(value: mode, label: mode.label(context.l10n)),
                      )
                      .toList(growable: false),
                  onChanged: (PlayerCoverFitMode? mode) {
                    if (mode == null) {
                      return;
                    }
                    _updatePlacement(placement.copyWith(coverFitMode: mode));
                  },
                ),
              ],
              if (widget.componentType == PlayerComponentType.seekBar) ...<Widget>[
                const SizedBox(height: 10),
                YaabsaExpressiveDropdownField<PlayerSeekTimePlacement>(
                  value: placement.seekTimePlacement,
                  decoration: InputDecoration(labelText: context.l10n.fieldTimeLabelsPosition),
                  options: PlayerSeekTimePlacement.values
                      .map(
                        (mode) =>
                            YaabsaDropdownOption<PlayerSeekTimePlacement>(value: mode, label: mode.label(context.l10n)),
                      )
                      .toList(growable: false),
                  onChanged: (PlayerSeekTimePlacement? mode) {
                    if (mode == null) {
                      return;
                    }
                    _updatePlacement(placement.copyWith(seekTimePlacement: mode));
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  context.l10n.metadataFieldValue(
                    context.l10n.fieldSeekBarHeight,
                    _formatSettingDecimal(context, placement.seekTrackHeight),
                  ),
                ),
                Slider(
                  value: placement.seekTrackHeight.clamp(4.0, 20.0),
                  min: 4.0,
                  max: 20.0,
                  divisions: 16,
                  label: _formatSettingDecimal(context, placement.seekTrackHeight),
                  onChanged: (double value) {
                    _updatePlacement(placement.copyWith(seekTrackHeight: value));
                  },
                ),
                Text(
                  context.l10n.metadataFieldValue(
                    context.l10n.fieldTimeFontSize,
                    _formatSettingDecimal(context, placement.seekTimeLabelFontSize),
                  ),
                ),
                Slider(
                  value: placement.seekTimeLabelFontSize.clamp(8.0, 22.0),
                  min: 8.0,
                  max: 22.0,
                  divisions: 14,
                  label: _formatSettingDecimal(context, placement.seekTimeLabelFontSize),
                  onChanged: (double value) {
                    _updatePlacement(placement.copyWith(seekTimeLabelFontSize: value));
                  },
                ),
              ],
              if (widget.componentType == PlayerComponentType.chapters ||
                  widget.componentType == PlayerComponentType.queue) ...<Widget>[
                const SizedBox(height: 10),
                YaabsaExpressiveDropdownField<PlayerCollectionEmptyMode>(
                  value: placement.emptyMode,
                  decoration: InputDecoration(labelText: context.l10n.fieldEmptyState),
                  options: PlayerCollectionEmptyMode.values
                      .map(
                        (mode) => YaabsaDropdownOption<PlayerCollectionEmptyMode>(
                          value: mode,
                          label: mode.label(context.l10n),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (PlayerCollectionEmptyMode? mode) {
                    if (mode == null) {
                      return;
                    }
                    _updatePlacement(placement.copyWith(emptyMode: mode));
                  },
                ),
              ],
              if (widget.componentType == PlayerComponentType.utilities) ...<Widget>[
                const SizedBox(height: 10),
                ..._profile.utilityOrder.indexed.map((entry) {
                  final index = entry.$1;
                  final utility = entry.$2;
                  final enabled = !_profile.hiddenUtilities.contains(utility);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(utility.label(context.l10n)),
                      subtitle: Text(enabled ? context.l10n.statusVisible : context.l10n.optionHidden),
                      trailing: Wrap(
                        spacing: 2,
                        children: <Widget>[
                          IconButton(
                            tooltip: context.l10n.actionMoveDirection(context.l10n.directionUp),
                            onPressed: index > 0 ? () => _moveUtility(index, -1) : null,
                            icon: const Icon(Icons.arrow_upward_rounded),
                          ),
                          IconButton(
                            tooltip: context.l10n.actionMoveDirection(context.l10n.directionDown),
                            onPressed: index < _profile.utilityOrder.length - 1 ? () => _moveUtility(index, 1) : null,
                            icon: const Icon(Icons.arrow_downward_rounded),
                          ),
                          Switch(value: enabled, onChanged: (bool value) => _toggleUtilityVisibility(utility, value)),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
