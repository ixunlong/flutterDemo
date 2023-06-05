import 'dart:developer';

import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sports/logic/home/navigation_controller.dart';
import 'package:sports/logic/match/match_all_controller.dart';
import 'package:sports/logic/match/match_page_controller.dart';
import 'package:sports/logic/match/soccer_match_filter_controller.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/util/date_utils_extension.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/match/match_list_cell.dart';
import 'package:sports/view/match/match_type_segment_widget.dart';
import 'package:sports/view/other/match_flow_menu.dart';
import 'package:sports/widgets/common_button.dart';
import 'package:sports/widgets/loading_check_widget.dart';
import 'package:sports/widgets/no_data_widget.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../loading/loading_match_list.dart';

class MatchAllView extends StatefulWidget {
  const MatchAllView({super.key});

  @override
  State<MatchAllView> createState() => _MatchAllViewState();
}

class _MatchAllViewState extends State<MatchAllView> {
  final controller = Get.put(MatchAllController());
  ScrollController? scrollController;
  // final scrollController = ScrollController();
  final navigationController = Get.find<NavigationController>();
  bool isScrollDown = false;
  double lastOffset = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      log('addPostFrameCallback');
      // PrimaryScrollController.of(context).addListener(didScroll);
    });
  }

  @override
  void didUpdateWidget(covariant MatchAllView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    log('didUpdateWidget');
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
    return GetBuilder<MatchAllController>(
      builder: (_) {
        return Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            EasyRefresh(
              controller: controller.refreshController,
              // scrollController: PrimaryScrollController.of(context),
              onRefresh: () async {
                Utils.onEvent('bspd_sx');
                await controller.getMatch();
                // int index = controller.getLeastAnchor();
                // controller.refreshController.finishRefresh();
                // Future.delayed(Duration(seconds: 2)).then((value) {
                //   scrollController.scrollToIndex(index,
                //       preferPosition: AutoScrollPosition.begin);
                //   // scrollController.highlight(index);
                // });
              },
              child: LoadingCheckWidget<int>(
                data: controller.groupMatchList?.length ?? 0,
                isLoading: controller.firstLoad,
                // scrollable: true,
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
                    // primary: true,
                    controller: PrimaryScrollController.of(context),
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
                                (index1) => MatchListCell(controller
                                    .groupMatchList![index][index1]))),
                      );
                    }),
              ),
            ),
            // Positioned(
            //     bottom: 40,
            //     child: MatchTypeWidget(
            //       0,
            //       controller.firstLoad,
            //       controller.quickFilter,
            //       onTap: (index) {
            //         controller.onSelectMatchType(index);
            //       },
            //     )),
            _bottomBar()
          ],
        );
      },
    );
  }

  _bottomBar() {
    // bool showBottom = false;
    // int hideMatch = 0;
    // final filter =
    //     Get.find<SoccerMatchFilterController>(tag: Constant.matchFilterTagAll);
    // if (controller.quickFilter == QuickFilter.qingbao ||
    //     controller.quickFilter == QuickFilter.guandian) {
    //   if (controller.hideMatch != 0 && !controller.hideBottom) {
    //     showBottom = true;
    //     hideMatch = controller.hideMatch;
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
                style: TextStyle(fontSize: 11, color: Colours.grey_color)),
            Spacer(),
            TextButton(
                onPressed: () {
                  Utils.onEvent('bspd_sxfc_hf');
                  // controller.onSelectDefault();
                  controller.onSelectMatchType(QuickFilter.all);
                  update();
                },
                child: const Text('恢复默认比赛',
                    style: TextStyle(fontSize: 11, color: Colours.main_color))),
          ]),
        ),
      ),
    );
  }

  didScroll() {
    navigationController.onMatchScroll();
  }
}
