import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'employee.dart';

class DatabaseHelper {
  static const _databaseName = "EmployeeDatabase.db";
  static const _databaseVersion = 1;

  static const table = 'employees';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnJoinDate = 'joinDate';
  static const columnIsActive = 'isActive';

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion,
        onCreate: (db, version) async {
      await db.execute('''
            CREATE TABLE $table (
              $columnId INTEGER PRIMARY KEY,
              $columnName TEXT NOT NULL,
              $columnJoinDate TEXT NOT NULL,
              $columnIsActive BOOLEAN NOT NULL
            )
          ''');
    });
  }

  Future<void> insertEmployee(Employee employee) async {
    final db = await _initDatabase();
    await db.insert(
      table,
      employee.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Employee>> employees() async {
    final db = await _initDatabase();
    final List<Map<String, dynamic>> maps = await db.query(table);

    return List.generate(maps.length, (i) {
      return Employee(
        id: maps[i][columnId],
        name: maps[i][columnName],
        joinDate: DateTime.parse(maps[i][columnJoinDate]),
        isActive: maps[i][columnIsActive] == 1,
      );
    });
  }
}
