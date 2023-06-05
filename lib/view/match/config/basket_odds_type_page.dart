import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/common_widget.dart';

class BasketOddsTypePage extends StatefulWidget {
  const BasketOddsTypePage({super.key});

  @override
  State<BasketOddsTypePage> createState() => _BasketOddsTypePageState();
}

class _BasketOddsTypePageState extends State<BasketOddsTypePage> {
  BasketConfig config = Get.find<ConfigService>().basketConfig;
  ConfigService configService = Get.find<ConfigService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.appBar(title: Text('篮球指数类型')),
      backgroundColor: Colours.scaffoldBg,
      body: ListView(children: [
        SizedBox(height: 10),
        cell(0),
        CommonWidget.seperateLine(),
        cell(1),
        CommonWidget.seperateLine(),
        cell(2)
      ]),
    );
  }

  Widget cell(int index) {
    return CommonWidget.selectCell(
        configService.basketOddsType[index], config.basketList7.contains(index),
        onTap: () {
      if (config.basketList7.contains(index)) {
        config.basketList7.remove(index);
      } else {
        config.basketList7.add(index);
      }
      config.basketList7.sort((a, b) => a.compareTo(b));
      update();
      configService.update(ConfigType.basketList7, config.basketList7);
    });
  }
}
