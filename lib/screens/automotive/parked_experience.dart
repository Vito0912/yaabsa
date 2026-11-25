import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/aaos_service.dart';
import 'package:yaabsa/util/l10n.dart';

class ParkedExperienceScreen extends StatelessWidget {
  const ParkedExperienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: context.l10n.navSettings,
            onPressed: () {
              context.go('/?tab=settings');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: context.l10n.actionSignOut,
            onPressed: () async {
              await containerRef.read(appDatabaseProvider).clearActiveUserId();
              await audioHandler.androidAutoAuthenticationChanged(authenticated: false);
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
                      label: Text(context.l10n.aaosOpenMediaCenter),
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
                      label: Text(context.l10n.navSettings),
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
