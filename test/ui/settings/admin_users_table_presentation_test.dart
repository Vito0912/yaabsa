import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/admin/admin_user.dart';
import 'package:yaabsa/components/settings/admin_users/admin_users_table_presentation.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('admin user table keeps identity badges and email together on mobile', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(YaabsaPreviewApp(child: Scaffold(body: _buildTable())));
    await tester.pumpAndSettle();

    expect(find.text('Alice Example'), findsOneWidget);
    expect(find.text('ACTIVE'), findsOneWidget);
    expect(find.text('OPENID'), findsOneWidget);
    expect(find.text('alice@example.com'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('admin user table keeps row callbacks and active-user delete protection', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    AdminUser? editedUser;
    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Scaffold(
          body: _buildTable(
            activeUserId: _users.first.id,
            onEditUser: (user) async {
              editedUser = user;
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final editButton = find.byTooltip('Edit user').first;
    await tester.tap(editButton);
    await tester.pump();

    expect(editedUser, _users.first);
    expect(find.text('alice@example.com'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('admin user actions share their shape while delete keeps destructive styling', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(YaabsaPreviewApp(child: Scaffold(body: _buildTable())));
    await tester.pumpAndSettle();

    final qrAction = _buttonForTooltip(tester, 'Create Authentication Code');
    final editAction = _buttonForTooltip(tester, 'Edit user');
    final toggleAction = _buttonForTooltip(tester, 'Disable user');
    final deleteAction = _buttonForTooltip(tester, 'Delete user');
    final qrShape = qrAction.style!.shape!.resolve(const <WidgetState>{});
    final editShape = editAction.style!.shape!.resolve(const <WidgetState>{});
    final toggleShape = toggleAction.style!.shape!.resolve(const <WidgetState>{});
    final qrIconColor = _iconColorForTooltip(tester, 'Create Authentication Code');
    final editIconColor = _iconColorForTooltip(tester, 'Edit user');
    final toggleIconColor = _iconColorForTooltip(tester, 'Disable user');
    final colorScheme = Theme.of(tester.element(find.byType(AdminUsersTablePresentation))).colorScheme;

    expect(editShape, qrShape);
    expect(toggleShape, qrShape);
    expect(qrShape, isA<RoundedRectangleBorder>());
    expect(editIconColor, qrIconColor);
    expect(toggleIconColor, qrIconColor);
    expect(deleteAction.style!.shape!.resolve(const <WidgetState>{}), isA<RoundedRectangleBorder>());
    expect(deleteAction.style!.foregroundColor!.resolve(const <WidgetState>{}), colorScheme.error);
    expect(tester.takeException(), isNull);
  });

  testWidgets('admin user table provides a search-specific empty state', (tester) async {
    await tester.pumpWidget(
      const YaabsaPreviewApp(
        child: Scaffold(
          body: AdminUsersTablePresentation(
            users: [],
            activeUserId: null,
            busyUserIds: <String>{},
            isLoading: false,
            searchQuery: 'missing',
            onCreateAuthenticationCode: _ignoreAction,
            onEditUser: _ignoreAction,
            onToggleUserActive: _ignoreAction,
            onUnlinkOpenId: _ignoreAction,
            onDeleteUser: _ignoreAction,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No users match your current search.'), findsOneWidget);
    expect(find.text('Try a different username, role, or email filter.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

IconButton _buttonForTooltip(WidgetTester tester, String tooltip) {
  final buttons = tester.widgetList<IconButton>(find.byType(IconButton));
  return buttons.firstWhere((button) => button.tooltip == tooltip);
}

Color? _iconColorForTooltip(WidgetTester tester, String tooltip) {
  final buttonFinder = find.byWidget(_buttonForTooltip(tester, tooltip));
  final iconFinder = find.descendant(of: buttonFinder, matching: find.byType(Icon)).first;

  return tester.widget<Icon>(iconFinder).color;
}

Widget _buildTable({String? activeUserId, Future<void> Function(AdminUser user)? onEditUser}) {
  return AdminUsersTablePresentation(
    users: _users,
    activeUserId: activeUserId,
    busyUserIds: const <String>{},
    isLoading: false,
    searchQuery: '',
    onCreateAuthenticationCode: _ignoreAction,
    onEditUser: onEditUser ?? _ignoreAction,
    onToggleUserActive: _ignoreAction,
    onUnlinkOpenId: _ignoreAction,
    onDeleteUser: _ignoreAction,
  );
}

const _users = <AdminUser>[
  AdminUser(
    id: 'user-1',
    username: 'Alice Example',
    email: 'alice@example.com',
    type: 'admin',
    isActive: true,
    hasOpenIdLink: true,
    createdAt: 1700000000000,
    lastSeen: 1700001000000,
  ),
  AdminUser(id: 'user-2', username: 'Disabled User', email: 'disabled@example.com', type: 'user', isActive: false),
];

Future<void> _ignoreAction(AdminUser user) async {}
