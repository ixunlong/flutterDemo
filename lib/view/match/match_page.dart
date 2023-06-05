import 'dart:async';

import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/match/basket_match_filter_controller.dart';
import 'package:sports/logic/match/match_page_controller.dart';
import 'package:sports/logic/match/soccer_match_filter_controller.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/match/basketball/basket_all_view.dart';
import 'package:sports/view/match/basketball/basket_bagin_view.dart';
import 'package:sports/view/match/basketball/basket_end_view.dart';
import 'package:sports/view/match/basketball/basket_focus_view.dart';
import 'package:sports/view/match/basketball/basket_schedule_view.dart';
import 'package:sports/view/match/match_%20schedule_view.dart';
import 'package:sports/view/match/match_all_view.dart';
import 'package:sports/view/match/match_begin_view.dart';
import 'package:sports/view/match/match_interest_view.dart';
import 'package:sports/view/match/match_result_view.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../res/styles.dart';
import '../../widgets/custom_indicator.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final controller = Get.put(MatchPageController());
  final leagueController0 =
      Get.put(SoccerMatchFilterController(), tag: Constant.matchFilterTagFocus);
  final leagueController1 =
      Get.put(SoccerMatchFilterController(), tag: Constant.matchFilterTagAll);
  final leagueController2 =
      Get.put(SoccerMatchFilterController(), tag: Constant.matchFilterTagBegin);
  final leagueController3 = Get.put(SoccerMatchFilterController(),
      tag: Constant.matchFilterTagSchedule);
  final leagueController4 = Get.put(SoccerMatchFilterController(),
      tag: Constant.matchFilterTagResult);
  final basketController0 =
      Get.put(BasketMatchFilterController(), tag: Constant.matchFilterTagFocus);
  final basketController1 =
      Get.put(BasketMatchFilterController(), tag: Constant.matchFilterTagAll);
  final basketController2 =
      Get.put(BasketMatchFilterController(), tag: Constant.matchFilterTagBegin);
  final basketController3 = Get.put(BasketMatchFilterController(),
      tag: Constant.matchFilterTagSchedule);
  final basketController4 = Get.put(BasketMatchFilterController(),
      tag: Constant.matchFilterTagResult);
  // final interestController = Get.put(MatchInterestController());
  // final leagueController1 = Get.put(SoccerMatchFilterController(), tag: '2');

  late final PageController _pageController = PageController();
  late final TabController _controller = TabController(length: 2, vsync: this);

  bool visible = false;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      controller.headIndex = _controller.index;
      update();
    });
    Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!visible) {
        return;
      }
      controller.getMatchController().getMatch();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colours.main,
          title: SizedBox(
            height: 34,
            child: Styles.defaultTabBar(
              tabs: const [Text("足球"), Text("篮球")],
              controller: _controller,
              labelColor: Colors.white,
              isScrollable: true,
              unselectedLabelColor: Colors.white,
              indicator: const CustomIndicator(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                  indicatorWidth: 30,
                  indicatorBottom: 1),
              labelPadding: const EdgeInsets.symmetric(horizontal: 12),
              fontSize: 18,
              onTap: (index) {
                Utils.onEvent('bspd_dbqhl', params: {'bspd_dbqhl': '$index'});
              },
            ),
          ),
          // ExtendedTabBar(
          //   tabs: [
          //     Image.asset(controller.headIndex == 0
          //         ? Utils.getImgPath("soccer_choose.png")
          //         : Utils.getImgPath("soccer_unchoose.png")),
          //     Image.asset(controller.headIndex == 1
          //         ? Utils.getImgPath("bb_choose.png")
          //         : Utils.getImgPath("bb_unchoose.png")),
          //   ],
          //   controller: _controller,
          //   isScrollable: true,
          //   labelPadding: EdgeInsets.zero,
          //   indicator: const CustomIndicator(
          //       borderSide: BorderSide(color: Colours.transparent)),
          //   labelColor: Colors.white,
          //   unselectedLabelColor: Colors.white,
          //   onTap: (value) {
          //     Utils.onEvent('bspd_dbqhl', params: {'bspd_dbqhl': '$value'});
          //   },
          // ),
          actions: [
            // GestureDetector(
            //     onTap: () {
            //       if (controller.headIndex == 0) {
            //         Get.toNamed(Routes.soccerConfig);
            //       } else {
            //         Get.toNamed(Routes.basketballConfig);
            //       }
            //     },
            //     child: Container(
            //       margin: const EdgeInsets.only(right: 16),
            //       child: Image.asset(
            //         Utils.getImgPath('config.png'),
            //         color: Colours.white,
            //         width: 22,
            //         fit: BoxFit.fitWidth,
            //       ),
            //     )),
            GestureDetector(
                onTap: () {
                  if (controller.headIndex == 0) {
                    Get.toNamed(Routes.matchSift,
                        arguments: controller.footballController.index);
                  } else {
                    Get.toNamed(Routes.basketFilter,
                        arguments: controller.basketballController.index);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: Image.asset(
                    Utils.getImgPath('filter.png'),
                    color: Colours.white,
                    width: 22,
                    fit: BoxFit.fitWidth,
                  ),
                ))
          ],
          // bottom: ,
        ),
        body: VisibilityDetector(
          onVisibilityChanged: (info) {
            visible = !info.visibleBounds.isEmpty;
          },
          key: const Key("match key"),
          child: Container(
            color: Colours.main,
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                  color: Colours.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(10))),
              child: ExtendedTabBarView(
                physics: const ClampingScrollPhysics(),
                controller: _controller,
                children: List.generate(2, (index) => tabBarPage(index)),
              ),
            ),
          ),
        ));
  }

  Widget tabBarPage(int index) {
    return Column(
      children: [
        Container(
          height: 40,
          // decoration: const BoxDecoration(
          //     border:
          //         Border(bottom: BorderSide(color: Colours.grey_color2))),
          child: Styles.defaultTabBar(
              physics: const ClampingScrollPhysics(),
              tabs: controller.tabs.map((f) {
                return Text(f);
              }).toList(),
              controller: index == 0
                  ? controller.footballController
                  : controller.basketballController,
              onTap: (value) {
                if (index == 0) {
                  Utils.onEvent('bspd_pd_qhl',
                      params: {'bspd_pd_qhl': '$value'});
                } else {
                  Utils.onEvent('lqbspd_pd_qhl',
                      params: {'lqbspd_pd_qhl': '$value'});
                }

                controller.changeIndex(value);
              },
              fontSize: 16),
        ),
        Expanded(
          child: ExtendedTabBarView(
              controller: index == 0
                  ? controller.footballController
                  : controller.basketballController,
              children: index == 0
                  ? List.generate(controller.tabs.length, (index) {
                      if (index == MatchTabPageStatus.follow.index) {
                        return const MatchInterestView();
                      } else if (index == MatchTabPageStatus.all.index) {
                        return const MatchAllView();
                      } else if (index == MatchTabPageStatus.live.index) {
                        return const MatchBeginView();
                      } else if (index == MatchTabPageStatus.schedule.index) {
                        return const MatchScheduleView();
                      } else if (index == MatchTabPageStatus.result.index) {
                        return const MatchResultView();
                      }
                      return Container();
                    })
                  : List.generate(controller.tabs.length, (index) {
                      if (index == MatchTabPageStatus.follow.index) {
                        return const BasketFocusView();
                      } else if (index == MatchTabPageStatus.all.index) {
                        return const BasketAllView();
                      } else if (index == MatchTabPageStatus.live.index) {
                        return const BasketBeginView();
                      } else if (index == MatchTabPageStatus.schedule.index) {
                        return const BasketScheduleView();
                      } else if (index == MatchTabPageStatus.result.index) {
                        return const BasketEndView();
                      }
                      return Container();
                    })),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
