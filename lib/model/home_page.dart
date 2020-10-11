import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:inventoryproject/model/record_page.dart';
import 'package:inventoryproject/utils/screens.dart';

import 'good_show_page.dart';
import 'in_out_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1080, height: 1920);
    return Scaffold(
      bottomNavigationBar: bottomNavigationBarWidget(),
      body: IndexedStack(
        children: <Widget>[GoodShowPage(), RecordPage()],
        index: index,
      ),
    );
  }

  Widget bottomNavigationBarWidget() {
    return SafeArea(
        child: Container(
      height: setHeight(98.0),
      width: setWidth(Screens.width),
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                index = 0;
              });
            },
            child: Text('商品'),
          ),
          GestureDetector(
            child: Text('出入库'),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                index = 1;
              });
            },
            child: Text('记录'),
          ),
        ],
      ),
    ));
  }
}
