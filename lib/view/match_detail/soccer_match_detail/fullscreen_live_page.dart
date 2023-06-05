import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:sports/logic/match/full_screen_live_controller.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/loading_check_widget.dart';

import '../../../res/colours.dart';

class FullScreenLivePage extends StatefulWidget {
  const FullScreenLivePage({Key? key, required this.liveAnimationUrl}) : super(key: key);

  final String liveAnimationUrl;
  @override
  State<FullScreenLivePage> createState() => _FullScreenLivePageState();
}


class _FullScreenLivePageState extends State<FullScreenLivePage> {
  final controller = Get.put(FullScreenLiveController());
  @override
  void initState() {
    super.initState();
    controller.inPage();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.quit();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FullScreenLiveController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colours.text_color,
          body: GestureDetector(
            onTap: () async{controller.showHead();},
            child: Stack(
              children: [
                LoadingCheckWidget<int>(
                  isLoading: controller.isLoading,
                  loading: Container(),
                  data: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SingleChildScrollView(
                        child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: [
                            Container(
                              width: Get.width - MediaQueryData.fromWindow(window).padding.left*2,
                              height: (Get.width - MediaQueryData.fromWindow(window).padding.left*2)*393/470,
                              alignment: Alignment.center,
                              child: InAppWebView(
                                initialUrlRequest: URLRequest(url: Uri.parse(widget.liveAnimationUrl)),
                                initialOptions: controller.options,
                                onLoadStop: (webController,url){
                                  webController.clearFocus();
                                  Future.delayed(const Duration(milliseconds: 100)).then(
                                    (value) => controller.setLoad());
                                },
                                onLoadError: (webController,url,code, message){
                                  message = '加载失败';
                                },
                              ),
                            ),
                            controller.loadUrl?Container(
                              width: Get.width,
                              height: Get.height,
                              color: Colours.text_color,
                              alignment: Alignment.center,
                              child: Text("正在加载",style: TextStyle(fontSize: 18,color: Colours.white)),
                            ):Container(),
                            Container(
                              width: Get.width,
                              height: (Get.width - MediaQueryData.fromWindow(window).padding.left*2)*393/470,
                              color: Colours.transparent,
                            ),
                            Visibility(
                              visible: controller.visible,
                              child: _head()
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Positioned(top: 0,child: _head())
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _head(){
    return Container(
      width: Get.width,
      height: 44,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colours.transparent,
        boxShadow: [BoxShadow(color: Color(0x50000000),blurRadius: 10,spreadRadius: 8)]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: MediaQueryData.fromWindow(window).padding.left + 5),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async{
                await controller.quit();
                Future.delayed(const Duration(milliseconds: 100)).then((value) => Get.back());
              },
              child: Container(
                width: 44,
                height: 44,
                child: Icon(
                  size: 24,
                  Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                  color: Colours.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: MediaQueryData.fromWindow(window).padding.left + 5),
            child: Text(DateTime.now().formatedString("HH:mm"),style: TextStyle(color: Colours.white))),
        ],
      ),
    );
  }
  // @override
  // void dispose() {
  //     controller.quit();
  //   super.dispose();
  // }
}
