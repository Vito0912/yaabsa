import 'package:flutter/material.dart';
import 'package:yaabsa/components/common/inputs/expressive_dropdown.dart';
import 'package:yaabsa/screens/player/layout/player_layout_config.dart';
import 'package:yaabsa/screens/player/player_empty_state_mode.dart';

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

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('${widget.componentType.label} settings', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              SwitchListTile(
                value: placement.cardStyle,
                title: const Text('Use card style'),
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
                      Text('Scale ${placement.scale.toStringAsFixed(2)}x'),
                      Slider(
                        value: placement.scale.clamp(0.6, 1.8),
                        min: 0.6,
                        max: 1.8,
                        divisions: 12,
                        label: '${placement.scale.toStringAsFixed(2)}x',
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
                SwitchListTile(
                  value: placement.showAuthor,
                  onChanged: (bool value) {
                    _updatePlacement(placement.copyWith(showAuthor: value));
                  },
                  title: const Text('Show author'),
                ),
                SwitchListTile(
                  value: placement.showNarrator,
                  onChanged: (bool value) {
                    _updatePlacement(placement.copyWith(showNarrator: value));
                  },
                  title: const Text('Show narrator'),
                ),
                SwitchListTile(
                  value: placement.showSeries,
                  onChanged: (bool value) {
                    _updatePlacement(placement.copyWith(showSeries: value));
                  },
                  title: const Text('Show series'),
                ),
                const SizedBox(height: 8),
                YaabsaExpressiveDropdownField<PlayerMetadataTextAlign>(
                  value: placement.textAlign,
                  decoration: const InputDecoration(labelText: 'Text alignment'),
                  options: PlayerMetadataTextAlign.values
                      .map((mode) => YaabsaDropdownOption<PlayerMetadataTextAlign>(value: mode, label: mode.label))
                      .toList(growable: false),
                  onChanged: (PlayerMetadataTextAlign? mode) {
                    if (mode == null) {
                      return;
                    }
                    _updatePlacement(placement.copyWith(textAlign: mode));
                  },
                ),
                const SizedBox(height: 10),
                Text('Font scale ${placement.mediaInfoFontScale.toStringAsFixed(2)}x'),
                Slider(
                  value: placement.mediaInfoFontScale.clamp(0.75, 1.6),
                  min: 0.75,
                  max: 1.6,
                  divisions: 17,
                  label: '${placement.mediaInfoFontScale.toStringAsFixed(2)}x',
                  onChanged: (double value) {
                    _updatePlacement(placement.copyWith(mediaInfoFontScale: value));
                  },
                ),
              ],
              if (widget.componentType == PlayerComponentType.cover) ...<Widget>[
                const SizedBox(height: 10),
                YaabsaExpressiveDropdownField<PlayerCoverFitMode>(
                  value: placement.coverFitMode,
                  decoration: const InputDecoration(labelText: 'Cover fit mode'),
                  options: PlayerCoverFitMode.values
                      .map((mode) => YaabsaDropdownOption<PlayerCoverFitMode>(value: mode, label: mode.label))
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
                  decoration: const InputDecoration(labelText: 'Time labels position'),
                  options: PlayerSeekTimePlacement.values
                      .map((mode) => YaabsaDropdownOption<PlayerSeekTimePlacement>(value: mode, label: mode.label))
                      .toList(growable: false),
                  onChanged: (PlayerSeekTimePlacement? mode) {
                    if (mode == null) {
                      return;
                    }
                    _updatePlacement(placement.copyWith(seekTimePlacement: mode));
                  },
                ),
                const SizedBox(height: 10),
                Text('Seek bar height ${placement.seekTrackHeight.toStringAsFixed(1)}'),
                Slider(
                  value: placement.seekTrackHeight.clamp(4.0, 20.0),
                  min: 4.0,
                  max: 20.0,
                  divisions: 16,
                  label: placement.seekTrackHeight.toStringAsFixed(1),
                  onChanged: (double value) {
                    _updatePlacement(placement.copyWith(seekTrackHeight: value));
                  },
                ),
                Text('Time font size ${placement.seekTimeLabelFontSize.toStringAsFixed(1)}'),
                Slider(
                  value: placement.seekTimeLabelFontSize.clamp(8.0, 22.0),
                  min: 8.0,
                  max: 22.0,
                  divisions: 14,
                  label: placement.seekTimeLabelFontSize.toStringAsFixed(1),
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
                  decoration: const InputDecoration(labelText: 'When this component has no data'),
                  options: PlayerCollectionEmptyMode.values
                      .map((mode) => YaabsaDropdownOption<PlayerCollectionEmptyMode>(value: mode, label: mode.label))
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
                      title: Text(utility.label),
                      subtitle: Text(enabled ? 'Visible' : 'Hidden'),
                      trailing: Wrap(
                        spacing: 2,
                        children: <Widget>[
                          IconButton(
                            tooltip: 'Move up',
                            onPressed: index > 0 ? () => _moveUtility(index, -1) : null,
                            icon: const Icon(Icons.arrow_upward_rounded),
                          ),
                          IconButton(
                            tooltip: 'Move down',
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
