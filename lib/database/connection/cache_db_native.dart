import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart' show databaseFactoryIo;
import 'package:yaabsa/util/app_paths.dart';

Future<Database> openCacheDatabase() async {
  final cacheFolder = await resolveDefaultCacheDirectory();
  final file = File(p.join(cacheFolder.path, 'cache.db'));
  await file.parent.create(recursive: true);
  return databaseFactoryIo.openDatabase(file.path);
}
