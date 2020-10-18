import 'package:flutter/cupertino.dart';
import 'package:inventoryproject/db/database.dart';
import 'package:inventoryproject/db/db_base_provider.dart';
import 'package:inventoryproject/db/good_attribute_table.dart';
import 'package:inventoryproject/model/good_attribute_model.dart';
import 'package:inventoryproject/provider/providers.dart';
import 'package:sqflite/sqflite.dart';

//冰箱provide
class BxProvide extends ChangeNotifier {
  Database database;
  GoodAttributeTable goodAttributeTable;
  init() async {
    debugPrint('创建数据库--BxProvide');
    goodAttributeTable = GoodAttributeTable();
    database = await goodAttributeTable.getDataBase();
    if (database == null) {
      debugPrint('数据库空');
    } else {
      debugPrint('数据库不空');
    }
  }

  //插入数据
  Future<int> insertData(GoodAttributeTable table) async {
    return goodAttributeTable.insert(database, table);
  }

  ///查询表中所有的数据
  Future<List<GoodAttributeTable>> queryAll() async {
    return await goodAttributeTable.queryAll(database);
  }
  bool isTableExit() {
    return GoodAttributeTable().isTableExits;
  }
}
