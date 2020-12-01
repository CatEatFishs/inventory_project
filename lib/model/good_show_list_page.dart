import 'package:flutter/material.dart';
import 'package:inventoryproject/db/good_attribute_table.dart';
import 'package:inventoryproject/provider/bx_provider.dart';
import 'package:provider/provider.dart';

import '../utils/R.dart';

//展示每个分类
class GoodShowListPage extends StatefulWidget {
  final String goodName;

  const GoodShowListPage({Key key, this.goodName = '冰箱'}) : super(key: key);

  @override
  _GoodShowListPageState createState() => _GoodShowListPageState();
}

class _GoodShowListPageState extends State<GoodShowListPage> with AutomaticKeepAliveClientMixin{
  List<GoodAttributeTable> goodList = [];
  BxProvide bxProvider;
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      debugPrint('list instance');
      // checkDataBase();
    });
    super.initState();
  }

  Widget tabWidget(List<GoodAttributeTable> list) {
    list.insert(0, GoodAttributeTable(model: '类型',price: '价格',num: '数量',time: '时间'));
    return Container(
        child: Table(
      //表格边框样式
      border: TableBorder.all(
        color: Colors.black.withOpacity(0.5),
      ),
      children: (list
          .asMap()
          .map((index, model) => MapEntry(
              index,
              TableRow(children: [
                Text('${list[index].model}'),
                Text('${list[index].price}'),
                Text('${list[index].num}'),
                Text('${list[index].time}'),
              ])))
          .values
          .toList()),
    ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(child: dataWidget());
  }

  Widget dataWidget() {
    switch (this.widget.goodName) {
      case '冰箱':
        return ChangeNotifierProvider(
          create: (_) {
            // BxProvide bxProvider = Provider.of<BxProvide>(context, listen: false);
          },
          child: Consumer<BxProvide>(builder: (context, bxProvider, _) {
            return tabWidget(bxProvider.getBxList);
          }),
        );
        break;
      case '洗衣机':
        return ChangeNotifierProvider(
          create: (_) {
            // bxProvider = Provider.of<BxProvide>(context, listen: false);
          },
          child: Consumer<XyjProvide>(builder: (context, xyjProvider, _) {
            return tabWidget(xyjProvider.getXyjList);
          }),
        );
        break;
      case '空调':
        return ChangeNotifierProvider(
          create: (_) {
            // bxProvider = Provider.of<BxProvide>(context, listen: false);
          },
          child: Consumer<KtProvide>(builder: (context, ktProvider, _) {
            return tabWidget(ktProvider.getKtList);
          }),
        );
        break;
      case '电视':
        return ChangeNotifierProvider(
          create: (_) {
            // bxProvider = providervider.of<BxProvide>(context, listen: false);
          },
          child: Consumer<DsProvide>(builder: (context, dsProvider, _) {
            return tabWidget(dsProvider.getDsList);
          }),
        );
        break;
      case '燃气灶':
        return ChangeNotifierProvider(
          create: (_) {
            // bxProvider = Provider.of<BxProvide>(context, listen: false);
          },
          child: Consumer<RqzProvide>(builder: (context, rqzProvider, _) {
            return tabWidget(rqzProvider.getRqzList);
          }),
        );
        break;
      case '抽烟机':
        return ChangeNotifierProvider(
          create: (_) {
            // bxProvider = Provider.of<BxProvide>(context, listen: false);
          },
          child: Consumer<YyjProvide>(builder: (context, yyjProvider, _) {
            return tabWidget(yyjProvider.getYyjList);
          }),
        );
        break;
      case '热水器':
        return ChangeNotifierProvider(
          create: (_) {
            // bxProvider = Provider.of<BxProvide>(context, listen: false);
          },
          child: Consumer<RsqProvide>(builder: (context, rsqProvider, _) {
            return tabWidget(rsqProvider.getRsqList);
          }),
        );
        break;
    }
    return Container();
  }

  void getChcek() async {
    BxProvide bxProvider = Provider.of<BxProvide>(context, listen: false);
    List<ResidueGoodModel> goodLists = await bxProvider.queryResidueAll();
    debugPrint('goodListsLength---${goodLists.length}');
    for (int i = 0; i < goodLists.length; i++) {
      debugPrint('element-----${goodLists[i].model.toString()}');
    }
  }
}
