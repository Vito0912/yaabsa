import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/settings/admin_server_sessions_view.dart';
import 'package:yaabsa/screens/settings/admin_server_settings.dart';

class AdminServerSessionsSettings extends StatelessWidget {
  const AdminServerSessionsSettings({super.key});

  static const String routeName = '/settings/admin-server/sessions';

  void _handleBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      context.pop();
      return;
    }

    context.go(AdminServerSettings.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 12, 20, 8),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Back',
                onPressed: () => _handleBack(context),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              Expanded(
                child: Text(
                  'Listening Sessions',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: AdminServerSessionsView()),
        ),
      ],
    );
  }
}
