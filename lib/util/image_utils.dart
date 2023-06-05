import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports/res/colours.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ImageUtils {
  static Future<String?> cropImage(String path) async {
    final croppedFile = await ImageCropper().cropImage(
      compressQuality: 50,
      sourcePath: path,
      aspectRatioPresets: Platform.isAndroid
          ? [CropAspectRatioPreset.square]
          : [CropAspectRatioPreset.square],
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: '裁剪',
            toolbarColor: Colours.main_color,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            hideBottomControls: true),
        IOSUiSettings(
            title: '',
            aspectRatioPickerButtonHidden: true,
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false)
      ],
    );
    return croppedFile?.path;
    // if (croppedFile != null) {
    //   imageFile = croppedFile;
    //   setState(() {
    //     state = AppState.cropped;
    //   });
    // }
  }

  static Future<XFile?> pickPhotoFormCamera({int imageQuality = 50}) async {
    return await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
  }

  static Future<List<AssetEntity>?> pickPhotoFormGallary(
      {int maxPhotos = 1}) async {
    return await AssetPicker.pickAssets(Get.context!,
        pickerConfig: AssetPickerConfig(
            maxAssets: maxPhotos,
            themeColor: Colours.main_color,
            requestType: RequestType.image,
            textDelegate: AssetPickerTextDelegate()));
  }
}
