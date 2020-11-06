import 'package:flutter/cupertino.dart';
import 'package:inventoryproject/db/good_attribute_table.dart';
import 'package:sqflite/sqflite.dart';

//冰箱provide
class BxProvide extends ChangeNotifier {
  Database database;
  GoodAttributeTable goodAttributeTable;
  List<GoodAttributeTable> bxDataList = [];

  init() async {
    debugPrint('创建数据库--BxProvide');
    goodAttributeTable = GoodAttributeTable();
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
    bxDataList.clear();
    List<GoodAttributeTable> list = await goodAttributeTable.queryAll(database);
    if (list != null) {
      bxDataList.addAll(list);
    }
    debugPrint('bxDataList length-${bxDataList.length}');
    notifyListeners();
    return bxDataList;
  }

  bool isTableExit() {
    return GoodAttributeTable().isTableExits;
  }

  List<GoodAttributeTable> get getBxList => bxDataList;
}
