import 'package:flutter/material.dart';
import 'package:inventoryproject/utils/R.dart';
import 'package:inventoryproject/utils/route_navigator.dart';
import 'package:inventoryproject/utils/screens.dart';

import 'page_check_record.dart';
import 'record_page.dart';

//数据中心
class DataCenter extends StatefulWidget {
  @override
  _DataCenterState createState() => _DataCenterState();
}

class _DataCenterState extends State<DataCenter> {
  TextStyle _textLeaveLeadingStyle =
      TextStyle(fontSize: setSp(32), color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      margin: EdgeInsets.only(
          top: setWidth(30), left: setWidth(30), right: setWidth(60)),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => jumpToPage('查询记录'),
            behavior: HitTestBehavior.translucent,
            child: Container(
              height: setWidth(94),
              width: getScreenWidth(),
              alignment: Alignment.centerLeft,
              child: Text(
                '查询记录',
                style: _textLeaveLeadingStyle,
              ),
            ),
          ),
          Container(
            width: getScreenWidth(),
            height: setWidth(1),
            color: R.color_gray_666,
          ),
          GestureDetector(
            onTap: () => jumpToPage('历史记录'),
            behavior: HitTestBehavior.translucent,
            child: Container(
              height: setWidth(94),
              width: getScreenWidth(),
              alignment: Alignment.centerLeft,
              child: Text(
                '历史记录',
                style: _textLeaveLeadingStyle,
              ),
            ),
          ),
          Container(
            width: getScreenWidth(),
            height: setWidth(1),
            color: R.color_gray_666,
          ),
        ],
      ),
    ));
  }

  jumpToPage(String pageName) {
    if (pageName == '查询记录') {
      NavigatorRoute.push(context, CheckRecord(), pageName: null);
    } else {
      NavigatorRoute.push(context, RecordPage(), pageName: null);
    }
  }
}
