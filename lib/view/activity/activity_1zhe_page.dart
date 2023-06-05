import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sports/model/home/lbt_entiry.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/tip_resources.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:get/get.dart';
import 'package:sports/view/my/discount/my_discount_page.dart';

import '../../res/styles.dart';

class Activity1zhePage extends StatelessWidget {
  Activity1zhePage({super.key});

  final desc = TipResources.gift4newuserTips ??
      [
        LbtEntity(content: "1.用户获得活动资格之日起，连续赠送7日、每日2张一折券。"),
        LbtEntity(content: "2.本活仅限新注册的用户和未消费用户享受。"),
        LbtEntity(content: "3.满足活动条件的用户在查看专家观点时会自动显示券后的价格。"),
        LbtEntity(
            content: "4.相同注册手机号、同一设备或其他与用户身份相关信息的特征标记能够形成关联，均视为同一用户，按同一用户处理。"),
        LbtEntity(
            content:
                "5.活动过程中，凡以不正当手段（作弊、扰乱系统、实施网络攻击等）参与本次活动的用户，红球会有权终止其参与活动，井取消所有活动资格。"),
        LbtEntity(
            content:
                "6.如遇不可抗力（包括但不限于重大灾害事件、活动受政府机关指令需要停止举办或调整的、活动中存在大面积作弊行为、活动造受严重网络攻击或因系统故障导致活动领取资格大批量出错、活动不能正常进行的），红球会可取消、修改或暂停本活动。"),
        LbtEntity(content: "7.如遇其他任何纠纷，最终解释权均归红球会所有。"),
        LbtEntity(content: "8.本活动与Apple Inc.无关。"),
      ];

  @override
  Widget build(BuildContext context) {
    final ratio = Get.width / 375;
    final height = ratio * 828;
    return Scaffold(
      appBar: Styles.appBar(
        title: Text("活动规则"),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          height: height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage(Utils.getImgPath("activity_bg1.png")))),
          child: LayoutBuilder(builder: (p0, p1) {
            final height = p1.maxHeight / 828 * 168;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: height,
                ),
                Image.asset(Utils.getImgPath("activity_btn1.png"))
                    .tap(() async {
                  User.needLogin(() {
                    Get.off(() => MyDiscountPage());
                  });
                }),
                Container(
                  // height: 500,
                  margin: EdgeInsets.only(left: 16, right: 16, bottom: 50),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xB3FFFFFF)),
                  child: _content(),
                )
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _content() {
    return Column(
      children: [
        Text(
          "活动规则",
          style: TextStyle(
              fontSize: 16,
              color: Colours.text_color1,
              fontWeight: FontWeight.w500),
        ).marginOnly(top: 16, bottom: 8),
        ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(left: 16, right: 16),
          children: [
            ...desc.map((e) => Text(
                  e.content ?? "",
                  style: TextStyle(fontSize: 14, color: Colours.grey666666),
                ).marginOnly(bottom: 4)),
            SizedBox(
              height: 16,
            )
          ],
        ),
      ],
    );
  }
}
