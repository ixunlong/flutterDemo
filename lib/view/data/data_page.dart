import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/data/data_channel_filter_page.dart';
import 'package:sports/widgets/loading_check_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../logic/data/data_page_controller.dart';
import '../../util/user.dart';
import '../../widgets/custom_indicator.dart';

class DataPage extends StatefulWidget {
  const DataPage({Key? key}) : super(key: key);

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.put(DataPageController());

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<DataPageController>(builder: (controller) {
      return VisibilityDetector(
        key: const Key("Data"),
        onVisibilityChanged: (VisibilityInfo info) async {
          if (!info.visibleBounds.isEmpty && controller.login != User.isLogin) {
            controller.login = User.isLogin;
            await controller.requestData();
            await controller.updateTab();
            await Future.delayed(const Duration(milliseconds: 200));
            update();
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text('赛事', style: TextStyle(color: Colours.white)),
              backgroundColor: Colours.main,
              // title: TabBar(
              //   tabs: [
              //     Image.asset(controller.currentHeadIndex == 0
              //         ? Utils.getImgPath("hot_choose.png")
              //         : Utils.getImgPath("hot_unchoose.png")),
              //     Image.asset(controller.currentHeadIndex == 1
              //         ? Utils.getImgPath("match_choose.png")
              //         : Utils.getImgPath("match_unchoose.png"))
              //   ],
              //   controller: controller.headTabController,
              //   isScrollable: true,
              //   labelPadding: EdgeInsets.zero,
              //   indicator: const CustomIndicator(
              //       borderSide: BorderSide(color: Colours.transparent)),
              //   onTap: (index) {
              //     controller.currentHeadIndex = index;
              //     if (index == 0) {
              //       controller.tabController.animateTo(0);
              //       update();
              //     } else {
              //       controller.tabController.animateTo(5);
              //     }
              //     update();
              //   },
              // ),
            ),
            body: LoadingCheckWidget<int>(
              isLoading: controller.isLoading,
              loading: Container(),
              data: controller.data?.length,
              child: controller.isLoading
                  ? Container()
                  : Container(
                      color: Colours.main,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(
                            color: Colours.white,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10))),
                        child: Column(
                          children: [
                            _tabBar(),
                            Expanded(
                              child: TabBarView(
                                  physics:
                                      const LessSpringClampingScrollPhysics(),
                                  key: Key(controller.tabs.join(',')),
                                  controller: controller.tabController,
                                  children: controller.seasonPage),
                            )
                          ],
                        ),
                      ),
                    ),
            )),
      );
    });
  }

  Widget _tabBar() {
    return SizedBox(
      width: Get.width,
      child: Row(
        children: [
          Flexible(
              fit: FlexFit.tight,
              child: SizedBox(
                  height: 40,
                  child: Styles.defaultTabBar(
                    physics: const LessSpringClampingScrollPhysics(),
                    controller: controller.tabController,
                    isScrollable: true,
                    fontSize: 16,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 13),
                    tabs: controller.tabs,
                  ))),
          // Container(
          //   width: 46,
          //   height: 40,
          //   alignment: Alignment.center,
          //   decoration: BoxDecoration(
          //       color: Colours.white,
          //       borderRadius:
          //           const BorderRadius.only(topRight: Radius.circular(10)),
          //       boxShadow: [
          //         BoxShadow(
          //             color: Colours.grey80.withOpacity(0.3),
          //             offset: const Offset(-5, -1),
          //             blurRadius: 2.0,
          //             spreadRadius: -4,
          //             blurStyle: BlurStyle.normal)
          //       ]),
          //   child: Image.asset(Utils.getImgPath("my_league_channel.png")),
          // ).tap(() async {
          //   Utils.onEvent('sjpd_gdpd');
          //   controller.result = await Get.bottomSheet(
          //       const DataChannelFilterPage(),
          //       isScrollControlled: true,
          //       ignoreSafeArea: false);
          //   await controller.requestData();
          //   await controller.updateTab();
          //   await Future.delayed(const Duration(milliseconds: 100));
          //   if (controller.result != 0 && controller.result != null) {
          //     controller.tabController.animateTo((controller.data?.indexWhere(
          //                 (element) => element.leagueId == controller.result) ??
          //             0) +
          //         5);
          //     controller.result = 0;
          //   }
          // })
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
