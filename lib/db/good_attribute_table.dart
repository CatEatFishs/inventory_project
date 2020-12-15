//商品属性
import 'package:flutter/cupertino.dart';
import 'package:inventoryproject/db/db_base_provider.dart';
import 'package:inventoryproject/model/residue_good_model.dart';
import 'package:inventoryproject/utils/date_utils.dart';
import 'package:sqflite/sqflite.dart';

class GoodAttributeTable extends BaseProvider {
  String tableName;

  //Id
  final String _columnId = "id";

  //出入库
  final String _columnIntAndOut = 'inAndOut';

  //类型
  final String _columnType = 'type';

  //型号
  final String _columnModel = 'model';

  //价格
  final String _columnPrice = 'price';

  //卖出价格
  final String _columnOutPrice = 'outPrice';

  //数量
  final String _columnNum = 'num';

  //出入库时间
  final String _columnTime = 'time';

  //系统时间
  final String _columnSystemTime = 'systemTime';

  //出库数量
  final String _columnOutNum = 'outNum';

  //剩余数量
  final String _columnResidueNum = 'residueNum';

  //是否被选择
  bool isSelect = false;

  int id;
  String intAndOut; //出入库
  String type; //类型
  String model; //型号
  String price; //价格
  String outPrice; //卖出价格
  String num; //数量
  String time; //出入库时间
  String systemTime; //系统时间
  String outNum; //出库数量
  String residueNum; //剩余数量

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      _columnIntAndOut: intAndOut,
      _columnType: type,
      _columnModel: model,
      _columnPrice: price,
      _columnNum: num,
      _columnTime: time,
      _columnSystemTime: systemTime,
      _columnOutNum: outNum ?? '0',
      _columnResidueNum: residueNum ?? num,
      _columnOutPrice: outPrice
    };
    return map;
  }

  GoodAttributeTable(
      {this.id,
      this.intAndOut,
      this.type,
      this.model,
      this.price,
      this.num,
      this.time,
      this.systemTime,
      this.outNum,
      this.residueNum,
      this.outPrice,
      this.isSelect = false});

  set setTabName(String tabName) {
    this.tableName = tabName;
  }

  GoodAttributeTable.fromMap(Map<String, dynamic> map) {
    id = map[_columnId];
    intAndOut = map[_columnIntAndOut];
    type = map[_columnType];
    model = map[_columnModel];
    price = map[_columnPrice];
    num = map[_columnNum];
    time = map[_columnTime];
    systemTime = map[_columnSystemTime];
    outNum = map[_columnOutNum];
    residueNum = map[_columnResidueNum];
    outPrice = map[_columnOutPrice];
  }

  @override
  getTableName() {
    return tableName;
  }

  @override
  tableFieldSqlString() {
    return tableBaseString(tableName, _columnId) +
        """
        $_columnIntAndOut text ,
        $_columnType text ,
        $_columnModel text ,
        $_columnPrice text ,
        $_columnOutPrice text,
        $_columnNum text ,
        $_columnTime text ,
        $_columnSystemTime text,
        $_columnOutNum text,
        $_columnResidueNum text)
        """;
  }

  ///插入数据
  Future<int> insert(Database database, GoodAttributeTable table) async {
    if (database == null) {
      database = await this.getDataBase();
      return database.insert(this.getTableName(), table.toMap());
    } else {
      return database.insert(this.getTableName(), table.toMap());
    }
  }

  ///查询表中所有的数据
  Future<List<GoodAttributeTable>> queryAll(Database database) async {
    List<Map<String, dynamic>> result =
    await database.query(tableName, columns: [
      _columnId,
      _columnIntAndOut,
      _columnType,
      _columnModel,
      _columnPrice,
      _columnNum,
      _columnTime,
      _columnSystemTime,
      _columnOutNum,
      _columnResidueNum,
      _columnOutPrice
    ]);

    List<GoodAttributeTable> newList = List();

    if (result != null) {
      result.forEach((value) {
        newList.add(GoodAttributeTable.fromMap(value));
      });
    }

    return newList;
  }

  //查询
  Future<List<ResidueGoodModel>> queryResidueAll(Database database,
      String tableName,
      {String type, String model, String price}) async {
    // String sql="SELECT * FROM $tableName WHERE $_columnIntAndOut='入库' ORDER BY time DESC";
    String sql =
        "select model,price,time,sum(num) FROM $tableName group by model";

    List<Map<String, dynamic>> result = await database.rawQuery(sql);
    List<ResidueGoodModel> newList = List();

    if (result != null) {
      result.forEach((value) {
        newList.add(ResidueGoodModel.fromJson(value));
      });
    }
    for (int i = 0; i < newList.length; i++) {
      debugPrint(newList[i].model);
    }

    return newList;
  }

  Future<List<GoodAttributeTable>> queryConditionData(
      Database database, String tableName,
      {String inAndOut, String model, String startTime, String endTime}) async {
    String sql;
    if (inAndOut == '不限' || inAndOut == '请选择') {
      sql =
          "SELECT * FROM $tableName WHERE  $_columnType = '$model' and $_columnTime >= '$startTime' and $_columnTime <= '$endTime' ORDER BY time ";
    } else {
      sql =
          "SELECT * FROM $tableName WHERE $_columnIntAndOut = '$inAndOut' and $_columnType = '$model' and $_columnTime >= '$startTime' and $_columnTime<= '$endTime' ORDER BY time ";
    }
    List<Map<String, dynamic>> result = await database.rawQuery(sql);
    List<GoodAttributeTable> newList = List();

    if (result != null) {
      result.forEach((value) {
        newList.add(GoodAttributeTable.fromMap(value));
      });
    }
    return newList;
  }

  //按照id 删除某一条数据
  Future<int> queryDeleteIdData(Database database, String tableName, int id) {
    String sql = "DELETE FROM $tableName WHERE $_columnId = '$id'";
    Future<int> rawDelete = database.rawDelete(sql);
    return rawDelete;
  }

  //查询相同类型且剩余数量大于0的数据
  Future<List<GoodAttributeTable>> queryCheckSameXhRecord(Database database,
      String tableName, String model) async {
    String sql =
        "SELECT * FROM $tableName WHERE $_columnModel = '$model' and $_columnResidueNum > '0' ORDER BY time";
    List<Map<String, dynamic>> result = await database.rawQuery(sql);
    List<GoodAttributeTable> newList = List();
    if (result != null) {
      result.forEach((value) {
        newList.add(GoodAttributeTable.fromMap(value));
      });
    }
    return newList;
  }

  Future<int> queryUpDataDataRecord(
      Database database, String tableName, GoodAttributeTable table) async {
    String sql =
        "UPDATE $tableName SET $_columnOutNum = '${table.outNum}',$_columnResidueNum = '${table.residueNum}' WHERE $_columnId = '${table.id}' ";
    int result = await database.rawUpdate(sql);
    debugPrint('sql----$sql----value-$result');
    return result;
  }
}
