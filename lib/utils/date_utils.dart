import 'package:flutter/widgets.dart';

class DateUtils {
  static String DatePaserToMils(String time) {
    String a = DateTime.parse(time).millisecondsSinceEpoch.toString();
    return a;
  }

  static String DatePaserToYMD(String time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return '${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }
}
