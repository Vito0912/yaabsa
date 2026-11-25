import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/main_wear.dart' show wearAudioHandler;
import 'package:yaabsa/provider/core/server_reachability_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/core/user_scope_invalidation.dart';
import 'package:yaabsa/provider/wear/wear_sign_in_provider.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/components/wear/wear_account_details.dart';
import 'package:yaabsa/screens/wear/components/wear_browse_scaffold.dart';
import 'package:yaabsa/ui/components/wear/wear_confirmation_screen.dart';
import 'package:yaabsa/util/auth/account_removal.dart';
import 'package:yaabsa/util/l10n.dart';

class WearAccountScreen extends ConsumerStatefulWidget {
  const WearAccountScreen({super.key});

  @override
  ConsumerState<WearAccountScreen> createState() => _WearAccountScreenState();
}

class _WearAccountScreenState extends ConsumerState<WearAccountScreen> {
  bool _busy = false;
  String? _error;

  Future<void> _signOut() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null || _busy) {
      return;
    }

    final confirmed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => WearConfirmationScreen(
          title: context.l10n.actionSignOut,
          message: context.l10n.wearSignOutWarning,
          confirmLabel: context.l10n.actionSignOut,
          icon: Icons.logout,
          destructive: true,
        ),
      ),
    );
    if (!mounted || confirmed != true) {
      return;
    }
    final current = ref.read(currentUserProvider).value;
    if (current?.id != user.id || current?.server?.url != user.server?.url) {
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });
    final db = ref.read(appDatabaseProvider);
    try {
      await wearAudioHandler.clearAccount();
      final wasActiveUser = await removeStoredAccount(db: db, user: user);
      if (wasActiveUser) {
        await db.clearActiveUserId();
      }
      if (mounted) {
        invalidateUserScopedProviders(ref);
        ref.invalidate(currentUserProvider);
        ref.invalidate(allStoredUsersProvider);
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = wearRequestError(error);
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    final reachable = ref.watch(serverReachabilityProvider);
    final colors = Theme.of(context).colorScheme;
    final children = <Widget>[
      if (user != null)
        WearAccountIdentity(
          username: user.username,
          roleLabel: WearAccountIdentity.formatRole(context.l10n, user.type),
        ),
      WearAccountServerDetails(serverUrl: user?.server?.url ?? '', reachable: reachable),
      if (_error != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Semantics(
            liveRegion: true,
            child: Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: colors.error),
            ),
          ),
        ),
      if (_busy)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Center(
            child: YaabsaCircularProgressIndicator(
              strokeWidth: 2,
              size: 24,
              semanticsLabel: context.l10n.statusSigningOut,
            ),
          ),
        ),
      WearBrowseButton(
        title: _busy ? context.l10n.statusSigningOut : context.l10n.actionSignOut,
        icon: Icons.logout,
        destructive: true,
        onPressed: _busy ? null : _signOut,
      ),
    ];
    return WearBrowseScaffold(
      title: context.l10n.accountLabel,
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}
