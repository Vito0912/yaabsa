import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wear_plus/wear_plus.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/wear/wear_pairing_screen.dart';
import 'package:yaabsa/screens/wear/wear_player_screen.dart';

class WearHomeScreen extends ConsumerWidget {
  const WearHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return WatchShape(
      builder: (context, shape, child) {
        return AmbientMode(
          builder: (context, mode, child) {
            return currentUser.when(
              data: (user) {
                if (user != null) {
                  return const WearPlayerScreen();
                }
                return const WearPairingScreen();
              },
              loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(strokeWidth: 2))),
              error: (_, _) => const WearPairingScreen(),
            );
          },
        );
      },
    );
  }
}
