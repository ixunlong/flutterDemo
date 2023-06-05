
import 'package:sports/util/sp_utils.dart';

class LocalSettings {

  static const _wlanDownKey = "wlanDown";

  static Json settings = SpUtils.localSettings;
  static save() => SpUtils.localSettings = settings;

  static bool get wlanDown => settings[_wlanDownKey] ?? true;
  static set wlanDown(bool b) => settings[_wlanDownKey] = b;
}
