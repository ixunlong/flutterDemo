import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:pinput/pinput.dart';
import 'package:sports/logic/login/login_logic.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/widgets/common_button.dart';
import 'package:sports/widgets/time_show_widget.dart';

import '../../res/styles.dart';

class LoginVerifyPage extends StatefulWidget {
  const LoginVerifyPage({super.key});

  @override
  State<LoginVerifyPage> createState() => _LoginVerifyPageState();
}

class _LoginVerifyPageState extends State<LoginVerifyPage> {
  final logic =
      Get.find<LoginLogic>(tag: Get.arguments == LoginType.bind ? '1' : '0');
  final _codeFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    log('${Get.arguments}');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).requestFocus(_codeFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.appBar(
        backgroundColor: Colours.transparent,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 10),
          const Text('输入验证码',
              style: TextStyle(
                color: Colours.text_color,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              )),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('验证码已发送：',
                  style: TextStyle(
                    color: Colours.text_color,
                    fontSize: 14,
                  )),
              Text(logic.phone!,
                  style: const TextStyle(
                    color: Colours.text_color,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  )),
            ],
          ),
          const SizedBox(height: 20),
          pinWidget(),
          // TimeShowWidget(time: 60);
          const SizedBox(height: 20),
          _countWidget()
        ]),
      )),
    );
    ;
  }

  Widget pinWidget() {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 50,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colours.text_color,
      ),
      decoration: BoxDecoration(
          border: Border.all(color: Colours.grey_color),
          borderRadius: BorderRadius.circular(4)),
    );
    final focosPinTheme = PinTheme(
      width: 60,
      height: 50,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colours.text_color,
      ),
      decoration: BoxDecoration(
          border: Border.all(color: Colours.main_color),
          borderRadius: BorderRadius.circular(4)),
    );
    final cursor = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 2,
          height: 20,
          decoration: const BoxDecoration(
            color: Colours.main_color,
            // borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
    return Pinput(
      focusNode: _codeFocus,
      length: 6,
      pinAnimationType: PinAnimationType.fade,
      // controller: controller,
      // focusNode: focusNode,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focosPinTheme,
      showCursor: true,
      cursor: cursor,
      onCompleted: (code) {
        logic.doLogin(code);
      },
      // preFilledWidget: preFilledWidget,
    );
  }

  Widget _countWidget() {
    return Obx(() => Center(
          child: CommonButton(
            onPressed: () {
              if (logic.currentTime.value == 0) {
                logic.resendSms();
              }
            },
            text: logic.currentTime.value == 0
                ? '重发验证码'
                : '重发验证码（${logic.currentTime}秒）',
            textStyle: TextStyle(fontWeight: FontWeight.w400),
            foregroundColor: logic.currentTime.value == 0
                ? Colours.main_color
                : Colours.grey_color1,
          ),
        ));
  }
}
