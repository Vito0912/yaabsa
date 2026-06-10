import 'package:flutter/material.dart';
import 'package:yaabsa/provider/wear/wear_providers.dart';

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
          _errorMessage = 'No response from phone.\nMake sure the phone app is open.';
        });
      }
      // On success the home screen switches to the player via the
      // active-user providers; nothing to do here.
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
                const Text(
                  'Sign in on your phone\nto continue...',
                  style: TextStyle(fontSize: 12, color: Colors.white54),
                  textAlign: TextAlign.center,
                ),
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
