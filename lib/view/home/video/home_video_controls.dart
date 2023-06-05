import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/home/video/home_video_action.dart';
import 'package:sports/view/home/video/video_brightness_widget.dart';
import 'package:sports/view/home/video/video_speed_bottomsheet.dart';
import 'package:sports/view/home/video/video_speed_widget.dart';
import 'package:sports/widgets/common_button.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class HomeVideoControls extends StatefulWidget {
  final bool fullscreen;
  const HomeVideoControls({super.key, this.fullscreen = false});

  @override
  State<HomeVideoControls> createState() => _HomeVideoControlsState();
}

class _HomeVideoControlsState extends State<HomeVideoControls> {
  final double iconSize = 24;

  /// Font size.
  ///
  /// This size is used for all the text.
  final double fontSize = 12;

  double speed = 1;

  /// [FlickProgressBarSettings] settings.
  final FlickProgressBarSettings? progressBarSettings =
      FlickProgressBarSettings(
    playedColor: Colours.main,
  );
  late bool fullscreen;

  bool showSpeedWidget = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fullscreen = widget.fullscreen;
  }

  // @override
  // void dispose() {
  //   FlickControlManager controlManager =
  //       Provider.of<FlickControlManager>(context);
  //   if (controlManager.isFullscreen) {
  //     controlManager.exitFullscreen();
  //   }

  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    FlickControlManager controlManager =
        Provider.of<FlickControlManager>(context);
    FlickVideoManager videoManager = Provider.of<FlickVideoManager>(context);
    FlickDisplayManager displayManager =
        Provider.of<FlickDisplayManager>(context);
    double horizontalPadding = 10;
    if (fullscreen) {
      horizontalPadding = (Get.width - (Get.height / 1080 * 1920)) / 2 + 20;
    }
    if (horizontalPadding < 0) {
      horizontalPadding = 10;
    }

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        FlickShowControlsAction(
          handleVideoTap: () {
            if (showSpeedWidget == true) {
              showSpeedWidget = false;
              update();
            } else {
              displayManager.handleVideoTap();
            }
          },
          child: const HomeVideoAction(
            child: Center(
              child: FlickVideoBuffer(
                  bufferingChild: SpinKitFadingCircle(
                color: Colours.white,
                size: 40,
              )),
            ),
          ),
        ),
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FlickAutoHideChild(
              child: Container(
                // width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Colours.black.withOpacity(0.7),
                      Colours.black.withOpacity(0.0)
                    ])),
              ),
            )),
        Visibility(
          visible: videoManager.errorInVideo,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('视频加载失败，请稍后重试'),
            SizedBox(height: 12),
            CommonButton(
              onPressed: () {
                videoManager.videoPlayerController!.initialize();
                // videoManager.videoPlayerController.play()
              },
              text: '重新连接',
              textStyle: TextStyle(fontSize: 13),
              minWidth: 90,
              minHeight: 32,
              foregroundColor: Colours.white,
              backgroundColor: Colours.white.withOpacity(0.1),
            )
          ]),
        ),
        //全屏倍速播放
        if (fullscreen && showSpeedWidget)
          VideoSpeedWidget(
            onSpeedChanged: (value) {
              speed = value;
              controlManager.setPlaybackSpeed(value);
              showSpeedWidget = false;
              update();
            },
          ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FlickAutoHideChild(
              child: Container(
                // width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Colours.black.withOpacity(0),
                      Colours.black.withOpacity(0.7)
                    ])),
              ),
            )),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: FlickAutoHideChild(
              child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                  key: const Key("back"),
                  onTap: () {
                    log(controlManager.isFullscreen.toString());
                    controlManager.isFullscreen
                        ? controlManager.exitFullscreen()
                        : Get.back();
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: fullscreen ? 15 : 10,
                          horizontal: horizontalPadding),
                      child: Image.asset(
                        Utils.getImgPath('arrow_back.png'),
                        color: Colours.white,
                        width: iconSize,
                        height: iconSize,
                      ))),
              Spacer(),
              //小屏视频倍速
              if (!fullscreen)
                CommonButton(
                  minHeight: 30,
                  minWidth: 50,
                  onPressed: () async {
                    double? changeSpeed =
                        await Get.bottomSheet(VideoSpeedBottomsheet(speed));
                    if (changeSpeed != null) {
                      speed = changeSpeed;
                      controlManager.setPlaybackSpeed(changeSpeed);
                    }
                  },
                  text: '倍速',
                  textStyle: TextStyle(fontSize: 12, color: Colours.white),
                )
            ],
          )),
        ),
        Positioned(
          right: 0,
          child: VideoBrightnessWidget(),
        ),
        Positioned.fill(
          child: FlickAutoHideChild(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10, horizontal: horizontalPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlickPlayToggle(
                        size: iconSize,
                        playChild: Image.asset(Utils.getImgPath('play.png')),
                        pauseChild: Image.asset(Utils.getImgPath('pause.png')),
                      ),
                      SizedBox(
                        width: iconSize / 2,
                      ),
                      // FlickSoundToggle(
                      //   size: iconSize,
                      // ),
                      // SizedBox(
                      //   width: iconSize / 2,
                      // ),
                      FlickCurrentPosition(
                        fontSize: fontSize,
                      ),
                      SizedBox(
                        width: iconSize / 2,
                      ),
                      Expanded(
                        child: FlickVideoProgressBar(
                          flickProgressBarSettings: progressBarSettings,
                        ),
                      ),
                      SizedBox(
                        width: iconSize / 2,
                      ),
                      FlickTotalDuration(
                        fontSize: fontSize,
                      ),
                      SizedBox(
                        width: iconSize / 2,
                      ),
                      // Expanded(
                      //   child: Container(),
                      // ),
                      // FlickSubtitleToggle(
                      //   size: iconSize,
                      // ),
                      // SizedBox(
                      //   width: iconSize / 2,
                      // ),
                      fullscreen
                          ? CommonButton(
                              minHeight: 24,
                              minWidth: 30,
                              onPressed: () {
                                // controlManager.
                                displayManager.hidePlayerControls();
                                showSpeedWidget = true;
                                update();
                              },
                              text: '倍速',
                              foregroundColor: Colours.white,
                            )
                          : FlickFullScreenToggle(
                              size: iconSize,
                              enterFullScreenChild:
                                  Image.asset(Utils.getImgPath('rotate.png')),
                              exitFullScreenChild:
                                  Image.asset(Utils.getImgPath('rotate.png'))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// class HomeVideoControls extends StatelessWidget {
//   // HomeVideoControls(
//   //     {Key? key,
//   //     // this.iconSize = 24,
//   //     // this.fontSize = 12,
//   //     progressBarSettings,
//   //     this.fullscreen = false})
//   //     : progressBarSettings = progressBarSettings ??
//   //           FlickProgressBarSettings(
//   //             playedColor: Colours.main,
//   //           );

//   /// Icon size.
//   ///
//   /// This size is used for all the player icons.
  
// }
