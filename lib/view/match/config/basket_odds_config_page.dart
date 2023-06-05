import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/match/match_page_controller.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/common_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BasketOddsConfigPage extends StatefulWidget {
  const BasketOddsConfigPage({super.key});

  @override
  State<BasketOddsConfigPage> createState() => _BasketOddsConfigPageState();
}

class _BasketOddsConfigPageState extends State<BasketOddsConfigPage> {
  BasketConfig config = Get.find<ConfigService>().basketConfig;
  ConfigService configService = Get.find<ConfigService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.appBar(title: Text('篮球指数设置')),
      backgroundColor: Colours.scaffoldBg,
      body: VisibilityDetector(
        key: Key('SoccerOddsConfigPage'),
        onVisibilityChanged: (info) {
          if (!info.visibleBounds.isEmpty) {
            final matchController =
                Get.find<MatchPageController>().getMatchController();
            matchController.updateView();
            update();
          }
        },
        child: ListView(children: [
          SizedBox(height: 10),
          CommonWidget.switchCell('显示指数', config.basketList1 == 1, onTap: () {
            config.basketList1 = (config.basketList1 == 1 ? 0 : 1);
            update();
            configService.update(ConfigType.soccerList1, config.basketList1);
            final matchController =
                Get.find<MatchPageController>().getMatchController();
            matchController.updateView();
          }),
          SizedBox(height: 10),
          CommonWidget.cell(
              '指数类型',
              config.basketList7
                  .map((e) => configService.basketOddsType[e])
                  .toList()
                  .join(' | '), onTap: () {
            Get.toNamed(Routes.basketOddsType);
          }),
          CommonWidget.seperateLine(),
          CommonWidget.cell(
              '指数公司',
              configService.oddsCompany!
                  .firstWhere((element) => element.id == config.basketList8)
                  .name!, onTap: () {
            Get.toNamed(Routes.oddsCompany, arguments: 1);
          }),
          CommonWidget.seperateLine(),
          CommonWidget.cell('指数显示', config.basketList9 == 0 ? '初始' : '即时',
              onTap: () {
            Get.toNamed(Routes.oddsShow, arguments: 1);
          }),
        ]),
      ),
    );
  }
}
