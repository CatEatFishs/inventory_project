import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:inventoryproject/db/good_attribute_table.dart';
import 'package:inventoryproject/model/residue_good_model.dart';
import 'package:inventoryproject/provider/bx_provider.dart';
import 'package:inventoryproject/provider/default_provider.dart';
import 'package:inventoryproject/provider/ds_provider.dart';
import 'package:inventoryproject/provider/kt_provider.dart';
import 'package:inventoryproject/provider/pj_provider.dart';
import 'package:inventoryproject/provider/rqz_provider.dart';
import 'package:inventoryproject/provider/rsq_provider.dart';
import 'package:inventoryproject/provider/xjd_provider.dart';
import 'package:inventoryproject/provider/xyj_provider.dart';
import 'package:inventoryproject/provider/yyj_provider.dart';
import 'package:inventoryproject/utils/R.dart';
import 'package:inventoryproject/utils/date_utils.dart';
import 'package:inventoryproject/utils/global_event.dart';
import 'package:inventoryproject/utils/screens.dart';
import 'package:inventoryproject/utils/util_picker.dart';
import 'package:inventoryproject/utils/utils.dart';
import 'package:inventoryproject/utils/utils_widget.dart';
import 'package:provider/provider.dart';

//剩余库存
class ResidueInventoryList extends StatefulWidget {
  final String goodName;

  const ResidueInventoryList({Key key, this.goodName = '冰箱'}) : super(key: key);

  @override
  _ResidueInventoryListState createState() => _ResidueInventoryListState();
}

