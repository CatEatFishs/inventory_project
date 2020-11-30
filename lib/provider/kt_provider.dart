import 'package:flutter/cupertino.dart';
import 'package:inventoryproject/db/good_attribute_table.dart';
import 'package:sqflite/sqflite.dart';

//空调provide
class KtProvide extends ChangeNotifier {
  final String tableName = 'KtDateBaseTable';
  Database database;
  GoodAttributeTable goodAttributeTable;
  List<GoodAttributeTable> ktDataList = [];

  init() async {
    debugPrint('创建数据库--ktProvide');
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
    ktDataList.clear();
    List<GoodAttributeTable> list = await goodAttributeTable.queryAll(database);
    if (list != null) {
      ktDataList.addAll(list);
    }
    debugPrint('bxDataList length-${ktDataList.length}');
    notifyListeners();
    return ktDataList;
  }

  bool isTableExit() {
    return GoodAttributeTable().isTableExits;
  }

  List<GoodAttributeTable> get getKtList => ktDataList;
}
