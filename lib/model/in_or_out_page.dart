import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:inventoryproject/db/good_attribute_table.dart';
import 'package:inventoryproject/provider/bx_provider.dart';
import 'package:inventoryproject/provider/default_provider.dart';
import 'package:inventoryproject/provider/ds_provider.dart';
import 'package:inventoryproject/provider/kt_provider.dart';
import 'package:inventoryproject/provider/pj_provider.dart';
import 'package:inventoryproject/provider/providers.dart';
import 'package:inventoryproject/provider/rqz_provider.dart';
import 'package:inventoryproject/provider/rsq_provider.dart';
import 'package:inventoryproject/provider/xjd_provider.dart';
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
import 'package:inventoryproject/utils/utils_widget.dart';

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

  List<GoodAttributeTable> inAndOutTableList = []; //出入库table
  List<GoodAttributeTable> upDataTableList = []; //修改的table

  int totalOutNum = 0; //待要出库数量

  List<ResidueModel> residueModelList = []; //查出来剩余数量list

  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() {
    inOrOutList = ['入库', '出库'];
    goodTypeList = ['冰箱', '洗衣机', '空调', '电视', '燃气灶', '油烟机', '热水器','小家电','配件'];
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
              SizedBox(height: setWidth(30)),
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
    return Offstage(
      offstage: inOrOutTitle=='入库',
      child: Column(
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
                                      if (residueModelList[index].currentOutNum <
                                          residueModelList[index]
                                              .residueNum) {
                                        if (mounted) {
                                          setState(() {
                                            residueModelList[index]
                                                .currentOutNum++;
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
                                Text('${residueModelList[index].currentOutNum}'),
                                Container(
                                  width: 40,
                                  height: 20,
                                  child: RaisedButton(
                                    onPressed: () {
                                      if (residueModelList[index].currentOutNum ==
                                          0)
                                        return;
                                      if (mounted) {
                                        setState(() {
                                          residueModelList[index].currentOutNum--;
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
      ),
    );
  }

  //检查参数是否填写
  checkParams() {
    if (xhController.text.isEmpty) return showToast('请填写型号！');
    if (priceController.text.isEmpty) return showToast('请填写价格！');
    if (numController.text.isEmpty) return showToast('请填写数量！');
    if (!checkOutNum()) return showToast('填写出库数量与待出库数量不匹配！');
    if (inOrOutTitle == '入库') {
      GoodAttributeTable table = new GoodAttributeTable(
          intAndOut: inOrOutTitle,
          type: goodTypeTitle,
          model: xhController.text.trim(),
          price: UtilsWidget.str2double(priceController.text.trim()),
          num: UtilsWidget.str2int( numController.text.trim()),
          outNum: 0,
          residueNum: UtilsWidget.str2int(numController.text.trim()),
          outPrice: 0.0,
          time: DateUtils.DatePaserToMils(goodTime),
          systemTime: DateTime.now().toString());
      inAndOutTableList.add(table);
    } else {
      //出库 1.增加出库记录
      residueModelList.forEach((element) {
        if (element.currentOutNum > 0) {
          GoodAttributeTable table = GoodAttributeTable(
              intAndOut: inOrOutTitle,
              type: goodTypeTitle,
              model: xhController.text.trim(),
              price: element.price,
              num: 0,
              outNum: element.outNum,
              residueNum: 0,
              outPrice: UtilsWidget.str2double(priceController.text.trim()),
              time: DateUtils.DatePaserToMils(goodTime),
              systemTime: DateTime.now().toString()
          );
          inAndOutTableList.add(table);
          //2.修改库存
          GoodAttributeTable upDataTable = GoodAttributeTable(
            id: element.id,
            outNum: (element.outNum + element.currentOutNum), //出库数 = 以前出库数+将要出库数
            residueNum: (element.residueNum - element.currentOutNum), //剩余 = 以前剩余数-将要出库数
          );
          upDataTableList.add(upDataTable);
        }
      });
    }
    setType();

  }

  List<ResidueGoodModel> list;

  //检查待出库数量是否匹配输入数量
  bool checkOutNum() {
    if(inOrOutTitle=='入库')return true;
    totalOutNum = 0;
    residueModelList.forEach((element) {
      totalOutNum += element.currentOutNum;
    });
    return totalOutNum == int.parse(numController.text.trim());
  }

  //插入数据库
  setType() async {
    switch (goodTypeTitle) {
      case '冰箱':
        BxProvide bxProvider = Provider.of<BxProvide>(context, listen: false);
        insertData(bxProvider);
        updateData(bxProvider);
        break;
      case '洗衣机':
        XyjProvide xyjProvider =
        Provider.of<XyjProvide>(context, listen: false);
        insertData(xyjProvider);
        updateData(xyjProvider);
        break;
      case '空调':
        KtProvide ktProvide = Provider.of<KtProvide>(context, listen: false);
        insertData(ktProvide);
        updateData(ktProvide);
        break;
      case '电视':
        DsProvide dsProvider = Provider.of<DsProvide>(context, listen: false);
        insertData(dsProvider);
        updateData(dsProvider);
        break;
      case '燃气灶':
        RqzProvide rqzProvide = Provider.of<RqzProvide>(context, listen: false);
        insertData(rqzProvide);
        updateData(rqzProvide);
        break;
      case '油烟机':
        YyjProvide yyjProvide = Provider.of<YyjProvide>(context, listen: false);
        insertData(yyjProvide);
        updateData(yyjProvide);

        break;
      case '热水器':
        RsqProvide rsqProvide = Provider.of<RsqProvide>(context, listen: false);
        insertData(rsqProvide);
        updateData(rsqProvide);
        break;
      case '小家电':
        XjdProvide rsqProvide = Provider.of<XjdProvide>(context, listen: false);
        insertData(rsqProvide);
        updateData(rsqProvide);
        break;
      case '配件':
        PjProvide rsqProvide = Provider.of<PjProvide>(context, listen: false);
        insertData(rsqProvide);
        updateData(rsqProvide);
        break;
    }

    GlobalEvent.eventBus.fire(InAndOutEvent(type: goodTypeTitle));
    NavigatorRoute.pop(context);
  }

  //插入数据库
  Future<void> insertData(DefaultProvider provider) async {
    inAndOutTableList.forEach((element) async {
      await provider.insertData(element);
    });
  }

  //修改数据库
  updateData(DefaultProvider provider) async {
    upDataTableList.forEach((element) async {
      await provider.upDataData(element);
    });
  }

  //查询同一型号剩余数量大于0的记录
  checkSameXhRecord() async {
    if (xhController.text
        .trim()
        .isEmpty) return showToast('请填写查询型号！');
    DefaultProvider provider;
    switch (goodTypeTitle) {
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
    checkSameXhRecordFunction(provider);
  }

  //查询同一型号剩余数量大于0的记录
  checkSameXhRecordFunction(DefaultProvider provider) async {
    List<GoodAttributeTable> sameXhRecordList =
    await provider.checkSameXhRecord(xhController.text.trim());
    if (sameXhRecordList.length > 0) {
      showToast('查询出${sameXhRecordList.length}条数据');
      residueModelList.clear();
      sameXhRecordList.forEach((element) {
        residueModelList.add(
            ResidueModel(
                element.id,
                element.model,
                element.num,
                element.residueNum,
                element.price,
                element.outNum,
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
  int num; //总数量
  int residueNum; //剩余数量
  double price;
  int outNum;
  int currentOutNum;

  ResidueModel(this.id, this.xh, this.num, this.residueNum, this.price,
      this.outNum, this.currentOutNum);
}
