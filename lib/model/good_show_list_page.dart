import 'package:flutter/material.dart';
import 'package:inventoryproject/db/good_attribute_table.dart';
import 'package:inventoryproject/model/residue_good_model.dart';
import 'package:inventoryproject/provider/bx_provider.dart';
import 'package:inventoryproject/provider/ds_provider.dart';
import 'package:inventoryproject/provider/kt_provider.dart';
import 'package:inventoryproject/provider/rqz_provider.dart';
import 'package:inventoryproject/provider/rsq_provider.dart';
import 'package:inventoryproject/provider/xyj_provider.dart';
import 'package:inventoryproject/provider/yyj_provider.dart';
import 'package:inventoryproject/utils/dialog_utils.dart';
import 'package:inventoryproject/utils/utils.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:inventoryproject/utils/date_utils.dart';
import 'package:inventoryproject/utils/global_event.dart';
import 'package:inventoryproject/utils/screens.dart';
import 'package:inventoryproject/utils/utils_widget.dart';

//展示每个分类
class GoodShowListPage extends StatefulWidget {
  final String goodName;

  const GoodShowListPage({Key key, this.goodName = '冰箱'}) : super(key: key);

  @override
  _GoodShowListPageState createState() => _GoodShowListPageState();
}

class _GoodShowListPageState extends State<GoodShowListPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<GoodAttributeTable> goodList = [];
  StreamSubscription<InAndOutEvent> inAndOutEventStreamSubscription;
  BxProvide bxProvider;
  XyjProvide xyjProvider;
  KtProvide ktProvider;
  DsProvide dsProvider;
  RqzProvide rqzProvider;
  YyjProvide yyjProvider;
  RsqProvide rsqProvider;
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
          columnWidths: {
            //列宽
            4: FixedColumnWidth(setWidth(200)),
          },
          //表格边框样式
          border: TableBorder.all(
            color: Colors.black.withOpacity(0.5),
          ),
          children: (goodList
              .asMap()
              .map((index, model) => MapEntry(
                  index,
                  TableRow(children: [
                    GestureDetector(
                      onLongPress: (){
                        setState(() {
                          goodList[index].isSelect=true;
                        });
                        showDialogs(index);
                      },
                      child: Container(
                        height: setWidth(90),
                        padding: EdgeInsets.only(left: 5),
                        alignment: Alignment.centerLeft,
                        color: goodList[index].isSelect?Colors.black.withOpacity(0.3):Colors.white,
                        child: Text('${goodList[index].intAndOut}',
                            style: TextStyle(
                                fontSize: setSp(28),
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                    GestureDetector(
                      onLongPress: (){
                        setState(() {
                          goodList[index].isSelect=true;
                        });
                        showDialogs(index);
                      },
                      child: Container(
                        height: setWidth(90),
                        padding: EdgeInsets.only(left: 5),
                        alignment: Alignment.centerLeft,
                        color: goodList[index].isSelect?Colors.black.withOpacity(0.3):Colors.white,
                        child: Text('${goodList[index].model}',
                            style: TextStyle(
                                fontSize: setSp(28),
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                    GestureDetector(
                      onLongPress: (){
                        setState(() {
                          goodList[index].isSelect=true;
                        });
                        showDialogs(index);
                      },
                      child: Container(
                        height: setWidth(90),
                        padding: EdgeInsets.only(left: 5),
                        alignment: Alignment.centerLeft,
                        color: goodList[index].isSelect?Colors.black.withOpacity(0.3):Colors.white,
                        child: Text(
                          '${goodList[index].price}',
                        ),
                      ),
                    ),
                    GestureDetector(
                      onLongPress: (){
                        setState(() {
                          goodList[index].isSelect=true;
                        });
                        showDialogs(index);
                      },
                      child: Container(
                        height: setWidth(90),
                        padding: EdgeInsets.only(left: 5),
                        alignment: Alignment.centerLeft,
                        color: goodList[index].isSelect?Colors.black.withOpacity(0.3):Colors.white,
                        child: Text('${goodList[index].num}'),
                      ),
                    ),
                    GestureDetector(
                      onLongPress: (){
                        setState(() {
                          goodList[index].isSelect=true;
                        });
                        showDialogs(index);
                      },
                      child: Container(
                        height: setWidth(90),
                        padding: EdgeInsets.only(left: 5),
                        alignment: Alignment.centerLeft,
                        color: goodList[index].isSelect?Colors.black.withOpacity(0.3):Colors.white,
                        child: Text(
                            '${DateUtils.DatePaserToYMD(goodList[index].time)}'),
                      ),
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
                margin:
                    EdgeInsets.only(left: setWidth(15), right: setWidth(15)),
                child: dataWidget()),
          )
        ],
      ),
    );
  }

  Widget headWidget() {
    return Container(
        child: Table(
          columnWidths: {
            //列宽
            4: FixedColumnWidth(setWidth(200)),
          },
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
                child: Text('出入库',
                    style: TextStyle(
                        fontSize: setSp(28), fontWeight: FontWeight.w500)),
              ),
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
                child: Text('数量'),
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

  showDialogs(int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return InfoCustomDialog(
          confirmCallback: (){
            debugPrint('确定');
            deleteData(index);
            Navigator.pop(context);
          },
          dismissCallback: (){
            Navigator.pop(context);
            setState(() {
              goodList[index].isSelect=false;
            });
          },
        );
      },
    );
  }

  void getCheck() async {
    switch (this.widget.goodName) {
      case '冰箱':
        bxProvider = Provider.of<BxProvide>(context, listen: false);
        goodList = await bxProvider.queryAll();
        break;
      case '洗衣机':
        xyjProvider =
            Provider.of<XyjProvide>(context, listen: false);
        goodList = await xyjProvider.queryAll();
        break;
      case '空调':
        ktProvider = Provider.of<KtProvide>(context, listen: false);
        goodList = await ktProvider.queryAll();
        break;
      case '电视':
        dsProvider = Provider.of<DsProvide>(context, listen: false);
        goodList = await dsProvider.queryAll();
        break;
      case '燃气灶':
        rqzProvider = Provider.of<RqzProvide>(context, listen: false);
        goodList = await rqzProvider.queryAll();
        break;
      case '油烟机':
        yyjProvider = Provider.of<YyjProvide>(context, listen: false);
        goodList = await yyjProvider.queryAll();
        break;
      case '热水器':
        rsqProvider = Provider.of<RsqProvide>(context, listen: false);
        goodList = await rsqProvider.queryAll();
        break;
    }
    if (mounted) {
      setState(() {});
    }
  }

  //删除数据
  void deleteData(int index)async{
    int result=0;
    switch (this.widget.goodName) {
      case '冰箱':
        result= await bxProvider.queryDeleteIdData(goodList[index].id);
        break;
      case '洗衣机':
        result= await xyjProvider.queryDeleteIdData(goodList[index].id);
        break;
      case '空调':
        result= await ktProvider.queryDeleteIdData(goodList[index].id);
        break;
      case '电视':
        result= await dsProvider.queryDeleteIdData(goodList[index].id);
        break;
      case '燃气灶':
        result = await rqzProvider.queryDeleteIdData(goodList[index].id);
        break;
      case '油烟机':
        result = await yyjProvider.queryDeleteIdData(goodList[index].id);
        break;
      case '热水器':
        result = await rsqProvider.queryDeleteIdData(goodList[index].id);
        break;
    }
    if(result==1){
      goodList.removeAt(index);
      showToast('记录删除成功！');
      GlobalEvent.eventBus.fire(InAndOutEvent(type: this.widget.goodName));
      if(mounted){
        setState(() {
        });
      }
    }
  }


}
