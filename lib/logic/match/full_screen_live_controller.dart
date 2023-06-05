import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:limiting_direction_csx/limiting_direction_csx.dart';
import 'package:sports/logic/match/soccer_match_detail_controller.dart';

import '../../res/colours.dart';

class FullScreenLiveController extends GetxController{
  bool _loadUrl = true;
  bool _isLoading = true;
  bool _visible = false;
  Timer? timer;
  final InAppWebViewGroupOptions _options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
    ),
    /// android 支持HybridComposition
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  bool get visible => _visible;
  bool get loadUrl => _loadUrl;
  bool get isLoading => _isLoading;
  InAppWebViewGroupOptions get options => _options;

  void setLoad(){
    _loadUrl = false;
    update();
  }

  Future inPage() async{
    if(GetPlatform.isIOS){
      await LimitingDirectionCsx.setScreenDirection(DeviceDirectionMask.Landscape);
    }else{
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight
      ]);
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    Future.delayed(const Duration(milliseconds: 100)).then(
      (value) {
        _isLoading = false;
        update();
      }
    );
    update();
  }

  Future showHead() async{
    _visible = !_visible;
    if(timer != null){
      if(!_visible){
        timer!.cancel();
        log('cancel');
      }
    }
    timer = Timer(const Duration(seconds: 5), () {
    _visible = false;
    update();
    log('detect');
    });
    if(!_visible){
      timer!.cancel();
      log('cancel');
    }
    // Future.delayed(const Duration(seconds: 5)).then((value){
    //   log('detect');
    //   _visible ==true?_visible = false:_visible = false;
    //   update();
    // });
    log(_visible.toString());
    update();
  }

  Future quit() async{
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    if(GetPlatform.isIOS){
      await LimitingDirectionCsx.setScreenDirection(DeviceDirectionMask.Portrait);
    }else{
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ]);
    }
    _isLoading = true;
    update();
  }

}