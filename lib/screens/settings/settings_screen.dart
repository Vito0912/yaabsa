import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/settings/presentation/settings_shell.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';

class MainSettingsScreen extends StatelessWidget {
  const MainSettingsScreen({super.key});

  static const String routeName = SettingsRoutes.root;

  @override
  Widget build(BuildContext context) {
    return const SettingsShell();
  }
}
