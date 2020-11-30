import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:inventoryproject/utils/screens.dart';

import 'R.dart';

/// picker管理类
class PickerUtils {
  /// 单列多列无联动picker
  /// 数据传入格式pickerData: 单列[['1', '2', '3',]] 或 多列 [['1', '2', '3',], ['a', 'b', 'c',]]
  /// isLinked: 是否联动（不联动，可不传）
  /// selectedIndexList默认定位到的index（联动不传值）: 单列[0] 或 多列 [0, 0]
  /// 返回值 - 最终选择值在对应列表的索引数组: indexList: [0] 或 [1, 3]
  /// 返回值 - 最终选择值数组: indexList: ['北京'] 或 ['北京', '上海']
  static showTextPicker(
    BuildContext context, {
    List<dynamic> pickerData,
    bool isLinked = false,
    String middleTitle,
    List<int> selectedIndexList, // 联动，则不需要传递
    Function(List<int> indexList, List<dynamic> valueList) onConfirm,
  }) {
    removeFocus(context);
    Picker(
      adapter: PickerDataAdapter<String>(
        pickerdata: pickerData,
        isArray: !isLinked, // 如果为联动，需要设置为false
      ),
      changeToFirst: isLinked,
      hideHeader: false,
      selecteds: selectedIndexList,
      backgroundColor: Colors.white,
      title: Text(
        middleTitle,
        style: TextStyle(fontSize: 15, color: Colors.black),
      ),
      height: 250,
      textStyle: TextStyle(color: Colors.black, fontSize: 15),
      selectedTextStyle: TextStyle(color: Colors.red, fontSize: 18),
      cancelText: '取消',
      cancelTextStyle: TextStyle(
        fontSize: 15,
        color: Colors.black,
      ),
      confirmText: '确定',
      confirmTextStyle: TextStyle(
        fontSize: 15,
        color: Colors.blue,
      ),
      onConfirm: (Picker picker, List value) {
        onConfirm(value, picker.getSelectedValues());
      },
    ).showModal(context);
  }

  // 移除焦点
  static void removeFocus(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  /// 年月日picker
  /// type:日期时间类型，使用PickerDateTimeType枚举
  /// yearSuffix monthSuffix daySuffix年月日后缀
  /// initDateTime: 初始化的日期值
  /// minDateTime：最小日期（不限制可不传）
  /// maxDateTime：最大日期（不限制可不传）
  /// 返回值: DateTime
  static showDatePicker(
    BuildContext context, {
    String middleTitle,
    int type = PickerDateTimeType.kYMDHMS,
    DateTime initDateTime,
    DateTime minDateTime,
    DateTime maxDateTime,
//    String yearSuffix = '年',
//    String monthSuffix = '月',
//    String daySuffix = '日',
    Function(DateTime dateTime) onConfirm,
  }) {
    removeFocus(context);
    Picker(
      adapter: new DateTimePickerAdapter(
        type: type,
        isNumberMonth: true,
        value: initDateTime,
        minValue: minDateTime,
        maxValue: maxDateTime,
        yearSuffix: '年',
        monthSuffix: '月',
        daySuffix: '日',
//        yearSuffix: yearSuffix,
//        monthSuffix: monthSuffix,
//        daySuffix: daySuffix,
      ),
      height: 250,
      title: new Text(
        middleTitle,
        style: TextStyle(
          fontSize: setSp(30),
        ),
      ),
      backgroundColor: Colors.white,
      cancelText: '取消',
      cancelTextStyle: TextStyle(
        fontSize: setSp(30),
        color: R.color_gray_666,
      ),
      textStyle: TextStyle(color: R.color_gray_666, fontSize: setSp(30)),
      selectedTextStyle: TextStyle(color: Colors.black, fontSize: setSp(36)),
      confirmText: '确定',
      confirmTextStyle: TextStyle(
        fontSize: setSp(30),
        color: R.color_blue_108EE9,
      ),
      onConfirm: (Picker picker, List value) {
        DateTime _dateTime = DateTime.parse(picker.adapter.toString());
        onConfirm(_dateTime);
      },
    ).showModal(context);
  }

// pickerData参考示例

// 单列不联动数据
/*
  List<List<String>> accidentInfoPickerData = [
    ['无事故', '轻微刮蹭', '碰撞事故']
  ];
  * */

// 多列不联动数据
/*
  List<List<String>> goBackTourPickerData = [
    ["飞机去", "高铁去", "火车去", "汽车去", "游轮去"],
    ["飞机回", "高铁回", "火车回", "汽车回", "游轮回"]
  ];
  */

// 多列联动数据
/*
  List testPickerData = [
    {
      "a": [
        {
          "a1": [1, 2, 3, 4]

        },
        {
          "a2": [5, 6, 7, 8]
        },
        {
          "a3": [9, 10, 11, 12]
        }
      ]
    },
    {
      "b": [
        {
          "b1": [11, 22, 33, 44]
        },
        {
          "b2": [55, 66, 77, 88]
        },
        {
          "b3": [99, 1010, 1111, 1212]
        }
      ]
    }
  ];
  */
//二级联动
/*
  testPickerData  = [
      {
        "a": [
          "1",
        ]
      },
      {
        "b": [
          "2",
          "2",
          "2"
        ]
      },
      {
        "b": [
          "2"
        ]
      }
    ];

  */

}
