import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/wear/wear_dashboard_screen.dart';
import 'package:yaabsa/screens/wear/wear_pairing_screen.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

class WearHomeScreen extends ConsumerWidget {
  const WearHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    if (currentUser.isLoading && !currentUser.hasValue) {
      return const Scaffold(body: Center(child: YaabsaCircularProgressIndicator(strokeWidth: 2, size: 32)));
    }
    if (currentUser.hasError) {
      return Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () {
              ref.invalidate(currentUserProvider);
            },
            child: const Text('Could not load account. Retry'),
          ),
        ),
      );
    }

    final user = currentUser.value;
    return _WearUserNavigator(key: ValueKey((user?.id, user?.server?.url)), signedIn: user != null);
  }
}

class _WearUserNavigator extends StatefulWidget {
  const _WearUserNavigator({required this.signedIn, super.key});

  final bool signedIn;

  @override
  State<_WearUserNavigator> createState() => _WearUserNavigatorState();
}

class _WearUserNavigatorState extends State<_WearUserNavigator> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return NavigatorPopHandler(
      onPopWithResult: (_) async {
        await _navigatorKey.currentState?.maybePop();
      },
      child: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (_) => widget.signedIn ? const WearDashboardScreen() : const WearPairingScreen(),
        ),
      ),
    );
  }
}
