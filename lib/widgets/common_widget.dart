import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/utils.dart';

class CommonWidget {
  static cell(String title, String detail, {Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 52,
        color: Colours.white,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [
          Text(title,
              style: TextStyle(color: Colours.text_color1, fontSize: 16)),
          Spacer(),
          Text(detail, style: TextStyle(color: Colours.grey66, fontSize: 14)),
          SizedBox(width: 10),
          Image.asset(Utils.getImgPath("arrow_right.png"))
        ]),
      ),
    );
  }

  //勾选框
  static selectCell(String title, bool select, {Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 52,
        color: Colours.white,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [
          Text(title,
              style: TextStyle(color: Colours.text_color1, fontSize: 16)),
          Spacer(),
          Image.asset(
            Utils.getImgPath(select ? 'select.png' : 'unselect.png'),
            width: 20,
            height: 20,
          ),
        ]),
      ),
    );
  }

  static seperateLine({double indent = 16}) {
    return Divider(height: 0.5, color: Colours.greyEE, indent: indent);
  }

  static Widget switchCell(String title, bool select, {Function()? onTap}) {
    return Container(
      height: 52,
      color: Colours.white,
      padding: EdgeInsets.only(left: 16, right: 10),
      child: Row(children: [
        Text(
          title,
          style: TextStyle(color: Colours.text_color1, fontSize: 16),
        ),
        Spacer(),
        Transform.scale(
          scale: 0.9,
          child: CupertinoSwitch(
            value: select,
            // trackColor: Colours.main_color,
            activeColor: Colours.main_color,
            onChanged: (value) {
              if (onTap != null) {
                onTap();
              }
            },
          ),
        )
      ]),
    );
  }

  static Widget cupertinoSwitch(bool select, {Function()? onTap}) {
    return Transform.scale(
      scale: 0.9,
      child: CupertinoSwitch(
        value: select,
        // trackColor: Colours.main_color,
        activeColor: Colours.main_color,
        onChanged: (value) {
          if (onTap != null) {
            onTap();
          }
        },
      ),
    );
  }
}
