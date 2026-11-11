import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/screens/settings/settings_backup_settings.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/util/settings_backup.dart';

void main() {
  late _BackupSettingsManager manager;
  late ProviderContainer container;
  late FilePickerPlatform originalPicker;
  late _BackupFilePicker picker;

  setUp(() {
    manager = _BackupSettingsManager();
    container = ProviderContainer(overrides: [settingsManagerProvider.overrideWith(() => manager)]);
    originalPicker = FilePickerPlatform.instance;
    picker = _BackupFilePicker();
    FilePickerPlatform.instance = picker;
    picker.file = _MemoryFile(SettingsBackup.encode(global: {SettingKeys.appThemeMode: 'light'}, users: {}));
  });

  tearDown(() {
    FilePickerPlatform.instance = originalPicker;
    container.dispose();
  });

  Future<void> open(WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: SettingsBackupSettings())),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('exports a portable backup through the save picker', (tester) async {
    await open(tester);
    await tester.tap(find.text('Export settings'));
    await tester.pumpAndSettle();

    final backup = SettingsBackup.decode(utf8.decode(picker.exportedBytes!));
    expect(backup.global, {SettingKeys.appThemeMode: 'dark'});
    expect(backup.users, isEmpty);
    expect(picker.exportedName, startsWith('yaabsa_settings_'));
    expect(find.text('Settings exported'), findsOneWidget);
  });

  testWidgets('cancelled export does not report success', (tester) async {
    picker.destination = null;
    await open(tester);
    await tester.tap(find.text('Export settings'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('previews import and cancellation keeps settings unchanged', (tester) async {
    await open(tester);
    await tester.tap(find.text('Import settings'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Import settings?'), findsOneWidget);
    expect(find.textContaining('1 app settings and 0 account settings'), findsOneWidget);
    expect(manager.global[SettingKeys.appThemeMode], 'dark');

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(manager.global[SettingKeys.appThemeMode], 'dark');
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('confirmed import persists preferences and reports completion', (tester) async {
    await open(tester);
    await tester.tap(find.text('Import settings'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.widgetWithText(FilledButton, 'Import'));
    await tester.pumpAndSettle();

    expect(manager.global[SettingKeys.appThemeMode], 'light');
    expect(find.text('Settings imported. Restart the app to apply all changes.'), findsOneWidget);
  });

  testWidgets('preview counts matching account settings and reports skipped accounts', (tester) async {
    manager.savedUserIds.add('user-1');
    picker.file = _MemoryFile(
      SettingsBackup.encode(
        global: {},
        users: {
          'user-1': {SettingKeys.rewindInterval: '10', SettingKeys.fastForwardInterval: '20'},
          'user-2': {SettingKeys.rewindInterval: '30'},
        },
      ),
    );
    await open(tester);
    await tester.tap(find.text('Import settings'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('0 app settings and 2 account settings'), findsOneWidget);
    expect(find.textContaining('1 unmatched account will be skipped.'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
  });

  testWidgets('unmatched account-only backup does not offer an import', (tester) async {
    picker.file = _MemoryFile(
      SettingsBackup.encode(
        global: {},
        users: {
          'unknown': {SettingKeys.rewindInterval: '30'},
        },
      ),
    );
    await open(tester);
    await tester.tap(find.text('Import settings'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('No settings to import for saved accounts with matching user IDs'), findsOneWidget);
  });

  testWidgets('invalid backup reports an error without changing preferences', (tester) async {
    picker.file = _MemoryFile('{}');
    await open(tester);
    await tester.tap(find.text('Import settings'));
    await tester.pumpAndSettle();

    expect(find.text('Choose a Yaabsa settings backup.'), findsOneWidget);
    expect(find.text('Import settings?'), findsNothing);
    expect(manager.global[SettingKeys.appThemeMode], 'dark');
  });

  testWidgets('cancelled file picker returns to idle without an error', (tester) async {
    picker.file = null;
    await open(tester);
    await tester.tap(find.text('Import settings'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byType(SnackBar), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}

class _BackupSettingsManager extends SettingsManager {
  final global = {SettingKeys.appThemeMode: 'dark'};
  final savedUserIds = <String>{};

  @override
  Stream<int> build() => Stream.value(0);

  @override
  Future<String> exportSettings() async {
    return SettingsBackup.encode(global: global, users: {});
  }

  @override
  Future<Map<String, Map<String, String>>> matchingBackupUsers(Map<String, Map<String, String>> users) async {
    return Map.fromEntries(users.entries.where((entry) => savedUserIds.contains(entry.key)));
  }

  @override
  Future<void> importSettings({
    required Map<String, String> global,
    required Map<String, Map<String, String>> users,
  }) async {
    this.global.addAll(global);
  }
}

class _BackupFilePicker extends FilePickerPlatform {
  PlatformFile? file;

  Uint8List? exportedBytes;
  String? exportedName;
  Uri? destination = Uri.parse('content://backup/settings.json');

  @override
  Future<Uri?> saveFile({
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
    String? dialogTitle,
    String? initialDirectory,
    Function(FilePickerStatus)? onFileSaving,
    WindowsOptions windowsOptions = const WindowsOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    WebOptions webOptions = const WebOptions(),
  }) async {
    exportedBytes = bytes;
    exportedName = fileName;
    return destination;
  }

  @override
  Future<PlatformFile?> pickFile({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    int compressionQuality = 0,
    AndroidOptions androidOptions = const AndroidOptions(),
    DarwinOptions darwinOptions = const DarwinOptions(),
    WindowsOptions windowsOptions = const WindowsOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    WebOptions webOptions = const WebOptions(),
  }) async {
    return file;
  }
}

final class _MemoryFile extends PlatformFile {
  _MemoryFile(String source) : _bytes = Uint8List.fromList(utf8.encode(source));

  final Uint8List _bytes;

  @override
  String get name => 'settings.json';

  @override
  Uri get uri => Uri.parse('content://backup/settings.json');

  @override
  Never get xFile => throw UnimplementedError();

  @override
  Future<int> length() async => _bytes.length;

  @override
  int lengthSync() => _bytes.length;

  @override
  Future<Uint8List> readAsBytes() async => _bytes;

  @override
  Stream<Uint8List> readAsByteStream() => Stream.value(_bytes);
}
