import 'package:get/get.dart';
import 'package:sports/locale/language_config.dart';

class LanguageInfoConfig extends Translations {
  String configLanguageMessage(String str) {
    return str.tr;
  }

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      LanguageConfig.home: 'home',
      LanguageConfig.match: 'match',
      LanguageConfig.mine: 'mine',
    },
    'zh_CN': {
      LanguageConfig.home: '首页',
      LanguageConfig.match: '比赛',
      LanguageConfig.mine: '我的',
    }
  };
}