import 'package:flutter/material.dart';
import 'package:inventoryproject/model/good_show_list_page.dart';
import 'package:inventoryproject/utils/R.dart';
import 'package:inventoryproject/utils/screens.dart';

//出入库记录
class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage>
    with SingleTickerProviderStateMixin {
  List<Tab> myTabs;
  TabController tabController;

  @override
  void initState() {
    super.initState();

    myTabs = [
      new Tab(text: '冰箱'),
      new Tab(text: '洗衣机'),
      new Tab(text: '空调'),
      new Tab(text: '电视'),
      new Tab(text: '燃气灶'),
      new Tab(text: '油烟机'),
      new Tab(text: '热水器')
    ];
    tabController = new TabController(length: myTabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            TabBar(
                controller: tabController,
                tabs: myTabs,
                isScrollable: true,
                indicatorColor: Colors.amber,
                labelColor: Colors.black,
                unselectedLabelColor: R.color_gray_666,
                labelStyle: TextStyle(fontSize: setSp(32)),
                unselectedLabelStyle: TextStyle(fontSize: setSp(28)),
                indicatorSize: TabBarIndicatorSize.label),
            Expanded(
                flex: 1,
                child: TabBarView(
                  controller: tabController,
                  children: myTabs
                      .asMap()
                      .map((index, model) => MapEntry(
                          index, GoodShowListPage(goodName: model.text)))
                      .values
                      .toList(),
                ))
          ],
        ),
      )),
    );
  }
}



