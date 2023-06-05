import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/service/um_service.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/view/my/web_page.dart';
import 'package:sports/widgets/common_button.dart';

class PrivacyAgreeView extends StatelessWidget {
  // final VoidCallback? onAgree;
  const PrivacyAgreeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Container(
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(30),
          //   color: Colours.white,
          // ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          width: Get.width - 96,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              const Text('个人信息保护指引',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
              const SizedBox(height: 16),
              SizedBox(
                height: 250,
                child: SingleChildScrollView(
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(children: [
                      const TextSpan(
                          text: '感谢您使用红球会APP！\n我们根据最新的监管要求更新了',
                          style: TextStyle(color: Colours.grey_color)),
                      TextSpan(
                          text: '《用户协议》',
                          style: const TextStyle(color: Colours.main_color),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.toNamed(Routes.webview,
                                  arguments: const WebPara(
                                      "", Constant.serviceAgreementUrl,
                                      longpress: true));
                            }),
                      const TextSpan(
                          text: '与',
                          style: TextStyle(color: Colours.grey_color)),
                      TextSpan(
                          text: '《隐私政策》',
                          style: const TextStyle(color: Colours.main_color),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.toNamed(Routes.webview,
                                  arguments: const WebPara(
                                      "", Constant.privacyPolicyUrl,
                                      longpress: true));
                            }),
                      const TextSpan(
                          text:
                              '，请点击了解更新后的详细内容。后续在使用 APP 期间，您可以通过：“我的”-“更多设置”-“关于我们”，查看上述协议内容。\n在此特向您说明如下：\n1.我们更新了与第三方合作的相关情形，即红球会中部分服务的功能实现由第三方程序提供，为此相关第三方可能需要收集使用必要的个人信息。\n2.基于您的明示同意，我们可能会申请您的通知、相机、相册/存储、网络、麦克风等获取个人信息的设备权限，但您有权拒绝或取消授权。\n3.我们会采取业界先进的安全措施，尽全力保护您的信息安全。\n4.未经您同意，我们不会向第三方共享或提供您的任何个人信息。\n5.您可以查询、更正您的个人信息，我们也提供账号注销的渠道。\n点击“同意”按钮代表你已阅读并同意上述协议。',
                          style: TextStyle(color: Colours.grey_color)),
                    ])
                  ])),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: CommonButton(
                      onPressed: () {
                        Get.back(result: false);
                      },
                      text: '不同意',
                      radius: 8,
                      minHeight: 44,
                      foregroundColor: Colours.grey_color,
                      backgroundColor: Colours.greyF2,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    fit: FlexFit.tight,
                    child: CommonButton(
                      onPressed: () {
                        SpUtils.sp.setBool(Constant.agreePrivacy, true);
                        Get.back(result: true);
                      },
                      text: '同意',
                      minHeight: 44,
                      // minWidth: double.infinity,
                      radius: 8,
                      foregroundColor: Colours.white,
                      backgroundColor: Colours.main_color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrivacyAgreeView1 extends StatelessWidget {
  // final VoidCallback? onAgree;
  const PrivacyAgreeView1({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colours.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          width: 280,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('温馨提示',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: SingleChildScrollView(
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(children: [
                      const TextSpan(
                          text: '您需同意个人信息保护指引后我们才能继续为你提供完整服务。红球会会严格遵守',
                          style: TextStyle(color: Colours.grey_color)),
                      TextSpan(
                          text: '《用户协议》',
                          style: const TextStyle(color: Colours.main_color),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.toNamed(Routes.webview,
                                  arguments: const WebPara(
                                      "用户协议", Constant.serviceAgreementUrl,
                                      longpress: true));
                            }),
                      const TextSpan(
                          text: '与',
                          style: TextStyle(color: Colours.grey_color)),
                      TextSpan(
                          text: '《隐私政策》',
                          style: const TextStyle(color: Colours.main_color),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.toNamed(Routes.webview,
                                  arguments: const WebPara(
                                      "隐私政策", Constant.privacyPolicyUrl,
                                      longpress: true));
                            }),
                      const TextSpan(
                          text: '来收集和使用信息，并保障您的个人信息安全。',
                          style: TextStyle(color: Colours.grey_color)),
                    ])
                  ])),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: CommonButton(
                      onPressed: () {
                        exit(0);
                      },
                      text: '退出App',
                      radius: 8,
                      minHeight: 44,
                      foregroundColor: Colours.grey_color,
                      backgroundColor: Colours.greyF2,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    fit: FlexFit.tight,
                    child: CommonButton(
                      onPressed: () {
                        SpUtils.sp.setBool(Constant.agreePrivacy, true);
                        Get.back();
                      },
                      text: '同意',
                      minHeight: 44,
                      // minWidth: double.infinity,
                      radius: 8,
                      foregroundColor: Colours.white,
                      backgroundColor: Colours.main_color,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
