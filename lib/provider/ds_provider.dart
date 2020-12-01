import 'package:flutter/cupertino.dart';
import 'package:inventoryproject/db/good_attribute_table.dart';
import 'package:inventoryproject/model/residue_good_model.dart';
import 'package:sqflite/sqflite.dart';

//电视provide
class DsProvide extends ChangeNotifier {
  final String tableName = 'DsDateBaseTable';
  Database database;
  GoodAttributeTable goodAttributeTable;
  List<GoodAttributeTable> dsDataList = [];
  List<ResidueGoodModel> residueDataList = [];

  init() async {
    debugPrint('创建数据库--dsProvide');
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
    dsDataList.clear();
    List<GoodAttributeTable> list = await goodAttributeTable.queryAll(database);
    if (list != null) {
      dsDataList.addAll(list);
    }
    debugPrint('dsDataList length-${dsDataList.length}');
    notifyListeners();
    return dsDataList;
  }

  bool isTableExit() {
    return GoodAttributeTable().isTableExits;
  }

  List<GoodAttributeTable> get getDsList => dsDataList;

  //查询剩余数据
  List<ResidueGoodModel> get getResidueDataList => residueDataList;
}
