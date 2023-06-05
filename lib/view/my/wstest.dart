import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../res/styles.dart';
import 'package:sports/util/web_socket_connection.dart';

class WsTestPage extends StatefulWidget {
  const WsTestPage({super.key});

  @override
  State<WsTestPage> createState() => _WsTestPageState();
}

class _WsTestPageState extends State<WsTestPage> {
  final qxbId = Get.arguments as int;

  StreamSubscription? sub1;
  StreamSubscription? sub2;

  @override
  void initState() {
    log("ws connected = ${WsConnection.connected}");

    sub1 = WsConnection.liveStream(qxbId).listen((event) {});
    sub2 = WsConnection.eventStream(qxbId).listen((event) {});

    super.initState();
  }

  @override
  void dispose() {
    sub1?.cancel();
    sub2?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.appBar(),
      body: Container(
        child: Column(
          children: [
            Tooltip(
              message:
                  "assssacsacasbjcjasbcjasnxjansxnajxnakjxnasxajxnasaskbcjhabshcbahsbcajsxjasnchascbacjhabsjasbxhjabxkhsaj",
              child: Container(
                constraints: BoxConstraints(maxWidth: 100),
                child: Text("assssacsacasbjcjasbcjasnxjansxnajxnakjxnasxajxnas",
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ),
            Text("第二栏")
          ],
        ),
      ),
    );
  }
}
