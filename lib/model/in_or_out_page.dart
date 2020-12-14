import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:inventoryproject/db/good_attribute_table.dart';
import 'package:inventoryproject/provider/bx_provider.dart';
import 'package:inventoryproject/provider/default_provider.dart';
import 'package:inventoryproject/provider/ds_provider.dart';
import 'package:inventoryproject/provider/kt_provider.dart';
import 'package:inventoryproject/provider/providers.dart';
import 'package:inventoryproject/provider/rqz_provider.dart';
import 'package:inventoryproject/provider/rsq_provider.dart';
import 'package:inventoryproject/provider/test_provider.dart';
import 'package:inventoryproject/provider/xyj_provider.dart';
import 'package:inventoryproject/provider/yyj_provider.dart';
import 'package:inventoryproject/utils/R.dart';
import 'package:inventoryproject/utils/date_utils.dart';
import 'package:inventoryproject/utils/global_event.dart';
import 'package:inventoryproject/utils/list_title_utils.dart';
import 'package:inventoryproject/utils/screens.dart';
import 'package:inventoryproject/utils/toast_utils.dart';
import 'package:inventoryproject/utils/util_picker.dart';
import 'package:flutter/services.dart';
import 'package:inventoryproject/utils/utils.dart';

import 'residue_good_model.dart';

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
  String goodTime;
  TextEditingController xhController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController numController = TextEditingController();
  bool isIn = true; //true 入库  false 出库

  GoodAttributeTable table; //入库table
  List<GoodAttributeTable> outTableList = []; //出库table

  int totalOutNum = 0; //待要出库数量

  List<ResidueModel> residueModelList = [];

  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() {
    inOrOutList = ['入库', '出库'];
    goodTypeList = ['冰箱', '洗衣机', '空调', '电视', '燃气灶', '油烟机', '热水器'];
    goodTime =
    '${DateTime.now().year.toString()}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  leadingStr: '型    号：', editText: xhWidget()),
              Divider(
                color: R.color_gray_666,
                height: setWidth(1),
              ),
              ListTitleUtils.listTitleEdit(
                  leadingStr: inOrOutTitle == '入库' ? '进    价：' : '出    价：',
                  editText: priceWidget()),
              Divider(
                color: R.color_gray_666,
                height: setWidth(1),
              ),
              ListTitleUtils.listTitleEdit(
                  leadingStr: '数    量：', editText: numWidget()),
              Divider(
                color: R.color_gray_666,
                height: setWidth(1),
              ),
              ListTitleUtils.listTitle(
                  leadingStr: isIn ? '入库时间：' : '出库时间：',
                  title: goodTime,
                  function: _showDatePicker),
              Divider(
                color: R.color_gray_666,
                height: setWidth(1),
              ),
              Container(
                width: AdaptUtils.screenW(),
                padding: EdgeInsets.only(
                    left: setWidth(30),
                    right: setWidth(30),
                    top: setWidth(100)),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        R.color_gray_8a8a.withOpacity(0.5)),
                  ),
                  onPressed: checkParams,
                  child: Container(
                    width: AdaptUtils.screenW(),
                    height: setWidth(45),
                    alignment: Alignment.center,
                    child: Text('完成'),
                  ),
                ),
              ),
              tabWidget()
            ],
          ),
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
            if (inOrOutTitle == '出库') {
              isIn = false;
            } else {
              isIn = true;
            }
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: setWidth(250),
            child: EditableText(
                controller: xhController,
                focusNode: FocusNode(),
                style: TextStyle(
                    fontSize: setSp(32),
                    color: Colors.black,
                    textBaseline: TextBaseline.alphabetic),
                cursorColor: Colors.blue,
                backgroundCursorColor: Colors.white),
          ),
          Offstage(
            offstage: isIn,
            child: GestureDetector(
              onTap: checkSameXhRecord,
              behavior: HitTestBehavior.translucent,
              child: Container(
                width: setWidth(80),
                height: setWidth(54),
                decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.all(Radius.circular(setWidth(4))),
                    border: Border.all(
                        color: Colors.lightBlueAccent, width: setWidth(2))),
                child: Text(
                  '查询',
                  style: TextStyle(
                      fontSize: setSp(32),
                      color: Colors.lightBlueAccent,
                      textBaseline: TextBaseline.alphabetic),
                ),
                alignment: Alignment.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  //价格
  Widget priceWidget() {
    return Container(
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

  ///出生日期选择器
  void _showDatePicker() {
    PickerUtils.showDatePicker(context,
        middleTitle: '选择日期',
        type: PickerDateTimeType.kYMD, onConfirm: (dateTime) {
          setState(() {
            goodTime =
            '${dateTime.year.toString()}-${dateTime.month.toString().padLeft(
                2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
          });
        });
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
          columnWidths: {
            //列宽
            // 0: FixedColumnWidth(getDoubleUnitWidth),
            // 1: FixedColumnWidth(getUnitWidth),
            // 2: FixedColumnWidth(getDoubleUnitWidth),
            // 3: FixedColumnWidth(getUnitWidth),
            3: FixedColumnWidth(setWidth(230)),
          },
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
                child: Text('出库数量'),
              )
            ])
          ],
        ));
  }

  Widget tabWidget() {
    return Column(
      children: [
        Offstage(
          offstage: residueModelList.length == 0,
          child: headWidget(),
        ),
        Container(
            child: Table(
              //表格边框样式
              border: TableBorder.all(
                color: Colors.black.withOpacity(0.5),
              ),
              columnWidths: {
                //列宽
                // 0: FixedColumnWidth(getDoubleUnitWidth),
                // 1: FixedColumnWidth(getUnitWidth),
                // 2: FixedColumnWidth(getDoubleUnitWidth),
                // 3: FixedColumnWidth(getUnitWidth),
                3: FixedColumnWidth(setWidth(230)),
              },
              children: (residueModelList
                  .asMap()
                  .map((index, model) =>
                  MapEntry(
                      index,
                      TableRow(decoration: BoxDecoration(), children: [
                        Container(
                          height: setWidth(90),
                          padding: EdgeInsets.only(left: 5),
                          alignment: Alignment.centerLeft,
                          child: Text('${residueModelList[index].xh}',
                              style: TextStyle(
                                  fontSize: setSp(28),
                                  fontWeight: FontWeight.w500)),
                        ),
                        Container(
                          height: setWidth(90),
                          padding: EdgeInsets.only(left: 5),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${residueModelList[index].residueNum}',
                          ),
                        ),
                        Container(
                          height: setWidth(90),
                          padding: EdgeInsets.only(left: 5),
                          alignment: Alignment.centerLeft,
                          child: Text('${residueModelList[index].price}'),
                        ),
                        Container(
                          height: setWidth(90),
                          padding: EdgeInsets.only(left: 10, right: 10),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 40,
                                height: 20,
                                child: RaisedButton(
                                  onPressed: () {
                                    if (residueModelList[index].outNum <
                                        int.parse(
                                            residueModelList[index]
                                                .residueNum)) {
                                      if (mounted) {
                                        setState(() {
                                          residueModelList[index].outNum++;
                                        });
                                      }
                                    } else {
                                      showToast('已达到最大库存！');
                                    }
                                  },
                                  child: Text(
                                    '+',
                                    style: TextStyle(
                                        fontSize: setSp(36), color: Colors.red),
                                  ),
                                ),
                              ),
                              Text('${residueModelList[index].outNum}'),
                              Container(
                                width: 40,
                                height: 20,
                                child: RaisedButton(
                                  onPressed: () {
                                    if (residueModelList[index].outNum == 0)
                                      return;
                                    if (mounted) {
                                      setState(() {
                                        residueModelList[index].outNum--;
                                      });
                                    }
                                  },
                                  child: Text(
                                    '-',
                                    style: TextStyle(
                                        fontSize: setSp(36), color: Colors.red),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ])))
                  .values
                  .toList()),
            ))
      ],
    );
  }

  //检查参数是否填写
  checkParams() {
    if (xhController.text.isEmpty) return showToast('请填写型号！');
    if (priceController.text.isEmpty) return showToast('请填写价格！');
    if (numController.text.isEmpty) return showToast('请填写数量！');
    if (checkOutNum()) return showToast('填写出库数量与待出库数量不匹配！');
    if (inOrOutTitle == '入库') {
      table = new GoodAttributeTable(
          intAndOut: inOrOutTitle,
          type: goodTypeTitle,
          model: xhController.text.trim(),
          price: priceController.text.trim(),
          num: numController.text.trim(),
          outNum: '0',
          residueNum: numController.text.trim(),
          outPrice: '0',
          time: DateUtils.DatePaserToMils(goodTime),
          systemTime: DateTime.now().toString());
    } else {
      //出库 1.增加出库记录 2.修改库存
      residueModelList.forEach((element) {
        if (element.outNum > 0) {
          GoodAttributeTable table = GoodAttributeTable(
              intAndOut: inOrOutTitle,
              type: goodTypeTitle,
              model: xhController.text.trim(),
              price: element.price,
              num: '0',
              outNum: element.outNum.toString(),
              residueNum: '0',
              outPrice: priceController.text.trim(),
              time: DateUtils.DatePaserToMils(goodTime),
              systemTime: DateTime.now().toString()
          );
          outTableList.add(table);
        }
      });
    }
    /*
    table = new GoodAttributeTable(
        intAndOut: inOrOutTitle,
        type: goodTypeTitle,
        model: xhController.text.trim(),
        price: inOrOutTitle == '入库' ? priceController.text.trim() : '0',
        num: inOrOutTitle == '入库' ? numController.text.trim() : '0',
        outNum: inOrOutTitle == '入库' ? '0' : '$totalOutNum',
        //需要计算出库数量
        residueNum: inOrOutTitle == '入库' ? '${numController.text.trim()}' : '0',
        outPrice: inOrOutTitle == '入库' ? '0' : priceController.text.trim(),
        time: DateUtils.DatePaserToMils(goodTime),
        systemTime: DateTime.now().toString());

     */

    setType();
  }

  List<ResidueGoodModel> list;

  //检查待出库数量是否匹配输入数量
  bool checkOutNum() {
    residueModelList.forEach((element) {
      totalOutNum += element.outNum;
    });
    return totalOutNum == int.parse(numController.text.trim());
  }

  //插入数据库
  setType() async {
    switch (goodTypeTitle) {
      case '冰箱':
        BxProvide bxProvider = Provider.of<BxProvide>(context, listen: false);
        if (isInAndOut()) {
          list = bxProvider.getResidueDataList;
          if (!isResidueGood()) {
            return showToast('出库数量不能大于库存数');
          }
        }
        await bxProvider.insertData(table);
        await bxProvider.queryAll();
        break;
      case '洗衣机':
        XyjProvide xyjProvider =
        Provider.of<XyjProvide>(context, listen: false);
        if (isInAndOut()) {
          list = xyjProvider.getResidueDataList;
          if (!isResidueGood()) {
            return showToast('出库数量不能大于库存数');
          }
        }
        await xyjProvider.insertData(table);
        await xyjProvider.queryAll();
        break;
      case '空调':
        KtProvide ktProvide = Provider.of<KtProvide>(context, listen: false);
        if (isInAndOut()) {
          list = ktProvide.getResidueDataList;
          if (!isResidueGood()) {
            return showToast('出库数量不能大于库存数');
          }
        }
        await ktProvide.insertData(table);
        await ktProvide.queryAll();
        break;
      case '电视':
        DsProvide dsProvider = Provider.of<DsProvide>(context, listen: false);
        if (isInAndOut()) {
          list = dsProvider.getResidueDataList;
          if (!isResidueGood()) {
            return showToast('出库数量不能大于库存数');
          }
        }
        await dsProvider.insertData(table);
        await dsProvider.queryAll();
        break;
      case '燃气灶':
        RqzProvide rqzProvide = Provider.of<RqzProvide>(context, listen: false);
        if (isInAndOut()) {
          list = rqzProvide.getResidueDataList;
          if (!isResidueGood()) {
            return showToast('出库数量不能大于库存数');
          }
        }
        await rqzProvide.insertData(table);
        await rqzProvide.queryAll();
        break;
      case '油烟机':
        YyjProvide yyjProvide = Provider.of<YyjProvide>(context, listen: false);
        if (isInAndOut()) {
          list = yyjProvide.getResidueDataList;
          if (!isResidueGood()) {
            return showToast('出库数量不能大于库存数');
          }
        }
        await yyjProvide.insertData(table);
        await yyjProvide.queryAll();
        break;
      case '热水器':
        RsqProvide rsqProvide = Provider.of<RsqProvide>(context, listen: false);
        if (isInAndOut()) {
          list = rsqProvide.getResidueDataList;
          if (!isResidueGood()) {
            return showToast('出库数量不能大于库存数');
          }
        }
        await rsqProvide.insertData(table);
        await rsqProvide.queryAll();
        break;
    }

    GlobalEvent.eventBus.fire(InAndOutEvent(type: goodTypeTitle));
    NavigatorRoute.pop(context);
  }


  //出库时 是否够数量
  bool isResidueGood() {
    String model = xhController.text.trim();
    String num = numController.text.trim();
    if (list != null) {
      list.forEach((element) {
        if (element.model == model && element.sumNum >= int.parse(num)) {
          return true;
        }
      });
    }
    return false;
  }

  //出入库  入库false 出库 true
  bool isInAndOut() {
    return inOrOutTitle == '出库';
  }

  /*
      1.查询此型号 剩余数量>0的记录
   */

  //查询同一型号剩余数量大于0的记录
  checkSameXhRecord() async {
    if (xhController.text
        .trim()
        .isEmpty) return showToast('请填写查询型号！');
    switch (goodTypeTitle) {
      case '冰箱':
        BxProvide bxProvider = Provider.of<BxProvide>(context, listen: false);
        checkSameXhRecordFunction(bxProvider);
        break;
      case '电视':
        TestProvider testProvider =
        Provider.of<TestProvider>(context, listen: false);
        checkSameXhRecordFunction(testProvider);
        break;
    }
    return [];
  }

  //查询同一型号剩余数量大于0的记录
  checkSameXhRecordFunction(DefaultProvider provider) async {
    List<GoodAttributeTable> sameXhRecordList =
    await provider.checkSameXhRecord(xhController.text.trim());
    if (sameXhRecordList.length > 0) {
      showToast('查询出${sameXhRecordList.length}条数据');
      sameXhRecordList.forEach((element) {
        residueModelList.add(
            ResidueModel(
                element.id, element.model, element.residueNum, element.price,
                0));
      });
      if (mounted) {
        setState(() {});
      }
    } else {
      showToast('此型号暂无库存！');
    }
  }

}

class ResidueModel {
  int id;
  String xh;
  String residueNum;
  String price;
  int outNum;

  ResidueModel(this.id, this.xh, this.residueNum, this.price, this.outNum);
}
