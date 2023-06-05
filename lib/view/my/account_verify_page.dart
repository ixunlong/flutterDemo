import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sports/http/api.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/regex.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

enum _VerifyState { not, process, done }

class AccountVerifyPage extends StatefulWidget {
  const AccountVerifyPage({super.key});

  @override
  State<AccountVerifyPage> createState() => _AccountVerifyPageState();
}

class _AccountVerifyPageState extends State<AccountVerifyPage> {

  bool get verified => false;

  final tname = TextEditingController();
  final tID = TextEditingController();
  final tcode = TextEditingController();
  
  String phone = User.info?.phone ?? "";
  String? name = User.info?.realName;
  // ignore: non_constant_identifier_names
  String? ID = User.info?.cardId;

  _VerifyState get state => User.isPersonVerified ? _VerifyState.done : _VerifyState.not;

  Widget _makeInput(String hint,{TextEditingController? tec}) => TextFormField(
    controller: tec,
    onChanged: (value) {
      checkValid();  
    },
    decoration: InputDecoration(border: InputBorder.none,hintText: hint,hintStyle: const TextStyle(fontSize: 14,color: Colours.grey99)),
  );

  Widget get inputName => _makeInput("请输入姓名",tec: tname);
  Widget get inputID => _makeInput("请输入身份证",tec: tID);
  Widget get inputCode => _makeInput("请输入验证码",tec: tcode);

  static DateTime smsTime = DateTime.fromMicrosecondsSinceEpoch(0);
  Timer? t;
  int get smsSecond => DateTime.now().difference(smsTime).inSeconds;

  bool valid = false;
  checkValid() {
    final idno = RegExp(r'^[1-9]\d{5}(18|19|20)\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$');
    valid = idno.hasMatch(tID.text) && tname.text.isNotEmpty;
    update();
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }
  @override
  void initState() {
    User.fetchUserInfos();
    t = Timer.periodic(const Duration(seconds: 1), (timer) { 
      if (DateTime.now().difference(smsTime).inSeconds < 120) {
        update();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Widget body;
    switch (state) {
      case _VerifyState.not:
        body = _verifyColumn();
        break;
      default:
      body = _stateColumn(state);
    }

    return Scaffold(
      appBar: Styles.appBar(title: const Text("实名认证")),
      backgroundColor: Colours.scaffoldBg,
      body: body.tap(() { 
        FocusScope.of(context).unfocus();
      }),
    );
  }

  Widget _stateColumn(_VerifyState state) => Column(
    children: [
      Container(
        height: 194,
        color: Colors.white,
        alignment: Alignment.center,
        child: DefaultTextStyle(
          style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colours.text_color1),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Container(
                height: 52,
                width: 52,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colours.main
                ),
                child: const Icon(Icons.done_sharp,color: Colours.white,size: 36)
              ),
              const SizedBox(height: 20,),
              if (state == _VerifyState.done)
              const Text("已完成实名认证"),
              if (state == _VerifyState.process)
              const Text("审核中")
            ]),
        ),
      ),
      const SizedBox(height: 10),
      _whiteBox(Column(children: [
        _cell("姓名", tail: Text(name ?? "")),
        _divider(),
        _cell("身份证号", tail: Text(ID ?? "")),
      ],))
    ],
  );

  Widget _verifyColumn() {
    return Column(
      children: [
        const SizedBox(height: 10),
        _whiteBox(Column(children: [
          _cell("姓名", tail: inputName),
          const Divider(indent: 16,height: 0.5,color: Colours.greyEE),
          _cell("身份证", tail: inputID),
        ],)),
        const SizedBox(height: 10),
        _whiteBox(Column(children: [
          _cell("手机号", tail: Row(
            children: [
              Text('${phone.characters.take(3)}*****${phone.characters.takeLast(4)}'),
              const Spacer(),
              Container(
                width: 81,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: const Color(0xFFFFECEE),
                  border: Border.all(color: Colours.main)
                ),
                child: Text( smsSecond >= 60 ? '获取验证吗' : "${60 - smsSecond}秒后",style: const TextStyle(color: Colours.main,fontSize: 13)),
              ).tap(() {
                if (smsSecond < 60) { return; }
                Api.sendSmsCode(phone, 3).then((value) {
                  smsTime = DateTime.now();
                });
              })
            ],
          )),
          const Divider(indent: 16,height: 0.5,color: Colours.greyEE),
          _cell("验证码", tail: inputCode),
        ],)),
        const SizedBox(height: 50),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 44,
          decoration: BoxDecoration(
            color: valid ? Colours.main : Colours.main.withOpacity(0.5),
            borderRadius: BorderRadius.circular(2)
          ),
          alignment: Alignment.center,
          child: const Text("确认",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),
        ).tap(() {
          Api.authCheckName(tID.text, tname.text, tcode.text).then((value) async {
            if (value.data['d']) {
              await Future.delayed(const Duration(milliseconds: 100));
              User.fetchUserInfos().then((value) {
                name = User.info?.realName ?? tname.text;
                ID = User.info?.cardId ?? tID.text;
                update();
              });
            } else {
              Utils.alertQuery('信息填写有误，请核对后重新提交');
            }
          });
        })
      ],
    );
  } 

  Widget _whiteBox(Widget child) => Container(
    color: Colors.white,
    child: child,
  );

  Widget _divider() => const Divider(indent: 16,height: 0.5,color: Colours.greyEE);

  Widget _cell(String title,{required Widget tail}) {
    return Container(
      height: 52,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(title).sized(width: 74),
          // tail
          Expanded(child: tail)
        ],
      ),
    );
  }
}