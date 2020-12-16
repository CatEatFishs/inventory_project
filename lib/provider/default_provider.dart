import 'package:flutter/material.dart';
import 'package:inventoryproject/model/out_good_model.dart';
import 'package:inventoryproject/model/residue_good_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:inventoryproject/db/good_attribute_table.dart';
import 'package:inventoryproject/model/residue_good_model.dart';
import 'package:sqflite/sqflite.dart';

import 'default_provider.dart';

class DefaultProvider extends ChangeNotifier {
  String tableName;
  GoodAttributeTable goodAttributeTable;
  Database database;

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

  setTableName(String tableName) {
    this.tableName = tableName;
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

  ///按id删除某一条数据
  Future<int> queryDeleteIdData(int id) async {
    return await goodAttributeTable.queryDeleteIdData(database, tableName, id);
  }

  bool isTableExit() {
    return GoodAttributeTable().isTableExits;
  }

  //查询所有数据
  List<GoodAttributeTable> get getBxList => bxDataList;

  //查询剩余数据
  List<ResidueGoodModel> get getResidueDataList => residueDataList;

  Future<List<GoodAttributeTable>> checkSameXhRecord(
      String goodTypeTitle) async {
    return await goodAttributeTable.queryCheckSameXhRecord(
        database, tableName, goodTypeTitle);
  }

  //修改数据库（根据id 修改 出库，剩余字段）
  Future<int> upDataData(GoodAttributeTable table) async {
    return await goodAttributeTable.queryUpDataDataRecord(
        database, tableName, table);
  }

  //详细查询剩余库存
  Future<List<ResidueGoodModel>> queryResidueInventoryData(
      {String startTime, String endTime}) async {
    if (startTime == null || startTime.isEmpty) startTime = null;
    if (startTime == null || startTime.isEmpty) endTime = null;
    return await goodAttributeTable.queryResidueInventoryData(
        database, tableName, startTime, endTime);
  }

  //详细查询已出库存
  Future<List<OutGoodModel>> queryOutInventoryData(
      {String startTime, String endTime}) async {
    if (startTime == null || startTime.isEmpty) startTime = null;
    if (startTime == null || startTime.isEmpty) endTime = null;
    return await goodAttributeTable.queryOutInventoryData(
        database, tableName, startTime, endTime);
  }
}
