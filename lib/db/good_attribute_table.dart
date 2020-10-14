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

  String intAndOut; //出入库
  String type; //类型
  String model; //型号
  String price; //价格
  String num; //数量
  String time; //出入库时间

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      intAndOut: intAndOut,
      type: type,
      model: model,
      price: price,
      num: num,
      time: time
    };
    return map;
  }

  GoodAttributeTable(
      {this.intAndOut, this.type, this.model, this.price, this.num, this.time});

  GoodAttributeTable.fromMap(Map<String, dynamic> map) {
    intAndOut = map[intAndOut];
    type = map[type];
    model = map[model];
    price = map[price];
    num = map[num];
    time = map[time];
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
        $intAndOut text ,
        $type text ,
        $model text ,
        $price text ,
        $num integer ,
        $time text )
        """;
  }

  ///插入数据
  Future<void> insert() async {
    Database dataBase = await getDataBase();
/*
    //2-如果表不存在就创建表  //3-插入数据

    String sql = """insert or replace into $tableName (
    $_columnIntAndOut ,
    $_columnType ,
    $_columnModel ,
    $_columnPrice ,
    $_columnNum ,
    $_columnTime
    ) values(
    '$intAndOut',
    '$type',
    '$model',
    '$price',
    '$num',
    '$time'
    )
    """;
    return dataBase.execute(sql);

 */
    var count = await dataBase.insert(tableName, toMap());
  }

/*
  ///查询表中所有的数据
  Future<List<GoodAttributeTable>> queryAll() async {
    Database dataBase = await getDataBase();
    String sql = "select * from $tableName where $_columnJGUsername='${App.getInstance()?.getSelfInfo()?.jgUsername}'";
    List<Map<String, dynamic>> result = await dataBase.rawQuery(sql);

    List<GoodAttributeTable> newList = List();

    if (result != null) {
      newList.clear();
      result.forEach((value) {
        newList.add(GoodAttributeTable.fromMap(value));
      });
    }

    return newList;
  }

   */

}
