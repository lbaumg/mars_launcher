
import 'package:flutter_mars_launcher/data/app_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ShortcutAppsDatabase {
  static final ShortcutAppsDatabase instance = ShortcutAppsDatabase._init();

  static final _tableShortcuts = 'shortcutApps';
  static final _tableSpecialShortcuts = 'specialShortcutApps';
  static final _columnId = 'id';
  static final _columnPackageName = 'packageName';
  static final _columnAppName = 'appName';
  static final _columnIsSystemApp = 'systemApp';

  final List<String> tableValues = [
    _columnId,
    _columnPackageName,
    _columnAppName,
    _columnIsSystemApp
  ];

  static Database? _database;

  ShortcutAppsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('apps.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    print("Database path: $path");

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {

    /// Create table for shortcuts
    await db.execute('''
       CREATE TABLE $_tableShortcuts(
        $_columnId INT PRIMARY KEY ON CONFLICT REPLACE,
        $_columnPackageName TEXT NOT NULL,
        $_columnAppName TEXT NOT NULL,
        $_columnIsSystemApp BOOLEAN NOT NULL)
        ''');

    /// Create table for special shortcuts
    await db.execute('''
       CREATE TABLE $_tableSpecialShortcuts(
        $_columnId TEXT PRIMARY KEY ON CONFLICT REPLACE,
        $_columnPackageName TEXT NOT NULL,
        $_columnAppName TEXT NOT NULL,
        $_columnIsSystemApp BOOLEAN NOT NULL)
        ''');
  } // TODO initialise with standard values if not set and afterwards only update

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  // Future<int> numOfRows() {
  //   int count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM table_name'));
  // }

  Future create(AppInfo appInfo) async {
    final db = await instance.database;
    final id = await db.insert(_tableShortcuts, appInfo.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    print("Inserted: ${appInfo.toJson()["id"]}, $id");
  }

  Future<AppInfo> readShortcutApp(int index) async {
    final db = await instance.database;
    final maps = await db.query(_tableShortcuts,
        columns: tableValues, where: '$_columnId = ?', whereArgs: [index]);

    if (maps.isNotEmpty) {
      return AppInfo.fromJson(maps.first);
    } else {
      throw Exception('ID $index not found');
    }
  }

  Future<List<AppInfo>> readAllShortcutApps() async {
    final db = await instance.database;
    final result = await db.query(_tableShortcuts);

    return result.map((json) => AppInfo.fromJson(json)).toList();
  }

  Future<int> update(AppInfo appInfo) async {
    final db = await instance.database;

    return db.update(_tableShortcuts, appInfo.toJson(),
        where: '$_columnId = ?', whereArgs: [appInfo.toJson()["id"]]);
  }

  Future<int> delete(index) async {
    final db = await instance.database;
    return db.delete(_tableShortcuts,
        where: '$_columnId = ?', whereArgs: [index]);
  }

}
