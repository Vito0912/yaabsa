import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/sessions/current_user_listening_sessions_tab.dart';
import 'package:yaabsa/components/sessions/long_listening_sessions_dialog.dart';
import 'package:yaabsa/features/settings/model/setting_definition.dart';
import 'package:yaabsa/features/settings/model/setting_definitions.dart';
import 'package:yaabsa/provider/common/stats_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/ui/components/buttons/yaabsa_button.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/l10n.dart';

class UserListeningSessionsView extends ConsumerStatefulWidget {
  const UserListeningSessionsView({super.key});

  static const String routeName = '/sessions';

  @override
  ConsumerState<UserListeningSessionsView> createState() => _UserListeningSessionsViewState();
}

class _UserListeningSessionsViewState extends ConsumerState<UserListeningSessionsView> {
  final GlobalKey<CurrentUserListeningSessionsTabState> _sessionsTabKey =
      GlobalKey<CurrentUserListeningSessionsTabState>();

  Future<void> _openFindLongSessions() async {
    final deletedAny = await showLongListeningSessionsDialog(context, ref);
    if (!deletedAny || !mounted) {
      return;
    }

    ref.invalidate(listeningStatsProvider);
    ref.invalidate(listeningActivityStatsProvider);
    await _sessionsTabKey.currentState?.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider).value;
    final deleteLongSessionsEnabled = watchSettingDefinition(
      ref,
      AppSettingDefs.toolsDeleteLongListeningSessions,
      userId: currentUser?.id,
    );
    final showFindLongSessions = deleteLongSessionsEnabled && currentUser != null;
    final horizontalPadding = context.isMobile ? 16.0 : 24.0;

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(horizontalPadding - 8, 12, horizontalPadding, 8),
            child: Row(
              children: [
                IconButton(
                  tooltip: context.l10n.actionBack,
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      context.pop();
                      return;
                    }
                    context.go('/?tab=stats');
                  },
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                Expanded(
                  child: Text(
                    context.l10n.headingListeningSessions,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                if (showFindLongSessions) ...[
                  const SizedBox(width: 8),
                  if (context.isMobile)
                    YaabsaButton.iconSmall(
                      variant: YaabsaButtonVariant.outlined,
                      icon: const Icon(Icons.cleaning_services_outlined),
                      tooltip: context.l10n.actionFindLongSessions,
                      onPressed: _openFindLongSessions,
                    )
                  else
                    YaabsaButton.small(
                      variant: YaabsaButtonVariant.outlined,
                      icon: const Icon(Icons.cleaning_services_outlined),
                      label: Text(context.l10n.actionFindLongSessions),
                      onPressed: _openFindLongSessions,
                    ),
                ],
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: CurrentUserListeningSessionsTab(key: _sessionsTabKey),
            ),
          ),
        ],
      ),
    );
  }
}
