import 'package:flutter/material.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';

class LibrarySettings extends StatelessWidget {
  const LibrarySettings({super.key});

  static const String routeName = '/settings/library';

  @override
  Widget build(BuildContext context) {
    return const SettingsPageScaffold(title: 'Library Settings', children: [_ComingSoonSettingBody()]);
  }
}

class _ComingSoonSettingBody extends StatelessWidget {
  const _ComingSoonSettingBody();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Text('Library-specific settings will appear here.', style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
