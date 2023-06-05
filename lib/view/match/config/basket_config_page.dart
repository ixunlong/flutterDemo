import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:get/get.dart';
import 'package:sports/logic/match/match_page_controller.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/model/config_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/sound_utils.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/common_bottomsheet.dart';
import 'package:sports/widgets/common_widget.dart';
import 'package:sports/widgets/cupertino_picker_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BasketConfigPage extends StatefulWidget {
  const BasketConfigPage({super.key});

  @override
  State<BasketConfigPage> createState() => _BasketConfigPageState();
}

class _BasketConfigPageState extends State<BasketConfigPage> {
  ConfigService configService = Get.find<ConfigService>();
  BasketConfig config = Get.find<ConfigService>().basketConfig;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.appBar(title: Text('篮球比赛设置')),
      backgroundColor: Colours.scaffoldBg,
      body: VisibilityDetector(
        key: Key('BasketConfigPage'),
        onVisibilityChanged: (info) {
          if (!info.visibleBounds.isEmpty) {
            update();
          }
        },
        child: ListView(
          children: [
            separateTitle('应用内提醒'),
            CommonWidget.cell(
                '提醒范围', config.basketInAppAlert1 == 0 ? '我关注的比赛' : '全部比赛',
                onTap: () async {
              Utils.onEvent('lqpd_szan', params: {'lqpd_szan': '0'});
              // Get.toNamed(Routes.alertRangeConfig, arguments: 1);
              final result = await Get.bottomSheet(CupertinoPickerWidget(
                ['我关注的比赛', '全部比赛'],
                title: '提醒范围',
                initialIndex: config.basketInAppAlert1,
              ));
              if (result != null) {
                if (config.basketInAppAlert1 == result) {
                  return;
                }
                config.basketInAppAlert1 = result;
                update();
                Get.find<ConfigService>().update(
                    ConfigType.basketInAppAlert1, config.basketInAppAlert1);
              }
              // if (result == 0) {
              //   if (config.soccerInAppAlert1 == 0) {
              //     return;
              //   }
              //   config.soccerInAppAlert1 = 0;
              //   update();
              //   Get.find<ConfigService>().update(
              //       ConfigType.soccerInAppAlert1, config.soccerInAppAlert1);
              // } else {
              //   if (basketConfig.basketInAppAlert1 == 0) {
              //     return;
              //   }
              //   basketConfig.basketInAppAlert1 = 0;
              //   update();
              //   Get.find<ConfigService>().update(ConfigType.basketInAppAlert1,
              //       basketConfig.basketInAppAlert1);
              // }
            }),
            SizedBox(height: 10),
            jinqiu(),
            if (config.basketInAppAlert2.contains(0)) ...[
              SizedBox(height: 10),
              cell([
                title('弹窗范围'),
                Spacer(),
                selectItem('比赛列表', config.basketInAppAlert3 == 0, onTap: () {
                  Utils.onEvent('lqpd_szan', params: {'lqpd_szan': '2'});
                  if (config.basketInAppAlert3 == 0) return;
                  config.basketInAppAlert3 = 0;
                  update();
                  configService.update(
                      ConfigType.basketInAppAlert3, config.basketInAppAlert3);
                }),
                SizedBox(width: 13),
                selectItem('APP全局', config.basketInAppAlert3 == 1, onTap: () {
                  Utils.onEvent('lqpd_szan', params: {'lqpd_szan': '2'});
                  if (config.basketInAppAlert3 == 1) return;
                  config.basketInAppAlert3 = 1;
                  update();
                  configService.update(
                      ConfigType.basketInAppAlert3, config.basketInAppAlert3);
                }),
              ]),
            ],
            SizedBox(height: 10),
            switchCell('全部、赛程、赛果频道共享筛选条件', config.basketInAppAlert4 == 1,
                ConfigType.basketInAppAlert4),
            separateTitle('列表数据设置'),
            zhishu(),
            separateTitle('通知设置'),
            CommonWidget.cell(
                '关注比赛通知',
                config.pushBasket1 == 1 && configService.pushConfig.pushAll == 1
                    ? config.getPushConfigCount()
                    : '0/2', onTap: () {
              Utils.onEvent('lqpd_szan', params: {'lqpd_szan': '7'});
              Get.toNamed(Routes.basketPushConfig);
            }),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget cell(List<Widget> children, {Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 52,
        color: Colours.white,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: children),
      ),
    );
  }

  Widget title(String title) {
    return Text(title,
        style: TextStyle(color: Colours.text_color1, fontSize: 16));
  }

  Widget separateTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 16, top: 12, bottom: 6),
      child: Text(title, style: TextStyle(color: Colours.grey66, fontSize: 13)),
    );
  }

  Widget detail(String title) {
    return Text(title, style: TextStyle(color: Colours.grey66, fontSize: 16));
  }

  Widget switchCell(String title, bool select, int id) {
    return Container(
      height: 52,
      color: Colours.white,
      padding: EdgeInsets.only(left: 16, right: 10),
      child: Row(children: [
        Text(
          title,
          style: TextStyle(color: Colours.text_color1, fontSize: 16),
        ),
        Spacer(),
        Transform.scale(
          scale: 0.9,
          child: CupertinoSwitch(
            value: select,
            // trackColor: Colours.main_color,
            activeColor: Colours.main_color,
            onChanged: (value) {
              if (id == ConfigType.basketInAppAlert4) {
                Utils.onEvent('lqpd_szan', params: {'lqpd_szan': '3'});
                config.basketInAppAlert4 =
                    (config.basketInAppAlert4 == 1 ? 0 : 1);
                configService.update(id, config.basketInAppAlert4);
              } else if (id == ConfigType.basketList2) {
                Utils.onEvent('lqpd_szan', params: {'lqpd_szan': '5'});
                config.basketList2 = (config.basketList2 == 1 ? 0 : 1);
                configService.update(id, config.basketList2);
              } else if (id == ConfigType.basketList3) {
                Utils.onEvent('lqpd_szan', params: {'lqpd_szan': '6'});
                config.basketList3 = (config.basketList3 == 1 ? 0 : 1);
                configService.update(id, config.basketList3);
              }
              if (id != ConfigType.basketInAppAlert4) {
                final matchController =
                    Get.find<MatchPageController>().getMatchController();
                matchController.updateView();
              }
              update();
            },
          ),
        )
      ]),
    );
  }

  Widget selectItem(String title, bool select, {Function()? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 40,
        child: Row(
          children: [
            Image.asset(
              Utils.getImgPath(select ? 'select.png' : 'unselect.png'),
              width: 14,
              height: 14,
            ),
            const SizedBox(width: 3),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colours.grey_color),
            )
          ],
        ),
      ),
    );
  }

  jinqiu() {
    return cell([
      title('赛果提醒'),
      Spacer(),
      selectItem('弹窗', config.basketInAppAlert2.contains(0), onTap: () {
        Utils.onEvent('lqpd_szan', params: {'lqpd_szan': '1'});
        if (config.basketInAppAlert2.contains(0)) {
          config.basketInAppAlert2.clear();
        } else {
          config.basketInAppAlert2.add(0);
        }
        update();
        configService.update(
            ConfigType.basketInAppAlert2, config.basketInAppAlert2);
      }),
      SizedBox(width: 12),
      selectItem('声音', config.basketInAppAlert2.contains(1), onTap: () {
        Utils.onEvent('lqpd_szan', params: {'lqpd_szan': '1'});
        if (config.basketInAppAlert2.contains(1)) {
          config.basketInAppAlert2.remove(1);
        } else {
          config.basketInAppAlert2.add(1);
          config.basketInAppAlert2
              .addIf(!config.basketInAppAlert2.contains(0), 0);
        }
        update();
        configService.update(
            ConfigType.basketInAppAlert2, config.basketInAppAlert2);
      }),
      SizedBox(width: 12),
      selectItem('震动', config.basketInAppAlert2.contains(2), onTap: () {
        Utils.onEvent('lqpd_szan', params: {'lqpd_szan': '1'});
        if (config.basketInAppAlert2.contains(2)) {
          config.basketInAppAlert2.remove(2);
        } else {
          config.basketInAppAlert2.add(2);
          config.basketInAppAlert2
              .addIf(!config.basketInAppAlert2.contains(0), 0);
        }
        update();
        configService.update(
            ConfigType.basketInAppAlert2, config.basketInAppAlert2);
      }),
    ]);
  }

  zhishu() {
    return Container(
      color: Colours.white,
      child: Column(children: [
        CommonWidget.cell('显示指数', config.basketList1 == 1 ? '开启' : '关闭',
            onTap: () {
          Get.toNamed(Routes.basketOddsConfig);
        }),
        Divider(height: 0.5, color: Colours.greyEE, indent: 16),
        switchCell('显示球队排名', config.basketList2 == 1, ConfigType.basketList2),
        Divider(height: 0.5, color: Colours.greyEE, indent: 16),
        switchCell('显示彩种编号', config.basketList3 == 1, ConfigType.basketList3),
      ]),
    );
  }
}
