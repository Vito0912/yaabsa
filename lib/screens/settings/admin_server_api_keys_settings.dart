import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/settings/admin_server_api_keys_view.dart';
import 'package:yaabsa/screens/settings/admin_server_settings.dart';
import 'package:yaabsa/util/l10n.dart';

class AdminServerApiKeysSettings extends StatelessWidget {
  const AdminServerApiKeysSettings({super.key});

  static const String routeName = '/settings/admin-server/api-keys';

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
                  context.l10n.navApiKeys,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1040),
              child: const AdminServerApiKeysView(),
            ),
          ),
        ),
      ],
    );
  }
}
