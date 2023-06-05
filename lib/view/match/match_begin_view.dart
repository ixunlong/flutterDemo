import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sports/logic/home/navigation_controller.dart';
import 'package:sports/logic/match/match_begin_controller.dart';
import 'package:sports/logic/match/match_page_controller.dart';
import 'package:sports/logic/match/match_result_list_controller.dart';
import 'package:sports/logic/match/soccer_match_filter_controller.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/util/date_utils_extension.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/match/match_list_cell.dart';
import 'package:sports/view/other/match_flow_menu.dart';
import 'package:sports/widgets/common_button.dart';
import 'package:sports/widgets/loading_check_widget.dart';
import 'package:sports/widgets/no_data_widget.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../loading/loading_match_list.dart';

class MatchBeginView extends StatefulWidget {
  const MatchBeginView({super.key});

  @override
  State<MatchBeginView> createState() => _MatchBeginViewState();
}

class _MatchBeginViewState extends State<MatchBeginView> {
  final controller = Get.put(MatchBeginController());
  final scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {
      Get.find<NavigationController>().onMatchScroll();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    PrimaryScrollController.of(context).addListener(didScroll);
  }

  @override
  void deactivate() {
    PrimaryScrollController.of(context).removeListener(didScroll);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MatchBeginController>(builder: (_) {
      return Stack(
        children: [
          EasyRefresh(
            controller: controller.refreshController,
            // scrollController: scrollController,
            onRefresh: () {
              Utils.onEvent('bspd_sx');
              controller.getMatch();
            },
            child: LoadingCheckWidget<int>(
              data: controller.groupMatchList?.length ?? 0,
              isLoading: controller.firstLoad,
              loading: const LoadingMatchList(),
              noData: NoDataWidget(
                needScroll: true,
                tip: controller.quickFilter == QuickFilter.yiji
                    ? '暂无一级比赛'
                    : (controller.quickFilter == QuickFilter.jingcai
                        ? '暂无竞足比赛'
                        : '暂无比赛'),
              ),
              child: ListView.builder(
                  primary: true,
                  // controller: scrollController,
                  itemCount: controller.dateList?.length ?? 0,
                  itemBuilder: (context, index) {
                    return StickyHeader(
                      header: Container(
                        height: 28.0,
                        color: Colours.greyF5F5F5,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        alignment: Alignment.center,
                        child: Text(
                          DateUtils.isSameDay(
                                  controller.dateList![index], DateTime.now())
                              ? '今天 ${DateFormat.E('zh_cn').format(controller.dateList![index])}'
                              : '${DateUtilsExtension.formatDateTime(controller.dateList![index], 'MM/dd')} ${DateFormat.E('zh_cn').format(controller.dateList![index])}',
                          style: const TextStyle(
                              color: Colours.text_color1, fontSize: 12),
                        ),
                      ),
                      content: Column(
                          children: List.generate(
                              controller.groupMatchList![index].length,
                              (index1) => MatchListCell(
                                  controller.groupMatchList![index][index1]))),
                    );
                  }),
            ),
          ),
          // Positioned(
          //     right: 10,
          //     bottom: 34,
          //     child: GestureDetector(
          //       onTap: () {
          //         controller.onSelectMatchType();
          //       },
          //       child: Image.asset(
          //         Utils.getImgPath(controller.getMatchTypeImage()),
          //         width: 48,
          //         height: 48,
          //         fit: BoxFit.fill,
          //       ),
          //     )),
          _bottomBar()
        ],
      );
    });
  }

  _bottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Visibility(
        visible: !controller.hideBottom && (controller.hideMatch != 0),
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
                style: TextStyle(fontSize: 11, color: Colours.grey_color)),
            Spacer(),
            TextButton(
                onPressed: () {
                  Utils.onEvent('bspd_sxfc_hf');
                  controller.onSelectDefault();
                },
                child: Text('恢复默认比赛',
                    style: TextStyle(fontSize: 11, color: Colours.main_color))),
          ]),
        ),
      ),
    );
  }

  didScroll() {
    Get.find<NavigationController>().onMatchScroll();
  }
}
