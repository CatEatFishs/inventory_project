import 'package:flutter/cupertino.dart';
import 'package:inventoryproject/db/good_attribute_table.dart';
import 'package:sqflite/sqflite.dart';

//燃气灶provide
class RqzProvide extends ChangeNotifier {
  final String tableName = 'RqzDateBaseTable';
  Database database;
  GoodAttributeTable goodAttributeTable;
  List<GoodAttributeTable> rqzDataList = [];

  init() async {
    debugPrint('创建数据库--RqzProvide');
    goodAttributeTable = GoodAttributeTable();
    goodAttributeTable.setTabName = tableName;
    database = await goodAttributeTable.getDataBase();
    queryAll();
    if (database == null) {
      debugPrint('数据库空');
    } else {
      debugPrint('数据库不空');
    }
  }

//插入数据
  Future<int> insertData(GoodAttributeTable table) async {
    int value = await goodAttributeTable.insert(database, table);
    notifyListeners();
    return value;
  }

  ///查询表中所有的数据
  Future<List<GoodAttributeTable>> queryAll() async {
    rqzDataList.clear();
    List<GoodAttributeTable> list = await goodAttributeTable.queryAll(database);
    if (list != null) {
      rqzDataList.addAll(list);
    }
    debugPrint('rqzDataList length-${rqzDataList.length}');
    notifyListeners();
    return rqzDataList;
  }

  bool isTableExit() {
    return GoodAttributeTable().isTableExits;
  }

  List<GoodAttributeTable> get getRqzList => rqzDataList;
}
