import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';

class LbtEntity {
  int? id;
  String? classId;
  String? title;
  String? content;
  String? href;
  String? imgUrl;
  int? needLogin;
  String? button;
  String? extInfo;
  int? sort;

  LbtEntity(
      {this.id,
      this.classId,
      this.title,
      this.content,
      this.href,
      this.imgUrl,
      this.needLogin,
      this.button,
      this.extInfo,
      this.sort});

  LbtEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classId = json['classId'];
    title = json['title'];
    content = json['content'];
    href = json['href'];
    imgUrl = json['imgUrl'];
    needLogin = json['needLogin'];
    button = json['button'];
    extInfo = json['extInfo'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['classId'] = this.classId;
    data['title'] = this.title;
    data['content'] = this.content;
    data['href'] = this.href;
    data['imgUrl'] = this.imgUrl;
    data['needLogin'] = this.needLogin;
    data['button'] = this.button;
    data['extInfo'] = this.extInfo;
    data['sort'] = this.sort;
    return data;
  }
}

extension LbtEntityEx1 on LbtEntity {
  doJump() async {
    if (href?.isEmpty ?? true) {
      return;
    }
    final ref = href!;

    if ((needLogin ?? 0) > 0) {
      await User.needLogin(() async {});
      if (!User.isLogin) {
        return;
      }
    }

    Utils.doRoute(ref);

    // if (RegExp("^http[s]?://").hasMatch(ref)) {
    //   Get.toNamed(Routes.webview, arguments: {"url": ref});
    //   return;
    // }
    // log("do jump setp 2");
    // _jsonJump(ref);
  }

  String _resolvePath(String path, {String? subpath}) {
    return path;
  }

  _jsonJump(String source) {
    try {
      final map = jsonDecode(source);
      final String path = map['path']! as String;
      final String? subpath = map['subpath'];
      final arguments = map['arguments'];
      final parameters = map['parameters'];
      Get.toNamed(_resolvePath(path, subpath: subpath), arguments: arguments, parameters: parameters);
    } catch (err) {
      log("json jump err ${err}");
    }
  }
}
