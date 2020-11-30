import 'package:flutter/cupertino.dart';
import 'package:inventoryproject/db/good_attribute_table.dart';
import 'package:sqflite/sqflite.dart';

//热水器provide
class RsqProvide extends ChangeNotifier {
  final String tableName = 'RsqDateBaseTable';
  Database database;
  GoodAttributeTable goodAttributeTable;
  List<GoodAttributeTable> rsqDataList = [];

  init() async {
    debugPrint('创建数据库--rsqProvide');
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
    rsqDataList.clear();
    List<GoodAttributeTable> list = await goodAttributeTable.queryAll(database);
    if (list != null) {
      rsqDataList.addAll(list);
    }
    debugPrint('rsqDataList length-${rsqDataList.length}');
    notifyListeners();
    return rsqDataList;
  }

  bool isTableExit() {
    return GoodAttributeTable().isTableExits;
  }

  List<GoodAttributeTable> get getRsqList => rsqDataList;
}
