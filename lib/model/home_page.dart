import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:inventoryproject/db/good_attribute_table.dart';
import 'package:inventoryproject/model/good_attribute_model.dart';
import 'package:inventoryproject/model/in_or_out_page.dart';
import 'package:inventoryproject/model/record_page.dart';
import 'package:inventoryproject/provider/bx_provider.dart';
import 'package:inventoryproject/utils/R.dart';
import 'package:inventoryproject/utils/route_navigator.dart';
import 'package:inventoryproject/utils/screens.dart';
import 'package:provider/provider.dart';

import '../utils/screens.dart';
import '../utils/screens.dart';
import 'good_show_page.dart';
import 'in_out_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int homeTabIndex = 0;
  BxProvide provide;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1080, height: 1920);
    provide = Provider.of<BxProvide>(context, listen: false);
    return Scaffold(
      bottomNavigationBar: bottomNavigationBarWidget(),
      backgroundColor: R.color_gray_666,
      body: IndexedStack(
        children: <Widget>[GoodShowPage(), RecordPage()],
        index: homeTabIndex,
      ),
    );
  }

  Widget bottomNavigationBarWidget() {


    String goodImage;
    double goodFont;
    String goodColor;
    String recordImage;
    String recordFont;
    switch(homeTabIndex){
      case 0:
        goodImage='images/icons/home_red_icon.png';
        goodFont=setSp(26);
        break;
      case 1:
        break;
      case 2:

        break;
    }




    return SafeArea(
        child: Container(
      height: setHeight(98.0),
      width: getScreenWidth(),
      color: Colors.white,
      padding: EdgeInsets.only(left: setWidth(30),right: setWidth(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                index = 0;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('images/icons/home_red_icon.png',width: setWidth(40),height: setHeight(40),),
                Text(' 商品',style: TextStyle(color: R.color_red_d81e,fontSize: setSp(26)),),
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
