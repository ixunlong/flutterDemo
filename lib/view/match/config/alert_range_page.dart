import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/common_widget.dart';

class AlertRangePage extends StatefulWidget {
  const AlertRangePage({super.key});

  @override
  State<AlertRangePage> createState() => _AlertRangePageState();
}

class _AlertRangePageState extends State<AlertRangePage> {
  SoccerConfig config = Get.find<ConfigService>().soccerConfig;
  BasketConfig basketConfig = Get.find<ConfigService>().basketConfig;
  int type = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.appBar(title: Text(type == 0 ? '足球提醒范围' : '篮球提醒范围')),
      backgroundColor: Colours.scaffoldBg,
      body: ListView(children: [
        SizedBox(height: 10),
        CommonWidget.selectCell(
            '我关注的比赛',
            type == 0
                ? (config.soccerInAppAlert1 == 0)
                : (basketConfig.basketInAppAlert1 == 0), onTap: () {
          if (type == 0) {
            if (config.soccerInAppAlert1 == 0) {
              return;
            }
            config.soccerInAppAlert1 = 0;
            update();
            Get.find<ConfigService>()
                .update(ConfigType.soccerInAppAlert1, config.soccerInAppAlert1);
          } else {
            if (basketConfig.basketInAppAlert1 == 0) {
              return;
            }
            basketConfig.basketInAppAlert1 = 0;
            update();
            Get.find<ConfigService>().update(
                ConfigType.basketInAppAlert1, basketConfig.basketInAppAlert1);
          }
        }),
        CommonWidget.seperateLine(),
        CommonWidget.selectCell(
            '全部比赛',
            type == 0
                ? (config.soccerInAppAlert1 == 1)
                : (basketConfig.basketInAppAlert1 == 1), onTap: () {
          if (type == 0) {
            if (config.soccerInAppAlert1 == 1) {
              return;
            }
            config.soccerInAppAlert1 = 1;
            update();
            Get.find<ConfigService>()
                .update(ConfigType.soccerInAppAlert1, config.soccerInAppAlert1);
          } else {
            if (basketConfig.basketInAppAlert1 == 1) {
              return;
            }
            basketConfig.basketInAppAlert1 = 1;
            update();
            Get.find<ConfigService>().update(
                ConfigType.basketInAppAlert1, basketConfig.basketInAppAlert1);
          }
        })
      ]),
    );
  }
}
