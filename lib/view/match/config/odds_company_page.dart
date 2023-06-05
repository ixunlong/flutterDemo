import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/common_widget.dart';

class OddsCompanyPage extends StatefulWidget {
  const OddsCompanyPage({super.key});

  @override
  State<OddsCompanyPage> createState() => _OddsCompanyPageState();
}

class _OddsCompanyPageState extends State<OddsCompanyPage> {
  ConfigService configService = Get.find<ConfigService>();
  //0足球  1篮球
  int type = Get.arguments;
  @override
  Widget build(BuildContext context) {
    List<Widget> widget = [];
    for (int index = 0; index < configService.oddsCompany!.length; index++) {
      widget.add(type == 0
          ? CommonWidget.selectCell(
              configService.oddsCompany![index].name ?? '',
              configService.soccerConfig.soccerList8 ==
                  configService.oddsCompany![index].id, onTap: () {
              configService.soccerConfig.soccerList8 =
                  configService.oddsCompany![index].id!;
              update();
              configService.update(ConfigType.soccerList8,
                  configService.soccerConfig.soccerList8);
            })
          : CommonWidget.selectCell(
              configService.oddsCompany![index].name ?? '',
              configService.basketConfig.basketList8 ==
                  configService.oddsCompany![index].id, onTap: () {
              configService.basketConfig.basketList8 =
                  configService.oddsCompany![index].id!;
              update();
              configService.update(ConfigType.basketList8,
                  configService.basketConfig.basketList8);
            }));
      if (index != configService.oddsCompany!.length - 1) {
        widget.add(CommonWidget.seperateLine());
      }
    }
    return Scaffold(
      appBar: Styles.appBar(title: Text(type == 0 ? '足球指数公司' : '篮球指数公司')),
      backgroundColor: Colours.scaffoldBg,
      body: ListView(children: [SizedBox(height: 10), ...widget]),
    );
  }
}
