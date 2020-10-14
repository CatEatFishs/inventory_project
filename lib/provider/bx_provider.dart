import 'package:flutter/cupertino.dart';
import 'package:inventoryproject/db/database.dart';
import 'package:inventoryproject/db/db_base_provider.dart';
import 'package:inventoryproject/db/good_attribute_table.dart';
import 'package:inventoryproject/model/good_attribute_model.dart';
import 'package:inventoryproject/provider/providers.dart';
import 'package:sqflite/sqflite.dart';

//冰箱provide
class BxProvide extends ChangeNotifier {
  init() {
    debugPrint('创建数据库--BxProvide');
    GoodAttributeTable().getDataBase();
  }


}
