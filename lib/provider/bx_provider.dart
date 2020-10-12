import 'package:flutter/cupertino.dart';
import 'package:inventoryproject/db/database.dart';
import 'package:inventoryproject/model/good_attribute_model.dart';
import 'package:sqflite/sqflite.dart';

//冰箱provide
class BxProvide extends ChangeNotifier {
  String tableName = 'bxDateBase';
  String path;
  Database db;

  init() async {
    path = await DataBaseProvider().creatTable(tableName);
    debugPrint('path path= $path');
  }

  insert(GoodAttributeModel model) async {
    if (db == null) {
      db = await DataBaseProvider().open(path, tableName);
    }
//    int value=await DataBaseProvider().insert(model);
//    debugPrint('插入返回值 value= $value');
  }
}
