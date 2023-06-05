import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:sports/model/expert/plan_Info_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/view/expert/viewpoint_widgets/content_html_view.dart';
import 'package:sports/widgets/describe_dialog.dart';

import '../../../util/utils.dart';

class PlanContentView extends StatefulWidget {
  const PlanContentView({super.key, this.planInfo, required this.readable});

  final PlanInfoEntity? planInfo;
  final bool readable;

  @override
  State<PlanContentView> createState() => _PlanContentViewState();
}

class _PlanContentViewState extends State<PlanContentView> {
  PlanInfoEntity? get planInfo => widget.planInfo;

  bool get readable => widget.readable;
  bool get matchStart =>
      (planInfo?.matchTime?.difference(DateTime.now()).inSeconds ?? 1) < 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _allReadBox();
  }

  _roundCenterBox(Widget child,
      {double width = 40, double height = 49, double radius = 6}) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0x26F53F3F), width: 0.5),
          borderRadius: BorderRadius.circular(radius)),
      child: child,
    );
  }

  String getData() {
    var regCom = RegExp(r'<\/p>[.\n]<p>');
    String append = '';
    String? com = planInfo?.planContent
        ?.split("<p>&nbsp;</p>")
        .join("<div style= 'height: 20;width: 200px;'>  </div>")
        .split(regCom)
        .join("</p><div style= 'height: 20;width: 200px;'>  </div><p>")
        .split("/><p>")
        .join("/><div style= 'height: 20;width: 200px;'>  </div><p>")
        .split("/><img")
        .join("/><div style= 'height: 20;width: 200px;'>  </div><img");
    if (com?.endsWith("v>") != true) {
      com = "$com<div style= 'height: 25;width: 200px;'>  </div>";
    }
    com?.split("").forEach((element) {
      if (regC.hasMatch(element)) {
        append += "$element\u200A";
      } else {
        append += element;
      }
    });
    var newData = "";
    newData = """
    <!DOCTYPE html>
      <html>
        <body style="margin: 8 20 0 20"><div style="color: #333;margin-top: 10;font-size: 17px; line-height: 1.3; letter-spacing: -1px; white-space: normal; text-align: justify;">$append<div style= 'height: 24;width: 200px;'></div></body>
      </html>
      <style>
      p{
        margin: 0;
      }
      img{
        max-width: 100%;
        height: auto;
        border-radius: 4px;
      }
      </style>
    """;
    return newData;
  }

  var regC = RegExp(r"[\u4e00-\u9fa5]");
  var reg = RegExp(r"(?<=(<[^>]+>))(.*(?!(&\w*;)+))(?=(<[^>]+>))");
  String changeForm(String data) {
    return data.splitMapJoin(
      reg,
      onMatch: (value) {
        String? v = '';
        for (var i = 0; i < value.groupCount; i++) {
          v = value.group(i);
          if (reg.hasMatch(v ?? "")) {
            changeForm(v ?? "");
          } else {
            v?.split('').join("\u2006");
          }
        }
        return v ?? '';
      },
    );
  }

  Widget _allReadBox() {
    // String content = planInfo?.planContent ?? "";
    // String subcontent = content;
    // if (!readable) {
    //   subcontent = "${subcontent.characters.take(50).string}...";
    //   content = content.characters.skip(50).string;
    // }
    // content = """
    //   <a href="https://baidu.com">baidu</a>
    // """;
    // log("content = $content");
    // Map<String, Style> style = {
    //   "body": Style(
    //       fontWeight: FontWeight.w400,
    //       padding: EdgeInsets.zero,
    //       margin: Margins(bottom: Margin(0)),
    //       fontSize: FontSize(17),
    //       color: const Color(0xff444444),
    //       lineHeight: const LineHeight(1.4),
    //       letterSpacing: -0.5,
    //       textAlign: TextAlign.justify
    //       ),
    // };
    return Column(
      children: [
        planInfo?.activityId != null
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(width: 16),
                  Text(
                    "该观点享受${planInfo?.activityId == 1 ? "首购不中退款" : "粉丝不中退款"}",
                    strutStyle: Styles.centerStyle(fontSize: 12),
                    style: const TextStyle(color: Colours.main, fontSize: 12),
                  ),
                  Container(width: 4),
                  Image.asset(
                          width: 12,
                          height: 12,
                          Utils.getImgPath("question_mark_red.png"))
                      .tap(() {
                    Get.dialog(const DescribeDialog(content: [
                      "1) 观点不中：观点推荐选项首选和次选均不中，则为不中。",
                      "2) 不中退时间：比赛赛果确认后的半小时内，实付红钻金额自动退款至红钻余额内。"
                    ], title: "不中退说明", confirmText: "知道了"));
                  })
                ],
              ).paddingOnly(bottom: 8)
            : Container(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              PlanContentHtmlView(htmldata: planInfo?.planSummary ?? ""),
              if (planInfo?.feeContentCnt != 0)
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      height: 0.5,
                      color: Color(0xFFBF8361),
                    )),
                    const Text("以下文字为付费内容",
                            style: TextStyle(
                                color: Color(0xFFBF8361), fontSize: 12))
                        .marginSymmetric(horizontal: 11),
                    Expanded(
                        child: Container(
                      height: 0.5,
                      color: Color(0xFFBF8361),
                    )),
                  ],
                ).marginOnly(top: 20, bottom: 12),
              if (planInfo?.feeContentCnt != 0)
                readable
                    ? PlanContentHtmlView(htmldata: planInfo?.feeContent ?? "")
                    : AspectRatio(
                        aspectRatio: 344 / 68,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              // color: Colors.amber,
                              image: DecorationImage(
                                  image: AssetImage(
                                      Utils.getImgPath("viewpoint_unsee.png")),
                                  fit: BoxFit.fill)),
                          height: 68,
                          child: Text(
                                  "付费可查看${planInfo?.feeContentCnt ?? 0}字比赛分析",
                                  style: TextStyle(color: Colors.white))
                              .marginOnly(top: 32),
                        ),
                      )
            ],
          ),
        ),
      ],
    );
  }

  _saleTip() {
    final dur = planInfo?.matchTime?.difference(DateTime.now()) ??
        Duration(hours: 0, minutes: 0, seconds: 0);
    final hour = dur.inHours;
    String hStr = "$hour";
    if (hStr.length == 1) {
      hStr = "0$hStr";
    }
    final minutes = dur.inMinutes - dur.inHours * 60;
    String mStr = "$minutes";
    if (mStr.length == 1) {
      mStr = "0$mStr";
    }
    final seconds = dur.inSeconds - dur.inMinutes * 60;
    String sStr = "$seconds";
    if (sStr.length == 1) {
      sStr = "0$sStr";
    }
    if (dur.inSeconds < 0) {
      hStr = "00";
      mStr = "00";
      sStr = "00";
    }
    return Container(
      height: 151,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "距售卖停止",
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 10),
          DefaultTextStyle(
            style: const TextStyle(fontSize: 20, color: Colours.main_color),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _roundCenterBox(Text(hStr)),
                const Text(":").paddingSymmetric(horizontal: 10),
                _roundCenterBox(Text(mStr)),
                const Text(":").paddingSymmetric(horizontal: 10),
                _roundCenterBox(Text(sStr))
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "付费后可查看专家推荐选项与分析",
            style: TextStyle(fontSize: 11, color: Colours.grey_color1),
          )
        ],
      ),
    );
  }
}
