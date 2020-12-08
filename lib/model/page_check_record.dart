import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:inventoryproject/db/good_attribute_table.dart';
import 'package:inventoryproject/provider/bx_provider.dart';
import 'package:inventoryproject/provider/ds_provider.dart';
import 'package:inventoryproject/provider/kt_provider.dart';
import 'package:inventoryproject/provider/rqz_provider.dart';
import 'package:inventoryproject/provider/rsq_provider.dart';
import 'package:inventoryproject/provider/xyj_provider.dart';
import 'package:inventoryproject/provider/yyj_provider.dart';
import 'package:inventoryproject/utils/R.dart';
import 'package:inventoryproject/utils/date_utils.dart';
import 'package:inventoryproject/utils/list_title_utils.dart';
import 'package:inventoryproject/utils/screens.dart';
import 'package:inventoryproject/utils/toast_utils.dart';
import 'package:inventoryproject/utils/util_picker.dart';
import 'package:provider/provider.dart';

//查询记录
class CheckRecord extends StatefulWidget {
  @override
  _CheckRecordState createState() => _CheckRecordState();
}

class _CheckRecordState extends State<CheckRecord> {
  String inOrOutTitle = '请选择';
  String goodTypeTitle = '请选择';
  List<String> goodTypeList = [];
  List<String> inOrOutList = []; //出入库
  String goodStartTime;
  String goodEndTime;
  List<GoodAttributeTable> goodList = [];
  TextStyle _textLeadingStyle = TextStyle(
      fontSize: setSp(32),
      color: Colors.black,
      textBaseline: TextBaseline.alphabetic);

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: setWidth(30), right: setWidth(30)),
          child: Column(
            children: [
              GestureDetector(
                onTap: _openInOrOutTypeBottomSheet,
                child: Container(
                    height: setWidth(94),
                    padding: EdgeInsets.only(right: setWidth(30)),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          '出入库：',
                          style: _textLeadingStyle,
                        ),
                        Text(
                          inOrOutTitle,
                          style: _textLeadingStyle,
                        )
                      ],
                    )),
              ),
              GestureDetector(
                onTap: _openGoodTypeBottomSheet,
                child: Container(
                    height: setWidth(94),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(right: setWidth(30)),
                    child: Row(
                      children: [
                        Text(
                          '类型：',
                          style: _textLeadingStyle,
                        ),
                        Text(
                          goodTypeTitle,
                          style: _textLeadingStyle,
                        )
                      ],
                    )),
              ),
              GestureDetector(
                onTap: () => _showDatePicker('startTime'),
                child: Container(
                    height: setWidth(94),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(right: setWidth(30)),
                    child: Row(
                      children: [
                        Text(
                          '开始时间：',
                          style: _textLeadingStyle,
                        ),
                        Text(
                          goodStartTime,
                          style: _textLeadingStyle,
                        )
                      ],
                    )),
              ),
              GestureDetector(
                onTap: () => _showDatePicker('endTime'),
                child: Container(
                    height: setWidth(94),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(right: setWidth(30)),
                    child: Row(
                      children: [
                        Text(
                          '结束时间：',
                          style: _textLeadingStyle,
                        ),
                        Text(
                          goodEndTime,
                          style: _textLeadingStyle,
                        )
                      ],
                    )),
              ),
              GestureDetector(
                onTap: checkData,
                child: Container(
                  height: setWidth(94),
                  alignment: Alignment.center,
                  color: R.color_gray_666.withOpacity(0.5),
                  width: getScreenWidth(),
                  padding: EdgeInsets.only(right: setWidth(30)),
                  child: Text(
                    '查询',
                    style: _textLeadingStyle,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: tabWidget(),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: setWidth(60),
              )
            ],
          ),
        ),
      ),
    );
  }

  setData() {
    inOrOutList = ['不限', '入库', '出库'];
    goodTypeList = ['冰箱', '洗衣机', '空调', '电视', '燃气灶', '油烟机', '热水器'];
    goodStartTime = goodEndTime =
        '${DateTime.now().year.toString()}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';
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

  Widget headWidget() {
    return Container(
        margin: EdgeInsets.only(top: setWidth(30)),
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
            // 0: FixedColumnWidth(getDoubleUnitWidth),
            // 1: FixedColumnWidth(getUnitWidth),
            // 2: FixedColumnWidth(getDoubleUnitWidth),
            // 3: FixedColumnWidth(getUnitWidth),
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
                  TableRow(decoration: BoxDecoration(), children: [
                    Container(
                      height: setWidth(90),
                      padding: EdgeInsets.only(left: 5),
                      alignment: Alignment.centerLeft,
                      child: Text('${goodList[index].intAndOut}',
                          style: TextStyle(
                              fontSize: setSp(28),
                              fontWeight: FontWeight.w500)),
                    ),
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
                      child: Text('${goodList[index].num}'),
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

  ///按条件查询
   checkData() async {
    if (goodTypeTitle.contains('请')) return showToast('请选择电器类型');
    switch (goodTypeTitle) {
      case '冰箱':
        BxProvide bxProvider = Provider.of<BxProvide>(context, listen: false);
        goodList = await bxProvider.queryConditionData(
            inAndOut: inOrOutTitle,
            model: goodTypeTitle,
            startTime: DateUtils.DatePaserToMils(goodStartTime),
            endTime: DateUtils.DatePaserToMils(goodEndTime));
        break;
      case '洗衣机':
        XyjProvide xyjProvider = Provider.of<XyjProvide>(
            context, listen: false);
        goodList = await xyjProvider.queryConditionData(
            inAndOut: inOrOutTitle,
            model: goodTypeTitle,
            startTime: DateUtils.DatePaserToMils(goodStartTime),
            endTime: DateUtils.DatePaserToMils(goodEndTime));
        break;
      case '空调':
        KtProvide ktProvider = Provider.of<KtProvide>(context, listen: false);
        goodList = await ktProvider.queryConditionData(
            inAndOut: inOrOutTitle,
            model: goodTypeTitle,
            startTime: DateUtils.DatePaserToMils(goodStartTime),
            endTime: DateUtils.DatePaserToMils(goodEndTime));
        break;
      case '电视':
        DsProvide dsProvider = Provider.of<DsProvide>(context, listen: false);
        goodList = await dsProvider.queryConditionData(
            inAndOut: inOrOutTitle,
            model: goodTypeTitle,
            startTime: DateUtils.DatePaserToMils(goodStartTime),
            endTime: DateUtils.DatePaserToMils(goodEndTime));
        break;
      case '燃气灶':
        RqzProvide rqzProvider =
            Provider.of<RqzProvide>(context, listen: false);
        goodList = await rqzProvider.queryConditionData(
            inAndOut: inOrOutTitle,
            model: goodTypeTitle,
            startTime: DateUtils.DatePaserToMils(goodStartTime),
            endTime: DateUtils.DatePaserToMils(goodEndTime));
        break;
      case '油烟机':
        YyjProvide yyjProvider =
            Provider.of<YyjProvide>(context, listen: false);
        goodList = await yyjProvider.queryConditionData(
            inAndOut: inOrOutTitle,
            model: goodTypeTitle,
            startTime: DateUtils.DatePaserToMils(goodStartTime),
            endTime: DateUtils.DatePaserToMils(goodEndTime));
        break;
      case '热水器':
        RsqProvide rsqProvider =
            Provider.of<RsqProvide>(context, listen: false);
        goodList = await rsqProvider.queryConditionData(
            inAndOut: inOrOutTitle,
            model: goodTypeTitle,
            startTime: DateUtils.DatePaserToMils(goodStartTime),
            endTime: DateUtils.DatePaserToMils(goodEndTime));
        break;
    }
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
