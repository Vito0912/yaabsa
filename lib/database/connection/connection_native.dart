import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:yaabsa/util/app_paths.dart';

QueryExecutor openConnection() {
  return LazyDatabase(() async {
    final configFolder = await resolveDefaultConfigDirectory();
    final file = File(p.join(configFolder.path, 'app_db.sqlite'));
    await file.parent.create(recursive: true);
    return NativeDatabase.createInBackground(file);
  });
}
