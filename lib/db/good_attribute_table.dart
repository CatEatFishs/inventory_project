//商品属性
import 'package:flutter/cupertino.dart';
import 'package:inventoryproject/db/db_base_provider.dart';
import 'package:sqflite/sqflite.dart';

class GoodAttributeTable extends BaseProvider {
  String tableName = 'BxDateBaseTable';

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

  //数量
  final String _columnNum = 'num';

  //出入库时间
  final String _columnTime = 'time';

  //系统时间
  final String _columnSystemTime = 'systemTime';

  String intAndOut; //出入库
  String type; //类型
  String model; //型号
  String price; //价格
  String num; //数量
  String time; //出入库时间
  String systemTime; //系统时间

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      _columnIntAndOut: intAndOut,
      _columnType: type,
      _columnModel: model,
      _columnPrice: price,
      _columnNum: num,
      _columnTime: time,
      _columnSystemTime: systemTime
    };
    return map;
  }

  GoodAttributeTable(
      {this.intAndOut,
      this.type,
      this.model,
      this.price,
      this.num,
      this.time,
      this.systemTime});

  GoodAttributeTable.fromMap(Map<String, dynamic> map) {
    intAndOut = map[_columnIntAndOut];
    type = map[_columnType];
    model = map[_columnModel];
    price = map[_columnPrice];
    num = map[_columnNum];
    time = map[_columnTime];
    systemTime = map[_columnSystemTime];
  }

  @override
  getTableName() {
    debugPrint('创建数据库名字');
    return tableName;
  }

  @override
  tableFieldSqlString() {
    debugPrint('创建数据库');
    return tableBaseString(tableName, _columnId) +
        """
        $_columnIntAndOut text ,
        $_columnType text ,
        $_columnModel text ,
        $_columnPrice text ,
        $_columnNum text ,
        $_columnTime text ,
        $_columnSystemTime text)
        """;
  }

  ///插入数据
  Future<int> insert(Database database, GoodAttributeTable table) async {
    if (database == null) {
      database = await this.getDataBase();
      return database.insert(
          this.getTableName(), table.toMap());
    } else {
      return database.insert(this.getTableName(), table.toMap());
    }
  }


  ///查询表中所有的数据
  Future<List<GoodAttributeTable>> queryAll(Database database) async {
    List<Map<String, dynamic>> result = await database.query(tableName,
        columns: [
          _columnId,
          _columnIntAndOut,
          _columnType,
          _columnModel,
          _columnPrice,
          _columnNum,
          _columnTime,
          _columnSystemTime
        ]);

    List<GoodAttributeTable> newList = List();

    if (result != null) {
      result.forEach((value) {
        newList.add(GoodAttributeTable.fromMap(value));
      });
    }

    return newList;
  }


}
