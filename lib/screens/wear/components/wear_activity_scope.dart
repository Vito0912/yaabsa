import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wear_plus/wear_plus.dart';
import 'package:yaabsa/provider/core/socket_work_policy.dart';
import 'package:yaabsa/provider/wear/wear_preferences_provider.dart';
import 'package:yaabsa/ui/components/wear/wear_ambient_view.dart';
import 'package:yaabsa/ui/components/wear/wear_page_header.dart';
import 'package:yaabsa/util/globals.dart' show containerRef;

class WearActivityScope extends StatelessWidget {
  const WearActivityScope({required this.active, required this.child, super.key});

  final bool active;
  final Widget child;

  static bool isActive(BuildContext context) {
    return WearActiveScope.isActive(context);
  }

  @override
  Widget build(BuildContext context) {
    return WearActiveScope(active: active, child: child);
  }
}

class WearActivityHost extends StatefulWidget {
  const WearActivityHost({required this.child, required this.mediaStream, required this.currentMediaItem, super.key});

  final Widget child;
  final Stream<MediaItem?> mediaStream;
  final MediaItem? Function() currentMediaItem;

  @override
  State<WearActivityHost> createState() => _WearActivityHostState();
}

class _WearActivityHostState extends State<WearActivityHost> {
  late final AppLifecycleListener _lifecycle;
  bool _foreground = true;
  bool? _reportedActive;

  @override
  void initState() {
    super.initState();
    _foreground =
        WidgetsBinding.instance.lifecycleState == null ||
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    _lifecycle = AppLifecycleListener(
      onStateChange: (state) {
        setState(() {
          _foreground = state == AppLifecycleState.resumed;
        });
      },
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AmbientMode(
      builder: (context, mode, child) {
        final ambient = mode == WearMode.ambient;
        final active = _foreground && !ambient;
        if (_reportedActive != active) {
          _reportedActive = active;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _reportedActive == active) {
              containerRef.read(socketInteractionActiveProvider.notifier).setActive(active);
            }
          });
        }

        return WearActiveScope(
          active: active,
          child: Stack(
            children: [
              Offstage(
                offstage: ambient,
                child: TickerMode(enabled: active, child: widget.child),
              ),
              if (ambient)
                Positioned.fill(
                  child: Consumer(
                    builder: (context, ref, child) {
                      final showMetadata = ref.watch(wearPreferencesProvider.select((value) => value.ambientMetadata));
                      return StreamBuilder<MediaItem?>(
                        stream: widget.mediaStream,
                        initialData: widget.currentMediaItem(),
                        builder: (context, snapshot) {
                          return WearAmbientView(
                            key: ValueKey(DateTime.now().minute),
                            title: showMetadata ? snapshot.data?.title : null,
                            author: showMetadata ? snapshot.data?.artist : null,
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
