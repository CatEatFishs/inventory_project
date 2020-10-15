import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'db_manager.dart';

///数据库表的基类
abstract class BaseProvider {
  bool isTableExits = false;

  ///创建Table的字段定义
  tableFieldSqlString();

  ///创建表的表名
  getTableName();

  ///创建表的Sql语句
  tableBaseString(String tableName, String columnId) {
    return "create table $tableName ( $columnId integer primary key autoincrement,";
  }

  Future<Database> getDataBase() async {
    return await open();
  }

  open() async {
    if (!isTableExits) {
      await prepare(getTableName(), tableFieldSqlString());
    }
    return await DBManager.instance.getCurrentDb();
  }

  prepare(tableName, String sql) async {
    isTableExits = await DBManager.instance.isTableExits(tableName);

    if (!isTableExits) {
      Database db = await DBManager.instance.getCurrentDb();
      return await db.execute(sql);
    }
  }

}
