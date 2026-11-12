import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show VoidCallback, kIsWeb;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tray_manager/tray_manager.dart' as tray;
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/handler/desktop_window_state.dart';
import 'package:yaabsa/util/logger.dart';

class TrayManager extends ConsumerStatefulWidget {
  const TrayManager(this.child, {super.key});

  static Future<void> update() async {
    if (kIsWeb || (!Platform.isLinux && !Platform.isWindows && !Platform.isMacOS)) {
      return;
    }

    _DesktopTrayController.instance.update();
  }

  final Widget child;

  @override
  ConsumerState<TrayManager> createState() => _TrayManagerState();
}

class _TrayManagerState extends ConsumerState<TrayManager> {
  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _DesktopTrayController.instance.attachView();
    }
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      _DesktopTrayController.instance.detachView();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _DesktopTrayController {
  _DesktopTrayController._();

  static final _DesktopTrayController instance = _DesktopTrayController._();

  tray.TrayIcon? _trayIcon;
  tray.Image? _iconImage;
  tray.ListenerId? _trayListenerId;
  _TrayMenuBinding? _menuBinding;
  int _attachedViews = 0;

  void attachView() {
    _attachedViews++;
    final trayIcon = _trayIcon;
    if (trayIcon != null) {
      _wireTrayEvents(trayIcon);
    }
  }

  void detachView() {
    if (_attachedViews > 0) {
      _attachedViews--;
    }

    if (_attachedViews == 0) {
      _unwireTrayEvents();
    }
  }

  void update() {
    if (!tray.TrayManager.instance.isSupported()) {
      return;
    }

    final trayIcon = _ensureTrayIcon();
    if (trayIcon == null) {
      return;
    }

    _ensureIconImage(trayIcon);

    final nextMenuBinding = _TrayMenuBinding.build();
    if (nextMenuBinding == null) {
      return;
    }

    trayIcon.setContextMenu(nextMenuBinding.rootMenu);
    if (Platform.isLinux) {
      trayIcon.setContextMenuTrigger(tray.ContextMenuTrigger.rightClicked);
    }

    final previousBinding = _menuBinding;
    _menuBinding = nextMenuBinding;
    if (previousBinding != null) {
      Timer.run(previousBinding.dispose);
    }
  }

  tray.TrayIcon? _ensureTrayIcon() {
    final existingIcon = _trayIcon;
    if (existingIcon != null) {
      _wireTrayEvents(existingIcon);
      return existingIcon;
    }

    final createdIcon = tray.TrayIcon.create();
    if (createdIcon == null) {
      logger('Unable to create desktop tray icon.', tag: 'TrayManager', level: InfoLevel.warning);
      return null;
    }

    createdIcon.setVisible(true);
    _trayIcon = createdIcon;
    _wireTrayEvents(createdIcon);
    return createdIcon;
  }

  void _ensureIconImage(tray.TrayIcon trayIcon) {
    if (_iconImage != null) {
      return;
    }

    final loadedImage = tray.ImageAsset.fromAsset('assets/logo_blue_fill.png');
    if (loadedImage == null) {
      logger('Unable to load desktop tray icon image.', tag: 'TrayManager', level: InfoLevel.warning);
      return;
    }

    trayIcon.icon = loadedImage;
    trayIcon.setVisible(true);
    _iconImage = loadedImage;
  }

  void _wireTrayEvents(tray.TrayIcon trayIcon) {
    if (_attachedViews == 0 || _trayListenerId != null) {
      return;
    }

    _trayListenerId = trayIcon.addListener((event) {
      if (event is tray.TrayIconClickedEvent) {
        trayIcon.openContextMenu();
      }
    });
  }

  void _unwireTrayEvents() {
    final listenerId = _trayListenerId;
    if (listenerId == null) {
      return;
    }

    _trayIcon?.removeListener(listenerId);
    _trayListenerId = null;
  }
}

class _TrayMenuBinding {
  _TrayMenuBinding._({required this.rootMenu, required this.menus, required this.items});

  final tray.Menu rootMenu;
  final List<tray.Menu> menus;
  final List<(tray.MenuItem, tray.ListenerId?)> items;

  static _TrayMenuBinding? build() {
    final rootMenu = tray.Menu.create();
    if (rootMenu == null) {
      logger('Unable to create tray context menu.', tag: 'TrayManager', level: InfoLevel.warning);
      return null;
    }

    final menus = <tray.Menu>[rootMenu];
    final items = <(tray.MenuItem, tray.ListenerId?)>[];

    void addActionItem(tray.Menu targetMenu, String label, VoidCallback onSelected) {
      final item = tray.MenuItem.createWithLabelAndType(label, tray.MenuItemType.normal);
      if (item == null) {
        return;
      }

      final listenerId = item.addListener((event) {
        if (event is tray.MenuItemClickedEvent) {
          onSelected();
        }
      });
      items.add((item, listenerId));
      targetMenu.addItem(item);
    }

    if (audioHandler.currentMediaItem != null) {
      final playbackMenu = tray.Menu.create();
      final playbackItem = tray.MenuItem.createWithLabelAndType('Playback', tray.MenuItemType.submenu);
      if (playbackMenu != null && playbackItem != null) {
        menus.add(playbackMenu);
        final isPlaying = audioHandler.playerControlState.playing;
        addActionItem(playbackMenu, isPlaying ? 'Pause' : 'Play', () {
          if (audioHandler.playerControlState.playing) {
            audioHandler.pause();
          } else {
            audioHandler.play();
          }
        });
        addActionItem(playbackMenu, 'Stop', audioHandler.stop);
        addActionItem(playbackMenu, 'Next', audioHandler.skipToNextInApp);
        addActionItem(playbackMenu, 'Previous', audioHandler.skipToPreviousInApp);
        addActionItem(playbackMenu, 'Fast Forward', () {
          audioHandler.seekAbsolute(audioHandler.position + const Duration(seconds: 10));
        });
        addActionItem(playbackMenu, 'Rewind', () {
          audioHandler.seekAbsolute(audioHandler.position - const Duration(seconds: 10));
        });

        playbackItem.submenu = playbackMenu;
        items.add((playbackItem, null));
        rootMenu.addItem(playbackItem);
      } else {
        playbackMenu?.dispose();
        playbackItem?.dispose();
      }
    }

    rootMenu.addSeparator();
    addActionItem(rootMenu, 'Play Last Played', _playLastPlayed);
    rootMenu.addSeparator();
    addActionItem(rootMenu, 'Exit App', _exitApp);

    return _TrayMenuBinding._(rootMenu: rootMenu, menus: menus, items: items);
  }

  static void _playLastPlayed() {
    unawaited(
      audioHandler.playLastPlayed().then((started) {
        final message = started
            ? 'Tray action resumed last played item.'
            : 'Tray action did not find a resumable last played item.';
        logger(message, tag: 'TrayManager', level: InfoLevel.info);
      }),
    );
  }

  static void _exitApp() {
    if (DesktopWindowState.isSupported) {
      unawaited(DesktopWindowState.close());
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  void dispose() {
    for (final (item, listenerId) in items) {
      if (listenerId != null) {
        item.removeListener(listenerId);
      }
      item.dispose();
    }
    items.clear();

    for (final menu in menus) {
      menu.dispose();
    }
    menus.clear();
  }
}
