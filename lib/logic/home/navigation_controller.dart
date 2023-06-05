import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:get/get.dart';
import 'package:sports/logic/expert/expert_page_controller.dart';
import 'package:sports/logic/match/match_page_controller.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/logic/service/push_service.dart';
import 'package:sports/logic/service/resource_service.dart';
import 'package:sports/model/home/lbt_entiry.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/data/data_page.dart';
import 'package:sports/view/expert/expert_page.dart';
import 'package:sports/view/home/home_page.dart';
import 'package:sports/view/match/match_page.dart';
import 'package:sports/view/my/my_page.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

class NavigationController extends GetxController
    with GetTickerProviderStateMixin {
  final List<Widget> pageList = [
    const ExpertPage(),
    const MatchPage(),
    const DataPage(),
    const MyPage(),
  ];

  final selectImage = [
    'tabicon_expert_select.png',
    'tabicon_match_select.png',
    'tabicon_data_select.png',
    'tabicon_my_select.png'
  ];
  final unselectArray = [
    'tabicon_expert_unselect.png',
    'tabicon_match_unselect.png',
    'tabicon_data_unselect.png',
    'tabicon_my_unselect.png'
  ];
  final selectArray = [
    'bottom_expert.gif',
    'bottom_match.gif',
    'bottom_data.gif',
    'bottom_my.gif'
  ];

  // late SVGAAnimationController animationController;
  final PageController pageController = PageController();
  List<FlutterGifController> gifC = [];
  late FlutterGifController refreshController;
  int currentIndex = 0;
  NavigationController();
  bool isMatchLoading = false;
  Timer? matchTimer;
  late List<List<Widget>> items;
  String? backgroundImage;
  bool isMatchScroll = false;
  //第一次加载底部选中为图片
  bool firstLoad = true;
  Widget? firstSelectImage;
  double? icon_width;
  double? icon_height;

  @override
  void onInit() {
    super.onInit();
    getNavigationConfig();
    // final gifController1 = FlutterGifController(
    //     vsync: this, duration: Duration(milliseconds: 1), value: 29);
    // final gifController2 = FlutterGifController(
    //     vsync: this, duration: Duration(milliseconds: 1), value: 0);
    // final gifController3 = FlutterGifController(
    //     vsync: this, duration: Duration(milliseconds: 1), value: 0);
    // final gifController4 = FlutterGifController(
    //     vsync: this, duration: Duration(milliseconds: 1), value: 0);
    // final gifController5 = FlutterGifController(
    //     vsync: this, duration: Duration(milliseconds: 1), value: 0);
    refreshController = FlutterGifController(
        vsync: this, duration: Duration(milliseconds: 1), value: 0);
    gifC = List.generate(pageList.length, (index) {
      if (index == currentIndex) {
        return FlutterGifController(
            vsync: this, duration: Duration(milliseconds: 1), value: 0);
        // return FlutterGifController(
        // vsync: this, duration: Duration(milliseconds: 1), value: 29);
      } else {
        return FlutterGifController(
            vsync: this, duration: Duration(milliseconds: 1), value: 0);
      }
    });
    // gifC = [
    //   gifController1,
    //   gifController2,
    //   gifController3,
    //   gifController4,
    //   gifController5
    // ];

    List<LbtEntity>? theme = Get.find<ResourceService>().navigationTheme;
    if (theme != null) {
      List<String> unselect = [];
      List<String> select = [];
      // for (int i = 1; i < 6; i++) {
      for (LbtEntity entity in theme) {
        // LbtEntity entity = theme[i];
        // if (entity.sort == i) {
        if (entity.title == 'unselect_image') {
          unselect.add(entity.imgUrl!);
        } else if (entity.title == 'select_gif') {
          select.add(entity.imgUrl!);
        } else if (entity.title == 'select_image') {
          selectImage.add(entity.imgUrl!);
        } else if (entity.title == 'background') {
          backgroundImage = entity.imgUrl!;
        } else if (entity.title == 'icon_width') {
          icon_width = double.tryParse(entity.content!);
        } else if (entity.title == 'icon_height') {
          icon_height = double.tryParse(entity.content!);
        }
        if (entity.title == 'select_image' && currentIndex + 1 == entity.sort) {
          firstSelectImage = CachedNetworkImage(imageUrl: entity.imgUrl ?? '');
          // items[controller.currentIndex][0] =
          //     CachedNetworkImage(imageUrl: entity.imgUrl ?? '');
        }
        // }
      }
      // }
      //底部动画预加载
      // for (String gif in select) {
      //   fetchGif(NetworkImage(gif));
      // }
      items = List.generate(
          4,
          (index) => [
                Image.asset(Utils.getImgPath(selectImage[currentIndex])),
                // GifImage(
                //     image: NetworkImage(select[index]),
                //     controller: gifC[index]),
                CachedNetworkImage(imageUrl: unselect[index])
              ]);
    } else {
      //底部动画预加载
      // for (String gif in selectArray) {
      //   fetchGif(AssetImage(Utils.getFilePath(gif)));
      // }
      items = List.generate(
          4,
          (index) => [
                Image.asset(Utils.getImgPath(selectImage[index])),
                // GifImage(
                //     image: AssetImage(Utils.getFilePath(selectArray[index])),
                //     controller: gifC[index]),
                Image.asset(Utils.getImgPath(unselectArray[index]))
              ]);
      firstSelectImage =
          Image.asset(Utils.getImgPath(selectImage[currentIndex]));
    }

    // loadSVGA();
  }

  @override
  void onReady() {
    super.onReady();
    if (SpUtils.loginAuth != null) {
      User.fetchUserInfos();
      Get.find<ResourceService>().getAppLogin();
    }
    Get.find<ConfigService>().loadConfig();
    if (Get.find<ResourceService>().navigationIndex != null) {
      pageController.jumpToPage(currentIndex);
    }

    if ((Get.arguments is LbtEntity?) || Get.arguments is LbtEntity) {
      LbtEntity? data = Get.arguments;
      if (data?.href != null) {
        data!.doJump();
      }
    } else if (Get.arguments is Map<String, dynamic>) {
      Get.find<PushService>().handleNotification(Get.arguments);
    }
  }

  void getNavigationConfig() {
    if (Get.find<ResourceService>().navigationIndex != null) {
      String jump = Get.find<ResourceService>().navigationIndex!.href!;
      int index = 0;
      if (jump == 'shouye') {
        index = pageList.indexWhere((element) => element is HomePage);
      } else if (jump == 'bisai') {
        index = pageList.indexWhere((element) => element is MatchPage);
      } else if (jump == 'tuijian') {
        index = pageList.indexWhere((element) => element is ExpertPage);
      } else if (jump == 'shuju') {
        index = pageList.indexWhere((element) => element is DataPage);
      } else if (jump == 'wode') {
        index = pageList.indexWhere((element) => element is MyPage);
      }
      if (index == -1) {
        // 如果 indexWhere 方法返回 -1，则抛出异常或者进行其他处理（例如使用默认页面）
        currentIndex = 0;
      } else {
        print("index is " + index.toString());
        currentIndex = index;
        // pageController.jumpToPage(index);
      }
      // pageController.jumpToPage(index);
    }
  }

  doMatchLoading() async {
    if (!isMatchLoading) {
      isMatchLoading = true;
      matchTimer = Timer.periodic(Duration(seconds: 2), (timer) {
        isMatchLoading = false;
        matchTimer?.cancel();
      });
      final matchController =
          Get.find<MatchPageController>().getMatchController();
      await matchController.doRefresh();
    }
  }

  onMatchScroll() {
    if (isMatchScroll) {
      return;
    }
    isMatchScroll = true;
    update();
  }

  // void loadSVGA() async {
  //   animationController = SVGAAnimationController(vsync: this)
  //     ..addListener(() {
  //       // log('======================= ${animationController}');
  //       update();
  //     });

  //   final videoItem = await SVGAParser.shared
  //       .decodeFromAssets(Utils.getFilePath('refresh.svga'));
  //   // videoItem.autorelease = false;
  //   animationController.videoItem = videoItem;

  //   // animationController.repeat().whenComplete(() => null)
  // }

  // void playSVGA() {
  //   if (animationController.isCompleted == true) {
  //     animationController.reset();
  //     // animationController.forward();
  //   }
  //   animationController.repeat();
  //   update();
  // }

  // void stopVGA() {
  //   animationController.stop();
  //   update();
  // }
}
