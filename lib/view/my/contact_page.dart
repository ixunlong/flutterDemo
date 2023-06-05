import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_qiyu/flutter_qiyu.dart';
import 'package:get/instance_manager.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/home/lbt_entiry.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/util/online_contact.dart';
import 'package:sports/util/sp_utils.dart';
import '../../res/styles.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/right_arrow_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:get/get.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  String qq = "1246786881";
  String wx = "QXB_kefu";

  final imageNames = const {
    "qq": "my_con_qq.png",
    "wx": "my_con_wx.png",
    "mail": "my_con_mail.png",
    "online": "my_contact_online.png"
  };

  List<LbtEntity> btnRes = [
    LbtEntity(title: "qq", content: "1246786881", button: "QQ客服"),
    LbtEntity(title: "wx", content: "QXB_kefu", button: "微信客服"),
    LbtEntity(title: "mail", content: "", button: "邮箱客服")
  ];

  List<LbtEntity> tips = [
    LbtEntity(
        title: "tip",
        content: "1.您可复制上方微信号或QQ号添加红球会官方客服，与我们联系，也可通过微信在线客服与我们即时沟通。"),
    LbtEntity(title: "tip", content: "2.客服工作时间：工作日8:30至22:00，休息日10:00至18:00。")
  ];

  _solvAppContactRes(List<LbtEntity> res) {
    if (res.isEmpty) {
      return;
    }
    btnRes.clear();
    tips.clear();
    for (var element in res) {
      if (element.title == "tip") {
        tips.add(element);
      } else {
        btnRes.add(element);
      }
    }
    update();
  }

  _getContactInfo() async {
    final list = await Api.getAppList("app_res_contact") ?? [];
    _solvAppContactRes(list);
    _saveContactToSp();
    update();
  }

  _getContactFromSp() {
    try {
      final res = (SpUtils.appContact?["list"] as List)
          .map((e) => LbtEntity.fromJson(e))
          .toList();
      _solvAppContactRes(res);
    } catch (err) {}
  }

  _saveContactToSp() {
    SpUtils.appContact = {
      "list": (btnRes + tips).map((e) => e.toJson()).toList()
    };
  }

  unreadChange(int count) {
    update();
  }

  @override
  void initState() {
    super.initState();
    _getContactFromSp();
    _getContactInfo();
    // OnlineContact.instance.inChatWindow = true;
    // QiYu.registerListener(unreadChange);
  }

  @override
  void dispose() {
    // QiYu.unregisterListener(unreadChange);
    // OnlineContact.instance.inChatWindow = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: Styles.appBar(
        backgroundColor: Colors.white,
        // foregroundColor: Colors.black,
        title: const Text("联系客服", style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          // const SizedBox(height: 10),
          // GestureDetector(
          //     onTap: () {
          //       OnlineContact.instance.openServiceWindow();
          //     },
          //     behavior: HitTestBehavior.opaque,
          //     child: _cell(
          //         LbtEntity(
          //             title: "online",
          //             button: "在线客服",
          //             content: OnlineContact.instance.unreadCount == 0
          //                 ? "每天9:00~17:30"
          //                 : "${OnlineContact.instance.unreadCount}"),
          //         isCopy: false)),
          const SizedBox(height: 10),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                ...btnRes.map((e) {
                  final islast = btnRes.last == e;
                  return Column(
                    children: [
                      _cell(e),
                      if (!islast)
                        const Divider(
                            height: 0.5, color: Color(0xffeeeeee), indent: 16)
                    ],
                  );
                })
              ],
            ),
          ),
          const SizedBox(height: 10),
          ...tips.map(
            (e) => Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
              child: Text(
                e.content ?? "",
                style: const TextStyle(fontSize: 13, color: Color(0xFF999999)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _cell(LbtEntity entity, {bool isCopy = true}) {
    final title = entity.button ?? "";
    final sub = entity.content ?? "";
    return Container(
      height: 52,
      padding: const EdgeInsets.only(left: 16, right: 15),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            child: CachedNetworkImage(
              imageUrl: entity.imgUrl ?? "",
              placeholder: (context, url) => Image.asset(
                  Utils.getImgPath(imageNames[entity.title ?? ""] ?? "")),
              errorWidget: (context, url, error) => Image.asset(
                  Utils.getImgPath(imageNames[entity.title ?? ""] ?? "")),
            ),
          ).marginOnly(right: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          const Spacer(),
          Text(sub,
              style: const TextStyle(color: Color(0xFF666666), fontSize: 15)),
          const SizedBox(width: 10),
          isCopy
              ? GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: sub));
                    ToastUtils.show("已复制 $sub");
                  },
                  child: Image.asset(Utils.getImgPath("my_copy.png"),
                      width: 19, height: 19),
                )
              : Image.asset(Utils.getImgPath("arrow_right.png"))
        ],
      ),
    );
  }
}
