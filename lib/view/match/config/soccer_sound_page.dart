import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/sound_utils.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/common_widget.dart';

class SoccerSoundPage extends StatefulWidget {
  const SoccerSoundPage({super.key});

  @override
  State<SoccerSoundPage> createState() => _SoccerSoundPageState();
}

class _SoccerSoundPageState extends State<SoccerSoundPage> {
  ConfigService configService = Get.find<ConfigService>();

  //0 主队 1客队
  int? type = Get.arguments;
  @override
  Widget build(BuildContext context) {
    List<Widget> widget = [];
    for (int index = 0; index < configService.sounds.length; index++) {
      widget.add(type == 0
          ? CommonWidget.selectCell(configService.sounds[index],
              configService.soccerConfig.soccerInAppAlert3 == index,
              onTap: () => onTap(index))
          : CommonWidget.selectCell(configService.sounds[index],
              configService.soccerConfig.soccerInAppAlert4 == index,
              onTap: () => onTap(index)));
      if (index != configService.sounds.length - 1) {
        widget.add(CommonWidget.seperateLine());
      }
    }
    return Scaffold(
      appBar: Styles.appBar(title: Text(type == 0 ? '主队进球声音' : '客队进球声音')),
      backgroundColor: Colours.scaffoldBg,
      body: ListView(children: [SizedBox(height: 10), ...widget]),
    );
  }

  onTap(int index) {
    if (type == 0) {
      configService.soccerConfig.soccerInAppAlert3 = index;
      configService.update(ConfigType.soccerInAppAlert3,
          configService.soccerConfig.soccerInAppAlert3);
      SoundUtils.playSoccerGoal(true);
    } else {
      configService.soccerConfig.soccerInAppAlert4 = index;
      configService.update(ConfigType.soccerInAppAlert4,
          configService.soccerConfig.soccerInAppAlert4);
      SoundUtils.playSoccerGoal(false);
    }
    update();
  }
}
