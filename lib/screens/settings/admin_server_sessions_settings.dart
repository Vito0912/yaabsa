import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/settings/admin_server_sessions_view.dart';
import 'package:yaabsa/screens/settings/admin_server_settings.dart';
import 'package:yaabsa/util/l10n.dart';

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
                tooltip: context.l10n.actionBack,
                onPressed: () => _handleBack(context),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              Expanded(
                child: Text(
                  context.l10n.headingListeningSessions,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        const Expanded(child: AdminServerSessionsView()),
      ],
    );
  }
}
