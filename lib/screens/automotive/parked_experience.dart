import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/aaos_service.dart';

class ParkedExperienceScreen extends StatelessWidget {
  const ParkedExperienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Media App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              context.go('/?tab=settings');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await containerRef.read(appDatabaseProvider).clearActiveUserId();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.directions_car, size: 64, color: Colors.blue),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.play_circle_outline),
                      label: const Text('Open Media Center'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: () async {
                        await AaosService.instance.launchMediaCenter(finishActivity: true);
                      },
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.settings),
                      label: const Text('Settings'),
                      onPressed: () {
                        context.go('/?tab=settings');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
