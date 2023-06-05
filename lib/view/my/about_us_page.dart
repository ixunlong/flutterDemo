import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sports/http/request_interceptor.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/app_config.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/utils.dart';

import '../../res/styles.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  PackageInfo? info;
  double spaceHeight = 97;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    info = await PackageInfo.fromPlatform();
    final mq = MediaQuery.of(context);
    final height = mq.size.height - mq.padding.top - 44;
    final fitheight = height - 200 - 52.5 * 5 - 50;
    spaceHeight = fitheight > 50 ? fitheight : 50;
    update();
  }

  @override
  Widget build(BuildContext context) {
    String channel = "";
    if (HeaderDeviceInfo.channel.isNotEmpty) {
      channel = " (${HeaderDeviceInfo.channel})";
    }
    return Scaffold(
      backgroundColor: Colours.scaffoldBg,
      appBar: Styles.appBar(
          title: GestureDetector(
              onLongPress: () {
                ToastUtils.show('msg');
              },
              child: Text("关于我们"))),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              height: 200,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Utils.getImgPath("qxb_logo.png"),
                    width: 80,
                    height: 80,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    info?.appName ?? "",
                    style: const TextStyle(
                        fontSize: 20, color: Colours.text_color1),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "版本:${info?.version ?? ""}${channel}",
                    style: const TextStyle(
                        fontSize: 12, color: Colours.grey_color1),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _cellBtn("服务协议").tap(Routes.agreements.toService),
                  const Divider(
                      indent: 16, height: 0.5, color: Color(0xffeeeeee)),
                  _cellBtn("隐私政策").tap(Routes.agreements.toPrivicy),
                  const Divider(
                      indent: 16, height: 0.5, color: Color(0xffeeeeee)),
                  _cellBtn("用户充值协议").tap(Routes.agreements.toRecharge),
                  const Divider(
                      indent: 16, height: 0.5, color: Color(0xffeeeeee)),
                  _cellBtn("自媒体协议").tap(Routes.agreements.toSelfMedia),
                  const Divider(
                      indent: 16, height: 0.5, color: Color(0xffeeeeee)),
                  _cellBtn("未成年隐私保护协议").tap(Routes.agreements.toLess18),
                  // const Divider(indent: 16,height: 0.5,color: Color(0xffeeeeee)),
                ],
              ),
            ),
            // SizedBox(height: spaceHeight),
            Spacer(),
            SafeArea(
              child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "Copyright ©2021-2023 红球会 All Rights Reserved.",
                    style: TextStyle(fontSize: 12, color: Colours.grey_color),
                  )),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget _cellBtn(String name) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(name),
          const Spacer(),
          Image.asset(Utils.getImgPath("arrow_right.png"))
        ],
      ),
    );
  }
}
