import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateUtilsExtension on DateUtils {
  ///时间戳转格式化时间
  ///dateFormat 'yyyy-MM-dd HH:mm:ss'
  static String formatTimeStamp(int timeStamp, String dateFormat) {
    if (timeStamp == 0) return '';

    var date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    // var formatDate = DateFormat(dateFormat).format(date);
    return formatDateTime(date, dateFormat);
  }

  ///标准时间格式化
  static String formatDateString(String dateString, String dateFormat) {
    final date = DateTime.parse(dateString).toLocal();
    var formatDate = DateFormat(dateFormat).format(date);
    return formatDate;
  }

  static String formatDateTime(DateTime date, String dateFormat) {
    // if (timeStamp == 0) return '';

    // var date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    var formatDate = DateFormat(dateFormat).format(date);
    return formatDate;
  }
}
