import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yaabsa/api/magic/magic_config.dart';
import 'package:yaabsa/util/globals.dart';

Future<void> showMagicConfigDialog(
  BuildContext context, {
  required String serverUrl,
  String? localServerUrl,
  required String username,
  required String? password,
  required Map<String, String> headers,
  required bool allowPassword,
  required Future<MagicConfigKeyMarker?> Function() ensureMarker,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => _MagicConfigDialog(
      serverUrl: serverUrl,
      localServerUrl: localServerUrl,
      username: username,
      password: password,
      headers: headers,
      allowPassword: allowPassword,
      ensureMarker: ensureMarker,
    ),
  );
}

class _MagicConfigDialog extends StatefulWidget {
  const _MagicConfigDialog({
    required this.serverUrl,
    required this.localServerUrl,
    required this.username,
    required this.password,
    required this.headers,
    required this.allowPassword,
    required this.ensureMarker,
  });

  final String serverUrl;
  final String? localServerUrl;
  final String username;
  final String? password;
  final Map<String, String> headers;
  final bool allowPassword;
  final Future<MagicConfigKeyMarker?> Function() ensureMarker;

  @override
  State<_MagicConfigDialog> createState() => _MagicConfigDialogState();
}

class _MagicConfigDialogState extends State<_MagicConfigDialog> {
  late String _selectedServerUrl;
  bool _includePassword = false;
  bool _includeHeaders = false;
  bool _passwordAcknowledged = false;
  bool _headersAcknowledged = false;
  bool _isGenerating = false;
  String? _token;
  String? _error;

  @override
  void initState() {
    super.initState();
    _selectedServerUrl = widget.serverUrl;
  }

  bool get _canShareQrFile => kIsWeb || defaultTargetPlatform != TargetPlatform.linux;

  Future<XFile?> _buildQrFile(String value) async {
    if (!_canShareQrFile) {
      return null;
    }

    final painter = QrPainter(
      data: value,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.M,
      gapless: true,
    );
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawColor(Colors.white, BlendMode.src);
    painter.paint(canvas, const Size(1600, 1600));
    final image = await recorder.endRecording().toImage(1600, 1600);
    final imageData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (imageData == null) {
      return null;
    }

    final bytes = imageData.buffer.asUint8List(imageData.offsetInBytes, imageData.lengthInBytes);
    return XFile.fromData(bytes, mimeType: 'image/png', name: 'yaabsa-authentication-code.png');
  }

