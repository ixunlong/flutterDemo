import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sports/res/colours.dart';

class ThemeProvider {
  ThemeData getTheme() {
    return ThemeData(
        iconTheme: IconThemeData(size: 20),
        fontFamilyFallback: ['PingFang SC'],
        // fontFamily: 'PingFang SC', //全局配置默认字体使得中文字重正常渲染
        primaryColor: Colours.main_color,
        scaffoldBackgroundColor: Colors.white,
        // hintColor: Colours.grey_text_color,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        textButtonTheme: TextButtonThemeData(style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith((states) {
          return Colors.transparent;
        }))),
        // textTheme: const TextTheme(
        //   headline4: TextStyle(
        //       fontSize: 30.0,
        //       fontWeight: FontWeight.bold,
        //       color: Colours.text_color),
        //   headline5: TextStyle(
        //       fontSize: 22.0,
        //       fontWeight: FontWeight.bold,
        //       color: Colours.text_color),
        //   headline6: TextStyle(
        //       fontSize: 18.0,
        //       fontWeight: FontWeight.bold,
        //       color: Colours.text_color),
        //   // labelLarge: TextStyle(fontSize: 17, color:/ Colours.grey_color),
        //   caption: TextStyle(fontSize: 13, color: Colours.grey_text_color),
        //   button: TextStyle(fontSize: 15, color: Colours.main_color),
        //   subtitle1: TextStyle(fontSize: 17, color: Colours.text_color),
        //   subtitle2: TextStyle(fontSize: 16, color: Colours.text_color),
        //   bodyText1: TextStyle(fontSize: 15, color: Colours.grey_text_color),
        //   //Common text style
        //   bodyText2: TextStyle(fontSize: 15, color: Colours.text_color),
        //   overline: TextStyle(fontSize: 11, color: Colours.grey_text_color1),
        // ),
        appBarTheme: const AppBarTheme(
            centerTitle: true,
            backgroundColor: Colours.white,
            elevation: 0,
            toolbarHeight: 44,
            iconTheme: IconThemeData(size: 20, color: Colours.text_color1),
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colours.text_color1,
              // fontFamily: "HanSans",
            )),
        cupertinoOverrideTheme: const CupertinoThemeData(
            textTheme: CupertinoTextThemeData(
          // dateTimePickerTextStyle:
          //     TextStyle(color: Colours.grey_color1, fontSize: 16),
          pickerTextStyle: TextStyle(color: Colours.grey_color, fontSize: 16),
          // textStyle: TextStyle(color: Colours.red_color, fontSize: 16),
        )),
        buttonTheme: const ButtonThemeData(buttonColor: Colours.main_color));
  }
}
