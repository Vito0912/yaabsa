import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/logger.dart';

class TrayManager extends ConsumerStatefulWidget {
  const TrayManager(this.child, {super.key});

  static const String playLatestKey = 'play_latest';
  static const String exitKey = 'exit_app';
  static const String playPauseKey = 'play_pause';
  static const String fastForwardKey = 'fast_forward';
  static const String rewindKey = 'rewind';
  static const String nextKey = 'next';
  static const String previousKey = 'previous';
  static const String stopKey = 'stop';

  static Future<void> update() async {
    if (!Platform.isLinux && !Platform.isWindows && !Platform.isMacOS) {
      return;
    }

    // TODO: Icon for Windows
    await trayManager.setIcon('assets/logo_blue_big_abs.png');
    Menu menu = Menu(
      items: [
        if (audioHandler.currentMediaItem != null)
          MenuItem.submenu(
            key: 'playback',
            label: 'Playback',
            submenu: Menu(
              items: [
                MenuItem(
                  key: TrayManager.playPauseKey,
                  label: audioHandler.playerControlState.playing ? 'Pause' : 'Play',
                ),
                MenuItem(key: TrayManager.stopKey, label: 'Stop'),
                MenuItem(key: TrayManager.nextKey, label: 'Next'),
                MenuItem(key: TrayManager.previousKey, label: 'Previous'),
                MenuItem(key: TrayManager.fastForwardKey, label: 'Fast Forward'),
                MenuItem(key: TrayManager.rewindKey, label: 'Rewind'),
              ],
            ),
          ),
        MenuItem.separator(),
        MenuItem(key: TrayManager.playLatestKey, label: 'Play Latest'),
        MenuItem.separator(),
        MenuItem(key: TrayManager.exitKey, label: 'Exit App'),
      ],
    );
    await trayManager.setContextMenu(menu);
  }

  final Widget child;
  @override
  ConsumerState<TrayManager> createState() => _TrayManagerState();
}

class _TrayManagerState extends ConsumerState<TrayManager> with TrayListener {
  @override
  void initState() {
    trayManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void onTrayIconMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseDown() {}

  @override
  void onTrayIconRightMouseUp() {}

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case TrayManager.playLatestKey:
        logger('Play latest clicked', tag: 'TrayManager', level: InfoLevel.info);
        // TODO: Implement
        break;
      case TrayManager.playPauseKey:
        audioHandler.playerControlState.playing ? audioHandler.pause() : audioHandler.play();
        break;
      case TrayManager.fastForwardKey:
        audioHandler.seek(audioHandler.position + const Duration(seconds: 10));
        break;
      case TrayManager.rewindKey:
        audioHandler.seek(audioHandler.position - const Duration(seconds: 10));
        break;
      case TrayManager.nextKey:
        audioHandler.skipToNext();
        break;
      case TrayManager.previousKey:
        audioHandler.skipToPrevious();
        break;
      case TrayManager.stopKey:
        audioHandler.stop();
        break;
      case TrayManager.exitKey:
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        break;
      default:
        logger('Unknown menu item clicked: ${menuItem.key}', tag: 'TrayManager', level: InfoLevel.warning);
        break;
    }
  }
}
