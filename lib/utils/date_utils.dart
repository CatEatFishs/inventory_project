import 'package:flutter/widgets.dart';

class DateUtils {
  static String DatePaserToMils(String time) {
    debugPrint('输入时间----$time');
    String a = DateTime.parse(time).millisecondsSinceEpoch.toString();
    debugPrint('输出时间----$a');
    return a;
  }

  static String DatePaserToYMD(String time) {
    debugPrint('输出时间time----$time');
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return '${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }
}
