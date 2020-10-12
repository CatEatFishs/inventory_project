import 'package:inventoryproject/model/good_attribute_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseProvider {
  Database db;
  String tableName; //表名称
  String columnId = '_id';
  String intAndOut = 'intAndOut'; //出入库
  String type = 'type'; //类型
  String model = 'model'; //型号
  String price = 'price'; //价格
  int num = 0; //数量
  String time = 'time'; //出入库时间
  String path;

  Future<String> creatTable(String tableName) async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    path = join(databasesPath, '$tableName.db');
    return path;
  }

  Future open(String path, String tableName) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableName ( 
  $columnId integer primary key autoincrement, 
  $intAndOut text not null,
  $type text not null,
  $model text not null,
  $price text not null,
  $num integer not null,
  $time text not null,)
''');
    });
  }

  /// 插入数据
  Future<int> insert(GoodAttributeModel model) async {
    int value = await db.insert(tableName, model.toMap());
    return value;
  }

  /*
  ///获取数据
  Future<GoodAttributeModel> getTodo(int id) async {
    List<Map> maps = await db.query(tableName,
        columns: [columnId, columnDone, columnTitle],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Todo.fromMap(maps.first);
    }
    return null;
  }

   */

  ///获取所有数据
  Future<List<Map<String, dynamic>>> getAllData() async {
    List<Map<String, dynamic>> records = await db.query('$tableName');
    return records;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  /*
  Future<int> update(GoodAttributeModel todo) async {
    return await db.update(tableTodo, todo.toMap(),
        where: '$columnId = ?', whereArgs: [todo.id]);
  }

   */

  Future close() async => db.close();
}
