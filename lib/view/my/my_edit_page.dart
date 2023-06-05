import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports/http/api.dart';
import 'package:sports/http/dio_utils.dart';
import 'package:sports/model/image_upload_result_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/image_utils.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:get/get.dart';
import 'package:sports/view/my/change_nickname_page.dart';
import 'package:sports/widgets/select_bottomsheet.dart';

import '../../res/styles.dart';

class MyEditPage extends StatefulWidget {
  const MyEditPage({super.key});

  @override
  State<MyEditPage> createState() => _MyEditPageState();
}

class _MyEditPageState extends State<MyEditPage> {
  clickChangeAvater() async {
    Utils.onEvent('wode_pd_xgnc', params: {'wode_pd_xgnc': '1'});
    if (User.info!.avatarUpdateDays! > 0) {
      ToastUtils.show('${User.info!.avatarUpdateDays!}日后可以修改头像');
      return;
    }
    final r = await Get.bottomSheet(SelectBottomSheet(["拍照", "从手机相册选择"]));
    // await Get.bottomSheet(SelectBottomSheet(["拍照", "从手机相册选择", '选一张']));

    String? path;
    if (r == 0) {
      final file = await ImageUtils.pickPhotoFormCamera();
      path = file?.path;
    } else if (r == 1) {
      final files = await ImageUtils.pickPhotoFormGallary();
      if (files != null) {
        File? file = await files.first.file;
        path = file?.path;
      }
      // } else if (r == 2) {
      //   await Get.toNamed(Routes.systemAvatars);
      //   update();
    } else {
      return;
    }
    if (path == null) {
      return;
    }
    final croppedFile = await ImageUtils.cropImage(path);
    if (croppedFile == null) {
      return;
    }
    List<ImageUploadResultEntity>? result =
        await DioUtils.uploadImage([croppedFile], 'avatar');
    if (result != null) {
      int? code = await Api.avatarUpdate(result.first.url!);
      if (code != null && code == 200) {
        ToastUtils.show('修改头像成功!');
        await User.fetchUserInfos(fetchFocus: false);
        update();
      }
    }
    // log("croped = $croped");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.appBar(
        title: Text("编辑资料"),
      ),
      backgroundColor: Color(0xfff7f7f7),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            alignment: Alignment.center,
            height: 173.5,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffeeeeee), width: 0.5),
                      // borderRadius: BorderRadius.circular(40),
                      // boxShadow: [BoxShadow(color: Color(0xff999999),blurRadius: 8)],
                      shape: BoxShape.circle),
                  child: CachedNetworkImage(
                      imageUrl: User.info?.avatar ?? "",
                      errorWidget: (context, url, error) => Image.asset(
                          Utils.getImgPath("my_header.png"),
                          fit: BoxFit.fill),
                      placeholder: (context, url) => Image.asset(
                          Utils.getImgPath("my_header.png"),
                          fit: BoxFit.fill)),
                ).tap(clickChangeAvater),
                const SizedBox(
                  height: 14,
                ),
                Text(
                  (User.info?.avatarUpdateDays == 0 ||
                          User.info?.avatarUpdateDays == null)
                      ? "点击更换头像"
                      : "${User.info?.avatarUpdateDays}日后可以更换头像",
                  style: TextStyle(fontSize: 14),
                ).tap(clickChangeAvater)
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            color: Colors.white,
            height: 52,
            child: Row(
              children: [
                Text(
                  "用户昵称",
                  style: TextStyle(color: Colours.text_color1),
                ),
                Spacer(),
                Text(
                  User.info?.name ?? '',
                  style: TextStyle(color: Colours.grey666666),
                ),
                Image.asset(Utils.getImgPath("arrow_right.png"))
                    .marginOnly(left: 10)
              ],
            ),
          ).tap(() async {
            Utils.onEvent('wode_pd_xgnc', params: {'wode_pd_xgnc': '0'});
            await Get.to(ChangeNicknamePage());
            await User.fetchUserInfos(fetchFocus: false);
            update();
          })
        ],
      ),
    );
  }
}
