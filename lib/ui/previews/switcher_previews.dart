import 'dart:async';

import 'package:flutter/widget_previews.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/components/app/library_switcher.dart';
import 'package:yaabsa/components/app/user_switcher.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';

import 'preview_fixtures.dart';
import 'preview_theme.dart';

@Preview(name: 'Selectors / loading / phone', size: Size(360, 100), wrapper: yaabsaPreviewLight)
@Preview(name: 'Selectors / loading / desktop', size: Size(1100, 100), wrapper: yaabsaPreviewDark)
Widget switchersLoadingPreview() {
  return _switchers();
}

@Preview(name: 'Selectors / loading stored user', size: Size(1100, 100), wrapper: yaabsaPreviewLight)
Widget switchersStoredUserLoadingPreview() {
  return _switchers(user: previewAdminUser());
}

@Preview(name: 'Selectors / ready / phone', size: Size(360, 100), wrapper: yaabsaPreviewLight)
@Preview(name: 'Selectors / ready / desktop', size: Size(1100, 100), wrapper: yaabsaPreviewDark)
Widget switchersReadyPreview() {
  return _switchers(user: previewAdminUser(), loading: false);
}

@Preview(name: 'Selectors / ready short names', size: Size(1100, 100), wrapper: yaabsaPreviewLight)
Widget switchersShortNamesPreview() {
  return _switchers(
    user: previewAdminUser().copyWith(username: 'Jo'),
    library: previewUploadLibrary().copyWith(name: 'SF'),
    loading: false,
  );
}

Widget _switchers({User? user, Library? library, bool loading = true}) {
  final displayedLibrary = library ?? previewUploadLibrary();
  return ProviderScope(
    overrides: [
      currentUserProvider.overrideWith((ref) {
        if (user == null) {
          return const Stream<User?>.empty();
        }

        return Stream.value(user);
      }),
      allStoredUsersProvider.overrideWith((ref) {
        if (loading) {
          return const Stream<List<User>>.empty();
        }

        return Stream.value([?user]);
      }),
      serverStatusProvider.overrideWith((ref) => const Stream<bool>.empty()),
      userLibrariesProvider.overrideWith((ref) {
        if (loading) {
          return Completer<List<Library>>().future;
        }

        return Future.value([displayedLibrary]);
      }),
      selectedLibraryIdProvider.overrideWith(_PreviewSelectedLibraryId.new),
      selectedLibraryProvider.overrideWith((ref) => loading ? null : displayedLibrary),
    ],
    child: const Center(
      child: Row(mainAxisSize: MainAxisSize.min, children: [UserSwitcher(), SizedBox(width: 6), LibrarySwitcher()]),
    ),
  );
}

class _PreviewSelectedLibraryId extends SelectedLibraryId {
  @override
  Stream<String?> build() => Stream.value(null);
}
