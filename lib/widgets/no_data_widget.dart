import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sports/logic/match/match_page_controller.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/common_button.dart';

class NoDataWidget extends StatelessWidget {
  final String? tip;
  final Function()? onTap;
  final String buttonText;
  final bool needScroll;
  final bool needPic;
  final ScrollPhysics? physics;
  final double? height;
  const NoDataWidget(
      {super.key,
      this.buttonText = "",
      this.onTap,
      this.tip,
      this.needScroll = false,
      this.physics,
      this.needPic = true,
      this.height});

  @override
  Widget build(BuildContext context) {
    return needScroll
        ? SizedBox.expand(
            child: LayoutBuilder(builder: (p0, p1) {
              log(p1.maxHeight.toString());
              return SingleChildScrollView(
                physics: physics ?? const ScrollPhysics(),
                child: Container(
                  height: height ?? p1.maxHeight,
                  child: noData(),
                ),
              );
            }),
          )
        : noData();
  }

  Widget noData() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (needPic)
            Image.asset(Utils.getImgPath("match_nodata.png"))
                .paddingOnly(bottom: 10),
          Text(tip ?? "暂无数据",
              style: TextStyle(color: Colours.grey66, fontSize: 14)),
          if (buttonText.isNotEmpty)
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                margin: const EdgeInsets.only(top: 14),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  border: Border.all(color: Colours.main, width: 0.5),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colours.main),
                ),
              ),
            )
        ],
      ),
    );
  }
}
