import 'package:flutter/cupertino.dart';
import 'package:inventoryproject/db/good_attribute_table.dart';
import 'package:inventoryproject/model/residue_good_model.dart';
import 'package:sqflite/sqflite.dart';

//冰箱provide
class BxProvide extends ChangeNotifier {
  final String tableName = 'BxDateBaseTable';
  Database database;
  GoodAttributeTable goodAttributeTable;
  List<GoodAttributeTable> bxDataList = [];
  List<ResidueGoodModel> residueDataList = [];

  init() async {
    goodAttributeTable = GoodAttributeTable();
    goodAttributeTable.setTabName = tableName;
    database = await goodAttributeTable.getDataBase();
    queryResidueAll();
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

  ///查询表中剩余物品的数据
  Future<List<ResidueGoodModel>> queryResidueAll() async {
    residueDataList =
        await goodAttributeTable.queryResidueAll(database, tableName);
    return residueDataList;
  }

  bool isTableExit() {
    return GoodAttributeTable().isTableExits;
  }

  //查询所有数据
  List<GoodAttributeTable> get getBxList => bxDataList;

  //查询剩余数据
  List<ResidueGoodModel> get getResidueDataList => residueDataList;
}
