import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/service/resource_service.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/user.dart';

import '../../res/routes.dart';
import '../../res/styles.dart';
import '../../util/toast_utils.dart';
import '../../util/utils.dart';

class ExpertRequestTypePage extends StatelessWidget {
  ExpertRequestTypePage({Key? key}) : super(key: key);

  final List<List<String>> content = [
    ["个人入驻", "适合熟悉足球、篮球的个人申请成为作者和球迷分享比赛的理解以及赛果预测！"],
    ["企业/网媒", "适合报纸、杂志、电视、电台或企业公司等分支机构相关品牌、产品和服务。"],
    ["MCN机构", "适合MCN机构，拥有行业知名账户以及拥有体育行业超强影响力机构入驻。"]
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.appBar(title: const Text('专家申请')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  User.needLogin(() async {
                    final data = await Api.expertApplyInfo();
                    if (data == null) {
                      Get.toNamed(Routes.expertApply);
                    } else {
                      Get.toNamed(Routes.expertApplySuccess, arguments: data);
                    }
                  });
                },
                child:
                    _buildCard(content[0], Colours.orangeCardGradientColorSet),
              ),
              Container(height: 16),
              GestureDetector(
                onTap: () => Get.to(() => contentByWeChat("企业/网媒入驻")),
                child:
                    _buildCard(content[1], Colours.greenCardGradientColorSet),
              ),
              Container(height: 16),
              GestureDetector(
                onTap: () => Get.to(() => contentByWeChat("MCN机构入驻")),
                child: _buildCard(content[2], Colours.blueCardGradientColorSet),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(List<String> contentList, List<Color> colorSet) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: colorSet.sublist(3, 5)),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(contentList[0],
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: colorSet[0])),
          Container(height: 6),
          Text(contentList[1],
              style: TextStyle(fontSize: 14, color: colorSet[1])),
          Container(height: 12),
          Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
              decoration: BoxDecoration(
                  color: const Color(0x80FFFFFF),
                  borderRadius: BorderRadius.circular(20)),
              child: Text('选择入驻',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colorSet[2])))
        ],
      ),
    );
  }

  Widget contentByWeChat(String title) {
    final resource = Get.find<ResourceService>();
    return Scaffold(
      appBar: Styles.appBar(title: Text(title)),
      backgroundColor: Colours.greyF7F7F7,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: Get.width,
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colours.white),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text("目前该渠道仅限平台邀请加入，",
                        style:
                            TextStyle(fontSize: 14, color: Colours.main_color)),
                    Text("如有疑问请咨询红球会客服。",
                        style:
                            TextStyle(fontSize: 14, color: Colours.main_color))
                  ],
                ),
              ),
              Container(height: 10),
              Container(
                width: Get.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colours.white),
                child: Column(
                  children: [
                    const Text("红球会客服微信",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colours.text_color)),
                    Container(height: 16),
                    const Divider(height: 0.5, color: Colours.greyEE),
                    Container(height: 50),
                    Image.asset(
                        width: 60,
                        height: 60,
                        Utils.getImgPath("qxb_logo.png")),
                    Container(height: 16),
                    Text("${resource.expertContact?.content}",
                        style:
                            TextStyle(fontSize: 14, color: Colours.grey666666)),
                    Container(height: 30),
                    GestureDetector(
                      onTap: () {
                        if (resource.expertContact != null) {
                          // Clipboard.setData(ClipboardData(
                          //     text: resource.expertContact!.content));
                          // ToastUtils.show("已复制微信号");
                        }
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 47, vertical: 13),
                          decoration: BoxDecoration(
                              color: Colours.main_color,
                              borderRadius: BorderRadius.circular(50)),
                          child: const Text('复制微信号',
                              style: TextStyle(
                                  fontSize: 16, color: Colours.white))),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
