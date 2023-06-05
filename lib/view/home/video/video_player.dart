import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sports/view/home/video/home_video_controls.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:volume_controller/volume_controller.dart';

class VideoPlayer extends StatefulWidget {
  final String url;
  final FlickManager flickManager;
  final VideoPlayerController playerController;
  const VideoPlayer(this.url, this.flickManager, this.playerController,
      {super.key});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late FlickManager flickManager = widget.flickManager;
  late VideoPlayerController playerController = widget.playerController;

  @override
  void initState() {
    super.initState();
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    VolumeController().showSystemUI = false;
    // PerfectVolumeControl.hideUI = true;
    // https://oss.qiuxiangbiao.com/test/video/017.mp4
    // playerController = VideoPlayerController.network(widget.url);
    // flickManager = FlickManager(
    //   videoPlayerController: playerController,
    //   getPlayerControlsTimeout: (
    //       {errorInVideo, isPlaying, isVideoEnded, isVideoInitialized}) {
    //     return Duration(seconds: 5);
    //   },
    // );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && mounted) {
          flickManager.flickControlManager?.autoPause();
        } else if (visibility.visibleFraction == 1) {
          flickManager.flickControlManager?.autoResume();
        }
      },
      child: FlickVideoPlayer(
        flickManager: flickManager,
        preferredDeviceOrientationFullscreen: [
          // DeviceOrientation.portraitUp,
          Platform.isAndroid
              ? DeviceOrientation.landscapeLeft
              : DeviceOrientation.landscapeRight,
          // DeviceOrientation.landscapeRight,
        ],
        flickVideoWithControls: FlickVideoWithControls(
          playerErrorFallback: Container(),
          playerLoadingFallback: Center(
              child: Text(
            '加载中...',
            style: TextStyle(fontSize: 16),
          )),
          controls: HomeVideoControls(),
        ),
        flickVideoWithControlsFullscreen: FlickVideoWithControls(
          videoFit: BoxFit.contain,
          playerLoadingFallback: Center(
              child: Text(
            '加载中...',
            style: TextStyle(fontSize: 16),
          )),
          controls: HomeVideoControls(
            fullscreen: true,
          ),
        ),
      ),
    );
  }
}
