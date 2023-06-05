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

class BasketPushConfigPage extends StatefulWidget {
  const BasketPushConfigPage({super.key});

  @override
  State<BasketPushConfigPage> createState() => _BasketPushConfigPageState();
}

class _BasketPushConfigPageState extends State<BasketPushConfigPage> {
  BasketConfig config = Get.find<ConfigService>().basketConfig;
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
      appBar: Styles.appBar(title: Text('篮球比赛通知')),
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
          CommonWidget.switchCell('关注篮球比赛', config.pushBasket1 == 1, onTap: () {
            config.pushBasket1 = (config.pushBasket1 == 1 ? 0 : 1);
            update();
            configService.update(ConfigType.pushBasket1, config.pushBasket1);
          }),
          separateTitle('开启后，您可以接收到已关注比赛的最新消息动态'),
          if (config.pushBasket1 == 1) basketPushConfig()
        ]
      ]),
    );
  }

  Widget basketPushConfig() {
    return Container(
        color: Colours.white,
        child: Column(children: [
          CommonWidget.switchCell('开赛（赛前5分钟）', config.pushBasket2 == 1,
              onTap: () {
            config.pushBasket2 = (config.pushBasket2 == 1 ? 0 : 1);
            update();
            configService.update(ConfigType.pushBasket2, config.pushBasket2);
          }),
          CommonWidget.seperateLine(),
          CommonWidget.switchCell('赛果', config.pushBasket3 == 1, onTap: () {
            config.pushBasket3 = (config.pushBasket3 == 1 ? 0 : 1);
            update();
            configService.update(ConfigType.pushBasket3, config.pushBasket3);
          })
        ]));
  }

  Widget separateTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 16, top: 6, bottom: 12),
      child: Text(title, style: TextStyle(color: Colours.grey66, fontSize: 13)),
    );
  }
}
