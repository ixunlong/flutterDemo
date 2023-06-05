import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/view/other/privacy_agree_view.dart';

class HomeLogic extends GetxController {
  // final MyRepository repository;
  // HomeController(this.repository);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    // showPrivacyDialog();
  }

  var count = 5.obs;

  void loadNew() {
    count.value = 5;
  }

  void loadMore() {
    count += 5;
  }
}
