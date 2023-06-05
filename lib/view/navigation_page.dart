import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:gaimon/gaimon.dart';
import 'package:get/get.dart';
import 'package:sports/logic/expert/expert_page_controller.dart';
import 'package:sports/logic/home/navigation_controller.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/logic/service/match_service.dart';
// import 'package:sports/main.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/lbt_dialog.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/home/home_page.dart';
import 'package:sports/widgets/update_check_widget.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  static callJump(String name) {
    _jump?.call(name);
  }

  static void Function(String)? _jump;

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final controller = Get.put(NavigationController());

  static const double _imageSize = 26.0;
  final List<String> _appBarTitles = ['首页', '比赛', '数据', '我的'];
  DateTime? lastPopTime;

  // int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // controller.loadSVGA();
    // Get.find<PushService>().initJpush();
    NavigationPage._jump = (name) {
      final idx = _appBarTitles.indexOf(name);
      if (idx < _appBarTitles.length && idx >= 0) {
        Get.until((route) => route.isFirst);
        controller.pageController.jumpToPage(idx);
      }
    };
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp, // 竖屏 Portrait 模式
        DeviceOrientation.portraitDown,
      ],
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {});
    UpdateCheckDialog.checkUpdate();
    final matchService = Get.find<MatchService>();
    if (matchService.oneLevelData == null) {
      matchService.getOneLevelLeague();
    }
  }

  @override
  Widget build(BuildContext context) {
    LbtDialogUtil.checkShowDialog(
        curRoute: _appBarTitles[controller.currentIndex]);
    return WillPopScope(
      onWillPop: () async {
        if (lastPopTime == null ||
            DateTime.now().difference(lastPopTime!) >
                Duration(milliseconds: 1500)) {
          lastPopTime = DateTime.now();
          // Fluttertoast.showToast(
          //     msg: '再按一次退出红球会',
          //     gravity: ToastGravity.CENTER,
          //     timeInSecForIosWeb: 1);
          ToastUtils.showDismiss('再按一次退出红球会', 1);
          return Future.value(false);
        } else {
          lastPopTime = DateTime.now();
          // 退出app
          return Future.value(true);
        }
      },
      child: Scaffold(
          bottomNavigationBar: GetBuilder<NavigationController>(
            builder: (_) {
              return Container(
                decoration: controller.backgroundImage == null
                    ? null
                    : BoxDecoration(
                        // color: Colours.redFFDBDB,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                              controller.backgroundImage!),
                        ),
                      ),
                child: BottomNavigationBar(
                  // backgroundColor: Theme.of(context).,
                  items: _buildBottomNavigationBarItem(context),
                  type: BottomNavigationBarType.fixed,
                  currentIndex: controller.currentIndex,
                  elevation: controller.backgroundImage == null ? 5 : 0,
                  // iconSize: 24.0,
                  selectedFontSize: 10,
                  unselectedFontSize: 10,
                  selectedItemColor: Colours.main_color,
                  unselectedItemColor: Colours.text_color1,
                  // selectedLabelStyle: TextStyle(height: 1.1),
                  // showSelectedLabels: false,
                  backgroundColor: controller.backgroundImage == null
                      ? Colours.white
                      : Colors.transparent,
                  onTap: (index) => onTapIndex(index),
                ),
              );
            },
          ),
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller.pageController,
            onPageChanged: (int index) {
              setState(() {
                controller.currentIndex = index;
              });
            },
            children: controller.pageList,
          )),
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarItem(context) {
    // var tabImages = [
    //   ['tabicon_home_select.png', 'tabicon_home_unselect.png'],
    //   ['bottom_match.gif', 'tabicon_match_unselect.png'],
    //   ['tabicon_expert_select.png', 'tabicon_expert_unselect.png'],
    //   ['tabicon_data_select.png', 'tabicon_data_unselect.png'],
    //   ['tabicon_my_select.png', 'tabicon_my_unselect.png']
    // ];
    List<List<Widget>> items = [];
    for (int i = 0; i < controller.items.length; i++) {
      // if (i == 1 && controller.isMatchScroll) {
      //   items.add([
      //     GifImage(
      //         image: AssetImage(Utils.getFilePath('refresh.gif')),
      //         controller: controller.refreshController),
      //     controller.items[i].last
      //   ]);
      // } else {
      items.add(List.from(controller.items[i]));
      // }
    }
    if (controller.firstLoad && controller.firstSelectImage != null) {
      //gif加载过慢,第一次加载用图片
      items[controller.currentIndex][0] = controller.firstSelectImage!;

      controller.firstLoad = false;
    }

    // if (controller.isMatchScroll) {
    //   items.replaceRange(1, 1, [
    //     [
    //       GifImage(
    //           image: AssetImage(Utils.getFilePath('refresh.gif')),
    //           controller: controller.refreshController),
    //       Image.asset(Utils.getImgPath(controller.unselectArray[1]))
    //     ]
    //   ]);
    // }
    double iconWidth = controller.icon_width ?? _imageSize;
    double iconHeight = controller.icon_height ?? _imageSize;
    return List.generate(controller.items.length, (i) {
      return BottomNavigationBarItem(
        tooltip: '',
        icon:
            SizedBox(width: iconWidth, height: iconHeight, child: items[i][1]),
        activeIcon:
            SizedBox(width: iconWidth, height: iconHeight, child: items[i][0]),
        // activeIcon: SizedBox(
        //   width: _imageSize,
        //   height: _imageSize,
        //   child: SVGAImage(animationController),
        // ),
        label: _appBarTitles[i],
      );
    });
  }

  onTapIndex(int index) async {
    // SoundUtils.playRedCard();
    if (controller.currentIndex == index) {
      if (index == 0) {
        final expertController = Get.find<ExpertPageController>();
        await expertController.doRefresh();
        // (controller.pageList[0] as ExpertPage).doRefresh();
      }
      if (index == 1) {
        controller.doMatchLoading();
        // controller.refreshController.reset();
        // controller.refreshController
        //     .animateTo(29, duration: Duration(seconds: 2));
        // final matchController =
        //     Get.find<MatchPageController>().getMatchController();
        // if (!controller.animationController.isAnimating) {
        //   controller.playSVGA();
        //   await matchController.doRefresh();
        // }
      }
      // if (index == 2) {
      //   final expertController = Get.find<ExpertPageController>();
      //   await expertController.doRefresh();
      // }
    } else {
      if (Get.find<ConfigService>().pushConfig.bottomVibration == 1) {
        if (Platform.isIOS) {
          HapticFeedback.mediumImpact();
        } else {
          // HapticFeedback.mediumImpact();
          // Vibration.vibrate(duration: 25, amplitude: 150);
          Gaimon.selection();
        }
      }
      if (index != 1) {
        controller.isMatchScroll = false;
      }
      controller.pageController.jumpToPage(index);
      // final gifController = controller.gifC[index];
      // gifController.reset();
      // gifController.animateTo(29, duration: Duration(seconds: 1));
      // if (index == 1) {
      //   controller.gifController.reset();
      //   controller.gifController.animateTo(29, duration: Duration(seconds: 1));
      // }
    }
  }
}
