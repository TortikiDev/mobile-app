import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'db_factory.dart';

class TortikiDbFactory implements DbFactory {
  final _dbName = 'tortiki_database.db';
  final _dbVersion = 1;

  @override
  Future<Database> createDb() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, _dbName),
      onCreate: (db, version) {
        return db.execute(
          '''
        CREATE TABLE 
        bookmarked_recipes(
          id INTEGER PRIMARY KEY, 
          title TEXT, 
          complexity REAL, 
          imageUrls TEXT)
        ''',
        );
      },
      version: _dbVersion,
    );
  }
}
