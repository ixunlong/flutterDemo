import 'package:flutter/material.dart';
import 'package:sports/res/colours.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class WebPara {
//   const WebPara(this.title, this.url, {this.longpress = false});
//   final String title;
//   final String url;
//   final bool longpress;
// }

class H5Page extends StatefulWidget {
  final String url;
  const H5Page(this.url, {super.key});

  @override
  State<H5Page> createState() => _H5PageState();
}

class _H5PageState extends State<H5Page> {
  late WebView webview;
  // late WebViewController wcontroller = WebViewController()
  //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //   ..setNavigationDelegate(NavigationDelegate(
  //     onNavigationRequest: (request) async => NavigationDecision.navigate,
  //   ))
  //   ..addJavaScriptChannel("WEB_QXB", onMessageReceived: (msg) {
  //     Utils.doRoute(msg.message);
  //   })
  //   ..setBackgroundColor(Colours.scaffoldBg)
  //   ..loadRequest(Uri.parse(widget.url));

  // late List<String> titles = [para.title];
  late WebViewController wcontroller;

  // late final webview = WebViewWidget(controller: wcontroller);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    webview = WebView(
        onWebViewCreated: (controller) {
          wcontroller = controller;
          wcontroller.loadUrl(widget.url);
        },
        javascriptMode: JavascriptMode.unrestricted,
        // javascriptChannels: {jsChannel},
        // initialUrl: url,
        backgroundColor: Colours.scaffoldBg);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colours.white,
          body: GestureDetector(
              onLongPress: () {},
              behavior: HitTestBehavior.opaque,
              child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                      bottom: MediaQuery.of(context).padding.bottom),
                  child: webview)),
        ),
        onWillPop: () async {
          final goback = !(await wcontroller.canGoBack());
          if (!goback) {
            wcontroller.goBack();
          }
          return goback;
        });
  }
}
