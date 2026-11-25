import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';
import 'package:yaabsa/util/audio_handler/bg_audio_handler.dart';
import 'package:yaabsa/util/cast/cast_backend.dart';
import 'package:yaabsa/util/cast/cast_service.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

class CastDeviceSheet extends StatefulWidget {
  const CastDeviceSheet({super.key, required this.casting});

  final CastService casting;

  @override
  State<CastDeviceSheet> createState() => _CastDeviceSheetState();
}

class _CastDeviceSheetState extends State<CastDeviceSheet> {
  bool _searching = false;
  bool _disconnecting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    unawaited(_discover());
  }

  Future<void> _discover() async {
    setState(() {
      _searching = true;
      _error = null;
    });

    await widget.casting.startDiscovery();
    if (!mounted) {
      await widget.casting.stopDiscovery();
      return;
    }

    setState(() {
      _searching = false;
    });
  }

  Future<void> _disconnect() async {
    setState(() {
      _disconnecting = true;
      _error = null;
    });

    try {
      await audioHandler.disconnectCast();
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = context.l10n.errorCastStopFailed;
          _disconnecting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    unawaited(widget.casting.stopDiscovery());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * (context.isMobile ? 0.65 : 0.55),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: Text(context.l10n.castDevices, style: Theme.of(context).textTheme.titleLarge)),
                  YaabsaActionIconButton(
                    icon: Icons.refresh,
                    iconSize: 24,
                    buttonSize: 48,
                    compact: false,
                    onPressed: _searching ? null : _discover,
                    tooltip: context.l10n.playerSearchAgain,
                  ),
                ],
              ),
              Text(widget.casting.supportedProtocols.map((protocol) => protocol.label).join(', ')),
              const SizedBox(height: 12),
              if (_searching) const YaabsaLinearProgressIndicator(),
              if (_error != null) Text(_error!),
              StreamBuilder<List<String>>(
                stream: widget.casting.discoveryErrors,
                initialData: widget.casting.discoveryErrors.value,
                builder: (context, snapshot) {
                  if (snapshot.data?.isNotEmpty ?? false) {
                    return Text(context.l10n.errorCastDiscoveryFailed);
                  }
                  return const SizedBox.shrink();
                },
              ),
              Expanded(
                child: StreamBuilder<bool>(
                  stream: widget.casting.connected,
                  initialData: widget.casting.hasConnectedSession,
                  builder: (context, connection) {
                    final active = connection.data == true ? widget.casting.activeDevice : null;
                    return StreamBuilder<List<CastDevice>>(
                      stream: widget.casting.devices,
                      initialData: widget.casting.devices.value,
                      builder: (context, snapshot) {
                        final devices = snapshot.data ?? [];
                        if (devices.isEmpty && active == null) {
                          return Center(
                            child: Text(
                              _searching
                                  ? context.l10n.statusSearchingCastDevices
                                  : context.l10n.statusNoCastDevicesFound,
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        return ListView(
                          children: [
                            if (active != null)
                              ListTile(
                                leading: const Icon(Icons.cast_connected),
                                title: Text(active.name),
                                subtitle: Text(
                                  context.l10n.castProtocolStatus(active.protocol.label, context.l10n.statusConnected),
                                ),
                                trailing: TextButton(
                                  onPressed: _disconnecting ? null : _disconnect,
                                  child: Text(context.l10n.actionDisconnect),
                                ),
                              ),
                            for (final device in devices)
                              if (device.id != active?.id || device.protocol != active?.protocol)
                                ListTile(
                                  leading: Icon(
                                    device.protocol == CastProtocol.chromecast ? Icons.cast : Icons.speaker,
                                  ),
                                  title: Text(device.name),
                                  subtitle: Text(device.protocol.label),
                                  onTap: _disconnecting ? null : () => Navigator.of(context).pop(device),
                                ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
