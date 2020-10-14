import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

///数据库的统一管理类，创建、关闭等基础操作
class DBManager {
  ///数据库的版本号
  static const int _VERSION = 1;

  ///数据库名称
  static const String _DB_Name = "HomeAppliance.db";

  factory DBManager() => _getInstance();

  static DBManager get instance => _getInstance();

  // 静态私有成员，没有初始化
  static DBManager _instance;

  // 私有构造函数
  DBManager._();

  // 静态、同步、私有访问点
  static DBManager _getInstance() {
    if (_instance == null) {
      _instance = new DBManager._();
    }
    return _instance;
  }

  static Database _database;

  ///获取当前数据库实例
  Future<Database> getCurrentDb() async {
    if (_database == null) {
      var databasePath = await getDatabasesPath();

      String dbName = _DB_Name;

      final String path = join(databasePath, dbName);

      return _database = await openDatabase(path, version: _VERSION);
    } else {
      return _database;
    }
  }

  ///判断指定表是否存在
  Future<bool> isTableExits(String tableName) async {
    await getCurrentDb();

    String sql =
        'select * from Sqlite_master where type= "table" and name="$tableName"';
    var result = await _database?.rawQuery(sql);
    return result != null && result.length > 0;
  }
}
