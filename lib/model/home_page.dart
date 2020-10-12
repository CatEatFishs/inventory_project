import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:inventoryproject/model/good_attribute_model.dart';
import 'package:inventoryproject/model/record_page.dart';
import 'package:inventoryproject/provider/bx_provider.dart';
import 'package:inventoryproject/utils/screens.dart';
import 'package:provider/provider.dart';

import 'good_show_page.dart';
import 'in_out_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  BxProvide provide;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1080, height: 1920);
    provide = Provider.of<BxProvide>(context, listen: false);
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
            onTap: () {
              provide.insert(new GoodAttributeModel(intAndOut: '1',
                  type: 'bx',
                  model: 'bx001',
                  price: '200',
                  num: '10',
                  time: '2020.10.12'));
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
