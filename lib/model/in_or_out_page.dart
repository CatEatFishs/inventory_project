import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventoryproject/db/good_attribute_table.dart';
import 'package:inventoryproject/provider/bx_provider.dart';
import 'package:inventoryproject/provider/providers.dart';
import 'package:inventoryproject/utils/R.dart';
import 'package:inventoryproject/utils/list_title_utils.dart';
import 'package:inventoryproject/utils/route_navigator.dart';
import 'package:inventoryproject/utils/screens.dart';
import 'package:inventoryproject/utils/toast_utils.dart';
import 'package:inventoryproject/utils/util_picker.dart';

//出入库页面
class InOrOutPage extends StatefulWidget {
  @override
  _InOrOutPageState createState() => _InOrOutPageState();
}

class _InOrOutPageState extends State<InOrOutPage> {
  List<String> inOrOutList = []; //出入库
  List<String> goodTypeList = [];
  String inOrOutTitle = '入库';
  String goodTypeTitle = '冰箱';
  TextEditingController xhController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController numController = TextEditingController();

  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() {
    inOrOutList = ['入库', '出库'];
    goodTypeList = ['冰箱', '洗衣机', '空调', '电视', '燃气灶', '抽烟机', '热水器'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: <Widget>[
              ListTitleUtils.listTitle(
                  leadingStr: '出入库：',
                  title: inOrOutTitle,
                  function: _openInOrOutTypeBottomSheet),
              Divider(
                color: R.color_gray_666,
                height: setWidth(1),
              ),
              ListTitleUtils.listTitle(
                  leadingStr: '类    型：',
                  title: goodTypeTitle,
                  function: _openGoodTypeBottomSheet),
              Divider(
                color: R.color_gray_666,
                height: setWidth(1),
              ),
              ListTitleUtils.listTitleEdit(
                  leadingStr: '型    号:', editText: xhWidget()),
              Divider(
                color: R.color_gray_666,
                height: setWidth(1),
              ),
              ListTitleUtils.listTitleEdit(
                  leadingStr: '价    格:', editText: priceWidget()),
              Divider(
                color: R.color_gray_666,
                height: setWidth(1),
              ),
              ListTitleUtils.listTitleEdit(
                  leadingStr: '数    量:', editText: numWidget()),
              Divider(
                color: R.color_gray_666,
                height: setWidth(1),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(R.color_gray_8a8a),
              ),
              onPressed: pressedFunction,
              child: Container(
                width: AdaptUtils.screenW(),
                height: setWidth(45),
                alignment: Alignment.center,
                child: Text('完成'),
              ),
            ),
          )
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  ///出入库类型
  Future _openInOrOutTypeBottomSheet() async {
    PickerUtils.showTextPicker(context,
        pickerData: [inOrOutList],
        middleTitle: '出入库',
        selectedIndexList: [0], onConfirm: (indexList, valueList) {
      setState(() {
        inOrOutTitle = inOrOutList[indexList[0]];
        FocusScope.of(context).requestFocus(FocusNode());
      });
    });
  }

  ///商品类型
  Future _openGoodTypeBottomSheet() async {
    PickerUtils.showTextPicker(context,
        pickerData: [goodTypeList],
        middleTitle: '商品类型',
        selectedIndexList: [0], onConfirm: (indexList, valueList) {
      setState(() {
        goodTypeTitle = goodTypeList[indexList[0]];
        FocusScope.of(context).requestFocus(FocusNode());
      });
    });
  }

  //型号
  Widget xhWidget() {
    return Container(
      padding: EdgeInsets.only(left: setWidth(30)),
      child: EditableText(
          controller: xhController,
          focusNode: FocusNode(),
          style: TextStyle(
              fontSize: setSp(32),
              color: Colors.black,
              textBaseline: TextBaseline.alphabetic),
          cursorColor: Colors.blue,
          backgroundCursorColor: Colors.white),
    );
  }

  //价格
  Widget priceWidget() {
    return Container(
      margin: EdgeInsets.only(left: setWidth(30)),
      child: EditableText(
          controller: priceController,
          focusNode: FocusNode(),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: TextStyle(
              fontSize: setSp(32),
              color: Colors.black,
              textBaseline: TextBaseline.alphabetic),
          cursorColor: Colors.blue,
          backgroundCursorColor: Colors.white),
    );
  }

  //数量
  Widget numWidget() {
    return Container(
      margin: EdgeInsets.only(left: setWidth(30)),
      child: EditableText(
          controller: numController,
          focusNode: FocusNode(),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: TextStyle(
              fontSize: setSp(32),
              color: Colors.black,
              textBaseline: TextBaseline.alphabetic),
          cursorColor: Colors.blue,
          backgroundCursorColor: Colors.white),
    );
  }

  GoodAttributeTable table;

  //检查参数是否填写
  checkParams() {
    if (xhController.text.isEmpty) return showToast('请填写型号！');
    if (priceController.text.isEmpty) return showToast('请填写价格！');
    if (numController.text.isEmpty) return showToast('请填写数量！');
    // {this.intAndOut, this.type, this.model, this.price, this.num, this.time});
    table = new GoodAttributeTable(
        intAndOut: inOrOutTitle,
        type: goodTypeTitle,
        model: xhController.text.trim(),
        price: priceController.text.trim(),
        num: numController.text.trim(),
        time: '2020-11-04',
        systemTime: DateTime.now().toString());
    setType();
  }

  BxProvide bxProvider;

  //插入数据库
  setType() async {
    switch (goodTypeTitle) {
      case '冰箱':
        bxProvider = Provider.of<BxProvide>(context, listen: false);
        await bxProvider.insertData(table);
        await bxProvider.queryAll();
        break;
      case '洗衣机':
        break;
      case '空调':
        break;
      case '电视':
        break;
      case '燃气灶':
        break;
      case '抽烟机':
        break;
      case '热水器':
        break;
    }

    NavigatorRoute.pop(context);
  }

  pressedFunction() {
    checkParams();
  }
}
