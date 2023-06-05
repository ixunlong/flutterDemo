import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/my/web_page.dart';
import '../../res/styles.dart';
import 'package:sports/widgets/common_dialog.dart';
import 'package:sports/widgets/right_arrow_widget.dart';

class PrivacySettingPage extends StatelessWidget {
  const PrivacySettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.scaffoldBg,
      appBar: Styles.appBar(
        title: Text("隐私设置"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                _cell("隐私政策", "", onTap: () {
                  Get.to(() => WebPage(),
                      arguments:
                          WebPara("", Constant.privacyPolicyUrl, longpress: true));
                }),
                // Divider(height: 0.5,color: Color(0xffeeeeee),indent: 16,),
                // if (User.auth != null)
                //   _cell(
                //     "账号注销",
                //     "",
                //     onTap: () => _onCancelAccount(),
                //   )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _cell(String title, String? desc, {void Function()? onTap}) {
    final c = Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      height: 52,
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(color: Color(0xFF292D32), fontSize: 16),
          ),
          const Spacer(),
          Text(
            desc ?? "",
            style: TextStyle(fontSize: 15, color: Color(0xff666666)),
          ),
          const SizedBox( width: 10 ),
          Image.asset(Utils.getImgPath("arrow_right.png"))
        ],
      ),
    );
    return GestureDetector(
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
