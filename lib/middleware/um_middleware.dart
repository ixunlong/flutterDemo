import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';
import 'package:sports/logic/service/um_service.dart';
import 'package:sports/res/routes.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class UmMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // const isLogin = false;
    // if (!isLogin) {
    //   return RouteSettings(name: Routes.login);
    // }
    return super.redirect(route);
  }

  // @override
  // Widget onPageBuilt(Widget page) {
  //   // TODO: implement onPageBuilt
  //   return super.onPageBuilt(page);
  // }
  String? route;

  @override
  GetPage? onPageCalled(GetPage? page) {
    route = page?.name;
    if (page != null) {
      UmengCommonSdk.onPageStart(page.name);
    }
    return super.onPageCalled(page);
  }

  @override
  void onPageDispose() {
    log('${Get.currentRoute}');
    if (Get.currentRoute == Routes.navigation) {
      Get.find<UmService>().payOriginRoute = '';
    }
    if (route != null) {
      UmengCommonSdk.onPageEnd(route!);
    }
  }
}
