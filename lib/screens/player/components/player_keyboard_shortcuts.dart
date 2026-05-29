import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaabsa/util/audio_handler/bg_audio_handler.dart';
import 'package:yaabsa/util/globals.dart';

class PlayerKeyboardShortcuts extends StatefulWidget {
  const PlayerKeyboardShortcuts({super.key, required this.child});

  final Widget child;

  @override
  State<PlayerKeyboardShortcuts> createState() => _PlayerKeyboardShortcutsState();
}

class _PlayerKeyboardShortcutsState extends State<PlayerKeyboardShortcuts> {
  static const double _volumeStep = 0.05;
  static const double _volumeEpsilon = 0.0001;

  final FocusNode _focusNode = FocusNode(debugLabel: 'player-shortcuts');

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    if (_hasModifierPressed || _isTextInputFocused()) {
      return KeyEventResult.ignored;
    }

    final logicalKey = event.logicalKey;
    if (logicalKey == LogicalKeyboardKey.space) {
      _togglePlayPause();
      return KeyEventResult.handled;
    }

    if (logicalKey == LogicalKeyboardKey.arrowLeft) {
      unawaited(audioHandler.rewind());
      return KeyEventResult.handled;
    }

    if (logicalKey == LogicalKeyboardKey.arrowRight) {
      unawaited(audioHandler.fastForward());
      return KeyEventResult.handled;
    }

    if (logicalKey == LogicalKeyboardKey.arrowUp) {
      _adjustVolumeBy(_volumeStep);
      return KeyEventResult.handled;
    }

    if (logicalKey == LogicalKeyboardKey.arrowDown) {
      _adjustVolumeBy(-_volumeStep);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  bool get _hasModifierPressed {
    final keyboard = HardwareKeyboard.instance;
    return keyboard.isAltPressed || keyboard.isControlPressed || keyboard.isMetaPressed;
  }

  bool _isTextInputFocused() {
    final focusedContext = FocusManager.instance.primaryFocus?.context;
    if (focusedContext == null) {
      return false;
    }

    if (focusedContext.widget is EditableText) {
      return true;
    }

    return focusedContext.findAncestorWidgetOfExactType<EditableText>() != null;
  }

  void _togglePlayPause() {
    final isPlaying = audioHandler.playerControlState.playing;
    if (isPlaying) {
      unawaited(audioHandler.pause());
      return;
    }

    unawaited(audioHandler.play());
  }

  void _adjustVolumeBy(double delta) {
    final currentVolume = audioHandler.player.volume;
    final nextVolume = (currentVolume + delta).clamp(0.0, BGAudioHandler.maxVolume).toDouble();
    if ((nextVolume - currentVolume).abs() <= _volumeEpsilon) {
      return;
    }

    unawaited(audioHandler.setVolume(nextVolume));
  }

  @override
  Widget build(BuildContext context) {
    return Focus(focusNode: _focusNode, autofocus: true, onKeyEvent: _handleKeyEvent, child: widget.child);
  }
}