class _ResidueInventoryListState extends State<ResidueInventoryList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<ResidueGoodModel> goodList = [];
  StreamSubscription<InAndOutEvent> inAndOutEventStreamSubscription;

  int totalResidueInventory = 0;
  double totalPrice = 0.0;
  String goodStartTime = '-'; //开始时间
  String goodEndTime = '-'; //结束时间
  @override
  void initState() {
    inAndOutEventStreamSubscription =
        GlobalEvent.eventBus.on<InAndOutEvent>().listen((value) {
      if (value.type != null &&
          value.type.isNotEmpty &&
          value.type == this.widget.goodName) {
        getCheck();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    inAndOutEventStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        child: Stack(
      children: [
        EasyRefresh(
          firstRefresh: true,
          firstRefreshWidget: null,
          // 数据为空时的视图
          header: UtilsWidget.refreshHeader(),
          footer: UtilsWidget.refreshFooter(),
          onRefresh: () async {
            goodList.clear();
            getCheck();
          },
          onLoad: () async {},
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                    margin: EdgeInsets.only(
                        left: setWidth(15), right: setWidth(15)),
                    child: tabWidget()),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: setWidth(150),
                ),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: bottomTotalPriceWidget(),
        )
      ],
    ));
  }

  Widget headWidget() {
    return Container(
        child: Table(
      //表格边框样式
      border: TableBorder(
        top: BorderSide(color: Colors.black.withOpacity(0.5)),
        right: BorderSide(color: Colors.black.withOpacity(0.5)),
        // bottom: BorderSide(color:Colors.black.withOpacity(0.5) ),
        left: BorderSide(color: Colors.black.withOpacity(0.5)),
        horizontalInside: BorderSide(color: Colors.black.withOpacity(0.5)),
        verticalInside: BorderSide(color: Colors.black.withOpacity(0.5)),
      ),
      children: [
        TableRow(decoration: BoxDecoration(), children: [
          Container(
            height: setWidth(60),
            padding: EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            child: Text('型号',
                style: TextStyle(
                    fontSize: setSp(28), fontWeight: FontWeight.w500)),
          ),
          Container(
            height: setWidth(60),
            padding: EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            child: Text(
              '剩余数量',
            ),
          ),
          Container(
            height: setWidth(60),
            padding: EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            child: Text('入库价格'),
          ),
          Container(
            height: setWidth(60),
            padding: EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            child: Text('总价'),
          )
        ])
      ],
    ));
  }

  Widget tabWidget() {
    return Column(
      children: [
        Offstage(
          offstage: goodList.length == 0,
          child: headWidget(),
        ),
        Container(
            child: Table(
          //表格边框样式
          border: TableBorder.all(
            color: Colors.black.withOpacity(0.5),
          ),
          children: (goodList
              .asMap()
              .map((index, model) => MapEntry(
                  index,
                  TableRow(decoration: BoxDecoration(), children: [
                    Container(
                      height: setWidth(90),
                      padding: EdgeInsets.only(left: 5),
                      alignment: Alignment.centerLeft,
                      child: Text('${goodList[index].model}',
                          style: TextStyle(
                              fontSize: setSp(28),
                              fontWeight: FontWeight.w500)),
                    ),
                    Container(
                      height: setWidth(90),
                      padding: EdgeInsets.only(left: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${goodList[index].residueNum}',
                      ),
                    ),
                    Container(
                      height: setWidth(90),
                      padding: EdgeInsets.only(left: 5),
                      alignment: Alignment.centerLeft,
                      child: Text('${goodList[index].price}'),
                    ),
                    Container(
                      height: setWidth(90),
                      padding: EdgeInsets.only(left: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                          '${goodList[index].residueNum * goodList[index].price}'),
                    )
                  ])))
              .values
              .toList()),
        ))
      ],
    );
  }

  Widget bottomTotalPriceWidget() {
    return Container(
        padding: EdgeInsets.only(bottom: setWidth(60)),
        child: Table(
          //表格边框样式
          border: TableBorder(
            top: BorderSide(color: Colors.black.withOpacity(0.5)),
            right: BorderSide(color: Colors.black.withOpacity(0.5)),
            bottom: BorderSide(color: Colors.black.withOpacity(0.5)),
            left: BorderSide(color: Colors.black.withOpacity(0.5)),
            horizontalInside: BorderSide(color: Colors.black.withOpacity(0.5)),
            verticalInside: BorderSide(color: Colors.black.withOpacity(0.5)),
          ),
          children: [
            TableRow(decoration: BoxDecoration(), children: [
              Container(
                height: setWidth(80),
                padding: EdgeInsets.only(left: 5),
                alignment: Alignment.centerLeft,
                color: R.color_green_3CB71D,
                child: Text('开始时间',
                    style: TextStyle(
                        fontSize: setSp(28), fontWeight: FontWeight.w500)),
              ),
              GestureDetector(
                onTap: () {
                  _showDatePicker('startTime');
                },
                child: Container(
                  height: setWidth(80),
                  padding: EdgeInsets.only(left: 5),
                  alignment: Alignment.center,
                  color: R.color_green_3CB71D,
                  child: Text(
                    '$goodStartTime',
                  ),
                ),
              ),
              Container(
                height: setWidth(80),
                padding: EdgeInsets.only(left: 5),
                alignment: Alignment.center,
                color: R.color_green_3CB71D,
                child: Text(
                  '结束时间',
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showDatePicker('endTime');
                },
                child: Container(
                  height: setWidth(80),
                  padding: EdgeInsets.only(left: 5),
                  alignment: Alignment.center,
                  color: R.color_green_3CB71D,
                  child: Text('$goodEndTime'),
                ),
              ),
              GestureDetector(
                onTap: getCheck,
                child: Container(
                  height: setWidth(80),
                  padding: EdgeInsets.only(left: 5),
                  alignment: Alignment.centerLeft,
                  color: R.color_red_d81e,
                  child: Text('立即查询'),
                ),
              )
            ]),
            TableRow(decoration: BoxDecoration(), children: [
              Container(
                height: setWidth(60),
                padding: EdgeInsets.only(left: 5),
                alignment: Alignment.centerLeft,
                color: R.color_green_3CB71D,
                child: Text('所有型号',
                    style: TextStyle(
                        fontSize: setSp(28), fontWeight: FontWeight.w500)),
              ),
              Container(
                height: setWidth(60),
                padding: EdgeInsets.only(left: 5),
                alignment: Alignment.centerLeft,
                color: R.color_green_3CB71D,
                child: Text(
                  '$totalResidueInventory',
                ),
              ),
              Container(
                height: setWidth(60),
                padding: EdgeInsets.only(left: 5),
                alignment: Alignment.centerLeft,
                color: R.color_green_3CB71D,
                child: Text(''),
              ),
              Container(
                height: setWidth(60),
                padding: EdgeInsets.only(left: 5),
                alignment: Alignment.centerLeft,
                color: R.color_green_3CB71D,
                child: Text(''),
              ),
              Container(
                height: setWidth(60),
                padding: EdgeInsets.only(left: 5),
                alignment: Alignment.centerLeft,
                color: R.color_green_3CB71D,
                child: Text('$totalPrice'),
              )
            ])
          ],
        ));
  }

  ///时间
  void _showDatePicker(String type) {
    PickerUtils.showDatePicker(context,
        middleTitle: '选择日期',
        type: PickerDateTimeType.kYMD, onConfirm: (dateTime) {
      setState(() {
        if (type == 'startTime') {
          goodStartTime =
              '${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
        } else {
          goodEndTime =
              '${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
        }
      });
    });
  }

  void getCheck() async {
    DefaultProvider provider;
    switch (this.widget.goodName) {
      case '冰箱':
        provider = Provider.of<BxProvide>(context, listen: false);
        break;
      case '洗衣机':
        provider = Provider.of<XyjProvide>(context, listen: false);
        break;
      case '空调':
        provider = Provider.of<KtProvide>(context, listen: false);
        break;
      case '电视':
        provider = Provider.of<DsProvide>(context, listen: false);
        break;
      case '燃气灶':
        provider = Provider.of<RqzProvide>(context, listen: false);
        break;
      case '油烟机':
        provider = Provider.of<YyjProvide>(context, listen: false);
        break;
      case '热水器':
        provider = Provider.of<RsqProvide>(context, listen: false);
        break;
      case '小家电':
        provider = Provider.of<XjdProvide>(context, listen: false);
        break;
      case '配件':
        provider = Provider.of<PjProvide>(context, listen: false);
        break;
    }
    queryResidueInventoryData(provider);
  }

  //详细查询剩余库存
  queryResidueInventoryData(DefaultProvider provider) async {
    goodList.clear();
    totalResidueInventory = 0;
    totalPrice = 0.0;
    goodList = await provider.queryResidueInventoryData(
        startTime: DateUtils.DatePaserToMils(goodStartTime),
        endTime: DateUtils.DatePaserToMils(goodEndTime));
    goodList.forEach((element) {
      totalResidueInventory += element.residueNum;
      totalPrice += (element.residueNum * element.price);
    });
    if (goodList.length == 0) {
      showToast('暂无数据');
    } else {
      showToast('总共查询到${goodList.length}条数据');
    }
    if (mounted) {
      setState(() {});
    }
  }
}
