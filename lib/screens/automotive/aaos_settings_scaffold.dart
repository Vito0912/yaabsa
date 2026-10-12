import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:yaabsa/util/aaos_service.dart';
import 'package:yaabsa/util/globals.dart' show audioHandler, isAudioHandlerInitialized;

enum AaosSettingsBackTarget { mediaCenter, settingsHome }

class AaosSettingsScaffold extends StatelessWidget {
  const AaosSettingsScaffold({super.key, required this.child, required this.backTarget, this.title = 'Settings'});

  final Widget child;
  final AaosSettingsBackTarget backTarget;
  final String title;

  void _refreshCurrentRoute(BuildContext context) {
    final state = GoRouterState.of(context);
    final queryParameters = <String, String>{
      ...state.uri.queryParameters,
      'refresh': DateTime.now().microsecondsSinceEpoch.toString(),
    };

    context.go(Uri(path: state.uri.path, queryParameters: queryParameters).toString());
  }

  Future<void> _handleBack(BuildContext context) async {
    if (backTarget == AaosSettingsBackTarget.settingsHome) {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/?tab=settings');
      }
      return;
    }

    if (isAudioHandlerInitialized) {
      audioHandler.invalidateAndroidAutoBrowseState(notify: false);
    }
    final launched = await AaosService.instance.launchMediaCenter(finishActivity: true);
    if (!context.mounted || launched) {
      return;
    }

    await SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isTopLevel = backTarget == AaosSettingsBackTarget.mediaCenter;
    return PopScope(
      canPop: !isTopLevel && context.canPop(),
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await _handleBack(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(
            icon: Icon(isTopLevel ? Icons.close : Icons.arrow_back),
            tooltip: isTopLevel ? 'Close' : 'Back',
            onPressed: () async {
              await _handleBack(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: () {
                _refreshCurrentRoute(context);
              },
            ),
          ],
        ),
        body: SafeArea(child: child),
      ),
    );
  }
}
