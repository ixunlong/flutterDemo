import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/service/um_service.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/view/expert/expert_focus_item.dart';
import 'package:sports/view/expert/expert_record_tag.dart';
import 'package:sports/view/home/lbt_view.dart';
import 'package:sports/view/loading/loading_expert_list.dart';
import 'package:sports/widgets/custom_indicator.dart';
import 'package:sports/widgets/loading_check_widget.dart';
import 'package:sports/widgets/no_data_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../logic/expert/expert_page_controller.dart';
import '../../model/expert/expert_top_entity.dart';
import '../../res/colours.dart';
import '../../util/user.dart';
import '../../util/utils.dart';
import 'expert_column_all_page.dart';
import 'expert_list_item.dart';

class ExpertPage extends StatefulWidget {
  const ExpertPage({super.key});

  @override
  State<ExpertPage> createState() => _ExpertPageState();
}

class _ExpertPageState extends State<ExpertPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  ExpertPageController controller = Get.put(ExpertPageController());
  @override
  void initState() {
    controller.getLbt();
    controller.getExpertTop();
    controller.getColumnData();
    for (int i = controller.tabs.length - 1; i >= 0; i--) {
      controller.getViews(i);
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.scrollController = PrimaryScrollController.of(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: Styles.appBar(
        backgroundColor: Colours.main,
        showBackButton: false,
        title: SizedBox(
          height: 34,
          child: Styles.defaultTabBar(
            tabs: const [Text("专栏"), Text("方案")],
            controller: controller.mainController,
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
              controller.mainIndex = index;
            },
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
                onTap: () => Get.toNamed(Routes.expertSearch),
                child: Image.asset(Utils.getImgPath("search_icon_black.png"),
                    alignment: Alignment.centerRight, color: Colours.white)),
          )
        ],
      ),
      body: TabBarView(
        controller: controller.mainController,
        physics: const ClampingScrollPhysics(),
        children: [
          const ExpertColumnAllPage(), // 专栏页面
          GetBuilder<ExpertPageController>(builder: (controller) {
            // 方案页面
            return VisibilityDetector(
                key: const Key("expert_focus_Key"),
                onVisibilityChanged: (VisibilityInfo info) {
                  controller.visible = !info.visibleBounds.isEmpty;
                  controller.isLogin();
                },
                child: Container(
                    color: Colours.main,
                    child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(
                            color: Colours.white,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10))),
                        child: _buildWidget())));
          }),
        ],
      ),
    );
  }

  Widget _buildWidget() {
    return EasyRefresh.builder(
      childBuilder: (context, physics) => _buildContent(physics),
      controller: controller.easyRefreshController,
      header: const ClassicHeader(
        position: IndicatorPosition.locator,
        clamping: true,
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
        readyText: "正在加载更多的专家...",
        processingText: "正在加载更多的专家...",
        processedText: "加载完成",
        noMoreText: "没有更多内容了～",
        showMessage: false,
        iconDimension: 0,
        succeededIcon: Container(),
        failedIcon: Container(),
        noMoreIcon: Container(),
        textStyle: const TextStyle(fontSize: 12, color: Colours.grey_color1),
      ),
      onRefresh: () async {
        Utils.onEvent('tjpd_sx');
        controller.getLbt();
        controller.getExpertTop();
        controller.setPage(controller.viewIndex, 1);
        await controller.getViews(controller.viewIndex);
        controller.easyRefreshController.resetFooter();
      },
      onLoad: () async {
        if (controller.viewIndex != 0) {
          controller.setPage(controller.viewIndex, null);
          await controller.getViews(controller.viewIndex);
          controller.easyRefreshController.finishLoad(
              (controller.pages[controller.viewIndex].items.length <
                      controller.pages[controller.viewIndex].page *
                          controller.pages[controller.viewIndex].pageSize)
                  ? IndicatorResult.noMore
                  : IndicatorResult.success);
        } else {
          controller.easyRefreshController.finishLoad(IndicatorResult.noMore);
        }
      },
    );
  }

  Widget _buildContent(physics) {
    return ScrollConfiguration(
      behavior: const ERScrollBehavior(),
      child: LoadingCheckWidget<int>(
        isLoading: controller.isLoading && controller.isTopLoading,
        data: controller.pages[0].items.length +
            (controller.lbt?.length ?? 0) +
            (controller.expertTop[0]?.length ?? 0) +
            ((controller.expertTop[1]?.length ?? 0)),
        noData: CustomScrollView(
            controller: ScrollController(),
            physics: physics,
            slivers: [
              const HeaderLocator.sliver(clearExtent: false),
              SliverToBoxAdapter(
                  child: SizedBox(
                      width: Get.width,
                      height: Get.height - 250,
                      child: const NoDataWidget())),
              const FooterLocator.sliver()
            ]),
        child: ExtendedNestedScrollView(
            controller: PrimaryScrollController.of(context),
            onlyOneScrollInBody: true,
            physics: physics,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return (controller.expertTop[0]?.length ?? 0) +
                          (controller.expertTop[1]?.length ?? 0) ==
                      0
                  ? <Widget>[const HeaderLocator.sliver(clearExtent: false)]
                  : <Widget>[
                      const HeaderLocator.sliver(clearExtent: false),
                      if (controller.lbt?.length != 0 && controller.lbt != null)
                        SliverToBoxAdapter(
                            child: LbtView(lbts: controller.lbt ?? [])
                                .paddingOnly(top: 16)),
                      SliverToBoxAdapter(
                        child: _buildHeader().paddingOnly(top: 16),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 222,
                          child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: controller.hotController,
                              children: List.generate(
                                  controller.expertTop.length,
                                  (index) => Column(
                                        children: [
                                          Row(
                                            children: List.generate(
                                                controller.expertTop[index]
                                                                ?.length !=
                                                            0 &&
                                                        controller.expertTop[
                                                                index] !=
                                                            null
                                                    ? 4
                                                    : 0,
                                                (childIndex) => Expanded(
                                                    child: _hotExpert(
                                                        controller.expertTop[
                                                            index]?[childIndex],
                                                        childIndex))),
                                          ),
                                          Container(height: 12),
                                          if (controller.expertTop[index]
                                                      ?.length !=
                                                  null &&
                                              (controller.expertTop[index]
                                                          ?.length ??
                                                      0) >
                                                  4)
                                            Row(
                                              children: List.generate(
                                                  controller.expertTop[index]!
                                                          .length -
                                                      4,
                                                  (childIndex) => Expanded(
                                                      child: _hotExpert(
                                                          controller.expertTop[
                                                                  index]
                                                              ?[childIndex + 4],
                                                          childIndex + 4))),
                                            ),
                                        ],
                                      ).paddingOnly(
                                          left: 5, right: 5, top: 10))),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                            padding: const EdgeInsets.only(bottom: 1),
                            color: Colours.greyF7F7F7,
                            height: 11),
                      )
                    ];
            },
            body: _buildTabBarView(physics)),
      ),
    );
  }

  Widget _buildTabBarView(physics) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 40,
              decoration: BoxDecoration(
                  border: controller.showBorder
                      ? const Border(
                          bottom: BorderSide(width: 0.5, color: Colours.greyEE))
                      : const Border()),
              child: Styles.defaultTabBar(
                  tabs: controller.tabs.map((f) {
                    return Text(f);
                  }).toList(),
                  controller: controller.viewController,
                  isScrollable: true,
                  fontSize: 16,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 13),
                  onTap: (value) {
                    Utils.onEvent('tjpd_gdl',
                        params: {'tjpd_gdl': '${value + 1}'});
                    controller.viewIndex = value;
                  })),
          Flexible(
            fit: FlexFit.loose,
            child: TabBarView(
                controller: controller.viewController,
                children: List.generate(controller.tabs.length, (tabIndex) {
                  return _buildPage(physics, tabIndex);
                })),
          ),
        ]);
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Styles.defaultTabBar(
            tabs: const [Text("足球专家"), Text("篮球专家")],
            fontSize: 16,
            isScrollable: true,
            indicator: const CustomIndicator(),
            labelPadding: const EdgeInsets.symmetric(horizontal: 13),
            controller: controller.hotController,
            labelColor: Colours.text_color1,
            unselectedLabelColor: Colours.grey66,
            onTap: (value) {
              // Utils.onEvent('tjpd_gdl',
              //     params: {'tjpd_gdl': '${value + 1}'});
              // controller.viewIndex = value;
              // controller.getViews(value);
              controller.hotIndex = value;
            }).paddingOnly(left: 2),
        Positioned(
          right: 16,
          top: 0,
          bottom: 0,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Utils.onEvent('tjpd_rmzj_qb');
              Get.toNamed(Routes.expertAll, arguments: controller.hotIndex);
            },
            child: Container(
              height: 20,
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text("全部",
                      style:
                          TextStyle(fontSize: 14, color: Colours.grey666666)),
                  const SizedBox(width: 6),
                  Image.asset(Utils.getImgPath('arrow_right.png'),
                      width: 6, height: 10)
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _hotExpert(ExpertTopEntity? entity, int index) {
    return GestureDetector(
      onTap: () {
        Utils.onEvent('tjpd_rmzj', params: {'tjpd_rmzj': '${index + 1}'});
        Get.find<UmService>().payOriginRoute = 'tj_rmzj${index + 1}';
        Get.toNamed(Routes.expertDetail,
            arguments: entity?.expertId.toString(),
            parameters: {"index": "${controller.hotIndex}"});
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colours.greyEE,
                    width: 0.5,
                    strokeAlign: BorderSide.strokeAlignOutside),
                shape: BoxShape.circle),
            child: CachedNetworkImage(
                fit: BoxFit.cover,
                width: 46,
                height: 46,
                placeholder: (context, url) => Container(),
                errorWidget: (context, url, error) => Container(),
                imageUrl: entity?.expertLogo ?? ''),
          ),
          SizedBox(height: 8, width: 10),
          Text(
            entity?.expertName ?? '',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            softWrap: true,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1, width: 10),
          ExpertRecordTag(
              text: entity?.redKeepHigh ??
                  entity?.mn ??
                  "${controller.hotIndex == 0 ? "足球" : "篮球"}分析师",
              tagType: entity?.redKeepHigh == null
                  ? TagType.thirdTag
                  : TagType.firstTag)
        ],
      ),
    );
  }

  Widget _buildPage(physics, tabIndex) {
    var tip = "";
    switch (tabIndex) {
      case 0:
        tip = "关注专家暂无观点";
        break;
      case 3:
        tip = "暂无免费观点";
        break;
      default:
        tip = "暂无相关观点";
    }
    return !controller.checkLogin && tabIndex == 0
        ? NoDataWidget(
            needScroll: true,
            physics: physics,
            tip: "请登录后查看",
            buttonText: "去登录",
            onTap: () => User.needLogin(() async {}))
        : LoadingCheckWidget<int>(
            isLoading: controller.isLoading,
            data: tabIndex == 0
                ? controller.formFocus().length
                : controller.pages[tabIndex].items.length,
            loading: const LoadingExpertWidget().loadingExpertList(false),
            noData: NoDataWidget(
              needScroll: true,
              physics: physics,
              tip: tip,
              buttonText: tabIndex == 0 ? "关注更多专家" : "",
              onTap: () => Get.toNamed(Routes.expertAll),
            ),
            child: CustomScrollView(physics: physics, slivers: [
              if (tabIndex == 0)
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        childCount: controller.formFocus().length,
                        (context, index) {
                  return ExpertFocusItem(
                      focusList: controller.formFocus()[index]);
                })),
              if (tabIndex != 0) ...[
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        childCount: controller.pages[tabIndex].items.length,
                        (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colours.greyF5F5F5, width: 4))),
                    child: ExpertListItem(
                        tabIndex: tabIndex,
                        entity: controller.pages[tabIndex].items[index]),
                  );
                })),
              ],
              const FooterLocator.sliver()
            ]),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
