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
import 'package:inventoryproject/utils/date_utils.dart';
import 'package:inventoryproject/utils/screens.dart';
import 'package:provider/provider.dart';

//剩余数量页面
class GoodShowResidueList extends StatefulWidget {
  final String goodName;

  const GoodShowResidueList({Key key, this.goodName = '冰箱'}) : super(key: key);

  @override
  _GoodShowResidueListState createState() => _GoodShowResidueListState();
}

class _GoodShowResidueListState extends State<GoodShowResidueList> {
  List<GoodAttributeTable> goodList = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getChcek();
    });
    super.initState();
  }

  Widget tabWidget(List<ResidueGoodModel> list) {
    return Column(
      children: [
        Offstage(
          offstage: list.length == 0,
          child: headWidget(),
        ),
        GestureDetector(
          onTap: getChcek,
          child: Container(
              child: Table(
            //表格边框样式
            border: TableBorder.all(
              color: Colors.black.withOpacity(0.5),
            ),
            children: (list
                .asMap()
                .map((index, model) => MapEntry(
                    index,
                    TableRow(decoration: BoxDecoration(), children: [
                      Container(
                        height: setWidth(60),
                        padding: EdgeInsets.only(left: 5),
                        alignment: Alignment.centerLeft,
                        child: Text('${list[index].model}',
                            style: TextStyle(
                                fontSize: setSp(28),
                                fontWeight: FontWeight.w500)),
                      ),
                      Container(
                        height: setWidth(60),
                        padding: EdgeInsets.only(left: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${list[index].price}',
                        ),
                      ),
                      Container(
                        height: setWidth(60),
                        padding: EdgeInsets.only(left: 5),
                        alignment: Alignment.centerLeft,
                        child: Text('${list[index].sumNum}'),
                      ),
                      Container(
                        height: setWidth(60),
                        padding: EdgeInsets.only(left: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                            '${DateUtils.DatePaserToYMD(list[index].time)}'),
                      )
                    ])))
                .values
                .toList()),
          )),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // BxProvide bxProvider = Provider.of<BxProvide>(context, listen: false);
    return Container(child: dataWidget());
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
    switch (this.widget.goodName) {
      case '冰箱':
        return ChangeNotifierProvider(
          create: (_) {
            // BxProvide bxProvider = Provider.of<BxProvide>(context, listen: false);
          },
          child: Consumer<BxProvide>(builder: (context, bxProvider, _) {
            return tabWidget(bxProvider.getResidueDataList);
          }),
        );
        break;
      case '洗衣机':
        return ChangeNotifierProvider(
          create: (_) {
            // bxProvider = Provider.of<BxProvide>(context, listen: false);
          },
          child: Consumer<XyjProvide>(builder: (context, xyjProvider, _) {
            return tabWidget(xyjProvider.getResidueDataList);
          }),
        );
        break;
      case '空调':
        return ChangeNotifierProvider(
          create: (_) {
            // bxProvider = Provider.of<BxProvide>(context, listen: false);
          },
          child: Consumer<KtProvide>(builder: (context, ktProvider, _) {
            return tabWidget(ktProvider.getResidueDataList);
          }),
        );
        break;
      case '电视':
        return ChangeNotifierProvider(
          create: (_) {
            // bxProvider = providervider.of<BxProvide>(context, listen: false);
          },
          child: Consumer<DsProvide>(builder: (context, dsProvider, _) {
            return tabWidget(dsProvider.getResidueDataList);
          }),
        );
        break;
      case '燃气灶':
        return ChangeNotifierProvider(
          create: (_) {
            // bxProvider = Provider.of<BxProvide>(context, listen: false);
          },
          child: Consumer<RqzProvide>(builder: (context, rqzProvider, _) {
            return tabWidget(rqzProvider.getResidueDataList);
          }),
        );
        break;
      case '抽烟机':
        return ChangeNotifierProvider(
          create: (_) {
            // bxProvider = Provider.of<BxProvide>(context, listen: false);
          },
          child: Consumer<YyjProvide>(builder: (context, yyjProvider, _) {
            return tabWidget(yyjProvider.getResidueDataList);
          }),
        );
        break;
      case '热水器':
        return ChangeNotifierProvider(
          create: (_) {
            // bxProvider = Provider.of<BxProvide>(context, listen: false);
          },
          child: Consumer<RsqProvide>(builder: (context, rsqProvider, _) {
            return tabWidget(rsqProvider.getResidueDataList);
          }),
        );
        break;
    }
    return Container();
  }

  void getChcek() async {
    BxProvide bxProvider = Provider.of<BxProvide>(context, listen: false);
    List<ResidueGoodModel> goodLists = await bxProvider.queryResidueAll();
  }
}
