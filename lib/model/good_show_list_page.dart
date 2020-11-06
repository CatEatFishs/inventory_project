import 'package:flutter/material.dart';
import 'package:inventoryproject/db/good_attribute_table.dart';
import 'package:inventoryproject/provider/bx_provider.dart';
import 'package:provider/provider.dart';

//展示每个分类
class GoodShowListPage extends StatefulWidget {
  final String goodName;

  const GoodShowListPage({Key key, this.goodName = '冰箱'}) : super(key: key);

  @override
  _GoodShowListPageState createState() => _GoodShowListPageState();
}

class _GoodShowListPageState extends State<GoodShowListPage> {
  List<GoodAttributeTable> goodList = [];
  BxProvide bxProvider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      debugPrint('list instance');
      // checkDataBase();
    });
    super.initState();
  }

  Widget tabWidget(List<GoodAttributeTable> list) {
    return Container(
        child: Table(
      //表格边框样式
      border: TableBorder.all(
        color: Colors.red,
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
    return Container(child: dataWidget());
  }

  Widget dataWidget() {
    switch (this.widget.goodName) {
      case '冰箱':
        return ChangeNotifierProvider(
          create: (_) {
            bxProvider = Provider.of<BxProvide>(context, listen: false);
          },
          child: Consumer<BxProvide>(builder: (context, bxProvider, _) {
            return tabWidget(bxProvider.getBxList);
          }),
        );
        break;
      case '洗衣机':
        return ChangeNotifierProvider(
          create: (_) {
            bxProvider = Provider.of<BxProvide>(context, listen: false);
          },
          child: Consumer<BxProvide>(builder: (context, bxProvider, _) {
            return tabWidget(bxProvider.getBxList);
          }),
        );
        break;
      case '空调':
        return ChangeNotifierProvider(
          create: (_) {
            bxProvider = Provider.of<BxProvide>(context, listen: false);
          },
          child: Consumer<BxProvide>(builder: (context, bxProvider, _) {
            return tabWidget(bxProvider.getBxList);
          }),
        );
        break;
      case '电视':
        return ChangeNotifierProvider(
          create: (_) {
            bxProvider = Provider.of<BxProvide>(context, listen: false);
          },
          child: Consumer<BxProvide>(builder: (context, bxProvider, _) {
            return tabWidget(bxProvider.getBxList);
          }),
        );
        break;
      case '燃气灶':
        return ChangeNotifierProvider(
          create: (_) {
            bxProvider = Provider.of<BxProvide>(context, listen: false);
          },
          child: Consumer<BxProvide>(builder: (context, bxProvider, _) {
            return tabWidget(bxProvider.getBxList);
          }),
        );
        break;
      case '抽烟机':
        return ChangeNotifierProvider(
          create: (_) {
            bxProvider = Provider.of<BxProvide>(context, listen: false);
          },
          child: Consumer<BxProvide>(builder: (context, bxProvider, _) {
            return tabWidget(bxProvider.getBxList);
          }),
        );
        break;
      case '热水器':
        return ChangeNotifierProvider(
          create: (_) {
            bxProvider = Provider.of<BxProvide>(context, listen: false);
          },
          child: Consumer<BxProvide>(builder: (context, bxProvider, _) {
            return tabWidget(bxProvider.getBxList);
          }),
        );
        break;
    }
    return Container();
  }
}
