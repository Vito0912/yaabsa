import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/util/aaos_service.dart';

import 'package:yaabsa/generated/l10n.dart';

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
      context.go('/?tab=settings');
      return;
    }

    final launched = await AaosService.instance.launchMediaCenter(finishActivity: true);
    if (!context.mounted || launched) {
      return;
    }

    context.go('/?tab=settings');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: S.current.screensAutomotiveAaosSettingsScaffoldBack,
          onPressed: () async {
            await _handleBack(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: S.current.screensAutomotiveAaosSettingsScaffoldRefresh,
            onPressed: () {
              _refreshCurrentRoute(context);
            },
          ),
        ],
      ),
      body: child,
    );
  }
}
