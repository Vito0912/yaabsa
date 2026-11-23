import 'package:flutter/widget_previews.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/admin/admin_user.dart';
import 'package:yaabsa/components/settings/admin_users/admin_users_table_presentation.dart';
import 'package:yaabsa/ui/components/lists/multi_select_list_card.dart';

import 'preview_fixtures.dart';
import 'preview_theme.dart';

@Preview(name: 'Admin users / light', size: Size(1280, 500), wrapper: yaabsaPreviewLight)
@Preview(name: 'Admin users / dark', size: Size(1280, 500), wrapper: yaabsaPreviewDark)
@Preview(name: 'Admin users / AMOLED', size: Size(1280, 500), wrapper: yaabsaPreviewAmoled)
Widget adminUsersTablePreview() => const AdminUsersTablePreview();

class AdminUsersTablePreview extends StatelessWidget {
  const AdminUsersTablePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: AdminUsersTablePresentation(
        users: previewAdminUsers(),
        activeUserId: 'preview-root',
        busyUserIds: const <String>{},
        isLoading: false,
        searchQuery: '',
        onCreateAuthenticationCode: _ignoreAdminAction,
        onEditUser: _ignoreAdminAction,
        onToggleUserActive: _ignoreAdminAction,
        onUnlinkOpenId: _ignoreAdminAction,
        onDeleteUser: _ignoreAdminAction,
      ),
    );
  }
}

Future<void> _ignoreAdminAction(AdminUser user) async {}

@Preview(name: 'Admin access selector / light', size: Size(520, 460), wrapper: yaabsaPreviewLight)
@Preview(name: 'Admin access selector / dark', size: Size(520, 460), wrapper: yaabsaPreviewDark)
@Preview(name: 'Admin access selector / AMOLED', size: Size(520, 460), wrapper: yaabsaPreviewAmoled)
Widget adminAccessSelectorPreview() => const AdminAccessSelectorPreview();

class AdminAccessSelectorPreview extends StatelessWidget {
  const AdminAccessSelectorPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: YaabsaMultiSelectListCard(
        title: 'Libraries',
        options: const [
          YaabsaMultiSelectOption(id: 'books', label: 'Audiobooks', subtitle: 'Book library'),
          YaabsaMultiSelectOption(id: 'podcasts', label: 'Podcasts', subtitle: 'Podcast library'),
          YaabsaMultiSelectOption(id: 'family', label: 'Family library', subtitle: 'Book library'),
        ],
        selectedIds: const {'books'},
        onSelectionChanged: _ignoreSelection,
      ),
    );
  }
}

void _ignoreSelection(Set<String> selection) {}
