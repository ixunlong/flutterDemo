import 'dart:io';

import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/util/utils.dart';

import '../widgets/custom_indicator.dart';
import 'colours.dart';

class Styles {
  static AppBar appBar(
      {List<Widget> actions = const [],
      IconThemeData? iconTheme,
      Color leadingColor = Colors.black,
      TextStyle? titleTextStyle,
      Widget? title,
      ScrollPhysics? physics,
      Color? foregroundColor,
      Color? backgroundColor,
      double? toolbarHeight,
      bool showBackButton = true,
      bool centerTitle = true}) {
    return AppBar(
      centerTitle: centerTitle,
      actions: actions,
      toolbarHeight: toolbarHeight,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      title: title,
      titleTextStyle: titleTextStyle,
      iconTheme: iconTheme,
      leading: showBackButton
          ? GestureDetector(
              onTap: Get.back,
              behavior: HitTestBehavior.translucent,
              child: Image.asset(
                Utils.getImgPath('arrow_back.png'),
                color: leadingColor,
              ),
            )
          : null,
      // IconButton(
      //   onPressed: Get.back,
      //   icon: ImageIcon(AssetImage(Utils.getImgPath("arrow_back.png")))),
    );
  }

  static ExtendedTabBar defaultTabBar({
    required List<Widget> tabs,
    TabController? controller,
    ValueChanged<int>? onTap,
    double fontSize = 14,
    ScrollPhysics? physics,
    Decoration? indicator,
    double indicatorBottom = 1,
    EdgeInsetsGeometry labelPadding = const EdgeInsets.symmetric(horizontal: 4),
    bool isScrollable = false,
    double indicatorWidth = 15,
    labelColor = Colors.red,
    unselectedLabelColor = Colours.grey66,
    fontWeight = FontWeight.w600,
    unselectedFontWeight = FontWeight.w500,
  }) {
    return ExtendedTabBar(
      tabs: tabs,
      physics: physics,
      labelPadding: labelPadding,
      controller: controller,
      indicator: indicator ??
          CustomIndicator(
              borderSide: const BorderSide(color: Colors.red, width: 2),
              indicatorWidth: indicatorWidth,
              indicatorBottom: indicatorBottom),
      isScrollable: isScrollable,
      labelColor: labelColor,
      unselectedLabelColor: unselectedLabelColor,
      unselectedLabelStyle:
          TextStyle(fontSize: fontSize, fontWeight: unselectedFontWeight),
      labelStyle: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
      onTap: onTap,
    );
  }

  static StrutStyle centerStyle(
      {required double fontSize, FontWeight? fontWeight}) {
    return StrutStyle(
        fontSize: fontSize,
        height: Platform.isIOS ? 1.1 : 1.4,
        forceStrutHeight: true,
        fontWeight: fontWeight ?? FontWeight.w400);
  }

  static TextStyle normalText({required double fontSize}) {
    return TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        color: Colours.text_color);
  }

  static TextStyle mediumText({required double fontSize}) {
    return TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: Colours.text_color);
  }

  static TextStyle boldText({required double fontSize}) {
    return TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: Colours.text_color);
  }

  static TextStyle normalSubText({required double fontSize}) {
    return TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        color: Colours.grey666666);
  }

  static TextStyle mediumSubText({required double fontSize}) {
    return TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: Colours.grey666666);
  }

  static TextStyle boldSubText({required double fontSize}) {
    return TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: Colours.grey666666);
  }

  static Widget placeholderIcon({double? width, double? height}) {
    return Container(
      color: Colours.greyD9,
      width: width,
      height: height,
    );
  }
}
