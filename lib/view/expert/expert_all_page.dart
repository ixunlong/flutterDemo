import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/expert/expert_all_page_controller.dart';
import 'package:sports/model/expert/expert_views_entity.dart';
import 'package:sports/widgets/no_data_widget.dart';

import '../../res/colours.dart';
import '../../res/routes.dart';
import '../../res/styles.dart';
import '../../widgets/common_button.dart';
import '../../widgets/custom_indicator.dart';
import '../../widgets/loading_check_widget.dart';
import 'expert_record_tag.dart';

class ExpertAllPage extends StatelessWidget {
  ExpertAllPage({Key? key}) : super(key: key);

  final controller = Get.put(ExpertAllPageController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpertAllPageController>(builder: (controller) {
      return Scaffold(
        appBar: Styles.appBar(
          title: SizedBox(
            height: 34,
            child: Styles.defaultTabBar(
              tabs: const [Text("足球"), Text("篮球")],
              controller: controller.tabController,
              isScrollable: true,
              indicatorBottom: 0,
              labelPadding: EdgeInsets.symmetric(horizontal: 12),
              fontSize: 18,
              onTap: (index) {
                controller.tabIndex = index;
                controller.getViews(index);
              },
            ),
          ),
        ),
        backgroundColor: Colours.greyFD,
        body: Column(
          children: [
            Expanded(
              child: EasyRefresh(
                header: const ClassicHeader(
                  dragText: "下拉刷新",
                  armedText: "松开刷新",
                  failedText: "刷新失败",
                  readyText: "正在刷新...",
                  processingText: "正在刷新...",
                  processedText: "刷新完成",
                  showMessage: false,
                  iconTheme: IconThemeData(color: Colours.text_color),
                  textStyle:
                      TextStyle(fontSize: 12, color: Colours.grey_color1),
                ),
                footer: ClassicFooter(
                  dragText: "上拉加载",
                  armedText: "松开加载",
                  failedText: "加载失败",
                  readyText: "正在加载更多的数据...",
                  processingText: "正在加载更多的数据...",
                  processedText: "加载完成",
                  noMoreText: "已加载全部专家",
                  showMessage: false,
                  iconDimension: 0,
                  succeededIcon: Container(),
                  failedIcon: Container(),
                  noMoreIcon: Container(),
                  textStyle:
                      const TextStyle(fontSize: 12, color: Colours.grey_color1),
                ),
                controller: controller.easyRefreshController,
                onRefresh: () async {
                  controller.setPage(1);
                  controller.getViews(controller.tabIndex);
                },
                onLoad: () async {
                  controller.setPage(null);
                  await controller.getViews(controller.tabIndex);
                  controller.easyRefreshController.finishLoad(
                      (controller.pages[controller.tabIndex].items.length >=
                              controller.pages[controller.tabIndex].total)
                          ? IndicatorResult.noMore
                          : IndicatorResult.success);
                },
                child: LoadingCheckWidget(
                  isLoading: controller.isLoading,
                  loading: Container(
                      width: Get.width,
                      height: 50,
                      alignment: Alignment.center,
                      child: const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colours.text_color, strokeWidth: 2))),
                  data: controller.pages[0].items.length +
                      controller.pages[1].items.length,
                  child: TabBarView(
                      controller: controller.tabController,
                      children: List.generate(
                          controller.pages.length,
                          (index) => LoadingCheckWidget<int>(
                                isLoading: controller.isLoading,
                                noData: const NoDataWidget(needScroll: true),
                                data: controller.pages[index].items.length,
                                child: MediaQuery.removePadding(
                                  removeTop: true,
                                  context: context,
                                  child: ListView.builder(
                                      itemBuilder: (context, childIndex) =>
                                          _cell(index, childIndex),
                                      itemCount:
                                          controller.pages[index].items.length),
                                ),
                              ))),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  _cell(int index, int childIndex) {
    Rows data = controller.pages[index].items[childIndex];
    return Container(
      color: Colours.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.expertDetail,
                            arguments: data.expertId!,
                            parameters: {"index": "$index"});
                      },
                      child: Container(
                          width: Get.width / 2,
                          height: 50,
                          color: Colours.transparent,
                          child: _expertInfoWidget(data))),
                  CommonButton(
                    onPressed: () {
                      controller.isFocus[index][childIndex]
                          ? controller.setFocus(
                              data.expertId, index, childIndex)
                          : controller.setFocus(
                              data.expertId, index, childIndex);
                    },
                    minHeight: 24,
                    minWidth: 56,
                    side: BorderSide(
                        color: controller.isFocus[index][childIndex]
                            ? Colours.grey_color1
                            : Colours.main_color,
                        width: 0.5),
                    text: controller.isFocus[index][childIndex] ? '已关注' : '关注',
                    textStyle: TextStyle(
                        fontSize: 13,
                        height: 1.3,
                        fontWeight: FontWeight.w400,
                        color: controller.isFocus[index][childIndex]
                            ? Colours.grey_color1
                            : Colours.main_color),
                  )
                ]),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16),
            height: 0.5,
            color: Colours.grey_color2,
          )
        ],
      ),
    );
  }

  Widget _expertInfoWidget(entity) {
    return GestureDetector(
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colours.greyEE, width: 0.5)),
            child: ClipOval(
                child: CachedNetworkImage(
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              imageUrl: entity.expertLogo ?? '',
            )),
          ),
          Container(width: 7),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entity.expertName ?? '',
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    entity.firstTag == null || entity.firstTag == ''
                        ? Container()
                        : ExpertRecordTag(
                            tagType: TagType.firstTag, text: entity.firstTag),
                    Container(width: 8),
                    entity.secondTag == null || entity.secondTag == ''
                        ? Container()
                        : ExpertRecordTag(
                            tagType: TagType.secondTag, text: entity.secondTag)
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
