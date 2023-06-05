import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sports/logic/home/navigation_controller.dart';
import 'package:sports/logic/match/basket_list_focus_controller.dart';
import 'package:sports/logic/match/basket_match_filter_controller.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/loading/loading_match_list.dart';
import 'package:sports/view/match/basketball/basket_list_cell.dart';
import 'package:sports/widgets/common_button.dart';
import 'package:sports/widgets/loading_check_widget.dart';
import 'package:sports/widgets/no_data_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../logic/match/match_page_controller.dart';
import '../../../util/user.dart';

class BasketFocusView extends StatefulWidget {
  const BasketFocusView({super.key});

  @override
  State<BasketFocusView> createState() => _MatchInterestViewState();
}

class _MatchInterestViewState extends State<BasketFocusView>
    with TickerProviderStateMixin {
  final controller = Get.put(BasketListFocusController());
  final scrollController = ScrollController();
  final filter =
      Get.find<BasketMatchFilterController>(tag: Constant.matchFilterTagFocus);
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      Get.find<NavigationController>().onMatchScroll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BasketListFocusController>(builder: (controller) {
      return VisibilityDetector(
        key: Key("interestKey"),
        onVisibilityChanged: (VisibilityInfo info) {
          controller.setVisible(!info.visibleBounds.isEmpty);
        },
        child: !controller.isLogin()
            ? NoDataWidget(
                tip: "请登录后查看",
                buttonText: "去登录",
                onTap: () => User.needLogin(() async {}))
            : Stack(
                children: [
                  EasyRefresh(
                    controller: controller.refreshController,
                    onRefresh: () {
                      Utils.onEvent('bspd_sx');
                      controller.getMatch();
                    },
                    child: LoadingCheckWidget<int>(
                      data: controller.originalData.length,
                      isLoading: controller.firstLoad,
                      noData: NoDataWidget(
                          needScroll: true,
                          tip: '暂无关注的比赛',
                          buttonText: '去关注',
                          onTap: () => Get.find<MatchPageController>()
                              .changeMatchIndex(1)),
                      loading: const LoadingMatchList(),
                      child: GroupedListView(
                        controller: controller.autoScrollController,
                        elements: controller.groupListData,
                        groupBy: (element) => element['group'],
                        order: GroupedListOrder.ASC,
                        // floatingHeader: true,
                        sort: false,
                        groupSeparatorBuilder: (value) {
                          return Container(
                            height: 28.0,
                            color: Colours.greyF5F5F5,
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.center,
                            child: Text(
                              value,
                              style: const TextStyle(
                                  color: Colours.text_color1, fontSize: 12),
                            ),
                          );
                        },
                        indexedItemBuilder: (context, element, index) {
                          return AutoScrollTag(
                              controller: controller.autoScrollController,
                              index: index,
                              key: ValueKey(index),
                              child: BasketListCell(
                                element['match'],
                              ));
                        },
                        // itemBuilder: (context, element) {
                        //   return MatchListCell(element['match']);
                        // },
                      ),
                    ),
                  ),
                ],
              ),
      );
    });
  }

  _bottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Visibility(
        visible: !controller.hideBottom && (filter.hideMatch != 0),
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
            Text('篮球频道因筛选合计隐藏${filter.hideMatch}场比赛',
                style:
                    const TextStyle(fontSize: 11, color: Colours.grey_color)),
            const Spacer(),
            TextButton(
                onPressed: () {
                  Utils.onEvent('bspd_sxfc_hf');
                  controller.onSelectDefault();
                },
                child: const Text('恢复默认比赛',
                    style: TextStyle(fontSize: 11, color: Colours.main_color))),
          ]),
        ),
      ),
    );
  }
}
