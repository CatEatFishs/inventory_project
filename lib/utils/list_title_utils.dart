import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventoryproject/utils/screens.dart';

class ListTitleUtils {
  static TextStyle _textLeadingStyle = TextStyle(
      fontSize: setSp(32),
      color: Colors.black,
      textBaseline: TextBaseline.alphabetic);

  static TextStyle _textTrailingStyle =
      TextStyle(fontSize: setSp(26), color: Colors.black);

  static TextStyle _textLeaveLeadingStyle =
      TextStyle(fontSize: setSp(32), color: Colors.black);

  static Widget ListTitle({String leadingStr, String title}) {
    return Container(
      height: setWidth(94),
//      child: Center(
//        child: ListTile(
//          leading: Text(
//            leadingStr,
//            style: _textLeadingStyle,
//          ),
//          title: Text(
//            title ?? '',
//            style: _textTitleStyle,
//          ),
//          contentPadding: EdgeInsets.symmetric(horizontal: AdaptUtils.pxW(30)),
//          trailing: trailing,
//          onTap: function,
//          dense: true,
//        ),
//      ),
    );
  }
}
