import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../res/styles.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPara {
  const WebPara(this.title, this.url, {this.longpress = false});
  final String title;
  final String url;
  final bool longpress;
}

class WebPage extends StatefulWidget {
  const WebPage({super.key});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  final WebPara para = () {
    // log("web view para = ${Get.arguments}");
    if (Get.arguments is WebPara) {
      return Get.arguments as WebPara;
    } else if (Get.arguments is Map<String, dynamic>) {
      final map = Get.arguments as Map<String, dynamic>;
      log("map = $map");
      return WebPara("${map["title"] ?? ""}", "${map["url"]}",
          longpress: map['longpress'] ?? false);
    }
    return const WebPara("", "");
  }.call();

  WebViewController? wcontroller;
  late List<String> titles = [para.title];

  final jsChannel = JavascriptChannel(
      name: "WEB_QXB",
      onMessageReceived: (msg) {
        Utils.doRoute(msg.message);
      });

  late final webview = WebView(
      onWebViewCreated: (controller) {
        wcontroller = controller;
      },
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: {jsChannel},
      initialUrl: para.url,
      navigationDelegate: (navigation) {
        log('$navigation');
        // if (navigation.url.startsWith('miguvideo')) {
        //   return NavigationDecision.prevent;
        // }
        return NavigationDecision.navigate;
      },
      backgroundColor: Colours.scaffoldBg);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colours.scaffoldBg,
          appBar: Styles.appBar(
            title: Text(titles.last),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.close))
            ],
          ),
          body: para.longpress
              ? GestureDetector(
                  onLongPress: () {},
                  behavior: HitTestBehavior.opaque,
                  child: webview)
              : webview,
        ),
        onWillPop: () async {
          final goback = !(await wcontroller?.canGoBack() ?? false);
          if (!goback) {
            wcontroller?.goBack();
          }
          return goback;
        });
  }
}
