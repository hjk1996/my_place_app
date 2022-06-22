import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DbHelper {
  static Future<Database> get db async {
    final basePath = await getDatabasesPath();
    final dbName = 'places.db';
    final dbPath = path.join(basePath, dbName);

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE places(id TEXT PRIMARY KEY, imagePath TEXT, title TEXT, loc_lat REAL, loc_lng REAL, address text)");
      },
    );
  }

  static Future<void> addPlace(String table, Map<String, Object> data) async {
    final db = await DbHelper.db;
    await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> removePlace(String id) async {
    final db = await DbHelper.db;
    await db.delete("places", where: "id = ?", whereArgs: [id]);
  }

  static Future<List<Map>> getPlaces() async {
    final db = await DbHelper.db;
    return db.query("places");
  }
}
