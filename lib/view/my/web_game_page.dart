import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../res/styles.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebGamePage extends StatefulWidget {
  const WebGamePage({super.key});

  @override
  State<WebGamePage> createState() => _WebGamePageState();
}

class _WebGamePageState extends State<WebGamePage> {
  String url = Get.arguments;
  WebViewController? wcontroller;
  String referer = 'http://www.shandw.com';

  final jsChannel = JavascriptChannel(
      name: "WEB_QXB",
      onMessageReceived: (msg) {
        Utils.doRoute(msg.message);
      });

  late WebView webview;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    webview = WebView(
        onWebViewCreated: (controller) {
          wcontroller = controller;
          wcontroller!.loadUrl(url, headers: {'Referer': referer});
        },
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: {jsChannel},
        navigationDelegate: (navigation) async {
          log(navigation.toString());
          if (navigation.url.startsWith("weixin://wap/pay?") ||
              navigation.url.startsWith("alipay")) {
            // final a = await canLaunchUrl(Uri.parse(navigation.url));

            launchUrl(Uri.parse(navigation.url));
            // return true;
            return NavigationDecision.prevent;
          }
          if (Platform.isAndroid) {
            if (navigation.url.startsWith('https')) {
              wcontroller!
                  .loadUrl(navigation.url, headers: {'Referer': referer});
              referer = navigation.url;
              return NavigationDecision.prevent;
            }
          }

          return NavigationDecision.navigate;
        },
        // initialUrl: url,
        backgroundColor: Colours.scaffoldBg);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colours.scaffoldBg,
          appBar: Styles.appBar(
            // title: Text(titles.last),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.close))
            ],
          ),
          body: webview,
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
