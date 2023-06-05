import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:sports/logic/expert/expert_page_controller.dart';
import 'package:sports/widgets/no_data_widget.dart';
import 'expert_column_item.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../res/colours.dart';
import '../../res/styles.dart';
import '../../widgets/loading_check_widget.dart';

class ExpertColumnAllPage extends StatefulWidget {
  const ExpertColumnAllPage({Key? key}) : super(key: key);

  @override
  State<ExpertColumnAllPage> createState() => _ExpertColumnAllPageState();
}

class _ExpertColumnAllPageState extends State<ExpertColumnAllPage> {
  ExpertPageController controller = Get.put(ExpertPageController());
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.columnScrollController = PrimaryScrollController.of(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpertPageController>(builder: (controller) {
      return VisibilityDetector(
          key: const Key("expert_column_all_page"),
          onVisibilityChanged: (VisibilityInfo info) {
            //... 判断可见
            controller.columnVisible = !info.visibleBounds.isEmpty;
            controller.isColumnLogin();
          },
          child: Container(
              //创建一个圆角的视图外观
              color: Colours.main,
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                    color: Colours.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10))),
                child: _buildWidget(0),
              )));
    });
  }

  Widget _buildWidget(int index) {
    return GetBuilder<ExpertPageController>(
      builder: (controller) {
        return EasyRefresh.builder(
          childBuilder: (context, physics) => _buildContent(physics),
          controller: controller.columnERController,
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
            textStyle:
                const TextStyle(fontSize: 12, color: Colours.grey_color1),
          ),
          onRefresh: () async {
            controller.setColumnPage(1);
            await controller.getColumnData();
            controller.columnERController.resetFooter();
          },
          onLoad: () async {
            controller.setColumnPage(null);
            await controller.getColumnData();
            controller.columnERController.finishLoad((controller
                        .columnRows.items.length <
                    controller.columnRows.page * controller.columnRows.pageSize)
                ? IndicatorResult.noMore
                : IndicatorResult.success);
          },
        );
      },
    );
  }

  Widget _buildContent(physics) {
    return ScrollConfiguration(
      behavior: const ERScrollBehavior(),
      child: LoadingCheckWidget<int>(
        isLoading: controller.isColumnLoading,
        loading: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Spacer(),
              SizedBox(
                height: 10,
              ),
              Text("加载中..."),
              Spacer(),
            ],
          ),
        ),
        data: controller.columnRows.items.length,
        noData: CustomScrollView(
          controller: ScrollController(),
          physics: physics,
          slivers: [
            const HeaderLocator.sliver(clearExtent: false),
            SliverToBoxAdapter(
              child: SizedBox(
                height: Get.height - 250,
                width: Get.width,
                child: const Text("暂无专栏"),
              ),
            ),
            const FooterLocator.sliver()
          ],
        ),
        child: ExtendedNestedScrollView(
            controller: PrimaryScrollController.of(context),
            onlyOneScrollInBody: true,
            physics: physics,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                const HeaderLocator.sliver(clearExtent: false),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 10,
                    width: Get.width,
                  ),
                ),
              ];
            },
            body: CustomScrollView(physics: physics, slivers: [
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: controller.columnRows.items.length,
                      (context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Colours.greyF5F5F5, width: 4))),
                  child: ExpertColumnItem(
                      entity: controller.columnRows.items[index]),
                );
              }))
            ])),
      ),
    );
  }
}
