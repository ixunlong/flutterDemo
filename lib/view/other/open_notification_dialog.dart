import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/service/um_service.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/my/web_page.dart';
import 'package:sports/widgets/common_button.dart';

class OpenNotificationDialog extends StatelessWidget {
  // final VoidCallback? onAgree;
  const OpenNotificationDialog({super.key});

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
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          width: 280,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  GestureDetector(
                    child: Image.asset(
                      Utils.getImgPath('bottomsheet_close.png'),
                      width: 24,
                    ),
                    onTap: () {
                      Get.back();
                    },
                  ),
                ],
              ),
              Image.asset(
                Utils.getImgPath('open_notification.png'),
                width: 180,
                height: 132,
              ),
              const SizedBox(height: 18),
              const Text('打开推送消息',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
              const SizedBox(height: 8),
              const Text('及时获取专家的最新观点',
                  style: TextStyle(fontSize: 14, color: Colours.grey66)),
              const SizedBox(height: 20),
              CommonButton.large(
                onPressed: () {
                  AppSettings.openNotificationSettings();
                  Get.back();
                },
                text: '前往开启',
                minHeight: 44,
                // minWidth: double.infinity,
                radius: 4,
                foregroundColor: Colours.white,
                backgroundColor: Colours.main_color,
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
