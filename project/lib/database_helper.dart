import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> initializeDatabase() async {
    if (_database != null) return _database!;

    // Get the path to the directory for the database
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'my_database.db');

    // Open and return the database
    _database = await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute(
        'CREATE TABLE Test(id INTEGER PRIMARY KEY, name TEXT)',
      );
    });

    return _database!;
  }

  Future<void> insertData(String name) async {
    final db = await initializeDatabase();
    await db.insert(
      'Test',
      {'name': name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final db = await initializeDatabase();
    return db.query('Test');
  }

  Future<void> closeDatabase() async {
    final db = await initializeDatabase();
    db.close();
  }
}
