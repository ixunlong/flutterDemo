import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/model/config_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/my/bottom_vibration_hint_page.dart';
import 'package:sports/view/other/open_notification_dialog.dart';
import 'package:sports/widgets/common_dialog.dart';
import 'package:sports/widgets/common_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PushSettingPage extends StatefulWidget {
  const PushSettingPage({super.key});

  @override
  State<PushSettingPage> createState() => _PushSettingPageState();
}

class _PushSettingPageState extends State<PushSettingPage> {
  ConfigService configService = Get.find<ConfigService>();
  PushConfig config = Get.find<ConfigService>().pushConfig;
  // bool allPusn = true;
  @override
  void initState() {
    // if (configList != null) {
    //   for (var config in configList!) {
    //     if (config.type == ConfigType.pushAll) {
    //       allPusn = config.config == '1';
    //     }
    //   }
    // }
    super.initState();
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
      appBar: Styles.appBar(title: Text('通知设置')),
      backgroundColor: Colours.scaffoldBg,
      body: VisibilityDetector(
        key: Key('PushSettingPage'),
        onVisibilityChanged: (info) {
          if (!info.visibleBounds.isEmpty) {
            update();
          }
        },
        child: ListView(children: [
          SizedBox(height: 10),
          CommonWidget.switchCell('消息通知设置', config.pushAll == 1, onTap: () {
            config.pushAll = (config.pushAll == 1 ? 0 : 1);
            update();
            configService.update(ConfigType.pushAll, config.pushAll);
          }),
          hint('开启后，您可以接收到最新动态消息'),
          if (config.pushAll == 1) ...[
            CommonWidget.cell(
                '足球比赛通知',
                configService.soccerConfig.pushSoccer1 == 1
                    ? configService.soccerConfig.getPushConfigCount()
                    : '0/7', onTap: () {
              Get.toNamed(Routes.soccerPushConfig);
            }),
            Divider(height: 0.5, color: Colours.greyEE, indent: 16),
            CommonWidget.cell(
                '篮球比赛通知',
                configService.basketConfig.pushBasket1 == 1
                    ? configService.basketConfig.getPushConfigCount()
                    : '0/2', onTap: () {
              Get.toNamed(Routes.basketPushConfig);
            }),
            hint('未关注比赛将不会收到任何比赛通知'),
            CommonWidget.switchCell('资讯新闻', config.pushNews == 1, onTap: () {
              config.pushNews = (config.pushNews == 1 ? 0 : 1);
              update();
              configService.update(ConfigType.pushNews, config.pushNews);
            }),
            hint('关闭后，将不会收到资讯消息通知'),
            CommonWidget.switchCell('关注专家提醒', config.pushExpert == 1,
                onTap: () {
              config.pushExpert = (config.pushExpert == 1 ? 0 : 1);
              update();
              configService.update(ConfigType.pushExpert, config.pushExpert);
            }),
            hint('开启后，关注专家发表观点，第一时间通知您'),
            CommonWidget.switchCell('夜间免打扰模式', config.pushInNight == 1,
                onTap: () {
              config.pushInNight = (config.pushInNight == 1 ? 0 : 1);
              update();
              configService.update(ConfigType.pushInNight, config.pushInNight);
            }),
            hint('开启后，您在夜间（23:00至次日7:00）将不会收到推送消息'),
          ],
          Container(
            height: 52,
            color: Colours.white,
            padding: EdgeInsets.only(left: 16, right: 10),
            child: Row(children: [
              Text(
                '底部导航栏震动',
                style: TextStyle(color: Colours.text_color1, fontSize: 16),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(BottomVibrationHintPage());
                },
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Image.asset(
                    Utils.getImgPath('question_mark_red.png'),
                    width: 12,
                  ),
                ),
              ),
              Spacer(),
              CommonWidget.cupertinoSwitch(config.bottomVibration == 1,
                  onTap: () {
                config.bottomVibration = (config.bottomVibration == 1 ? 0 : 1);
                update();
                configService.update(
                    ConfigType.bottomVibration, config.bottomVibration);
              })
              // CupertinoSwitch(
              //   value: config.bottomVibration == 1,
              //   // trackColor: Colours.main_color,
              //   activeColor: Colours.main_color,
              //   onChanged: (value) {

              //   },
              // )
            ]),
          )
        ]),
      ),
    );
  }

  Widget hint(String text) {
    return Container(
      padding: EdgeInsets.only(left: 16, top: 6, bottom: 12),
      child: Text(
        text,
        style: TextStyle(color: Colours.grey_color, fontSize: 13),
      ),
    );
  }
}
