import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/datetime_ex1.dart';

class TimeShowWidget extends StatefulWidget {
  const TimeShowWidget({super.key,required this.time});

  final DateTime time;

  @override
  State<TimeShowWidget> createState() => _TimeShowWidgetState();
}

class _TimeShowWidgetState extends State<TimeShowWidget> {

  late Timer t;
  // String _timeString = "";
  // String get timeString { return _timeString; }
  // void set timeString(String v) {
  //   if (_timeString != v) {
  //     setState(() {
  //       _timeString = v;    
  //     });
  //   }
  // }

  DateTime get time => widget.time;

  @override
  void initState() {
    super.initState();
    t = Timer.periodic(const Duration(seconds: 1), (timer) { 
      if (mounted) {
        setState(() {
          
        });
      }
    });
  }

  @override
  void dispose() {
    t.cancel();
    super.dispose();
  }

  String _displayText() {
    final now = DateTime.now();
    final seconds = time.difference(now).inSeconds;
    String f = "";
    if (seconds > 3600) {
      if ( time.millisecondsSinceEpoch > now.nextStartDay(3).millisecondsSinceEpoch) {
        f = time.formatedString("MM-dd HH:mm");
      } else if (time.millisecondsSinceEpoch > now.nextStartDay(2).millisecondsSinceEpoch) {
        f = "后天 ${time.formatedString("HH:mm")}";
      } else if (time.millisecondsSinceEpoch > now.nextStartDay(1).millisecondsSinceEpoch) {
        f = "明天 ${time.formatedString("HH:mm")}";
      } else {
        f = "今天 ${time.formatedString("HH:mm")}";
      }
    } else if (seconds >= 0) {
      f = "${seconds ~/ 60} ´ ${seconds % 60}";
    } else if (seconds >= -3600) {
      f = "${-seconds ~/ 60} ´ ${-seconds % 60}";
    } else {
      f = time.formatedString();
    }
    return f;
  }

  @override
  Widget build(BuildContext context) {
    final f = _displayText();
    return Text(f,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 12,color: Colours.grey_color),
      textAlign: TextAlign.right,
    );
  }

}