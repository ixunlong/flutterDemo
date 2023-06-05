import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sports/http/api.dart';
import 'package:sports/http/dio_utils.dart';
import 'package:sports/http/request_interceptor.dart';
import 'package:sports/logic/login/login_logic.dart';
import 'package:sports/model/app_update_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/app_config.dart';
import 'package:sports/util/lbt_dialog.dart';
import 'package:sports/util/local_settings.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/my/about_us_page.dart';
import 'package:sports/widgets/common_bottomsheet.dart';
import 'package:sports/widgets/common_dialog.dart';
import 'package:sports/widgets/down_dialog.dart';
import 'package:sports/widgets/share_bottom_sheet.dart';
import 'package:sports/widgets/update_check_widget.dart';
import 'package:tencent_kit/tencent_kit_platform_interface.dart';
import 'package:wechat_kit/wechat_kit_platform_interface.dart';
// import 'package:weibo_kit/weibo_kit_platform_interface.dart';

import '../../res/styles.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  PackageInfo? pinfo;
  String version = "";
  bool waiting = false;
  AppUpdateEntity? updateinfo;

  checkUpdate() async {
    updateinfo = await Api.checkUpdate(version);
    update();
  }

  String updateDesc() {
    if ((updateinfo?.needUpdate ?? 0) > 0) {
      return "发现最新版本${updateinfo?.latestVersion}";
    }
    return "当前版本$version";
  }

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((value) {
      pinfo = value;
      version = value.version;
      checkUpdate();
      update();
    });
  }

  _onCancelAccount() async {
    final flag = await Get.dialog(CommonDialog.alert(
      '您确定注销账号吗？',
      content: '注销账号后个人数据将会被全部删除，请问您确认注销账号吗？',
    ));
    if (flag) {
      if (await User.cancelAccount()) {
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      appBar: Styles.appBar(
        backgroundColor: Colors.white,
        title: Text("设置", style: TextStyle(color: Colors.black)),
        actions: [
          if (AppConfig.config.isDebug)
            IconButton(
                onPressed: () {
                  Get.bottomSheet(_baseUrlSetSheet());
                },
                icon: Icon(Icons.settings))
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            // color: Colors.white,
            child: Column(
              children: [
                _cell("账号与安全", "", onTap: () {
                  User.needLogin(() => Get.toNamed(Routes.accountSafe));
                }),
                // const Divider(height: 0.5, indent: 16),
                const SizedBox(height: 10),
                if (Platform.isAndroid)
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 51,
                            ),
                            Text("WLAN环境自动下载新版本"),
                            Spacer(),
                            CupertinoSwitch(
                                activeColor: Colours.main_color,
                                value: LocalSettings.wlanDown,
                                onChanged: (b) {
                                  LocalSettings.wlanDown = b;
                                  LocalSettings.save();
                                  if (b) {
                                    DownFileInfo.last?.runWlanDownTask();
                                  } else {
                                    DownFileInfo.last?.cancelWlanDownTask();
                                  }
                                  update();
                                })
                          ],
                        ),
                        const Divider(
                            height: 0.5, color: Color(0xffeeeeee), indent: 16)
                      ],
                    ),
                  ),
                // const Divider(height: 0.5, indent: 16),
                _cell("检查更新", updateDesc(), onTap: () async {
                  if (waiting) {
                    return;
                  }
                  waiting = true;
                  await UpdateCheckDialog.checkUpdate(
                      noignre: true, alert: true);
                  waiting = false;
                }),
                const SizedBox(height: 10),
                Container(
                  color: Colours.white,
                  child: Column(children: [
                    _cell("关于我们", "", onTap: () {
                      Get.toNamed(Routes.myAboutus);
                    }),
                  ]),
                )
                // const SizedBox(height: 10),
              ],
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              if (User.auth?.type == 0) {
                final value = await Get.dialog(CommonDialog.select(
                    '游客账号退出提醒', '去绑定', '确认退出',
                    content: '退出登录后，您在游客状态下获得和购买的红钻可能会丢失，建议您先绑定手机号。',
                    cancelText: '暂不退出'));
                if (value == 0) {
                  await Get.toNamed(Routes.login, arguments: LoginType.bind);
                  update();
                } else if (value == 1) {
                  await User.doLogout();
                  update();
                  Get.back();
                }
              } else {
                final value = await Utils.alertQuery("确定退出吗？") ?? false;
                if (value) {
                  await User.doLogout();
                  Get.back();
                  update();
                  Get.back();
                }
              }
            },
            child: Container(
                alignment: Alignment.center,
                color: Colors.white,
                height: User.isLogin ? 52 : 0,
                child: const Text("退出登录",
                    style: TextStyle(color: Colors.black, fontSize: 16))),
          )
        ],
      ),
    );
  }

  _cell(String title, String? desc, {void Function()? onTap}) {
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
              style: const TextStyle(fontSize: 15, color: Color(0xff666666))),
          const SizedBox(width: 10),
          Image.asset(Utils.getImgPath("arrow_right.png"))
        ],
      ),
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: c,
    );
  }

  Widget _baseUrlSetSheet() {
    final list = [
      ["开发 : ", Constant.devBaseUrl],
      ["测试 : ", Constant.testBaseUrl],
      ["生产 : ", Constant.prodBaseUrl]
    ];

    final cur = DioUtils.baseUrl;
    final stored = SpUtils.baseUrl;

    // ignore: prefer_function_declarations_over_variables
    final btn = (List<String> l, FutureOr Function()? click) {
      bool isCur = cur == l[1];
      bool isCheck = stored == l[1];
      return Container(
        height: 44,
        child: Row(
          children: [
            Text(l[0]),
            Text(l[1], style: TextStyle(color: isCur ? Colors.red : null)),
            Spacer(),
            if (isCheck) Icon(Icons.check, size: 16)
          ],
        ),
      ).tap(click);
    };

    return CommonBottomSheet(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text("token").marginOnly(right: 10),
            Expanded(child: Text(User.auth?.token ?? "", maxLines: 3)),
            const Icon(Icons.copy)
                .paddingSymmetric(horizontal: 10, vertical: 8)
                .tap(() async {
              if (await Utils.alertQuery("复制token?") ?? false) {
                Clipboard.setData(ClipboardData(text: User.auth?.token ?? ""))
                    .then((value) => ToastUtils.show("已复制"));
              }
            })
          ],
        ),
        Row(
          children: [
            Text("更换baseUrl ${pinfo?.version ?? ""}(${pinfo?.buildNumber ?? ""})",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500))
                .marginSymmetric(vertical: 10),
            Spacer(),
            IconButton(
                onPressed: () {
                  ToastUtils.showDismiss(HeaderDeviceInfo.descrption, 10);
                },
                icon: Icon(Icons.info)),
            IconButton(
                onPressed: () async {
                  // ToastUtils.showDismiss(HeaderDeviceInfo.descrption, 10);
                  final b = await Utils.alertQuery("清除一些缓存") ?? false;
                  if (b) {
                    SpUtils.gift4newuser = {};
                    SpUtils.notifySetted = false;
                    SpUtils.lbtDialogIds = null;
                    LbtDialogUtil.showedLbts = [];
                  }
                },
                icon: Icon(Icons.delete)),
          ],
        ),
        ...list.map((e) => btn(e, (() {
              Utils.alertQuery("更换base url ${e[1]}\n需要重启生效").then((value) {
                if (value ?? false) {
                  SpUtils.baseUrl = e[1];
                  Get.back();
                }
              });
            }))),
        SizedBox(height: 80)
      ],
    ));
  }
}
