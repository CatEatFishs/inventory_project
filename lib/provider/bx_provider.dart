import 'package:flutter/cupertino.dart';
import 'package:inventoryproject/db/good_attribute_table.dart';
import 'package:inventoryproject/model/residue_good_model.dart';
import 'package:sqflite/sqflite.dart';

//冰箱provide
class BxProvide extends ChangeNotifier {
  final String tableName = 'BxDateBaseTable';
  Database database;
  GoodAttributeTable goodAttributeTable;

  //所有数据
  List<GoodAttributeTable> bxDataList = [];

  ///剩余数量
  List<ResidueGoodModel> residueDataList = [];

  //按条件查询
  List<GoodAttributeTable> conditionDataList = [];

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

  ///按条件查询
  Future<List<GoodAttributeTable>> queryConditionData(
      {String inAndOut, String model, String startTime, String endTime}) async {
    conditionDataList = await goodAttributeTable.queryConditionData(
        database, tableName,
        inAndOut: inAndOut,
        model: model,
        startTime: startTime,
        endTime: endTime);
    return conditionDataList;
  }

  bool isTableExit() {
    return GoodAttributeTable().isTableExits;
  }

  //查询所有数据
  List<GoodAttributeTable> get getBxList => bxDataList;

  //查询剩余数据
  List<ResidueGoodModel> get getResidueDataList => residueDataList;
}
