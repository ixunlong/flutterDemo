import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sports/logic/home/navigation_controller.dart';
import 'package:sports/logic/match/match_page_controller.dart';
import 'package:sports/logic/match/match_schedule_controller.dart';
import 'package:sports/logic/match/match_schedule_list_controller.dart';
import 'package:sports/logic/match/soccer_match_filter_controller.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/match/match_list_cell.dart';
import 'package:sports/view/match/match_type_segment_widget.dart';
import 'package:sports/widgets/common_button.dart';
import 'package:sports/widgets/cupertino_picker_widget.dart';
import 'package:sports/widgets/loading_check_widget.dart';
import 'package:sports/widgets/no_data_widget.dart';

import '../../widgets/date_tab_bar.dart';
import '../loading/loading_match_list.dart';

class MatchScheduleView extends StatefulWidget {
  const MatchScheduleView({super.key});

  @override
  State<MatchScheduleView> createState() => _MatchScheduleViewState();
}

class _MatchScheduleViewState extends State<MatchScheduleView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final controller = Get.put(MatchScheduleController());
  final days =
      List.generate(7, (index) => DateTime.now().add(Duration(days: index)));
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: days.length,
      vsync: this,
    );
    _tabController.addListener(() {
      controller.changeIndex(_tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MatchScheduleController>(builder: (_) {
      return Stack(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DateTabBar(
                      onTap: (value) {
                        Utils.onEvent('bspd_rql_rl');
                        controller.changeIndex(value);
                      },
                      dateList: days,
                      controller: _tabController,
                      textStyle: const TextStyle(fontSize: 12),
                      subTextStyle: const TextStyle(fontSize: 12),
                      labelPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 5),
                      indicatorColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: Colors.red,
                      unselectedLabelColor: Colours.grey66,
                      labelStyle: const TextStyle(height: 2),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colours.grey_color5,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Utils.onEvent('bspd_rql_sx');
                      _showDatePicker();
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Image.asset(
                        Utils.getImgPath('calendar.png'),
                        fit: BoxFit.fill,
                        width: 22,
                        height: 22,
                      ),
                    ),
                  )
                  // IconButton(
                  //     onPressed: () {
                  //       Utils.onEvent('bspd_rql_sx');
                  //       _showDatePicker();
                  //     },
                  //     icon: ImageIcon(
                  //         Image.asset(Utils.getImgPath('calendar.png')).image))
                ],
              ),
              Container(
                  width: double.infinity,
                  height: 1,
                  color: Colours.grey_color2),
              Expanded(
                child: ExtendedTabBarView(
                  controller: _tabController,
                  children: days
                      .map((e) => MatchScheduleListView(e, days.indexOf(e)))
                      .toList(),
                ),
              ),
            ],
          ),
          // Positioned(
          //     bottom: 40,
          //     child: MatchTypeWidget(
          //       0,
          //       false,
          //       controller.quickFilter,
          //       onTap: (index) {
          //         controller.onSelectMatchType(index);
          //       },
          //     )),
          _bottomBar()
        ],
      );
    });
  }

  _bottomBar() {
    // bool showBottom = false;
    // int hideMatch = 0;
    // final filter = Get.find<SoccerMatchFilterController>(
    //     tag: Constant.matchFilterTagSchedule);
    // final listC =
    //     Get.find<MatchScheduleListController>(tag: controller.index.toString());

    // if (controller.quickFilter == QuickFilter.qingbao ||
    //     controller.quickFilter == QuickFilter.guandian) {
    //   if (listC.hideMatch != 0 && !controller.hideBottom) {
    //     showBottom = true;
    //     hideMatch = listC.hideMatch;
    //   }
    // } else {
    //   if (!controller.hideBottom && (filter.hideMatch != 0)) {
    //     showBottom = true;
    //     hideMatch = filter.hideMatch;
    //   }
    // }
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Visibility(
        visible: controller.hideMatch != 0 && !controller.hideBottom,
        child: Container(
          height: 30,
          width: double.infinity,
          color: Colours.pinkFFF3F3,
          child: Row(children: [
            SizedBox(
                width: 30,
                height: 30,
                child: CommonButton(
                  onPressed: () {
                    Utils.onEvent('bspd_sxfc_gb');
                    controller.onHideBottom();
                  },
                  text: '×',
                  foregroundColor: Colours.grey_color,
                )),
            Text('足球频道因筛选合计隐藏${controller.hideMatch}场比赛',
                style:
                    const TextStyle(fontSize: 11, color: Colours.grey_color)),
            const Spacer(),
            TextButton(
                onPressed: () {
                  Utils.onEvent('bspd_sxfc_hf');
                  controller.onSelectMatchType(QuickFilter.all);
                },
                child: const Text('恢复默认比赛',
                    style: TextStyle(fontSize: 11, color: Colours.main_color))),
          ]),
        ),
      ),
    );
  }

  void _showDatePicker() async {
    // var locale = Localizations.localeOf(context);
    List<String> title = days
        .map((e) =>
            '${DateFormat.MMMd('zh_cn').format(e)}       ${DateFormat.E('zh_cn').format(e)}')
        .toList();
    final selectIndex = await Get.bottomSheet(CupertinoPickerWidget(
      title,
      title: '选择日期',
      initialIndex: controller.index,
    ));
    _tabController.animateTo(selectIndex);
    log('$selectIndex');
  }
}

class MatchScheduleListView extends StatefulWidget {
  final DateTime date;
  final int pageIndex;
  const MatchScheduleListView(this.date, this.pageIndex, {super.key});

  @override
  State<MatchScheduleListView> createState() => _MatchScheduleListViewState();
}

class _MatchScheduleListViewState extends State<MatchScheduleListView> {
  // MatchScheduleListView({super.key}) {}
  late MatchScheduleListController controller;
  final scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(MatchScheduleListController(widget.date),
        tag: '${widget.pageIndex}');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    PrimaryScrollController.of(context).addListener(didScroll);
    log('didChangeDependencies');
  }

  @override
  void deactivate() {
    PrimaryScrollController.of(context).removeListener(didScroll);
    super.deactivate();
    log('deactivate');
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<MatchScheduleController>();
    return GetBuilder<MatchScheduleListController>(
      // init: controller,
      tag: '${widget.pageIndex}',
      builder: (_) {
        return EasyRefresh(
          controller: controller.refreshController,
          // scrollController: scrollController,
          onRefresh: () {
            Utils.onEvent('bspd_sx');
            controller.getMatch();
          },
          child: LoadingCheckWidget<int>(
            data: controller.matchList.length,
            isLoading: controller.firstLoad,
            loading: const LoadingMatchList(),
            noData: NoDataWidget(
              needScroll: true,
              tip: c.quickFilter == QuickFilter.yiji
                  ? '暂无一级比赛'
                  : (c.quickFilter == QuickFilter.jingcai ? '暂无竞足比赛' : '暂无比赛'),
            ),
            child: ListView.builder(
                primary: true,
                // controller: scrollController,
                itemCount: controller.matchList.length,
                itemBuilder: (context, index) {
                  return MatchListCell(controller.matchList[index]);
                }),
          ),
        );
      },
    );
  }

  didScroll() {
    Get.find<NavigationController>().onMatchScroll();
  }
}
