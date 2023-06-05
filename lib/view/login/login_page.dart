import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sports/logic/login/login_logic.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/regex.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/my/web_page.dart';
import 'package:sports/widgets/common_button.dart';
import 'package:get/get.dart';
import 'package:wechat_kit/wechat_kit_platform_interface.dart';

import '../../res/colours.dart';
import '../../res/styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final logic =
      Get.put(LoginLogic(), tag: Get.arguments == LoginType.bind ? '1' : '0');
  final phoneController = TextEditingController();
  // final _agree = false;

  // bool authChecked = false;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Styles.appBar(
          backgroundColor: Colours.transparent,
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  const Text('欢迎来到红球会',
                      style: TextStyle(
                          color: Colours.text_color1,
                          fontSize: 24,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Text(
                      logic.type == LoginType.login
                          ? '未注册的手机号验证通过后将自动注册'
                          : '绑定手机号',
                      style:
                          TextStyle(color: Colours.grey_color, fontSize: 14)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow((RegExp(Regex.number)))
                    ],
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      fillColor: Colours.grey_color4,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide.none),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      hintText: "请输入您的手机号码",
                      hintStyle: TextStyle(fontSize: 14),
                      suffixIconConstraints:
                          BoxConstraints(minHeight: 20, minWidth: 20),
                      suffixIcon: phoneController.text.isEmpty
                          ? null
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  phoneController.text = '';
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Image.asset(
                                  Utils.getImgPath('close.png'),
                                  width: 16,
                                  height: 16,
                                  // fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            logic.agreeUserPrivacy();
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                            child: Obx(() => Icon(
                                  logic.authChecked.value
                                      ? Icons.check_circle_rounded
                                      : Icons.radio_button_off_sharp,
                                  color: logic.authChecked.value
                                      ? Colours.main_color
                                      : Colours.grey_color1,
                                  size: 14,
                                )),
                          )),
                      // SizedBox(width: 8),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(children: [
                          TextSpan(
                              text: '我已阅读并同意',
                              style: TextStyle(
                                  color: Colours.grey_color1, fontSize: 12)),
                          TextSpan(
                              text: '《服务协议》',
                              style: TextStyle(
                                  color: Colours.guestColorBlue, fontSize: 12),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.toNamed(Routes.webview,
                                      arguments: const WebPara(
                                          "", Constant.serviceAgreementUrl,
                                          longpress: true));
                                }),
                          TextSpan(
                              text: '和',
                              style: TextStyle(
                                  color: Colours.grey_color1, fontSize: 12)),
                          TextSpan(
                              text: '《隐私政策》',
                              style: TextStyle(
                                  color: Colours.guestColorBlue, fontSize: 12),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.toNamed(Routes.webview,
                                      arguments: const WebPara(
                                          "", Constant.privacyPolicyUrl,
                                          longpress: true));
                                })
                        ])
                      ])),
                    ],
                  ),
                  SizedBox(height: 20),
                  CommonButton.large(
                    onPressed: () {
                      if (phoneController.text.length == 11) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        logic.doSendSms(phoneController.text);
                      }
                    },
                    text: '下一步',
                    minHeight: 48,
                    minWidth: double.infinity,
                    foregroundColor: Colors.white,
                    backgroundColor: phoneController.text.length == 11
                        ? Colours.main_color
                        : Colours.grey_color5,
                    radius: 24,
                  ),
                  Spacer(),
                  // if (Get.arguments != LoginType.bind) ...[
                  //   Center(
                  //     child: Text(
                  //       '其他登录方式',
                  //       style:
                  //           TextStyle(fontSize: 14, color: Colours.grey_color1),
                  //     ),
                  //   ),
                  //   SizedBox(height: 24),
                  //   Center(
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         // if (Platform.isIOS) ...[
                  //         GestureDetector(
                  //           onTap: () => logic.onWechatLogin(),
                  //           child: Image.asset(
                  //             Utils.getImgPath('weixin.png'),
                  //             width: 40,
                  //           ),
                  //         ),
                  //         SizedBox(width: 22),
                  //         // ],
                  //         // GestureDetector(
                  //         //   onTap: () => logic.onWechatLogin(),
                  //         //   child: Image.asset(
                  //         //     Utils.getImgPath('weixin.png'),
                  //         //     width: 40,
                  //         //   ),
                  //         // ),
                  //         // SizedBox(width: 22),
                  //         GestureDetector(
                  //           onTap: () => logic.onQQLogin(),
                  //           child: Image.asset(
                  //             Utils.getImgPath('qq.png'),
                  //             width: 40,
                  //           ),
                  //         ),
                  //         SizedBox(width: 22),
                  //         GestureDetector(
                  //           // onTap: () => logic.onWeiboLogin(),
                  //           child: Image.asset(
                  //             Utils.getImgPath('weibo.png'),
                  //             width: 40,
                  //           ),
                  //         ),
                  //         if (Platform.isIOS) ...[
                  //           SizedBox(width: 22),
                  //           GestureDetector(
                  //             onTap: () => logic.onAppleLogin(),
                  //             child: Image.asset(
                  //               Utils.getImgPath('apple.png'),
                  //               width: 40,
                  //             ),
                  //           )
                  //         ]
                  //       ],
                  //     ),
                  //   ),
                  // SizedBox(height: 40),
                  // ]
                ],
              ),
            ),
          ),
        ));
  }
}
