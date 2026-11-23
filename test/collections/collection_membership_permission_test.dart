import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/api/me/permissions.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/common/collection_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/setting_key.dart';

class _SettingsManager extends SettingsManager {
  @override
  Stream<int> build() => Stream.value(0);
}

class _UserSettingsWatcher extends UserSettingsWatcher {
  @override
  Stream<int> build() => Stream.value(0);
}

void main() {
  test('editing requires update permission and the collections preference', () async {
    for (final canUpdate in [true, false]) {
      for (final enabled in [true, false]) {
        final user = User(
          id: 'user',
          username: 'Reader',
          email: null,
          type: 'user',
          token: null,
          permissions: Permissions(
            download: false,
            update: canUpdate,
            delete: false,
            upload: false,
            accessAllLibraries: true,
            accessAllTags: true,
            accessExplicitContent: true,
          ),
        );
        final cache = SettingsCache()
          ..setAllUsers({
            'user': {SettingKeys.serverManagementCollections: '$enabled'},
          });
        final container = ProviderContainer(
          overrides: [
            currentUserProvider.overrideWith((ref) => Stream.value(user)),
            settingsCacheProvider.overrideWithValue(cache),
            settingsManagerProvider.overrideWith(_SettingsManager.new),
            userSettingsWatcherProvider.overrideWith(_UserSettingsWatcher.new),
          ],
        );
        final subscription = container.listen(currentUserProvider, (_, _) {});
        await container.read(currentUserProvider.future).timeout(const Duration(seconds: 5));
        expect(container.read(collectionMembershipEditingAllowedProvider), canUpdate && enabled);
        subscription.close();
        container.dispose();
      }
    }
  });
}
