import 'package:flutter/widgets.dart';

class DateUtils {
  static String DatePaserToMils(String time) {
    try {
      return DateTime.parse(time).millisecondsSinceEpoch.toString();
    } catch (_) {
      return '';
    }
  }

  static String DatePaserToYMD(String time) {
    try {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
      return '${dateTime.year.toString()}-${dateTime.month.toString().padLeft(
          2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }
}
