import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart' show databaseFactoryWeb;

Future<Database> openCacheDatabase() async {
  return databaseFactoryWeb.openDatabase('cache.db');
}
