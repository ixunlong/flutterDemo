import 'dart:async';
// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/utils.dart';
import 'dart:developer';

class VideoBrightnessWidget extends StatefulWidget {
  const VideoBrightnessWidget({super.key});

  @override
  State<VideoBrightnessWidget> createState() => _VideoBrightnessWidgetState();
}

class _VideoBrightnessWidgetState extends State<VideoBrightnessWidget> {
  double brightness = 0;
  bool visible = false;
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ScreenBrightness().current.then((value) {
      brightness = value;
    });
    // VolumeController().listener((value) {
    //   volumn = value;
    //   update();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: ScreenBrightness().onCurrentBrightnessChanged,
      builder: (context, snapshot) {
        double changedBrightness = brightness;
        // ScreenBrightness().hasChanged;
        if (snapshot.hasData && snapshot.data! != brightness) {
          changedBrightness = snapshot.data!;
          brightness = changedBrightness;
          visible = true;
          // update();
          timer?.cancel();
          timer = Timer.periodic(Duration(seconds: 2), (timer) {
            visible = false;
            update();
            log('update');
            timer.cancel();
          });
        }

        return AnimatedOpacity(
          opacity: visible ? 1 : 0,
          duration: Duration(milliseconds: 300),
          child: Container(
            height: 100,
            width: 50,
            child: RotatedBox(
                quarterTurns: 1,
                child: LinearPercentIndicator(
                  isRTL: true,
                  lineHeight: 2,
                  percent: changedBrightness / 1,
                  width: 100,
                  progressColor: Colours.white,
                )),
          ),
        );
      },
    );
  }
}
