import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Pengelola koneksi SQLite (singleton) + operasi CRUD tingkat rendah.
class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const _dbName = 'dominos.db';
  static const _dbVersion = 2;
  static const tableProfiles = 'profiles';

  Database? _db;

  Future<Database> get database async => _db ??= await _open();

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableProfiles (
            id         INTEGER PRIMARY KEY AUTOINCREMENT,
            name       TEXT NOT NULL,
            birth_date TEXT,
            phone      TEXT,
            email      TEXT,
            gender      TEXT,
            anniversary TEXT
          )
        ''');
      },
      // Migrasi: database versi 1 (belum ada gender & anniversary) -> versi 2
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE $tableProfiles ADD COLUMN gender TEXT');
          await db.execute(
              'ALTER TABLE $tableProfiles ADD COLUMN anniversary TEXT');
        }
      },
    );
  }

  // CREATE
  Future<int> insert(String table, Map<String, Object?> row) async {
    final db = await database;
    return db.insert(table, row);
  }

  // READ
  Future<List<Map<String, Object?>>> queryAll(String table) async {
    final db = await database;
    return db.query(table, orderBy: 'id ASC');
  }

  // UPDATE
  Future<int> update(String table, int id, Map<String, Object?> row) async {
    final db = await database;
    return db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

  // DELETE
  Future<int> delete(String table, int id) async {
    final db = await database;
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}