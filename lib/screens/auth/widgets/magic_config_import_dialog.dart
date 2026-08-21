import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

Future<String?> showMagicConfigImportDialog(BuildContext context) {
  return showDialog<String>(context: context, builder: (context) => const _MagicConfigImportDialog());
}

class _MagicConfigImportDialog extends StatefulWidget {
  const _MagicConfigImportDialog();

  @override
  State<_MagicConfigImportDialog> createState() => _MagicConfigImportDialogState();
}

class _MagicConfigImportDialogState extends State<_MagicConfigImportDialog> {
  final TextEditingController _controller = TextEditingController();

  bool get _scannerSupported =>
      kIsWeb ||
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Import Authentication Code'),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              minLines: 3,
              maxLines: 8,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Authentication Code',
                hintText: 'Paste the raw Authentication Code here',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            if (_scannerSupported)
              OutlinedButton.icon(
                onPressed: () async {
                  final value = await showDialog<String>(
                    context: context,
                    builder: (context) => const _MagicQrScannerDialog(),
                  );
                  if (!context.mounted || value == null || value.isEmpty) {
                    return;
                  }
                  Navigator.pop(context, value);
                },
                icon: const Icon(Icons.qr_code_scanner_rounded),
                label: const Text('Scan QR code'),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            final value = _controller.text.trim();
            if (value.isNotEmpty) {
              Navigator.pop(context, value);
            }
          },
          child: const Text('Import'),
        ),
      ],
    );
  }
}

class _MagicQrScannerDialog extends StatefulWidget {
  const _MagicQrScannerDialog();

  @override
  State<_MagicQrScannerDialog> createState() => _MagicQrScannerDialogState();
}

class _MagicQrScannerDialogState extends State<_MagicQrScannerDialog> {
  bool _captured = false;

  void _onDetect(BarcodeCapture capture) {
    if (_captured) {
      return;
    }

    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue?.trim();
      if (value == null || value.isEmpty) {
        continue;
      }
      _captured = true;
      Navigator.pop(context, value);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(
              onDetect: _onDetect,
              errorBuilder: (context, error) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.no_photography_outlined, size: 48, color: Theme.of(context).colorScheme.error),
                        const SizedBox(height: 12),
                        Text(
                          'Camera access is unavailable. Allow camera access in the device settings, or paste the raw code instead.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Close scanner')),
                      ],
                    ),
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton.filledTonal(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                      tooltip: 'Close scanner',
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Scan Authentication Code',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            IgnorePointer(
              child: Center(
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Text(
                  'Point the camera at the QR code',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String?> showMagicPasswordChangeDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) => const _MagicPasswordChangeDialog(),
  );
}

class _MagicPasswordChangeDialog extends StatefulWidget {
  const _MagicPasswordChangeDialog();

  @override
  State<_MagicPasswordChangeDialog> createState() => _MagicPasswordChangeDialogState();
}

class _MagicPasswordChangeDialogState extends State<_MagicPasswordChangeDialog> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmationController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  void _submit() {
    final newPassword = _newPasswordController.text;
    if (newPassword.isEmpty) {
      setState(() => _error = 'New password is required.');
      return;
    }
    if (newPassword != _confirmationController.text) {
      setState(() => _error = 'Passwords do not match.');
      return;
    }
    Navigator.pop(context, newPassword);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change your initial password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('For your security, the initial password from this Authentication Code can only be used once.'),
          const SizedBox(height: 14),
          TextField(
            controller: _newPasswordController,
            obscureText: true,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'New password', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _confirmationController,
            obscureText: true,
            onSubmitted: (_) => _submit(),
            decoration: const InputDecoration(labelText: 'Confirm new password', border: OutlineInputBorder()),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ],
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(onPressed: _submit, child: const Text('Change password')),
      ],
    );
  }
}
