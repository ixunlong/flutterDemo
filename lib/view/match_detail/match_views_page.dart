import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/match/match_views_controller.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/no_data_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../res/colours.dart';
import '../../util/user.dart';
import '../../widgets/common_button.dart';
import '../expert/expert_list_item.dart';

class MatchViewsPage extends StatefulWidget {
  const MatchViewsPage({Key? key}) : super(key: key);

  @override
  State<MatchViewsPage> createState() => _MatchViewsPageState();
}

class _MatchViewsPageState extends State<MatchViewsPage>
    with AutomaticKeepAliveClientMixin {
  final tag = DateTime.now().formatedString("HH:mm:ss");
  late MatchViewsController controller;

  @override
  void initState() {
    controller = Get.put(MatchViewsController(), tag: tag);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MatchViewsController>(
	  tag: tag,
    builder: (controller) {
      return VisibilityDetector(
        key: const Key("matchViewsKey"),
        onVisibilityChanged: (VisibilityInfo info) {
          controller.setVisible(!info.visibleBounds.isEmpty);
          controller.isLogin();
        },
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                color: Colours.white,
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                      controller.tabs.length,
                      (index) => CommonButton(
                          minWidth: 58,
                          minHeight: 24,
                          onPressed: () {
                            Utils.onEvent('bsxq_gd_qhl',
                                params: {'bsxq_gd_qhl': '${index + 1}'});
                            controller.changeIndex(index);
                            WidgetsBinding.instance
                                .addPostFrameCallback((timeStamp) {
                              controller.getViews(index);
                              controller.isLogin();
                            });
                          },
                          text: controller.tabs[index],
                          backgroundColor:
                          controller.currentIndex == index? Colours.redFFECEE : Colours.white,
                          textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: controller.currentIndex == index
                                  ? Colours.main_color
                                  : Colours.grey666666))),
                ),
              ),
              Expanded(child: _buildPage()),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPage() {
    return EasyRefresh.builder(
        header: const ClassicHeader(
          dragText: "下拉刷新",
          armedText: "松开刷新",
          failedText: "刷新失败",
          readyText: "正在刷新...",
          processingText: "正在刷新...",
          processedText: "刷新完成",
          showMessage: false,
          iconTheme: IconThemeData(color: Colours.text_color),
          textStyle: TextStyle(fontSize: 12),
        ),
        footer: ClassicFooter(
          position: IndicatorPosition.locator,
          dragText: "上拉加载",
          armedText: "松开加载",
          failedText: "加载失败",
          readyText: "正在加载更多的数据...",
          processingText: "正在加载更多的数据...",
          processedText: "加载完成",
          noMoreText: "无更多内容",
          showMessage: false,
          succeededIcon: Container(),
          failedIcon: Container(),
          noMoreIcon: Container(),
          iconDimension: 0,
          textStyle: const TextStyle(fontSize: 12, color: Colours.grey_color1),
        ),
        controller: controller.easyRefreshController,
        onRefresh: () async {
          controller.setPage(controller.currentIndex, 1);
          controller.getViews(controller.currentIndex);
        },
        onLoad: () async {
          controller.setPage(controller.currentIndex, null);
          await controller.getViews(controller.currentIndex);
          controller.easyRefreshController.finishLoad((controller
                      .pages[controller.currentIndex].items.length >=
                  controller.pages[controller.currentIndex].total)
              ? IndicatorResult.noMore
              : IndicatorResult.success);
        },
        childBuilder: (context, physics) {
          return _buildList(physics);
        });
  }

  Widget _buildList(physics) {
    return !controller.checkLogin
        ? NoDataWidget(needScroll: true,physics: physics,tip: "请登录后查看",buttonText: "去登录",onTap: ()=> User.needLogin(() async {}))
        : controller.pages[controller.currentIndex].items.isEmpty &&
                !controller.isLoading
            ? NoDataWidget(needScroll: true,physics: physics,tip: "暂无${controller.currentIndex == 2?"免费":"相关"}观点")
            : CustomScrollView(physics: physics, slivers: [
              SliverToBoxAdapter(child: Container(height: 10,color: Colours.greyF7F7F7)),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        childCount: controller
                            .pages[controller.currentIndex]
                            .items
                            .length, (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colours.greyF5F5F5, width: 4))),
                    child: ExpertListItem(
                        isMatchView: true,
                        entity: controller.pages[controller.currentIndex]
                            .items[index]),
                  );
                })),
                const FooterLocator.sliver()
              ]);
  }
  @override
  bool get wantKeepAlive => true;
}
