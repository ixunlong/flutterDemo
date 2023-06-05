import 'package:intl/intl.dart';

enum DateTimeTrimSelect {
  zero,
  year,
  month,
  day,
  hour,
  minute,
  second,
  milli,
  micro
}

extension DateTimeEx1 on DateTime {

  formatedString([String pattern = "yyyy-MM-dd HH:mm:ss"]) {
    return DateFormat(pattern).format(this);
  }

  bool isInToday() => isInDay(0);
  bool isInTommorow() => isInDay(1);

  bool isInDay(int distance) {
    final seconds = difference(DateTime.now().nextStartDay(distance)).inSeconds;
    return seconds > 0 && seconds < (3600 * 24);
  } 

  bool get isInThisYear => DateTime.now().year == year;

  DateTime nextStartDay([int days = 1]) => 
    add(Duration(days: days)).trim(DateTimeTrimSelect.day);

  DateTime nextStartHour([int hours = 1]) => 
    add(Duration(hours: hours)).trim(DateTimeTrimSelect.hour);
  
  DateTime nextStartMinute([int minutes = 1]) => 
    add(Duration(minutes: minutes)).trim(DateTimeTrimSelect.minute);
  
  DateTime nextStartSecond([int seconds = 1]) => 
    add(Duration(seconds: seconds)).trim(DateTimeTrimSelect.second);

  DateTime trim([DateTimeTrimSelect e = DateTimeTrimSelect.micro]) {
    return DateTime(
      e.index >= DateTimeTrimSelect.year.index ? year : 0,
      e.index >= DateTimeTrimSelect.month.index ? month : 0,
      e.index >= DateTimeTrimSelect.day.index ? day : 0,
      e.index >= DateTimeTrimSelect.hour.index ? hour : 0,
      e.index >= DateTimeTrimSelect.minute.index ? minute : 0,
      e.index >= DateTimeTrimSelect.second.index ? second : 0,
      e.index >= DateTimeTrimSelect.milli.index ? millisecond : 0,
      e.index >= DateTimeTrimSelect.micro.index ? microsecond : 0);
  }
}