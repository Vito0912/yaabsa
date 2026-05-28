import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yaabsa/components/player/common/volume_slider_panel.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/audio_handler/bg_audio_handler.dart';

class VolumeSlider extends StatefulWidget {
  const VolumeSlider({super.key});

  @override
  State<VolumeSlider> createState() => _VolumeSliderState();
}

class _VolumeSliderState extends State<VolumeSlider> {
  static const Size _buttonSize = Size.square(48);

  final LayerLink _anchorLink = LayerLink();
  OverlayEntry? _popupEntry;
  PointerDeviceKind? _lastPointerKind;
  Timer? _dismissTimer;
  bool _isButtonHovered = false;
  bool _isPopupHovered = false;
  double _lastNonZeroVolume = 1.0;

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _hidePopup();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: audioHandler.volumeStream,
      initialData: 1.0,
      builder: (context, snapshot) {
        final volume = (snapshot.data ?? 1.0).clamp(0.0, BGAudioHandler.maxVolume).toDouble();
        if (volume > 0) {
          _lastNonZeroVolume = volume;
        }
        final isBoosted = volume > 1.0;
        final colorScheme = Theme.of(context).colorScheme;

        return CompositedTransformTarget(
          link: _anchorLink,
          child: MouseRegion(
            onEnter: (_) => _onButtonHoverChanged(context, true),
            onExit: (_) => _onButtonHoverChanged(context, false),
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: (event) {
                _lastPointerKind = event.kind;
              },
              child: SizedBox(
                width: _buttonSize.width,
                height: _buttonSize.height,
                child: IconButton(
                  tooltip: 'Volume ${(volume * 100).round()}%',
                  onPressed: () => _handlePress(context, volume),
                  color: isBoosted ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.6),
                  icon: Icon(_iconForVolume(volume)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handlePress(BuildContext context, double currentVolume) {
    final useMouseClick = _lastPointerKind == PointerDeviceKind.mouse;
    _lastPointerKind = null;

    if (useMouseClick) {
      _toggleMute(currentVolume);
      return;
    }

    _hidePopup();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        final bottomInset = MediaQuery.of(sheetContext).viewInsets.bottom;
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottomInset),
            child: const VolumeSliderPanel(axis: Axis.horizontal),
          ),
        );
      },
    );
  }

  void _toggleMute(double currentVolume) {
    if (currentVolume <= 0.01) {
      final restoreVolume = _lastNonZeroVolume.clamp(0.0, BGAudioHandler.maxVolume).toDouble();
      audioHandler.setVolume(restoreVolume == 0 ? 1.0 : restoreVolume);
      return;
    }

    _lastNonZeroVolume = currentVolume;
    audioHandler.setVolume(0);
  }

  void _onButtonHoverChanged(BuildContext context, bool hovered) {
    _isButtonHovered = hovered;

    if (hovered) {
      _dismissTimer?.cancel();
      _showPopup(context);
      return;
    }

    _scheduleDismiss();
  }

  void _onPopupHoverChanged(bool hovered) {
    _isPopupHovered = hovered;
    if (hovered) {
      _dismissTimer?.cancel();
      return;
    }

    _scheduleDismiss();
  }

  void _scheduleDismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = Timer(const Duration(milliseconds: 120), () {
      if (!_isButtonHovered && !_isPopupHovered) {
        _hidePopup();
      }
    });
  }

  void _showPopup(BuildContext context) {
    if (_popupEntry != null) {
      return;
    }

    final overlay = Overlay.of(context, rootOverlay: true);
    _popupEntry = OverlayEntry(
      builder: (overlayContext) {
        return _VolumePopupOverlay(
          anchorLink: _anchorLink,
          onDismiss: _hidePopup,
          onHoverChanged: _onPopupHoverChanged,
        );
      },
    );
    overlay.insert(_popupEntry!);
  }

  void _hidePopup() {
    _dismissTimer?.cancel();
    _popupEntry?.remove();
    _popupEntry = null;
    _isPopupHovered = false;
  }

  IconData _iconForVolume(double volume) {
    if (volume <= 0.01) {
      return Icons.volume_off_rounded;
    }
    if (volume < 0.5) {
      return Icons.volume_mute_rounded;
    }
    if (volume < 1.0) {
      return Icons.volume_down_rounded;
    }
    return Icons.volume_up_rounded;
  }
}

class _VolumePopupOverlay extends StatelessWidget {
  const _VolumePopupOverlay({required this.anchorLink, required this.onDismiss, required this.onHoverChanged});

  final LayerLink anchorLink;
  final VoidCallback onDismiss;
  final ValueChanged<bool> onHoverChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Positioned.fill(
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(behavior: HitTestBehavior.translucent, onTap: onDismiss),
          ),
          CompositedTransformFollower(
            link: anchorLink,
            showWhenUnlinked: false,
            targetAnchor: Alignment.topCenter,
            followerAnchor: Alignment.bottomCenter,
            offset: const Offset(0, -8),
            child: MouseRegion(
              onEnter: (_) => onHoverChanged(true),
              onExit: (_) => onHoverChanged(false),
              child: Material(
                elevation: 10,
                color: colorScheme.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: VolumeSliderPanel(axis: Axis.vertical),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
