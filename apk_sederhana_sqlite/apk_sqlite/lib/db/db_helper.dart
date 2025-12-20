import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'mywallet.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            wallet TEXT,
            description TEXT,
            amount INTEGER,
            type TEXT
          )
        ''');
      },
    );
  }

  // INSERT
  Future<void> insertTransaction(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('transactions', data);
  }

  // SELECT
  Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await database;
    return await db.query('transactions');
  }
}
