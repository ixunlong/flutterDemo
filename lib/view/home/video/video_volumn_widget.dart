import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/utils.dart';
import 'package:volume_controller/volume_controller.dart';

class VideoVolumnWidget extends StatefulWidget {
  const VideoVolumnWidget({super.key});

  @override
  State<VideoVolumnWidget> createState() => _VideoVolumnWidgetState();
}

class _VideoVolumnWidgetState extends State<VideoVolumnWidget> {
  double volumn = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    VolumeController().getVolume().then((value) {
      volumn = value;
      update();
    });
    VolumeController().listener((value) {
      volumn = value;
      update();
    });
  }

  @override
  void dispose() {
    VolumeController().removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 50,
      child: RotatedBox(
          quarterTurns: 1,
          child: LinearPercentIndicator(
            isRTL: true,
            lineHeight: 2,
            percent: volumn / 1,
            width: 100,
            progressColor: Colours.white,
          )),
    );
  }
}
