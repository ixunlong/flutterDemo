import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:sports/http/api.dart';
import 'package:sports/http/dio_utils.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/common_button.dart';
import 'package:sports/widgets/verification_code_widget.dart';

class VerificationCodeView extends StatefulWidget {
  const VerificationCodeView({super.key});

  @override
  State<VerificationCodeView> createState() => _VerificationCodeViewState();
}

class _VerificationCodeViewState extends State<VerificationCodeView> {
  var _key = Utils.generateRandomString(20);
  final _controller = TextEditingController();
  bool showErrorMessage = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: 300,
        // height: 240,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            Center(
                child: Text(
              '安全验证',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            )),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        fillColor: Colours.grey_color4,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 2),
                        hintText: "请输入图中验证码",
                        hintStyle: const TextStyle(fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => refreshCode(),
                  child: Image.network(
                    '${DioUtils.baseUrl}/resource/app-do/kaptcha?key=$_key',
                    width: 89,
                    height: 43,
                  ),
                ),
                SizedBox(width: 16),
              ],
            ),
            SizedBox(height: 2),
            Row(
              children: [
                SizedBox(width: 16),
                Visibility(
                    visible: showErrorMessage,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Text(
                      '验证码错误',
                      style: TextStyle(color: Colours.main_color, fontSize: 12),
                    )),
                Spacer(),
                SizedBox(
                  height: 17,
                  // width: 40,
                  child: GestureDetector(
                    onTap: () {
                      refreshCode();
                    },
                    child: Text('换一张',
                        style:
                            TextStyle(fontSize: 12, color: Colours.grey_color)),
                    // text: '换一张',
                    // textStyle:
                    //     TextStyle(fontSize: 12, color: Colours.grey_color),
                  ),
                ),
                SizedBox(width: 16),
              ],
            ),

            // Align(
            //     alignment: Alignment.centerRight,
            //     child: SizedBox(
            //       height: 34,
            //       child: CommonButton(
            //         onPressed: () {
            //           refreshCode();
            //         },
            //         text: '换一张',
            //       ),
            //     )),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 0.5,
              color: Colours.grey_color2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: CommonButton(
                      onPressed: () => Get.back(),
                      text: '取消',
                      minHeight: 44,
                      textStyle: TextStyle(fontWeight: FontWeight.w500),
                      foregroundColor: Colours.grey_color),
                ),
                Container(
                  width: 0.5,
                  height: 44,
                  color: Colours.grey_color2,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: CommonButton(
                      onPressed: () => checkCode(),
                      text: '确定',
                      minHeight: 44,
                      textStyle: TextStyle(fontWeight: FontWeight.w500),
                      foregroundColor: Colours.main_color),
                ),
              ],
            )
            // CommonButton(
            //   onPressed: () => checkCode(),
            //   text: '确定',
            //   backgroundColor: Colours.main_color,
            //   foregroundColor: Colours.white,
            //   minWidth: double.infinity,
            //   radius: 5,
            // )
          ],
        ),
      ),
    );
  }

  void refreshCode() {
    setState(() {
      _key = Utils.generateRandomString(20);
    });
  }

  void checkCode() async {
    // dev.log(_controller.text);
    // print(_code.toString);
    if (_controller.text.isEmpty) {
      ToastUtils.show('请输入验证码');
    } else {
      final result = await Api.kaptchaValidate(_controller.text, _key);
      if (result == 200) {
        Get.back(result: true);
      } else {
        refreshCode();
        _controller.text = '';
        setState(() {
          showErrorMessage = true;
        });
      }
    }

    // if (_controller.text == _key.toString()) {
    //   Get.back(result: true);
    // } else {
    //   refreshCode();
    //   await Utils.alertQuery('验证码错误');
    // }
  }
}
