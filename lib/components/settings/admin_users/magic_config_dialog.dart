import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/settings/yaabsa_switch_tile.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yaabsa/api/magic/magic_config.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/l10n.dart';

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
        _error = context.l10n.errorAcknowledgePasswordSharingRisk;
      });
      return;
    }
    if (_includeHeaders && widget.headers.isNotEmpty && !_headersAcknowledged) {
      setState(() {
        _error = context.l10n.errorAcknowledgeCustomHeadersRisk;
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
            _error = context.l10n.errorAuthenticationCodeKeyRequired;
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
        _error = context.l10n.errorOperationFailed(context.l10n.operationGenerateAuthenticationCode, error.toString());
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
        title: context.l10n.shareAuthenticationCodeTitle,
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.errorQrCodeSharingUnavailable)));
      return;
    }

    await SharePlus.instance.share(
      ShareParams(
        title: context.l10n.semanticsAuthenticationCodeQrCode,
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.statusAuthenticationCodeCopied)));
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
      title: Text(context.l10n.fieldAuthenticationCode),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(context.l10n.messageShareAuthenticationCode, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              if (widget.localServerUrl != null && widget.localServerUrl != widget.serverUrl)
                YaabsaDropdownField<String>(
                  label: context.l10n.fieldServerAddress,
                  value: _selectedServerUrl,
                  enabled: !_isGenerating,
                  items: [
                    DropdownMenuItem(
                      value: widget.serverUrl,
                      child: Text(
                        context.l10n.serverUrlLocation(widget.serverUrl, context.l10n.serverLocationExternal),
                      ),
                    ),
                    DropdownMenuItem(
                      value: widget.localServerUrl,
                      child: Text(
                        context.l10n.serverUrlLocation(widget.localServerUrl!, context.l10n.serverLocationLocal),
                      ),
                    ),
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
                  child: YaabsaSwitchTile.adaptive(
                    title: Text(context.l10n.optionIncludeSetPassword),
                    subtitle: Text(context.l10n.descriptionIncludedSetPassword),
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
                  child: YaabsaSwitchTile.adaptive(
                    title: Text(context.l10n.optionIncludeCustomHeaders),
                    subtitle: Text(context.l10n.messageSavedHeadersIncluded(widget.headers.length)),
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
                  text: context.l10n.messagePasswordSharingAcknowledgement,
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
                  text: context.l10n.messageCustomHeadersAcknowledgement,
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
                Text(context.l10n.messageUseAuthenticationCode, style: Theme.of(context).textTheme.bodyMedium),
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
                        semanticsLabel: context.l10n.semanticsAuthenticationCodeQrCode,
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
                        label: Text(context.l10n.actionShareQrCode),
                      ),
                    OutlinedButton.icon(
                      onPressed: _share,
                      icon: const Icon(Icons.share_outlined),
                      label: Text(context.l10n.actionShare),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _copy(generated),
                      icon: const Icon(Icons.copy_outlined),
                      label: Text(context.l10n.actionCopy),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isGenerating ? null : () => Navigator.pop(context),
          child: Text(context.l10n.actionClose),
        ),
        if (generated == null)
          FilledButton(
            onPressed: _isGenerating ? null : _generate,
            child: Text(_isGenerating ? context.l10n.statusGenerating : context.l10n.actionCreateAuthenticationCode),
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
