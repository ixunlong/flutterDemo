import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/other/open_notification_dialog.dart';
import 'package:sports/widgets/common_dialog.dart';
import 'package:sports/widgets/common_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SoccerPushConfigPage extends StatefulWidget {
  const SoccerPushConfigPage({super.key});

  @override
  State<SoccerPushConfigPage> createState() => _SoccerPushConfigPageState();
}

class _SoccerPushConfigPageState extends State<SoccerPushConfigPage> {
  SoccerConfig config = Get.find<ConfigService>().soccerConfig;
  PushConfig pushConfig = Get.find<ConfigService>().pushConfig;
  ConfigService configService = Get.find<ConfigService>();
  bool showPushAll = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (configService.pushConfig.pushAll == 0) {
      showPushAll = true;
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final permission = await Permission.notification.isGranted;
      if (!permission) {
        Get.dialog(OpenNotificationDialog());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.appBar(title: Text('足球比赛通知')),
      backgroundColor: Colours.scaffoldBg,
      body: ListView(children: [
        SizedBox(height: 10),
        if (showPushAll) ...[
          CommonWidget.switchCell('消息通知设置', pushConfig.pushAll == 1, onTap: () {
            pushConfig.pushAll = (pushConfig.pushAll == 1 ? 0 : 1);
            update();
            configService.update(ConfigType.pushAll, pushConfig.pushAll);
          }),
          separateTitle('开启后，您可以接收到最新动态消息'),
        ],
        if (pushConfig.pushAll == 1) ...[
          CommonWidget.switchCell('关注足球比赛', config.pushSoccer1 == 1, onTap: () {
            config.pushSoccer1 = (config.pushSoccer1 == 1 ? 0 : 1);
            update();
            configService.update(ConfigType.pushSoccer1, config.pushSoccer1);
          }),
          separateTitle('开启后，您可以接收到已关注比赛的最新消息动态'),
          if (config.pushSoccer1 == 1) soccerPushConfig()
        ]
      ]),
    );
  }

  Widget soccerPushConfig() {
    return Container(
        color: Colours.white,
        child: Column(children: [
          CommonWidget.switchCell('首发阵容', config.pushSoccer2 == 1, onTap: () {
            config.pushSoccer2 = (config.pushSoccer2 == 1 ? 0 : 1);
            update();
            configService.update(ConfigType.pushSoccer2, config.pushSoccer2);
          }),
          CommonWidget.seperateLine(),
          CommonWidget.switchCell('开赛（赛前5分钟）', config.pushSoccer3 == 1,
              onTap: () {
            config.pushSoccer3 = (config.pushSoccer3 == 1 ? 0 : 1);
            update();
            configService.update(ConfigType.pushSoccer3, config.pushSoccer3);
          }),
          CommonWidget.seperateLine(),
          CommonWidget.switchCell('赛果', config.pushSoccer4 == 1, onTap: () {
            config.pushSoccer4 = (config.pushSoccer4 == 1 ? 0 : 1);
            update();
            configService.update(ConfigType.pushSoccer4, config.pushSoccer4);
          }),
          CommonWidget.seperateLine(),
          CommonWidget.switchCell('进球', config.pushSoccer5 == 1, onTap: () {
            config.pushSoccer5 = (config.pushSoccer5 == 1 ? 0 : 1);
            update();
            configService.update(ConfigType.pushSoccer5, config.pushSoccer5);
          }),
          CommonWidget.seperateLine(),
          CommonWidget.switchCell('红牌', config.pushSoccer6 == 1, onTap: () {
            config.pushSoccer6 = (config.pushSoccer6 == 1 ? 0 : 1);
            update();
            configService.update(ConfigType.pushSoccer6, config.pushSoccer6);
          }),
          CommonWidget.seperateLine(),
          CommonWidget.switchCell('黄牌', config.pushSoccer7 == 1, onTap: () {
            config.pushSoccer7 = (config.pushSoccer7 == 1 ? 0 : 1);
            update();
            configService.update(ConfigType.pushSoccer7, config.pushSoccer7);
          }),
          CommonWidget.seperateLine(),
          CommonWidget.switchCell('角球', config.pushSoccer8 == 1, onTap: () {
            config.pushSoccer8 = (config.pushSoccer8 == 1 ? 0 : 1);
            update();
            configService.update(ConfigType.pushSoccer8, config.pushSoccer8);
          }),
        ]));
  }

  Widget separateTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 16, top: 6, bottom: 12),
      child: Text(title, style: TextStyle(color: Colours.grey66, fontSize: 13)),
    );
  }
}