  Future<void> _generate() async {
    if (_includePassword && !_passwordAcknowledged) {
      setState(() {
        _error = 'Please acknowledge the password-sharing risk before continuing.';
      });
      return;
    }
    if (_includeHeaders && widget.headers.isNotEmpty && !_headersAcknowledged) {
      setState(() {
        _error = 'Please acknowledge the custom-header risk before continuing.';
      });
      return;
    }

    setState(() {
      _isGenerating = true;
      _error = null;
    });

    try {
      final includesHeaders = _includeHeaders && widget.headers.isNotEmpty;
      final requiresServerKey = _includePassword || includesHeaders;
      final marker = requiresServerKey ? await widget.ensureMarker() : null;
      if (requiresServerKey && marker == null) {
        if (mounted) {
          setState(() {
            _error = 'A server key is required to include protected Authentication Code data. Ask an administrator to enable it first.';
          });
        }
        return;
      }

      final token = MagicConfigCodec.create(
        serverUrl: _selectedServerUrl,
        username: widget.username,
        password: _includePassword ? widget.password : null,
        marker: marker,
        headers: _includeHeaders ? widget.headers : const <String, String>{},
      );

      if (!mounted) {
        return;
      }
      setState(() {
        _token = token;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = 'Could not generate Authentication Code: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  Future<void> _share() async {
    final value = _token;
    if (value == null || value.isEmpty) {
      return;
    }

    final qrFile = await _buildQrFile(value);
    final files = <XFile>[];
    if (qrFile != null) {
      files.add(qrFile);
    }

    if (!mounted) {
      return;
    }
    await SharePlus.instance.share(
      ShareParams(
        title: 'yaabsa Authentication Code',
        text: value,
        files: files.isEmpty ? null : files,
        sharePositionOrigin: _shareOrigin(context),
      ),
    );
  }

  Future<void> _shareQrCode() async {
    final value = _token;
    if (value == null || value.isEmpty) {
      return;
    }

    final qrFile = await _buildQrFile(value);
    if (!mounted) {
      return;
    }
    if (qrFile == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('QR-code sharing is unavailable on this platform.')));
      return;
    }

    await SharePlus.instance.share(
      ShareParams(
        title: 'yaabsa Authentication Code QR code',
        files: [qrFile],
        sharePositionOrigin: _shareOrigin(context),
      ),
    );
  }

  Future<void> _copy(String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Authentication Code copied.')));
  }

  Rect? _shareOrigin(BuildContext context) {
    if (defaultTargetPlatform != TargetPlatform.iOS && defaultTargetPlatform != TargetPlatform.macOS) {
      return null;
    }
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox) {
      return null;
    }
    return renderObject.localToGlobal(Offset.zero) & renderObject.size;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasHeaders = widget.headers.isNotEmpty;
    final generated = _token;

    return AlertDialog(
      title: const Text('Authentication Code'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Share a Authentication Code that prefills all important server information',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              if (widget.localServerUrl != null && widget.localServerUrl != widget.serverUrl)
                DropdownButtonFormField<String>(
                  initialValue: _selectedServerUrl,
                  decoration: const InputDecoration(labelText: 'Server URL'),
                  items: [
                    DropdownMenuItem(value: widget.serverUrl, child: Text('${widget.serverUrl} (external)')),
                    DropdownMenuItem(value: widget.localServerUrl, child: Text('${widget.localServerUrl} (local)')),
                  ],
                  onChanged: _isGenerating
                      ? null
                      : (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedServerUrl = value;
                            _token = null;
                          });
                        },
                ),
              if (widget.localServerUrl != null && widget.localServerUrl != widget.serverUrl)
                const SizedBox(height: 16),
              if (widget.allowPassword && widget.password != null)
                _MagicConfigOption(
                  child: SwitchListTile.adaptive(
                    title: const Text('Include set password'),
                    subtitle: const Text(
                      'The user can sign in without typing the password and must choose a new password immediately',
                    ),
                    secondary: const Icon(Icons.password_rounded),
                    value: _includePassword,
                    onChanged: _isGenerating
                        ? null
                        : (value) {
                            setState(() {
                              _includePassword = value;
                              _passwordAcknowledged = false;
                              _token = null;
                            });
                          },
                  ),
                ),
              if (hasHeaders)
                _MagicConfigOption(
                  child: SwitchListTile.adaptive(
                    title: const Text('Include custom headers'),
                    subtitle: Text(
                      '${widget.headers.length} saved header${widget.headers.length == 1 ? '' : 's'} will be included',
                    ),
                    secondary: const Icon(Icons.http_rounded),
                    value: _includeHeaders,
                    onChanged: _isGenerating
                        ? null
                        : (value) {
                            setState(() {
                              _includeHeaders = value;
                              _headersAcknowledged = false;
                              _token = null;
                            });
                          },
                  ),
                ),
              if (_includePassword)
                _AcknowledgementTile(
                  value: _passwordAcknowledged,
                  text: 'I understand that anyone who gets this code can use the temporary password until it is changed or the Authentication Code key is rotated',
                  onChanged: _isGenerating
                      ? null
                      : (value) {
                          setState(() {
                            _passwordAcknowledged = value;
                          });
                        },
                ),
              if (_includeHeaders && hasHeaders)
                _AcknowledgementTile(
                  value: _headersAcknowledged,
                  text: 'I understand that custom headers may contain secrets or grant server access',
                  onChanged: _isGenerating
                      ? null
                      : (value) {
                          setState(() {
                            _headersAcknowledged = value;
                          });
                        },
                ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: TextStyle(color: colorScheme.error)),
              ],
              if (generated != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Scan this code in yaabsa on the other device, or copy the raw Authentication Code and use “Import Authentication Code” on the sign-in screen.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final qrSize = math.min(constraints.maxWidth, context.isMobile ? 320.0 : 420.0);
                    return Center(
                      child: QrImageView(
                        data: generated,
                        version: QrVersions.auto,
                        errorCorrectionLevel: QrErrorCorrectLevel.M,
                        size: qrSize,
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.white,
                        gapless: true,
                        semanticsLabel: 'yaabsa Authentication Code QR code',
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                SelectableText(generated, maxLines: 5, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (_canShareQrFile)
                      OutlinedButton.icon(
                        onPressed: _shareQrCode,
                        icon: const Icon(Icons.qr_code_2_rounded),
                        label: const Text('Share QR code'),
                      ),
                    OutlinedButton.icon(
                      onPressed: _share,
                      icon: const Icon(Icons.share_outlined),
                      label: const Text('Share'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _copy(generated),
                      icon: const Icon(Icons.copy_outlined),
                      label: const Text('Copy'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: _isGenerating ? null : () => Navigator.pop(context), child: const Text('Close')),
        if (generated == null)
          FilledButton(
            onPressed: _isGenerating ? null : _generate,
            child: Text(_isGenerating ? 'Generating...' : 'Generate Authentication Code'),
          ),
      ],
    );
  }
}

class _MagicConfigOption extends StatelessWidget {
  const _MagicConfigOption({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class _AcknowledgementTile extends StatelessWidget {
  const _AcknowledgementTile({required this.value, required this.text, required this.onChanged});

  final bool value;
  final String text;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged == null ? null : (next) => onChanged!(next ?? false),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        tileColor: colorScheme.errorContainer.withValues(alpha: 0.45),
        selectedTileColor: colorScheme.primaryContainer.withValues(alpha: 0.65),
        selected: value,
        title: Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }
}
