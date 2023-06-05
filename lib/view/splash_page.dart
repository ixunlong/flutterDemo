import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sports/http/api.dart';
import 'package:sports/http/request_interceptor.dart';
import 'package:sports/logic/service/push_service.dart';
import 'package:sports/logic/service/resource_service.dart';
import 'package:sports/logic/service/third_login_service.dart';
import 'package:sports/logic/service/um_service.dart';
import 'package:sports/model/home/lbt_entiry.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/h5_page.dart';
import 'package:sports/view/navigation_page.dart';
import 'package:sports/view/other/privacy_agree_view.dart';
import 'package:sports/widgets/update_check_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final umService = Get.find<UmService>();
  final pushService = Get.find<PushService>();
  final thirdService = Get.find<ThirdLoginService>();
  final resource = Get.find<ResourceService>();
  StreamSubscription? pushSub;
  Timer? _timer;
  int? currentTime;
  LbtEntity? data;
  bool hasPushData = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (SpUtils.agreePrivacy != true) {
        final result = await Get.dialog(const PrivacyAgreeView(),
            barrierDismissible: false);
        if (result == false) {
          await Get.dialog(const PrivacyAgreeView1(),
              barrierDismissible: false);
        }
      }

      await HeaderDeviceInfo.init();
      umService.initUm();
      thirdService.initThird();
      pushSub = pushService.dataStream.listen((event) {
        hasPushData = true;
        onTapPush(event);
      });
      await pushService.initPush();
      await resource.getAppStart();

      data = resource.appLaunch;
      // int delay = 500;
      if (data != null) {
        int second = int.parse(data!.content!);
        currentTime = second;
        update();
        _startCount();
        // delay = (second * 1000).toInt();
      } else {
        Future.delayed(Duration(milliseconds: 500)).then((value) {
          doJump();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    pushSub?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  void _startCount() {
    // currentTime = 60;
    // _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentTime == 0) {
        doJump();
      } else {
        currentTime = currentTime! - 1;
      }
      update();
    });
  }

  doJump({bool tapImage = false}) {
    // Get.offNamed(Routes.navigation);
    if ((data == null || data?.href == null || data!.href!.length == 0) &&
        tapImage) {
      return;
    }
    _timer?.cancel();
    if (resource.starth5 == null) {
      toHomePage(tapImage ? data : null);
    } else {
      if (resource.starth5?.content.valuable == true) {
        Map<String, dynamic> json = jsonDecode(resource.starth5?.content ?? '');
        if (json['inApp'] == 1) {
          Get.off(H5Page(resource.starth5?.href ?? ''));
        } else {
          launchUrlString(resource.starth5?.href ?? '',
              mode: LaunchMode.externalApplication,
              webViewConfiguration: WebViewConfiguration(
                  headers: {'Authorization': User.auth?.token ?? ''}));
          // Get.off(() => NavigationPage(),
          //     routeName: Routes.navigation,
          //     transition: Transition.noTransition,
          //     arguments: tapImage ? launchData : null);
          toHomePage(tapImage ? data : null);
        }
      }
    }
  }

  toHomePage(dynamic arguments) {
    Get.off(() => const NavigationPage(),
        routeName: Routes.navigation,
        transition: Transition.noTransition,
        arguments: arguments);
    // Get.off(NavigationPage(),
    //     routeName: Routes.navigation,
    //     transition: Transition.noTransition,
    //     arguments: tapImage ? data : null);
  }

  onTapPush(Map<String, dynamic> data) {
    _timer?.cancel();
    Get.off(() => NavigationPage(),
        routeName: Routes.navigation,
        transition: Transition.noTransition,
        arguments: data);
    // if (SpUtils.loginAuth != null) {
    //   User.fetchUserInfos();
    //   User.fetchConfig();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colours.white,
          child: Column(
            children: [
              Expanded(
                  child: (data == null || hasPushData)
                      ? Container()
                      // Image.asset(
                      //     Utils.getImgPath('launch_middle.png'),
                      //     width: double.infinity,
                      //     fit: BoxFit.cover,
                      //   )
                      : GestureDetector(
                          onTap: () => doJump(tapImage: true),
                          child: CachedNetworkImage(
                            imageUrl: data!.imgUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (context, url) => Container(),
                          ),
                        )),
              Image.asset(
                Utils.getImgPath('launch_bottom.png'),
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            ],
          ),
        ),
        Visibility(
            visible: currentTime != null && !hasPushData,
            child: Positioned(top: 30, right: 20, child: count()))
      ],
    );
  }

  Widget count() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        doJump();
      },
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              color: Colours.black60,
              borderRadius: BorderRadius.all(Radius.circular(14))),
          width: 70,
          height: 28,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              width: 8,
              child: Text(
                '${currentTime}',
                style: TextStyle(color: Colours.white, fontSize: 12),
              ),
            ),
            Text(
              's',
              style: TextStyle(color: Colours.white, fontSize: 12),
            ),
            SizedBox(width: 4),
            Text(
              '|',
              style: TextStyle(color: Colours.blackdd, fontSize: 12),
            ),
            SizedBox(width: 4),
            Text(
              '跳过',
              style: TextStyle(color: Colours.white, fontSize: 12),
            )
          ]),
        ),
      ),
    );
  }
}
