import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wear_plus/wear_plus.dart';
import 'package:yaabsa/provider/wear/wear_providers.dart';
import 'package:yaabsa/screens/wear/wear_player_screen.dart';

/// Main WearOS screen that routes between pairing and player.
class WearHomeScreen extends ConsumerWidget {
  const WearHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasCredentials = ref.watch(wearHasCredentialsProvider);

    return WatchShape(
      builder: (context, shape, child) {
        return AmbientMode(
          builder: (context, mode, child) {
            return hasCredentials.when(
              data: (hasCreds) {
                if (hasCreds) {
                  return const WearPlayerScreen();
                }
                return const WearPairingScreen();
              },
              loading: () => const Scaffold(
                body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              error: (_, __) => const WearPairingScreen(),
            );
          },
        );
      },
    );
  }
}

/// Pairing
class WearPairingScreen extends ConsumerStatefulWidget {
  const WearPairingScreen({super.key});

  @override
  ConsumerState<WearPairingScreen> createState() => _WearPairingScreenState();
}

class _WearPairingScreenState extends ConsumerState<WearPairingScreen> {
  bool _isRequesting = false;
  String? _errorMessage;

  Future<void> _requestCredentials() async {
    setState(() {
      _isRequesting = true;
      _errorMessage = null;
    });

    try {
      final dataLayer = ref.read(wearDataLayerProvider);
      final creds = await dataLayer.requestCredentials();

      if (creds != null && mounted) {
        final store = ref.read(wearCredentialsStoreProvider);
        await store.saveCredentials(
          serverUrl: creds['serverUrl']!,
          token: creds['token']!,
        );
        ref.invalidate(wearHasCredentialsProvider);
      } else if (mounted) {
        setState(() {
          _errorMessage = 'No response from phone.\nMake sure the phone app is open.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed: $e';
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Welcome',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text(
                'Connect to your Audiobookshelf.',
                style: TextStyle(fontSize: 13, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (_isRequesting) ...[
                const CircularProgressIndicator(strokeWidth: 2, color: Colors.white70),
                const SizedBox(height: 8),
                const Text('Waiting for phone...', style: TextStyle(fontSize: 12, color: Colors.white54)),
              ] else ...[
                ElevatedButton(
                  onPressed: _requestCredentials,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  ),
                  child: const Text('Continue on phone'),
                ),
              ],
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: const TextStyle(fontSize: 11, color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _requestCredentials,
                  child: const Text('Retry', style: TextStyle(fontSize: 12)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
