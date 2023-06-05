
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sports/logic/service/config_service.dart';

enum AlertQos {
  system,
  upgrade,
  event,
  level
}

enum AlertType {
  picture,
  text,
  pictureWithText,
  animate
}

class DialogUtils {
  showDialog() {
    
  }
}

class EventAlertFilter {

  static soccerNeedAlert() {
    final config = Get.find<ConfigService>().soccerConfig;
    
    // 提示范围 0: 关注的 1:全部
    switch (config.soccerInAppAlert1) {
      case 0:
        break;
      default:
    }
    
    // 范围 0:比赛列表 1:全部
    switch (config.soccerInAppAlert6) {
      case 0:
        break;
      default:
    }
  }

}
