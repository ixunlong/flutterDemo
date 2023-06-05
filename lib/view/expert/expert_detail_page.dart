import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/expert/expert_detail_page_controller.dart';
import 'package:sports/model/expert/expert_views_entity.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/view/expert/expert_list_item.dart';
import 'package:sports/view/loading/loading_expert_detail.dart';
import 'package:sports/widgets/common_button.dart';
import 'package:sports/widgets/loading_check_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../res/colours.dart';
import '../../res/routes.dart';
import '../../util/utils.dart';
import '../../widgets/no_data_widget.dart';
import 'expert_detail_idea_item.dart';

class ExpertDetailPage extends StatefulWidget {
  const ExpertDetailPage({Key? key}) : super(key: key);

  @override
  State<ExpertDetailPage> createState() => _ExpertDetailPageState();
}

class _ExpertDetailPageState extends State<ExpertDetailPage> {
  final tag = DateTime.now().formatedString("HH:mm:ss");
  late ExpertDetailPageController controller;
  final String expertId = Get.arguments;

  @override
  void initState() {
    controller = Get.put(ExpertDetailPageController(), tag: tag);
    controller.getExpertDetail(expertId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScrollController(
      controller: controller.scrollController,
      child: Scaffold(
          backgroundColor: Colours.grey494E55,
          body: GetBuilder<ExpertDetailPageController>(
              tag: tag,
              builder: (controller) {
                return VisibilityDetector(
                    key: Key("expertDetail"),
                    onVisibilityChanged: (VisibilityInfo info) {
                      if (!info.visibleBounds.isEmpty) controller.checkFocus();
                    },
                    child: _buildWidget());
              })),
    );
  }

  Widget _buildWidget() {
    return EasyRefresh.builder(
      footer: ClassicFooter(
        position: IndicatorPosition.locator,
        dragText: "上拉加载",
        armedText: "松开加载",
        failedText: "加载失败",
        readyText: "正在加载更多的数据...",
        processingText: "正在加载更多的数据...",
        processedText: "加载完成",
        noMoreText: "没有更多内容了～",
        showMessage: false,
        succeededIcon: Container(),
        failedIcon: Container(),
        noMoreIcon: Container(),
        iconDimension: 0,
        textStyle: const TextStyle(fontSize: 12, color: Colours.grey_color1),
      ),
      controller: controller.easyRefreshController,
      onLoad: () async {
        controller.setPage(null);
        await controller.getViews(expertId, controller.tabIndex);
        controller.easyRefreshController.finishLoad(
            controller.isDataOutOfRange(controller.tabIndex)
                ? IndicatorResult.noMore
                : IndicatorResult.success);
      },
      childBuilder: (context, physics) => _buildContent(physics),
    );
  }

  Widget _buildContent(physics) {
    return ScrollConfiguration(
      behavior: const ERScrollBehavior(),
      child: ExtendedNestedScrollView(
          physics: physics,
          controller: controller.scrollController,
          pinnedHeaderSliverHeightBuilder: () =>
              kToolbarHeight +
              MediaQuery.of(context).padding.top +
              (controller.tabTexts.length > 1 ? 40 : 0),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              Obx(() => SliverAppBar(
                    pinned: true,
                    expandedHeight: controller.expendedHeight,
                    titleSpacing: 0.0,
                    leading: GestureDetector(
                      onTap: Get.back,
                      behavior: HitTestBehavior.translucent,
                      child: Image.asset(
                        Utils.getImgPath('arrow_back.png'),
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor:
                        Colours.grey494E55.withOpacity(controller.num),
                    iconTheme: const IconThemeData(color: Colours.white),
                    title: Opacity(
                        opacity: controller.num, child: _expertTitleWidget(1)),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: expertInfoWidget(),
                    ),
                  )),
              if (controller.tabTexts.length > 1)
                SliverToBoxAdapter(
                    child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 10,
                        color: const Color(0xFFF9BD66),
                      ),
                    ),
                    Container(
                      height: 40,
                      decoration: const BoxDecoration(
                          color: Colours.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10))),
                      child: Styles.defaultTabBar(
                          controller: controller.tabController,
                          tabs: List.generate(
                            controller.tabTexts.length,
                            (index) =>
                                Text(controller.tabTexts[index]['title']),
                          ),
                          fontSize: 16),
                    ),
                  ],
                )),
            ];
          },
          body: _buildViews(physics)),
    );
  }

  Widget _buildViews(physics) {
    return Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            color: Colours.white,
            borderRadius: controller.tabTexts.length <= 1
                ? const BorderRadius.only(
                    topRight: Radius.circular(10), topLeft: Radius.circular(10))
                : BorderRadius.zero),
        child: LoadingCheckWidget<int>(
          isLoading: controller.isLoading,
          loading: const LoadingExpertDetail(),
          data: (controller.entity?.isShowBb ?? 0) +
              (controller.entity?.isShowFb ?? 0) +
              (controller.isShowIdea ? 1 : 0),
          noData: NoDataWidget(needScroll: true, physics: physics),
          child: TabBarView(
              physics: controller.tabTexts.length > 1
                  ? const ClampingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              controller: controller.tabController,
              children: List.generate(
                  controller.tabTexts.length,
                  (index) => LoadingCheckWidget<int>(
                        isLoading: false,
                        data: controller.isIdeaColumn(index)
                            ? (controller.ideaList.items?.length ?? 0)
                            :
                            // controller.tabTexts[index]['type'] ==
                            //         ExpertDetailTabContentType.ideaColumn
                            //     ? (controller.ideaList.items?.length ?? 0)
                            //     :
                            (controller.pages[index].items.length +
                                (controller.newViews[index]?.length ?? 0)),
                        loading: const LoadingExpertDetail(),
                        child: CustomScrollView(
                          physics: physics,
                          slivers: controller.isIdeaColumn(index)
                              ? _expertIdeaListWidget()
                              :
                              // controller.tabTexts[index]['type'] ==
                              //         ExpertDetailTabContentType.ideaColumn
                              //     ? _expertIdeaListWidget()
                              //     :
                              [
                                  if ((controller.entity?.isShowBb ?? 0) +
                                          (controller.entity?.isShowFb ?? 0) >
                                      1)
                                    SliverToBoxAdapter(
                                        child: Container(
                                            height: 10,
                                            color: Colours.greyF5F5F5)),
                                  SliverToBoxAdapter(
                                      child: controller
                                                  .record[index].achievement ==
                                              null
                                          ? Container()
                                          : _expertRecordWidget(index)),
                                  if (controller.newViews[index]?.length != 0 &&
                                      controller.newViews[index] != null) ...[
                                    SliverToBoxAdapter(
                                        child: Container(
                                      color: Colours.white,
                                      padding: const EdgeInsets.only(
                                          left: 16.0, top: 15),
                                      child: Text(
                                          "在售方案（${controller.newViews[index]?.length ?? 0}）",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black)),
                                    )),
                                    SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                            childCount: controller
                                                    .newViews[index]?.length ??
                                                0, (context, childIndex) {
                                      return _expertNewViewsWidget(
                                          controller
                                              .newViews[index]![childIndex],
                                          childIndex,
                                          (controller.newViews[index]?.length ??
                                                  0) -
                                              1);
                                    })),
                                    SliverToBoxAdapter(
                                        child: Container(
                                            height: 10,
                                            color: Colours.greyF5F5F5))
                                  ],
                                  if (controller
                                      .pages[index].items.isNotEmpty) ...[
                                    SliverToBoxAdapter(
                                      child: Container(
                                        color: Colours.white,
                                        padding: const EdgeInsets.only(
                                            left: 16.0, top: 15),
                                        child: const Text("历史方案",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black)),
                                      ),
                                    ),
                                    SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                            childCount: controller
                                                .pages[index]
                                                .items
                                                .length, (context, childIndex) {
                                      return _expertHistoryViewsWidget(
                                          index, childIndex);
                                    }))
                                  ],
                                  const FooterLocator.sliver()
                                ],
                        ),
                      ))),
        ));
  }

  List<Widget> _expertIdeaListWidget() {
    return [
      SliverToBoxAdapter(
        child: Container(
          color: Colours.white,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                decoration: BoxDecoration(
                    color: const Color(0xFFededed),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                          color: Colours.grey_color2,
                          offset: Offset(0, 2),
                          blurRadius: 5,
                          spreadRadius: 0)
                    ]),
                child: Text(
                  "您已订阅Ta的专栏，XXXX-XX-XX到期",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF616161)),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.ideaList.items?.length ?? 0,
                itemBuilder: (context, index) {
                  return ExpertDetailIdeaItem(
                    entity: controller.ideaList.items![index],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ];
  }

  Widget _expertTitleWidget(int tag) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colours.grey_color1,
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignOutside),
                          shape: BoxShape.circle),
                      child: CachedNetworkImage(
                          width: tag == 1 ? 30 : 50,
                          height: tag == 1 ? 30 : 50,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(),
                          errorWidget: (context, url, error) => Container(),
                          imageUrl: controller.entity?.logo ?? ''),
                    ),
                    Container(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(controller.entity?.name ?? "",
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colours.white,
                                fontWeight: FontWeight.w500)),
                        tag == 1
                            ? Container()
                            : Text(
                                "粉丝 ${controller.entity?.focus ?? "暂无"}",
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colours.greyD1D1D1,
                                    fontWeight: FontWeight.w400),
                              )
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Padding(
                padding: EdgeInsets.only(right: tag == 1 ? 16.0 : 0.0),
                child: CommonButton(
                  minWidth: 60,
                  minHeight: 28,
                  onPressed: () {
                    controller.isFocus
                        ? controller.setFocus(false)
                        : controller.setFocus(true);
                  },
                  text: controller.isFocus ? "已关注" : "关注",
                  backgroundColor:
                      controller.isFocus ? Colours.greyEE : Colours.main_color,
                  textStyle: TextStyle(
                      fontSize: 13,
                      // height: 1.3,
                      fontWeight: FontWeight.w400,
                      color: controller.isFocus
                          ? Colours.grey_color1
                          : Colours.white),
                )),
          ],
        ),
      ],
    );
  }

  Widget expertInfoWidget() {
    return Container(
      width: Get.width,
      height: controller.infoHeight,
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: kToolbarHeight + MediaQueryData.fromWindow(window).padding.top),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF3233E),
            Color(0xFFF9BD66),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _expertTitleWidget(2),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              controller.entity?.info == '' || controller.entity?.info == null
                  ? " "
                  : controller.entity!.info!,
              textWidthBasis: TextWidthBasis.longestLine,
              style: const TextStyle(
                  fontSize: 13,
                  color: Colours.white,
                  fontWeight: FontWeight.w300),
              maxLines: 3,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  Widget _expertRecordWidget(int index) {
    var list = [
      controller.record[index].redKeep == null ||
              controller.record[index].redKeep == '' ||
              controller.record[index].redKeep == '-'
          ? '-'
          : controller.record[index].redKeep,
      controller.record[index].backRatio == null ||
              controller.record[index].backRatio == '' ||
              controller.record[index].backRatio == '-'
          ? '-'
          : "${double.parse(controller.record[index].backRatio!).toInt()}%",
      controller.record[index].redKeepHigh == null ||
              controller.record[index].redKeepHigh == '' ||
              controller.record[index].redKeepHigh == '-'
          ? '-'
          : controller.record[index].redKeepHigh,
    ];
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      color: Colours.greyF5F5F5,
      child: Container(
        color: Colors.white,
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 15, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${index == 0 ? "足球" : "篮球"}战绩",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black)),
            Container(height: 10),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: List.generate(
            //     3, (childIndex) => Container(
            //       width: (Get.width - 32 - 24) / 3,
            //       padding: const EdgeInsets.symmetric(vertical: 12),
            //       decoration: BoxDecoration(
            //         color: Colours.greyF5F7FA,
            //         borderRadius: BorderRadius.circular(5.0),
            //       ),
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Text(list[childIndex]!,
            //               style: const TextStyle(
            //                   fontSize: 16, color: Colours.main_color,fontWeight: FontWeight.w500)),
            //           Text(
            //               childIndex == 1
            //                   ? "近${controller.record[index].backRatioM ?? "n"}场回报"
            //                   : controller.recordTypeList[childIndex],
            //               style: const TextStyle(fontSize: 12))
            //         ],
            //       ),
            //     )),
            // ),
            // Container(height: 12),
            controller.record[index].achievement?.length == 0
                ? Container()
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                          controller.record[index]!.achievement!.length,
                          (childIndex) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: _buildAchievementList(index, childIndex),
                              )),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _expertNewViewsWidget(Rows entity, int index, int max) {
    return Container(
        decoration: BoxDecoration(
            border: index == max
                ? const Border()
                : const Border(
                    bottom: BorderSide(color: Colours.greyF5F5F5, width: 4))),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ExpertListItem(isExpertDetailView: true, entity: entity)));
  }

  Widget _expertHistoryViewsWidget(int index, int childIndex) {
    return DecoratedBox(
        decoration: BoxDecoration(
            border: const Border(
                bottom: BorderSide(color: Colours.greyF5F5F5, width: 4))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ExpertListItem(
              isExpertDetailView: true,
              entity: controller.pages[index].items[childIndex]),
        ));
  }

  Widget _buildAchievementList(int index, int childIndex) {
    var achievement = controller.record[index].achievement![childIndex];
    return ClipOval(
            child: Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                color: controller.colorList[achievement.status!],
                child: Text(controller.textList[achievement.status!],
                    style:
                        const TextStyle(fontSize: 10, color: Colours.white))))
        .tap(
            () => Get.toNamed(Routes.viewpoint, arguments: achievement.planId));
  }
}
