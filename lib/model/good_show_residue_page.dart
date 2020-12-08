import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:inventoryproject/db/good_attribute_table.dart';
import 'package:inventoryproject/model/residue_good_model.dart';
import 'package:inventoryproject/provider/bx_provider.dart';
import 'package:inventoryproject/provider/ds_provider.dart';
import 'package:inventoryproject/provider/kt_provider.dart';
import 'package:inventoryproject/provider/rqz_provider.dart';
import 'package:inventoryproject/provider/rsq_provider.dart';
import 'package:inventoryproject/provider/xyj_provider.dart';
import 'package:inventoryproject/provider/yyj_provider.dart';
import 'package:inventoryproject/utils/date_utils.dart';
import 'package:inventoryproject/utils/global_event.dart';
import 'package:inventoryproject/utils/screens.dart';
import 'package:inventoryproject/utils/utils_widget.dart';
import 'package:provider/provider.dart';

//剩余数量页面
class GoodShowResidueList extends StatefulWidget {
  final String goodName;

  const GoodShowResidueList({Key key, this.goodName = '冰箱'}) : super(key: key);

  @override
  _GoodShowResidueListState createState() => _GoodShowResidueListState();
}

class _GoodShowResidueListState extends State<GoodShowResidueList> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<ResidueGoodModel> goodList = [];
  StreamSubscription<InAndOutEvent> inAndOutEventStreamSubscription;

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
                        '${goodList[index].price}',
                      ),
                    ),
                    Container(
                      height: setWidth(90),
                      padding: EdgeInsets.only(left: 5),
                      alignment: Alignment.centerLeft,
                      child: Text('${goodList[index].sumNum}'),
                    ),
                    Container(
                      height: setWidth(90),
                      padding: EdgeInsets.only(left: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                          '${DateUtils.DatePaserToYMD(goodList[index].time)}'),
                    )
                  ])))
              .values
              .toList()),
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return EasyRefresh(
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
                child: dataWidget()),
          )
        ],
      ),
    );
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
                child: Text('类型',
                    style: TextStyle(
                        fontSize: setSp(28), fontWeight: FontWeight.w500)),
              ),
              Container(
                height: setWidth(60),
                padding: EdgeInsets.only(left: 5),
                alignment: Alignment.centerLeft,
                child: Text(
                  '价格',
                ),
              ),
              Container(
                height: setWidth(60),
                padding: EdgeInsets.only(left: 5),
                alignment: Alignment.centerLeft,
                child: Text('剩余数量'),
              ),
              Container(
                height: setWidth(60),
                padding: EdgeInsets.only(left: 5),
                alignment: Alignment.centerLeft,
                child: Text('时间'),
              )
            ])
          ],
        ));
  }

  Widget dataWidget() {
    return tabWidget();
  }

  void getCheck() async {
    switch (this.widget.goodName) {
      case '冰箱':
        BxProvide bxProvider = Provider.of<BxProvide>(context, listen: false);
        goodList = await bxProvider.queryResidueAll();
        break;
      case '洗衣机':
        XyjProvide xyjProvider = Provider.of<XyjProvide>(
            context, listen: false);
        goodList = await xyjProvider.queryResidueAll();
        break;
      case '空调':
        KtProvide ktProvider = Provider.of<KtProvide>(context, listen: false);
        goodList = await ktProvider.queryResidueAll();
        break;
      case '电视':
        DsProvide dsProvider = Provider.of<DsProvide>(context, listen: false);
        goodList = await dsProvider.queryResidueAll();
        break;
      case '燃气灶':
        RqzProvide rqzProvider =
            Provider.of<RqzProvide>(context, listen: false);
        goodList = await rqzProvider.queryResidueAll();
        break;
      case '油烟机':
        YyjProvide yyjProvider =
            Provider.of<YyjProvide>(context, listen: false);
        goodList = await yyjProvider.queryResidueAll();
        break;
      case '热水器':
        RsqProvide rsqProvider =
            Provider.of<RsqProvide>(context, listen: false);
        goodList = await rsqProvider.queryResidueAll();
        break;
    }
    if (mounted) {
      setState(() {

      });
    }
  }
}
