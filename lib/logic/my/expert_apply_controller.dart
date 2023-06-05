import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports/http/api.dart';
import 'package:sports/http/dio_utils.dart';
import 'package:sports/model/expert/expert_apply_entity.dart';
import 'package:sports/model/image_upload_result_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/image_utils.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../res/colours.dart';

class ExpertApplyController extends GetxController {
  ExpertApplyEntity data = ExpertApplyEntity();
  final nickNameController = TextEditingController();
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final infoController = TextEditingController();
  final wxController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  // String? avatar;
  // String? idCardFront;
  // String? idCardback;
  List<String> otherImage = [];
  bool agree = false;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (Get.arguments != null) {
      data = Get.arguments;
      nickNameController.text = data.name ?? '';
      nameController.text = data.realName ?? '';
      idController.text = data.idCard ?? '';
      infoController.text = data.info ?? '';
      wxController.text = data.wechat ?? '';
      otherImage = data.otherPhoto!.split(',');
    }
  }

  @override
  void onReady() async {
    super.onReady();
    // await AssetPicker.permissionCheck();
  }

  ///1 2 3 足球 篮球 足球和篮球
  void onSelectType(int index) {
    if (data.status == 0) {
      return;
    }
    data.type = index;
    update();
  }

  ///type 0 1 2 3 头像 身份证正面 身份证反面 入驻证明
  void addPhotoFromCamera(int type) async {
    final image = await ImageUtils.pickPhotoFormCamera();
    if (image == null) {
      return;
    }
    String path = image.path;
    if (type == 0) {
      final cropPath = await ImageUtils.cropImage(image.path);
      if (cropPath == null) {
        return;
      }
      path = cropPath;
    }
    List<ImageUploadResultEntity>? result =
        await DioUtils.uploadImage([path], 'expert');
    if (result != null) {
      if (type == 0) {
        data.logo = result.first.url;
        // avatar = path;
      } else if (type == 1) {
        data.idCard1 = result.first.url;
        // idCardFront = path;
      } else if (type == 2) {
        data.idCard2 = result.first.url;
        // idCardback = path;
      } else {
        otherImage.add(path);
      }
    }
    update();
  }

  void addPhotoFromGallary(int type) async {
    final images =
        await ImageUtils.pickPhotoFormGallary(maxPhotos: type == 3 ? 6 : 1);
    if (images == null) {
      return;
    }
    List<File> files = [];
    for (var data in images) {
      File? file = await data.file;
      if (file != null) {
        files.add(file);
      }
    }
    if (type == 0) {
      final cropPath = await ImageUtils.cropImage(files.first.path);
      if (cropPath == null) {
        return;
      }
      files = [File(cropPath)];
    }
    List<ImageUploadResultEntity>? result =
        await DioUtils.uploadImage(files.map((e) => e.path).toList(), 'expert');
    if (result != null) {
      if (type == 0) {
        // final file = files.first;
        data.logo = result.first.url;
        // avatar = files.first.path;
      } else if (type == 1) {
        // final file = await images.first.file;
        data.idCard1 = result.first.url;
        // idCardFront = files.first.path;
      } else if (type == 2) {
        // final file = await images.first.file;
        data.idCard2 = result.first.url;
        // idCardback = files.first.path;
      } else {
        otherImage.addAll(result.map((e) => e.url!));
        // data.otherPhoto = result.map((e) => e.url).toList().join(',');
      }
      update();
    }
  }

  onAgree() {
    agree = !agree;
    update();
  }

  void onApply() async {
    if (data.logo == null) {
      ToastUtils.show('请添加头像');
      return;
    }
    if (nickNameController.text.isEmpty) {
      ToastUtils.show('请输入昵称');
      return;
    }
    if (nickNameController.text.length < 2 ||
        nickNameController.text.length > 6) {
      ToastUtils.show('请输入2-6字昵称');
      return;
    }
    if (data.type == null) {
      ToastUtils.show('请选择擅长领域');
      return;
    }
    if (infoController.text.isEmpty) {
      ToastUtils.show('请输入专家介绍');
      return;
    }
    if (nameController.text.isEmpty) {
      ToastUtils.show('请输入姓名');
      return;
    }
    if (idController.text.isEmpty) {
      ToastUtils.show('请输入身份证号');
      return;
    }
    if (idController.text.length != 18) {
      ToastUtils.show('请输入正确的身份证号');
      return;
    }
    if (data.idCard1 == null || data.idCard2 == null) {
      ToastUtils.show('请添加身份证照片');
      return;
    }
    if (otherImage.isEmpty) {
      ToastUtils.show('请添加证明截图');
      return;
    }
    if (wxController.text.isEmpty) {
      ToastUtils.show('请输入联系微信');
      return;
    }
    if (!agree) {
      ToastUtils.show('请同意《自媒体协议》');
      return;
    }
    data.name = nickNameController.text;
    data.info = infoController.text;
    data.realName = nameController.text;
    data.idCard = idController.text;
    data.userId = User.info!.id;
    data.otherPhoto = otherImage.join(',');
    data.wechat = wxController.text;
    final result = await Api.expertApply(data);
    if (result != null) {
      Get.offAndToNamed(Routes.expertApplySuccess, arguments: result);
    }

    // Get.offNamedUntil(
    //     Routes.expertApplySuccess,
    //     (route) =>
    //         (route as GetPageRoute).routeName == Routes.expertRequestType);
  }

  onDeleteImage(int index) {
    otherImage.removeAt(index);
    update();
  }
}
