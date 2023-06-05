import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/common_widget.dart';

class OddsShowPage extends StatefulWidget {
  const OddsShowPage({super.key});

  @override
  State<OddsShowPage> createState() => _OddsShowPageState();
}

class _OddsShowPageState extends State<OddsShowPage> {
  ConfigService configService = Get.find<ConfigService>();
  List<String> title = ['初始', '即时'];
  //0足球  1篮球
  int type = Get.arguments;
  @override
  Widget build(BuildContext context) {
    List<Widget> widget = [];
    for (int index = 0; index < title.length; index++) {
      widget.add(type == 0
          ? CommonWidget.selectCell(
              title[index], configService.soccerConfig.soccerList9 == index,
              onTap: () {
              configService.soccerConfig.soccerList9 = index;
              update();
              configService.update(ConfigType.soccerList9,
                  configService.soccerConfig.soccerList9);
            })
          : CommonWidget.selectCell(
              title[index], configService.basketConfig.basketList9 == index,
              onTap: () {
              configService.basketConfig.basketList9 = index;
              update();
              configService.update(ConfigType.basketList9,
                  configService.basketConfig.basketList9);
            }));
      if (index != title.length - 1) {
        widget.add(CommonWidget.seperateLine());
      }
    }
    return Scaffold(
      appBar: Styles.appBar(title: Text('指数显示')),
      backgroundColor: Colours.scaffoldBg,
      body: ListView(children: [SizedBox(height: 10), ...widget]),
    );
  }
}
