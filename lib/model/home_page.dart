import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:inventoryproject/model/in_or_out_page.dart';
import 'package:inventoryproject/model/record_page.dart';
import 'package:inventoryproject/provider/bx_provider.dart';
import 'package:inventoryproject/utils/R.dart';
import 'package:inventoryproject/utils/route_navigator.dart';
import 'package:inventoryproject/utils/screens.dart';
import 'package:provider/provider.dart';
import '../utils/screens.dart';
import 'good_show_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int homeTabIndex = 0;
  BxProvide provide;

  @override
  Widget build(BuildContext context) {
    provide = Provider.of<BxProvide>(context, listen: false);
    return Scaffold(
      bottomNavigationBar: bottomNavigationBarWidget(),
      backgroundColor: Colors.white,
      body: IndexedStack(
        children: <Widget>[GoodShowPage(), RecordPage()],
        index: homeTabIndex,
      ),
    );
  }

  Widget bottomNavigationBarWidget() {
    String goodImage;
    double goodFont;
    Color goodColor;
    String recordImage;
    double recordFont;
    Color recordColor;
    switch (homeTabIndex) {
      case 0:
        goodImage = 'images/icons/home_red_icon.png';
        goodFont = setSp(26);
        goodColor = R.color_red_d81e;

        recordImage = 'images/icons/record_gray_icon.png';
        recordFont = setSp(24);
        recordColor = R.color_gray_8a8a;

        break;
      case 1:
        goodImage = 'images/icons/home_black_icon.png';
        goodFont = setSp(24);
        goodColor = Colors.black;

        recordImage = 'images/icons/record_black_icon.png';
        recordFont = setSp(26);
        recordColor = Colors.black;
        break;
    }

    return SafeArea(
        child: Container(
      height: setHeight(98.0),
      width: getScreenWidth(),
      color: Colors.white,
      padding: EdgeInsets.only(left: setWidth(30), right: setWidth(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                homeTabIndex = 0;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  goodImage,
                  width: setWidth(40),
                  height: setHeight(40),
                ),
                Text(
                  ' 商品',
                  style: TextStyle(color: goodColor, fontSize: goodFont),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              NavigatorRoute.push(context, InOrOutPage(), pageName: '');
            },
            child: Text('出入库'),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                homeTabIndex = 1;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  recordImage,
                  width: setWidth(40),
                  height: setHeight(40),
                ),
                Text(
                  ' 记录',
                  style: TextStyle(color: recordColor, fontSize: recordFont),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
