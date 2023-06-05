import 'package:get/get.dart';

import 'language_config.dart';

String configLanguage(String str) {
  return str.tr;
}

class TextUtils{
  static String get home => configLanguage(LanguageConfig.home);
  static String get match => configLanguage(LanguageConfig.match);
  static String get mine => configLanguage(LanguageConfig.mine);
}