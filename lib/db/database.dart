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


}
