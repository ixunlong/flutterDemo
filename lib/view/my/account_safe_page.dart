import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sports/logic/login/login_logic.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import '../../res/styles.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/common_dialog.dart';

class AccountSafePage extends StatefulWidget {
  const AccountSafePage({super.key});

  @override
  State<AccountSafePage> createState() => _AccountSafePageState();
}

class _AccountSafePageState extends State<AccountSafePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.appBar(
        title: Text('账号与安全'),
      ),
      backgroundColor: Colours.scaffoldBg,
      body: Column(children: [
        // if (User.auth?.type == 0) ...[
        const SizedBox(height: 10),
        Container(
          color: Colours.white,
          child: Column(children: [
            _cell(
                '手机号',
                User.auth?.type == 0
                    ? '绑定手机号'
                    : User.info!.phone!.substring(0, 3) +
                        '****' +
                        User.info!.phone!.substring(7),
                arrow: User.auth?.type == 0 ? true : false, onTap: () async {
              if (User.auth?.type == 0) {
                await Get.toNamed(Routes.login, arguments: LoginType.bind);
                update();
              }
            }),
            // const Divider(
            //   height: 0.5,
            //   indent: 16,
            //   color: Color(0xffeeeeee),
            // ),
            // _cell(
            //   '实名认证',
            //   User.isPersonVerified ? '已认证' : '未认证',
            //   onTap: () {
            //     Get.toNamed(Routes.accountVerify);
            //   },
            // ),
            // const Divider(
            //   height: 0.5,
            //   indent: 16,
            //   color: Color(0xffeeeeee),
            // ),
            // // ],
            // _cell(
            //   '账号关联',
            //   '使用第三方帐号快速登录',
            //   onTap: () {
            //     Get.toNamed(Routes.accountBind);
            //   },
            // ),
          ]),
        ),
        const SizedBox(height: 10),
        _cell(
          '账号注销',
          '',
          onTap: () => _onCancelAccount(),
        )
      ]),
    );
  }

  _cell(String title, String? desc,
      {void Function()? onTap, bool arrow = true}) {
    final c = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      height: 52,
      child: Row(
        children: [
          Text(title,
              style: const TextStyle(color: Color(0xFF292D32), fontSize: 16)),
          const Spacer(),
          Text(desc ?? "",
              style: const TextStyle(fontSize: 14, color: Colours.grey_color1)),
          if (arrow) ...[
            const SizedBox(width: 10),
            Image.asset(Utils.getImgPath("arrow_right.png"))
          ]
        ],
      ),
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: c,
    );
  }

  _onCancelAccount() async {
    final flag = await Get.dialog(CommonDialog.alert(
      '您确定注销账号吗？',
      content: '注销账号后个人数据将会被全部删除，请问您确认注销账号吗？',
    ));
    if (flag) {
      if (await User.cancelAccount()) {
        Get.close(2);
      }
    }
  }
}
