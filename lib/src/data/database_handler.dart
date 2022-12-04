import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class DataBaseHandler {
  Future<void> saveLocalData(Map<String, dynamic> data, String tableName,
      {bool shouldReplaceAll = false}) async {
    final db = await getDatabase();

    final store = intMapStoreFactory.store(tableName);

    await store.add(db, data);
  }

  Future<List<dynamic>> getLocalData(String tableName) async {
    final db = await getDatabase();

    final store = intMapStoreFactory.store(tableName);

    final result = await store.find(db);

    final entities = <dynamic>[];

    for (var element in result) {
      entities.add(element.value);
    }

    return entities;
  }

  Future<Database> getDatabase() async {
    final appDir = await getApplicationDocumentsDirectory();
    await appDir.create(recursive: true);
    final databasePath = join(appDir.path, 'sembast.db');
    final database = await databaseFactoryIo.openDatabase(databasePath);

    return database;
  }

  Future<void> clearTable(String tableName) async {
    final db = await getDatabase();

    final store = intMapStoreFactory.store(tableName);

    store.drop(db);
  }
}
