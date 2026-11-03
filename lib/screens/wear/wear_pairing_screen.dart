import 'package:dio/dio.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/provider/wear/wear_providers.dart';
import 'package:yaabsa/screens/wear/components/wear_scroll_view.dart';
import 'package:yaabsa/util/logger.dart';

class WearPairingScreen extends StatefulWidget {
  const WearPairingScreen({super.key});

  @override
  State<WearPairingScreen> createState() => _WearPairingScreenState();
}

class _WearPairingScreenState extends State<WearPairingScreen> {
  bool _isRequesting = false;
  String? _errorMessage;

  Future<void> _requestCredentials() async {
    setState(() {
      _isRequesting = true;
      _errorMessage = null;
    });

    try {
      final paired = await pairWithPhone();
      if (!paired && mounted) {
        setState(() {
          _errorMessage = 'No response from phone.\nCheck your phone for a pairing notification.';
        });
      }
      // On success the home screen switches to the player via the
      // active-user providers; nothing to do here.
    } catch (e, stack) {
      // DioException.message is null for transport failures; the actual
      // cause (socket, TLS, Cronet error) is in DioException.error.
      final detail = e is DioException ? '${e.type.name}: ${e.error ?? e.message}' : '$e';
      logger('Wear pairing failed: $detail\n$stack', tag: 'WearPairing', level: InfoLevel.error);
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed: $detail';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRequesting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: WearScrollView(
        children: [
          Text(
            'Welcome',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          Text(
            'Connect to your Audiobookshelf.',
            style: TextStyle(fontSize: 13, color: colorScheme.onSurface.withValues(alpha: 0.70)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          if (_isRequesting) ...[
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            const SizedBox(height: 8),
            Text(
              'Sign in on your phone\nto continue...',
              style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.54)),
              textAlign: TextAlign.center,
            ),
          ] else ...[
            ElevatedButton(
              onPressed: _requestCredentials,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                minimumSize: const Size(48, 48),
              ),
              child: const Text('Continue on phone', textAlign: TextAlign.center, style: TextStyle(fontSize: 14)),
            ),
          ],
          if (_errorMessage != null && !_isRequesting) ...[
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              style: TextStyle(fontSize: 12, color: colorScheme.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _requestCredentials,
              style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
              child: const Text('Retry', style: TextStyle(fontSize: 12)),
            ),
          ],
        ],
      ),
    );
  }
}
