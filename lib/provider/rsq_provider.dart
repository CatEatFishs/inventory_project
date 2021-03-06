import 'package:flutter/cupertino.dart';
import 'package:inventoryproject/db/good_attribute_table.dart';
import 'package:inventoryproject/model/residue_good_model.dart';
import 'package:inventoryproject/provider/default_provider.dart';
import 'package:sqflite/sqflite.dart';

//热水器provide
class RsqProvide extends DefaultProvider {
  final String tableName = 'RsqDateBaseTable';

  init() async {
    setTableName(tableName);
    super.init();
  }
/*
  Database database;
  GoodAttributeTable goodAttributeTable;
  List<GoodAttributeTable> rsqDataList = [];
  List<ResidueGoodModel> residueDataList = [];
  //按条件查询
  List<GoodAttributeTable> conditionDataList = [];
  init() async {
    debugPrint('创建数据库--rsqProvide');
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
    rsqDataList.clear();
    List<GoodAttributeTable> list = await goodAttributeTable.queryAll(database);
    if (list != null) {
      rsqDataList.addAll(list);
    }
    debugPrint('rsqDataList length-${rsqDataList.length}');
    notifyListeners();
    return rsqDataList;
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

  ///按id删除某一条数据
  Future<int> queryDeleteIdData(int id)async{
    return await goodAttributeTable.queryDeleteIdData(database, tableName,id);
  }

  bool isTableExit() {
    return GoodAttributeTable().isTableExits;
  }

  List<GoodAttributeTable> get getRsqList => rsqDataList;

  //查询剩余数据
  List<ResidueGoodModel> get getResidueDataList => residueDataList;

   */
}
