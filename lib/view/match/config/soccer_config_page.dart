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
import 'package:sports/widgets/common_widget.dart';
import 'package:sports/widgets/cupertino_picker_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SoccerConfigPage extends StatefulWidget {
  const SoccerConfigPage({super.key});

  @override
  State<SoccerConfigPage> createState() => _SoccerConfigPageState();
}

class _SoccerConfigPageState extends State<SoccerConfigPage> {
  ConfigService configService = Get.find<ConfigService>();
  SoccerConfig config = Get.find<ConfigService>().soccerConfig;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.appBar(title: Text('足球比赛设置')),
      backgroundColor: Colours.scaffoldBg,
      body: VisibilityDetector(
        key: Key('SoccerConfigPage'),
        onVisibilityChanged: (info) {
          if (!info.visibleBounds.isEmpty) {
            update();
          }
        },
        child: ListView(
          children: [
            separateTitle('应用内提醒'),
            CommonWidget.cell(
                '提醒范围', config.soccerInAppAlert1 == 0 ? '我关注的比赛' : '全部比赛',
                onTap: () async {
              Utils.onEvent('zqpd_szan', params: {'zqpd_szan': '0'});
              // Get.toNamed(Routes.alertRangeConfig, arguments: 0);
              final result = await Get.bottomSheet(CupertinoPickerWidget(
                ['我关注的比赛', '全部比赛'],
                title: '提醒范围',
                initialIndex: config.soccerInAppAlert1,
              ));
              if (result != null) {
                if (config.soccerInAppAlert1 == result) {
                  return;
                }
                config.soccerInAppAlert1 = result;
                update();
                Get.find<ConfigService>().update(
                    ConfigType.soccerInAppAlert1, config.soccerInAppAlert1);
              }
            }),
            SizedBox(height: 10),
            jinqiu(),
            SizedBox(height: 10),
            cell([
              title('红牌提示'),
              Spacer(),
              selectItem('弹窗', config.soccerInAppAlert5.contains(0), onTap: () {
                Utils.onEvent('zqpd_szan', params: {'zqpd_szan': '4'});
                if (config.soccerInAppAlert5.contains(0)) {
                  config.soccerInAppAlert5.clear();
                } else {
                  config.soccerInAppAlert5.add(0);
                }
                update();
                configService.update(
                    ConfigType.soccerInAppAlert5, config.soccerInAppAlert5);
              }),
              SizedBox(width: 12),
              selectItem('声音', config.soccerInAppAlert5.contains(1), onTap: () {
                Utils.onEvent('zqpd_szan', params: {'zqpd_szan': '4'});
                if (config.soccerInAppAlert5.contains(1)) {
                  config.soccerInAppAlert5.remove(1);
                } else {
                  config.soccerInAppAlert5.add(1);
                  config.soccerInAppAlert5
                      .addIf(!config.soccerInAppAlert5.contains(0), 0);
                }
                update();
                configService.update(
                    ConfigType.soccerInAppAlert5, config.soccerInAppAlert5);
              }),
              SizedBox(width: 12),
              selectItem('震动', config.soccerInAppAlert5.contains(2), onTap: () {
                Utils.onEvent('zqpd_szan', params: {'zqpd_szan': '4'});
                if (config.soccerInAppAlert5.contains(2)) {
                  config.soccerInAppAlert5.remove(2);
                } else {
                  config.soccerInAppAlert5.add(2);
                  config.soccerInAppAlert5
                      .addIf(!config.soccerInAppAlert5.contains(0), 0);
                }
                update();
                configService.update(
                    ConfigType.soccerInAppAlert5, config.soccerInAppAlert5);
              }),
            ]),
            if (config.soccerInAppAlert2.contains(0) ||
                config.soccerInAppAlert5.contains(0)) ...[
              SizedBox(height: 10),
              cell([
                title('弹窗范围'),
                Spacer(),
                selectItem('比赛列表', config.soccerInAppAlert6 == 0, onTap: () {
                  Utils.onEvent('zqpd_szan', params: {'zqpd_szan': '5'});
                  if (config.soccerInAppAlert6 == 0) return;
                  config.soccerInAppAlert6 = 0;
                  update();
                  configService.update(
                      ConfigType.soccerInAppAlert5, config.soccerInAppAlert5);
                }),
                SizedBox(width: 13),
                selectItem('APP全局', config.soccerInAppAlert6 == 1, onTap: () {
                  Utils.onEvent('zqpd_szan', params: {'zqpd_szan': '5'});
                  if (config.soccerInAppAlert6 == 1) return;
                  config.soccerInAppAlert6 = 1;
                  update();
                  configService.update(
                      ConfigType.soccerInAppAlert5, config.soccerInAppAlert5);
                }),
              ]),
            ],
            SizedBox(height: 10),
            switchCell('全部、赛程、赛果频道共享筛选条件', config.soccerInAppAlert7 == 1,
                ConfigType.soccerInAppAlert7),
            separateTitle('列表数据设置'),
            zhishu(),
            separateTitle('通知设置'),
            CommonWidget.cell(
                '关注比赛通知',
                config.pushSoccer1 == 1 && configService.pushConfig.pushAll == 1
                    ? config.getPushConfigCount()
                    : '0/7', onTap: () {
              Utils.onEvent('zqpd_szan', params: {'zqpd_szan': '13'});
              Get.toNamed(Routes.soccerPushConfig);
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
              if (id == ConfigType.soccerInAppAlert7) {
                Utils.onEvent('zqpd_szan', params: {'zqpd_szan': '6'});
                config.soccerInAppAlert7 =
                    (config.soccerInAppAlert7 == 1 ? 0 : 1);
                configService.update(id, config.soccerInAppAlert7);
              } else if (id == ConfigType.soccerList2) {
                Utils.onEvent('zqpd_szan', params: {'zqpd_szan': '8'});
                config.soccerList2 = (config.soccerList2 == 1 ? 0 : 1);
                configService.update(id, config.soccerList2);
              } else if (id == ConfigType.soccerList3) {
                Utils.onEvent('zqpd_szan', params: {'zqpd_szan': '9'});
                config.soccerList3 = (config.soccerList3 == 1 ? 0 : 1);
                configService.update(id, config.soccerList3);
              } else if (id == ConfigType.soccerList4) {
                Utils.onEvent('zqpd_szan', params: {'zqpd_szan': '10'});
                config.soccerList4 = (config.soccerList4 == 1 ? 0 : 1);
                configService.update(id, config.soccerList4);
              } else if (id == ConfigType.soccerList5) {
                Utils.onEvent('zqpd_szan', params: {'zqpd_szan': '11'});
                config.soccerList5 = (config.soccerList5 == 1 ? 0 : 1);
                configService.update(id, config.soccerList5);
              } else if (id == ConfigType.soccerList6) {
                Utils.onEvent('zqpd_szan', params: {'zqpd_szan': '12'});
                config.soccerList6 = (config.soccerList6 == 1 ? 0 : 1);
                configService.update(id, config.soccerList6);
              }
              if (id != ConfigType.soccerInAppAlert7) {
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
    return Container(
      color: Colours.white,
      child: Column(children: [
        cell([
          title('进球提示'),
          Spacer(),
          selectItem('弹窗', config.soccerInAppAlert2.contains(0), onTap: () {
            Utils.onEvent('zqpd_szan', params: {'zqpd_szan': '1'});
            if (config.soccerInAppAlert2.contains(0)) {
              config.soccerInAppAlert2.clear();
            } else {
              config.soccerInAppAlert2.add(0);
            }
            update();
            configService.update(
                ConfigType.soccerInAppAlert2, config.soccerInAppAlert2);
          }),
          SizedBox(width: 12),
          selectItem('声音', config.soccerInAppAlert2.contains(1), onTap: () {
            Utils.onEvent('zqpd_szan', params: {'zqpd_szan': '1'});
            if (config.soccerInAppAlert2.contains(1)) {
              config.soccerInAppAlert2.remove(1);
            } else {
              config.soccerInAppAlert2.add(1);
              config.soccerInAppAlert2
                  .addIf(!config.soccerInAppAlert2.contains(0), 0);
            }
            update();
            configService.update(
                ConfigType.soccerInAppAlert2, config.soccerInAppAlert2);
          }),
          SizedBox(width: 12),
          selectItem('震动', config.soccerInAppAlert2.contains(2), onTap: () {
            Utils.onEvent('zqpd_szan', params: {'zqpd_szan': '1'});
            if (config.soccerInAppAlert2.contains(2)) {
              config.soccerInAppAlert2.remove(2);
            } else {
              config.soccerInAppAlert2.add(2);
              config.soccerInAppAlert2
                  .addIf(!config.soccerInAppAlert2.contains(0), 0);
            }
            update();
            configService.update(
                ConfigType.soccerInAppAlert2, config.soccerInAppAlert2);
          }),
        ]),
        if (config.soccerInAppAlert2.contains(1)) ...[
          Divider(
            height: 0.5,
            color: Colours.greyEE,
            indent: 16,
          ),
          CommonWidget.cell(
              '主队进球声音', configService.sounds[config.soccerInAppAlert3],
              onTap: () {
            Utils.onEvent('zqpd_szan', params: {'zqpd_szan': '2'});
            Get.toNamed(Routes.soccerSoundConfig, arguments: 0);
          }),
          Divider(
            height: 0.5,
            color: Colours.greyEE,
            indent: 16,
          ),
          CommonWidget.cell(
              '客队进球声音', configService.sounds[config.soccerInAppAlert4],
              onTap: () {
            Utils.onEvent('zqpd_szan', params: {'zqpd_szan': '3'});
            Get.toNamed(Routes.soccerSoundConfig, arguments: 1);
          }),
        ]
      ]),
    );
  }

  zhishu() {
    return Container(
      color: Colours.white,
      child: Column(children: [
        CommonWidget.cell('显示指数', config.soccerList1 == 1 ? '开启' : '关闭',
            onTap: () {
          Utils.onEvent('zqpd_szan', params: {'zqpd_szan': '7'});
          Get.toNamed(Routes.soccerOddsConfig);
        }),
        Divider(height: 0.5, color: Colours.greyEE, indent: 16),
        switchCell('显示球队排名', config.soccerList2 == 1, ConfigType.soccerList2),
        Divider(height: 0.5, color: Colours.greyEE, indent: 16),
        switchCell('显示彩种编号', config.soccerList3 == 1, ConfigType.soccerList3),
        Divider(height: 0.5, color: Colours.greyEE, indent: 16),
        switchCell('显示观点数量', config.soccerList4 == 1, ConfigType.soccerList4),
        Divider(height: 0.5, color: Colours.greyEE, indent: 16),
        switchCell('显示红黄牌', config.soccerList5 == 1, ConfigType.soccerList5),
        Divider(height: 0.5, color: Colours.greyEE, indent: 16),
        switchCell('显示角球', config.soccerList6 == 1, ConfigType.soccerList6)
      ]),
    );
  }
}
