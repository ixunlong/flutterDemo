import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sports/logic/home/navigation_controller.dart';
import 'package:sports/logic/match/basket_list_all_controller.dart';
import 'package:sports/logic/match/basket_match_filter_controller.dart';
import 'package:sports/logic/match/match_page_controller.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/util/date_utils_extension.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/loading/loading_match_list.dart';
import 'package:sports/view/match/basketball/basket_list_cell.dart';
import 'package:sports/view/match/match_type_segment_widget.dart';
import 'package:sports/widgets/common_button.dart';
import 'package:sports/widgets/loading_check_widget.dart';
import 'package:sports/widgets/no_data_widget.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class BasketAllView extends StatefulWidget {
  const BasketAllView({super.key});

  @override
  State<BasketAllView> createState() => _BasketAllViewState();
}

class _BasketAllViewState extends State<BasketAllView> {
  final controller = Get.put(BasketListAllController());
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
  void didUpdateWidget(covariant BasketAllView oldWidget) {
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
    return GetBuilder<BasketListAllController>(
      builder: (_) {
        return Stack(
          alignment: Alignment.center,
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
                loading: const LoadingMatchList(),
                noData: NoDataWidget(
                  needScroll: true,
                  tip: controller.quickFilter == QuickFilter.yiji
                      ? '暂无一级比赛'
                      : (controller.quickFilter == QuickFilter.jingcai
                          ? '暂无竞篮比赛'
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
                                (index1) => BasketListCell(controller
                                    .groupMatchList![index][index1]))),
                      );
                    }),
              ),
            ),
            // Positioned(
            //     bottom: 40,
            //     child: MatchTypeWidget(
            //       1,
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
    // final filter =
    //     Get.find<BasketMatchFilterController>(tag: Constant.matchFilterTagAll);
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
            Text('篮球频道因筛选合计隐藏${controller.hideMatch}场比赛',
                style: TextStyle(fontSize: 11, color: Colours.grey_color)),
            Spacer(),
            TextButton(
                onPressed: () {
                  Utils.onEvent('bspd_sxfc_hf');
                  controller.onSelectDefault();
                  update();
                  // controller.onSelectMatchType(0);
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
