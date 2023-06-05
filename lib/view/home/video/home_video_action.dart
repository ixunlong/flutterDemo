import 'dart:developer';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/utils.dart';
import 'package:video_player/video_player.dart';
import 'package:volume_controller/volume_controller.dart';

/// GestureDetector's that calls [flickControlManager.seekForward]/[flickControlManager.seekBackward] onTap of opaque area/child.
///
/// Renders two GestureDetector inside a row, the first detector is responsible to seekBackward and the second detector is responsible to seekForward.
class HomeVideoAction extends StatefulWidget {
  const HomeVideoAction({Key? key, this.child}) : super(key: key);

  final Widget? child;

  @override
  State<HomeVideoAction> createState() => _HomeVideoActionState();
}

class _HomeVideoActionState extends State<HomeVideoAction> {
  Offset startOffset = const Offset(0, 0);
  Duration videoCurrentTime = const Duration(seconds: 0);
  double startVolumn = 0;
  double startBrightness = 0;
  int volumnLevel = 0;
  int brightnessLevel = 0;
  bool flag = true;

  @override
  Widget build(BuildContext context) {
    FlickControlManager controlManager =
        Provider.of<FlickControlManager>(context);
    FlickDisplayManager displayManager =
        Provider.of<FlickDisplayManager>(context);
    FlickVideoManager videoManager = Provider.of<FlickVideoManager>(context);
    VideoPlayerValue? videoPlayerValue = videoManager.videoPlayerValue;
    if (videoPlayerValue == null) return Container();

    void seekToRelativePosition(Offset offset) {
      final double relative = offset.dx / (Get.width);
      final Duration position = videoPlayerValue.duration * relative;
      controlManager.seekTo(videoCurrentTime + position);
    }

    return Stack(children: <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              // onTap: () {},
              onLongPressEnd: (detail) {
                // if (videoManager.isPlaying) {
                controlManager.setPlaybackSpeed(1);
                EasyLoading.dismiss();
                // Fluttertoast.cancel();
                // }
              },
              onLongPress: () {
                if (videoManager.isPlaying) {
                  controlManager.setPlaybackSpeed(2);
                  EasyLoading.showToast('倍速播放中',
                      duration: Duration(seconds: 10000),
                      toastPosition: EasyLoadingToastPosition.top);
                }
              },
              onDoubleTap: () {
                if (videoManager.isPlaying) {
                  controlManager.autoPause();
                } else {
                  controlManager.autoResume();
                }
                displayManager.handleShowPlayerControls();
              },
              onHorizontalDragStart: (DragStartDetails details) {
                if (!videoPlayerValue.isInitialized) {
                  return;
                }
                if (videoManager.isPlaying) {
                  controlManager.autoPause();
                }
                if (flag) {
                  displayManager.handleShowPlayerControls(
                      showWithTimeout: false);
                  setState(() {
                    startOffset = details.globalPosition;
                    videoCurrentTime = videoPlayerValue.position;
                    flag = false;
                  });
                }
              },
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                if (!videoPlayerValue.isInitialized) {
                  return;
                }
                seekToRelativePosition(details.globalPosition - startOffset);
                log(details.globalPosition.toString());
              },
              onHorizontalDragEnd: (DragEndDetails details) {
                displayManager.handleShowPlayerControls(showWithTimeout: true);
                controlManager.play();
                setState(() {
                  flag = true;
                });
              },
              onVerticalDragStart: (details) async {
                startOffset = details.globalPosition;
                if (startOffset.dx > Get.width / 2) {
                  startVolumn = await VolumeController().getVolume();
                  volumnLevel = 0;
                } else {
                  startBrightness = await ScreenBrightness().current;
                  brightnessLevel = 0;
                }
              },
              onVerticalDragUpdate: (DragUpdateDetails details) async {
                if (!videoPlayerValue.isInitialized) {
                  return;
                }
                // if ((details.globalPosition - startOffset).dy > 1.0) {
                if (startOffset.dx > Get.width / 2) {
                  onVolumnChanged(details.globalPosition - startOffset);
                } else {
                  onBrightnessChanged(details.globalPosition - startOffset);
                }

                // }

                // VolumeController().setVolume(volumn + 0.05, showSystemUI: true);
              },
            ),
          )
        ],
      ),
      if (widget.child != null) SizedBox(child: widget.child),
    ]);
  }

  onVolumnChanged(Offset offset) {
    //每移动10调一次音量
    int level = offset.dy ~/ 10;
    if (level != volumnLevel) {
      volumnLevel = level;
      double change = -offset.dy / 200;
      VolumeController().setVolume(startVolumn + change, showSystemUI: true);
    }
  }

  onBrightnessChanged(Offset offset) {
    int level = offset.dy ~/ 10;
    if (level != brightnessLevel) {
      brightnessLevel = level;
      double change = -offset.dy / 200;
      double brightness = 0;
      if (startBrightness + change > 1) {
        brightness = 1;
      } else if (startBrightness + change < 0) {
        brightness = 0;
      } else {
        brightness = startBrightness + change;
      }
      ScreenBrightness().setScreenBrightness(brightness);
    }
  }
}
