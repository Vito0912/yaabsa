import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/sessions/current_user_listening_sessions_tab.dart';

import 'package:yaabsa/generated/l10n.dart';

class UserListeningSessionsView extends StatelessWidget {
  const UserListeningSessionsView({super.key});

  static const String routeName = '/sessions';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 20, 8),
            child: Row(
              children: [
                IconButton(
                  tooltip: S.current.screensMainUserListeningSessionsViewBack,
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
                    S.current.screensMainUserListeningSessionsViewListeningSessions,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: CurrentUserListeningSessionsTab(),
            ),
          ),
        ],
      ),
    );
  }
}
