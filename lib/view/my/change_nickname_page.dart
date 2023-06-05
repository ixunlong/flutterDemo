import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import '../../res/styles.dart';

class ChangeNicknamePage extends StatefulWidget {
  const ChangeNicknamePage({super.key});

  @override
  State<ChangeNicknamePage> createState() => _ChangeNicknamePageState();
}

class _ChangeNicknamePageState extends State<ChangeNicknamePage> {
  final tc = TextEditingController();

  @override
  void dispose() {
    tc.dispose();
    super.dispose();
  }

  _clickChange() async {
    final name = tc.text.trim();
    FocusScope.of(context).unfocus();
    if (name.isEmpty) {
      Utils.alertQuery("请输入昵称");
      return;
    }
    final b = await User.nameUpdate(name) ?? false;
    // await Utils.alertQuery("修改昵称${(b) ? "成功" : "失败"}");
    if (b) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      appBar: Styles.appBar(
        title: Text("设置昵称", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            // height: 72,
            child: TextFormField(
              // maxLength: 12,
              controller: tc,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                  suffixIcon: tc.text.isEmpty
                      ? null
                      : GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            setState(() {
                              tc.text = "";
                            });
                          },
                          child: const SizedBox(
                              width: 30,
                              height: 30,
                              child: Icon(
                                Icons.cancel,
                                size: 18,
                                color: Colours.greyDDDDDD,
                              ))),
                  hintText: "请输入新的昵称",
                  hintStyle:
                      TextStyle(fontSize: 14, color: Colours.grey_color1)),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) {
                update();
              },
              validator: (String? value) {
                String? res;
                var reg = RegExp(r"[A-Za-z\d]");
                var reg1 = RegExp(r"[^a-zA-Z0-9\_\u4e00-\u9fa5]");
                var reg2 = RegExp(r"[\u4e00-\u9fa5]");
                if (value?.length == 0) {
                  res = "输入不能为空";
                } else {
                  if (reg1.hasMatch(value!)) {
                    res = "昵称仅包含中英文或数字";
                  } else {
                    if (reg.allMatches(value).length +
                            (reg2.allMatches(value).length) * 3 <=
                        18) {
                      res = null;
                    } else {
                      res = '不超过十二个字符';
                    }
                  }
                }
                return res;
              },
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.all(12),
            child: Text("请输入6个汉字或12个字符以内昵称，仅支持中文、英文、数字",
                style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
          ),
          // Container(child: Text("用户名已存在", style: TextStyle(color: Colors.red))),
          const SizedBox(height: 56),
          SizedBox(
            width: 184,
            height: 44,
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colours.main,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4))),
                onPressed: _clickChange,
                child: const Text("完成")),
          )
        ],
      ),
    );
  }
}
