class Regex {
  static const phone =
      r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$';
  static const number = '[0-9]';
  //数字1-9999
  static const number9999 = r'/^10000$|^([1-9][0-9]{0,3})';
}
