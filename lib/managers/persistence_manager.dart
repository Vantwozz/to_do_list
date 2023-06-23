import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list/utils/utils.dart';

class PersistenceManager {
  Database? _database;
  static const _tableName = "list";

  Future<Database> get _databaseGetter async {
    final appDirectory = await getApplicationDocumentsDirectory();
    _database ??= await openDatabase(
      '${appDirectory.path}/to_do_list.db',
      version: 1,
      onCreate: (db, version) {
        db.execute('CREATE TABLE $_tableName (id TEXT PRIMARY KEY, '
            'text TEXT NOT NULL, '
            'importance TEXT, '
            'deadline INTEGER, '
            'done INTEGER CHECK(done == 0 OR done == 1), '
            'color TEXT, '
            'created_at INTEGER NOT NULL, '
            'changed_at INTEGER NOT NULL, '
            'last_updated_by TEXT NOT NULL)');
      },
    );
    return _database!;
  }

  Future<List<AdvancedTask>> getList() async {
    final db = await _databaseGetter;
    final items = await db.query(_tableName);
    return items.map((item) => AdvancedTask.fromJson(item)).toList();
  }

  Future<void> insertTask({required AdvancedTask task}) async {
    final db = await _databaseGetter;
    var data = {
      "id": task.id,
      "text": task.text,
      "importance": task.importance,
      "done": task.done ? 1 : 0,
      "deadline": task.deadline,
      "color": "#FFFFFF",
      "created_at": task.createdAt,
      "changed_at": DateTime.now().millisecondsSinceEpoch.toInt(),
      "last_updated_by": "1"
    };
    if (task.deadline == null) {
      data.remove("deadline");
    }
    db.insert(_tableName, data);
  }

  Future<void> deleteTask({required String id})async {
    final db = await _databaseGetter;
    db.rawDelete('DELETE FROM $_tableName WHERE id = \'$id\'');
  }

  Future<void> updateTask({required AdvancedTask task})async{
    final db = await _databaseGetter;
    db.rawUpdate('UPDATE $_tableName SET text = \'${task.text}\', '
        'importance = \'${task.importance}\', '
        'done = ${task.done ? 1 : 0}, '
        'deadline = ${task.deadline}, '
        'color = \'#FFFFFF\', '
        'changed_at = ${DateTime.now().millisecondsSinceEpoch.toInt()}, '
        'last_updated_by = "1" '
        'WHERE id = \'${task.id}\'');
  }

  Future<AdvancedTask> getTask ({required String id})async{
    final db = await _databaseGetter;
    final item = await db.rawQuery('SELECT * FROM $_tableName WHERE id = \'$id\'');
    return item.map((item) => AdvancedTask.fromJson(item)).toList()[0];    //return AdvancedTask.fromJson(item);
  }
}
