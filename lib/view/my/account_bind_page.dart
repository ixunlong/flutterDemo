import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sports/http/api.dart';
import '../../res/styles.dart';
import 'package:sports/logic/login/login_logic.dart';
import 'package:sports/logic/service/third_login_service.dart';
import 'package:sports/model/third_auth_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:tencent_kit/tencent_kit.dart' as qq;
import 'package:wechat_kit/wechat_kit_platform_interface.dart' as wx;
// import 'package:weibo_kit/weibo_kit.dart' as wb;

class AccountBindPage extends StatefulWidget {
  const AccountBindPage({super.key});

  @override
  State<AccountBindPage> createState() => _AccountBindPageState();
}

class _AccountBindPageState extends State<AccountBindPage> {
  late final StreamSubscription<wx.BaseResp> _wechatListener;
  late final StreamSubscription<qq.BaseResp> _qqListener;
  // late final StreamSubscription<wb.BaseResp> _wbListener;
  final thirdLoginService = Get.find<ThirdLoginService>();
  bool wxBind = false;
  bool wbBind = false;
  bool qqBind = false;
  bool appleBind = false;
  List<ThirdAuthEntity> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getData();
    });
    _wechatListener =
        wx.WechatKitPlatform.instance.respStream().listen((event) {
      log('$event');
      if (event is wx.AuthResp) {
        wx.AuthResp auth = event;
        if (auth.errorCode == 0) {
          thirdBind(wxCode: auth.code);
        }
      }
    });
    _qqListener = qq.Tencent.instance.respStream().listen((event) {
      log('$event');
      if (event is qq.LoginResp) {
        qq.LoginResp auth = event;
        if (auth.ret == 0) {
          thirdBind(qqAccessToken: auth.accessToken, qqOpenid: auth.openid);
        }
      }
    });
    // _wbListener = wb.Weibo.instance.respStream().listen((event) {
    //   log('$event');
    //   if (event is wb.AuthResp) {
    //     wb.AuthResp auth = event;
    //     if (auth.errorCode == 0) {
    //       thirdBind(wbAccessToken: auth.accessToken, wbUid: auth.userId);
    //     }
    //   }
    // });
  }

  @override
  void dispose() {
    _wechatListener.cancel();
    _qqListener.cancel();
    // _wbListener.cancel();
    super.dispose();
  }

  getData() async {
    List<ThirdAuthEntity>? result = await Api.getAuthList();
    if (result != null) {
      list = result;
      bool wxBind1 = false;
      bool wbBind1 = false;
      bool qqBind1 = false;
      bool appleBind1 = false;
      for (ThirdAuthEntity data in result) {
        if (data.type == 1) {
          wxBind1 = true;
        } else if (data.type == 2) {
          wbBind1 = true;
        } else if (data.type == 3) {
          qqBind1 = true;
        } else if (data.type == 4) {
          appleBind1 = true;
        }
      }
      wxBind = wxBind1;
      wbBind = wbBind1;
      qqBind = qqBind1;
      appleBind = appleBind1;
    }
    update();
  }

  unbind(int type) async {
    int? result = await Api.thirdUnbind(type);
    if (result == 200) {
      getData();
    }
  }

  thirdBind(
      {String? qqAccessToken,
      String? qqOpenid,
      String? wbAccessToken,
      String? wbUid,
      String? iosIdentityToken,
      String? wxCode}) async {
    final result = await Api.thirdBind(
        qqAccessToken: qqAccessToken,
        qqOpenid: qqOpenid,
        wbAccessToken: wbAccessToken,
        wbUid: wbUid,
        iosIdentityToken: iosIdentityToken,
        wxCode: wxCode);
    if (result == 200) {
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.appBar(
        title: Text('账号关联'),
      ),
      backgroundColor: Colours.scaffoldBg,
      body: Column(children: [
        // if (Platform.isIOS) ...[
        const SizedBox(height: 10),
        _cell(
          wxBind ? '解绑微信账号' : '绑定微信账号',
          wxBind
              ? list.where((element) => element.type == 1).first.name
              : '未绑定',
          onTap: () async {
            if (wxBind) {
              final result = await Utils.alertQuery('确定要解除绑定吗？');
              if (result == true) {
                unbind(1);
              }
            } else {
              thirdLoginService.onWechatLogin();
            }
          },
        ),
        const Divider(height: 0.5, indent: 16, color: Color(0xffeeeeee)),
        // ],
        _cell(
            wbBind ? '解绑微博账号' : '绑定微博账号',
            wbBind
                ? list.where((element) => element.type == 2).first.name
                : '未绑定', onTap: () async {
          if (wbBind) {
            final result = await Utils.alertQuery('确定要解除绑定吗？');
            if (result == true) {
              unbind(2);
            }
          } else {
            // thirdLoginService.onWeiboLogin();
          }
        }),
        const Divider(height: 0.5, indent: 16, color: Color(0xffeeeeee)),
        _cell(
            qqBind ? '解绑QQ账号' : '绑定QQ账号',
            qqBind
                ? list.where((element) => element.type == 3).first.name
                : '未绑定', onTap: () async {
          if (qqBind) {
            final result = await Utils.alertQuery('确定要解除绑定吗？');
            if (result == true) {
              unbind(3);
            }
          } else {
            thirdLoginService.onQQLogin();
          }
        }),
        if (Platform.isIOS) ...[
          const Divider(height: 0.5, indent: 16, color: Color(0xffeeeeee)),
          _cell(appleBind ? '解绑Apple ID' : '绑定Apple ID',
              appleBind ? '已绑定' : '未绑定', onTap: () async {
            if (appleBind) {
              final result = await Utils.alertQuery('确定要解除绑定吗？');
              if (result == true) {
                unbind(4);
              }
            } else {
              AuthorizationCredentialAppleID auth =
                  await thirdLoginService.onAppleLogin();
              thirdBind(iosIdentityToken: auth.identityToken);
            }
          })
        ]
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
}
