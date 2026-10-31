import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/util/audio_handler/bg_audio_handler.dart';
import 'package:yaabsa/util/cast/cast_backend.dart';
import 'package:yaabsa/util/cast/cast_service.dart';
import 'package:yaabsa/util/globals.dart';

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
          _error = 'Unable to stop playback on the receiver';
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
                  Expanded(child: Text('Cast devices', style: Theme.of(context).textTheme.titleLarge)),
                  IconButton(
                    onPressed: _searching ? null : _discover,
                    tooltip: 'Search again',
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
              Text(widget.casting.supportedProtocols.map((protocol) => protocol.label).join(' and ')),
              const SizedBox(height: 12),
              if (_searching) const LinearProgressIndicator(),
              if (_error != null) Text(_error!),
              StreamBuilder<List<String>>(
                stream: widget.casting.discoveryErrors,
                initialData: widget.casting.discoveryErrors.value,
                builder: (context, snapshot) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [for (final error in snapshot.data ?? <String>[]) Text(error)],
                  );
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
                                  ? 'Searching for devices on your network...'
                                  : 'No devices found. Check that your receiver is on the same network.',
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
                                subtitle: Text('${active.protocol.label} • Connected'),
                                trailing: TextButton(
                                  onPressed: _disconnecting ? null : _disconnect,
                                  child: const Text('Disconnect'),
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
