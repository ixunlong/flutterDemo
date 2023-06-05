import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/match/soccer_match_odds_controller.dart';
import 'package:sports/model/match/soccer_odds_entity.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/loading_check_widget.dart';
import 'package:sports/widgets/no_data_widget.dart';

import '../../../res/colours.dart';
import '../../../widgets/common_button.dart';

class SoccerMatchOddsView extends StatefulWidget {
  const SoccerMatchOddsView({Key? key}) : super(key: key);

  @override
  State<SoccerMatchOddsView> createState() => _SoccerMatchOddsViewState();
}

class _SoccerMatchOddsViewState extends State<SoccerMatchOddsView> {
  final controller = Get.put(SoccerMatchOddsController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SoccerMatchOddsController>(builder: (controller) {
      return Column(
        children: [
          Container(
            color: Colours.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                  controller.typeList.length,
                  (childIndex) => Flexible(
                        flex: 1,
                        child: CommonButton(
                          minWidth: 60,
                          minHeight: 24,
                          onPressed: () async {
                            Utils.onEvent("zqbsxq_zs",
                                params: {"zqbsxq_zs": childIndex});
                            controller.typeIndex = childIndex;
                            controller.requestData();
                          },
                          text: controller.typeList[childIndex],
                          backgroundColor: controller.typeIndex == childIndex
                              ? Colours.redFFECEE
                              : Colours.white,
                          textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: controller.typeIndex == childIndex
                                  ? Colours.main_color
                                  : Colours.grey66),
                        ),
                      )),
            ),
          ),
          Expanded(
            child: EasyRefresh.builder(
              onRefresh: () async {
                await controller.requestData();
              },
              childBuilder: (context, physics) {
                return LoadingCheckWidget<int>(
                  isLoading: false,
                  data: controller.data.length,
                  noData: NoDataWidget(needScroll: true,tip:"暂无${controller.typeList[controller.typeIndex]}数据"),
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colours.greyF5F5F5,width: 10))),
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                controller.data.length + 1,
                                (index) => Container(
                                  height: index == 0 ? 30 : 60,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(left: 16),
                                  color: index % 2 == 0
                                    ? Colours.greyF5F7FA
                                    : Colours.white,
                                  child: Text(
                                    index == 0
                                      ? "公司"
                                      : controller.data[index - 1]
                                        .companyName ?? "",
                                    style: Styles.normalText(
                                      fontSize: 11)))
                                .tap(() {
                              if (index != 0) {
                                Utils.onEvent("zqbsxq_zs",
                                  params: {"zqbsxq_zs": 4});
                                Get.toNamed(Routes.soccerOddsDetail,
                                  arguments: [
                                    controller.data[index - 1].companyId,
                                    controller.detail.matchId,
                                    controller.typeIndex
                                  ]);
                              }
                            })),
                            ),
                          ),
                          Expanded(
                              flex: 8,
                              child: SingleChildScrollView(
                                // physics: const ClampingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  children: List.generate(
                                    controller.data.length + 1,
                                    (index) => index == 0
                                      ? header()
                                      : item(controller.data[index - 1],
                                        index)),
                                )).paddingOnly(right: 16)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      );
    });
  }

  Widget item(SoccerOddsEntity entity, int index) {
    var firstData = controller.formSingleLine(entity.firstData ?? []);
    var lastData = controller.formSingleLine(entity.lastData ?? []);
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.soccerOddsDetail, arguments: [
        controller.data[index - 1].companyId,
        controller.detail.matchId,
        controller.typeIndex
      ]),
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(vertical: 10),
        color: index % 2 == 0 ? Colours.greyF5F7FA : Colours.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (controller.typeIndex == 2)
                  Container(
                    width: 30,
                    child: Text(entity.line ?? "",
                            style: const TextStyle(
                                fontSize: 12, color: Colours.text_color))
                        .center,
                  ),
                Container(
                  width: 30,
                  alignment: Alignment.center,
                  child: Text("初", style: Styles.normalSubText(fontSize: 11))),
                Container(
                  width: 52,
                  alignment: Alignment.center,
                  child: firstData[0]),
                Container(
                  width: 52,
                  alignment: Alignment.center,
                  child: (controller.typeIndex == 1 || controller.typeIndex == 3
                    ? Text(entity.line ?? "", style: const TextStyle(fontSize: 12,
                      color: Colours.text_color))
                    : firstData[1]),
                ),
                Container(
                  width: 52,
                  alignment: Alignment.center,
                  child: firstData[2]),
                Container(
                  width: 110,
                  alignment: Alignment.center,
                  child: firstData[3]),
                Container(
                  width: 60,
                  alignment: Alignment.center,
                  child: Text(
                    entity.firstRate.isNullOrEmpty ? ""
                      : "${(double.parse(entity.firstRate!) * 100).toStringAsFixed(2)}%",
                    style: const TextStyle(
                      fontSize: 12, color: Colours.text_color)),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (controller.typeIndex == 2)
                  Container(
                    width: 30,
                    alignment: Alignment.center,
                    child: Text(entity.line ?? "",
                      style: const TextStyle(
                        fontSize: 12, color: Colours.text_color)),
                  ),
                Container(
                    width: 30,
                    alignment: Alignment.center,
                    child: Text("即", style: TextStyle(fontSize: 11,color: Colours.grey99))),
                Container(
                    width: 52,
                    alignment: Alignment.center,
                    child: lastData[0]),
                Container(
                  width: 52,
                  alignment: Alignment.center,
                  child: (controller.typeIndex == 1 || controller.typeIndex == 3
                      ? Text(entity.line ?? "", style: const TextStyle(fontSize: 12,
                      color: Colours.text_color))
                      : lastData[1]),
                ),
                Container(
                    width: 52,
                    alignment: Alignment.center,
                    child: lastData[2]),
                Container(
                    width: 110,
                    alignment: Alignment.center,
                    child: lastData[3]),
                Container(
                  width: 60,
                  alignment: Alignment.center,
                  child: Text(
                      entity.lastRate.isNullOrEmpty ? ""
                          : "${(double.parse(entity.lastRate!) * 100).toStringAsFixed(2)}%",
                      style: const TextStyle(
                          fontSize: 12, color: Colours.text_color)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Container(
      height: 30,
      color: Colours.greyF5F7FA,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (controller.typeIndex == 2)
            Container(
              width: 30,
              alignment: Alignment.center,
              child: Text("让",
                  style: const TextStyle(
                      fontSize: 12, color: Colours.text_color)),
            ),
          Container(
              width: 30,
              alignment: Alignment.center,
              child: Text("即", style: TextStyle(fontSize: 11,color: Colours.transparent))),
          Container(
              width: 52,
              alignment: Alignment.center,
              child: Text(controller.headTypeList[0],
                  style: TextStyle(fontSize: 12, color: Colours.text_color))),
          Container(
            width: 52,
            alignment: Alignment.center,
            child: Text(controller.headTypeList[1],
                style: TextStyle(fontSize: 12, color: Colours.text_color)),
          ),
          Container(
              width: 52,
              alignment: Alignment.center,
              child: Text(controller.headTypeList[2],
                  style: TextStyle(fontSize: 12, color: Colours.text_color))),
          Container(
              width: 110,
              alignment: Alignment.center,
              child: Text("凯利",
                  style: TextStyle(fontSize: 12, color: Colours.text_color))),
          Container(
            width: 60,
            alignment: Alignment.center,
            child: Text("返还率",
                style: TextStyle(fontSize: 12, color: Colours.text_color))
          )
        ],
      ),
    );
  }
}
