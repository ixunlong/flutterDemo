import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:sports/logic/team/basketball/bb_team_count_controller.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/common_button.dart';
import 'package:sports/widgets/cupertino_picker_widget.dart';
import 'package:sports/widgets/no_data_widget.dart';

class BasketTeamCountView extends StatefulWidget {
  const BasketTeamCountView({super.key});

  @override
  State<BasketTeamCountView> createState() => _BasketTeamCountViewState();
}

class _BasketTeamCountViewState extends State<BasketTeamCountView> {
  BbTeamCountController controller =
      Get.put(BbTeamCountController(), tag: '${Get.arguments}');
  List<String> paimingTitle = ['排名', '总胜负', '主胜/负', '客胜/负'];
  List<String> shujuTitle = ['排名', '总胜负', '主胜/负', '客胜/负'];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BbTeamCountController>(
      tag: '${Get.arguments}',
      builder: (_) {
        return Container(
          color: Colours.greyF7,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: controller.yearData == null
                ? Container()
                : (controller.yearData!.isEmpty
                    ? NoDataWidget()
                    : Column(
                        children: [
                          if (controller.nation == 1) _pageChoice(),
                          Expanded(
                            child: ListView(
                              children: [
                                SizedBox(height: 10),
                                paiming(),
                                SizedBox(height: 10),
                                shuju()
                              ],
                            ),
                          ),
                        ],
                      )),
          ),
        );
      },
    );
  }

  Widget _pageChoice() {
    return Container(
      color: Colours.white,
      padding: const EdgeInsets.only(left: 12, right: 8, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
              // await controller.showDatePicker();
              // await controller.requestData();
              // await Future.delayed(const Duration(microseconds: 500)).then(
              //     (value) => controller.observerController.jumpTo(
              //         index: controller.years[controller.yearIndex].year
              //                     .toString() ==
              //                 DateTime.now().formatedString('yyyy')
              //             ? controller.data?.matchGroup?.indexWhere((element) =>
              //                     element.title ==
              //                     DateTime.now().formatedString('yyyy-MM')) ??
              //                 0
              //             : (controller.data?.matchGroup?.length ?? 1) - 1));
            },
            child: Container(
              height: 24,
              width: 58,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 6, right: 2),
              decoration: BoxDecoration(
                  color: Colours.greyF5F7FA,
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        Utils.parseYear(controller
                                .yearData![controller.yearIndex1].seasonYear ??
                            ''),
                        strutStyle: Styles.centerStyle(fontSize: 12),
                        style: const TextStyle(
                            fontSize: 12, color: Colours.text_color)),
                    const SizedBox(width: 2),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Image.asset(Utils.getImgPath('down_arrow.png')),
                    )
                  ]),
            ),
          ),
          Container(width: 5),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                    controller.yearData!.length,
                    (childIndex) => Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () async {
                              // controller.getType(childIndex);
                            },
                            child: Container(
                              height: 24,
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: controller.leagueIndex3 == childIndex
                                      ? Colours.redFFECEE
                                      : Colours.white),
                              child: Text(
                                  controller.yearData![controller.yearIndex3]
                                          .leagueInfo![childIndex].leagueName ??
                                      "",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          controller.leagueIndex3 == childIndex
                                              ? Colours.main_color
                                              : Colours.text_color),
                                  strutStyle: Styles.centerStyle(fontSize: 14)),
                            ),
                          ),
                        )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget paiming() {
    // final selectScope = controller.nation == 1
    //     ? controller.scopeIndex3
    //     : controller.scopeIndex1;
    return Container(
      decoration: BoxDecoration(
          color: Colours.white,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      margin: EdgeInsets.symmetric(horizontal: 12),
      padding: EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('球队排名',
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(controller.getQiuduiScope().length,
                      (index) {
                    return GestureDetector(
                      onTap: () {
                        controller.changeScope1(index);
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          height: 22,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              color: controller.scopeIndex1 == index
                                  ? Colours.main_color
                                  : Colours.greyF5F5F5),
                          // width: 52,
                          child: Text(
                            (controller.getQiuduiScope()[index].scopeName ??
                                    '') +
                                (controller.getQiuduiScope()[index].stageName ??
                                    ''),
                            style: TextStyle(
                                color: controller.scopeIndex1 == index
                                    ? Colours.white
                                    : Colours.grey_color,
                                fontSize: 12),
                          )),
                    );

                    // Container(
                    //   margin: EdgeInsets.onlyright: 10),
                    //   // padding: EdgeInsets.symmetric(horizontal: 8),
                    //   height: 22,
                    //   // width: 52,
                    //   child: CommonButton(
                    //     onPressed: () {
                    //       controller.changeScope1(index);
                    //     },
                    //     text: (controller
                    //                 .yearData![controller.yearIndex1]
                    //                 .leagueInfo![controller.leagueIndex1]
                    //                 .scope![index]
                    //                 .scopeName ??
                    //             '') +
                    //         (controller
                    //                 .yearData![controller.yearIndex1]
                    //                 .leagueInfo![controller.leagueIndex1]
                    //                 .scope![index]
                    //                 .stageName ??
                    //             ''),
                    //     textStyle: TextStyle(
                    //         fontWeight: FontWeight.w400, fontSize: 12),
                    //     padding: EdgeInsets.symmetric(horizontal: 8),
                    //     backgroundColor: controller.scopeIndex1 == index
                    //         ? Colours.main_color
                    //         : Colours.greyF5F5F5,
                    //     foregroundColor: controller.scopeIndex1 == index
                    //         ? Colours.white
                    //         : Colours.grey_color,
                    //     // radius: 6,
                    //   ),
                    // );
                  }),
                ),
              ),
            ),
            SizedBox(width: 10),
            SizedBox(
                height: 22,
                width: 61,
                child: _selectButton(
                    Utils.parseYear(controller
                            .yearData![controller.yearIndex1].seasonYear ??
                        ''), () async {
                  final yearList = controller.yearData!
                      .map((e) => Utils.parseYear(e.seasonYear!))
                      .toList();
                  final result = await Get.bottomSheet(CupertinoPickerWidget(
                    yearList,
                    title: '选择年份',
                    initialIndex: controller.yearIndex1,
                  ));
                  if (result != null) {
                    controller.changeYear1(result);
                  }
                })),
          ],
        ),
        SizedBox(height: 16),
        Wrap(
          children: [
            data('排名', controller.teamRank?.teamRank ?? '-'),
            data('总胜负', controller.teamRank?.victoryOrDefeatTotal ?? '-'),
            data('主胜/负', controller.teamRank?.victoryOrDefeatHome ?? '-'),
            data('客胜/负', controller.teamRank?.victoryOrDefeatAway ?? '-')
          ],
          spacing: (Get.width - 56 - 240 - 1) / 3,

          // alignment: WrapAlignment.end,
          // crossAxisAlignment: WrapCrossAlignment.end,
          // runAlignment: WrapAlignment.center,
        )
      ]),
    );
  }

  Widget shuju() {
    return Container(
      decoration: BoxDecoration(
          color: Colours.white,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      margin: EdgeInsets.symmetric(horizontal: 12),
      padding: EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('球队数据',
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                      controller
                          .yearData![controller.yearIndex1]
                          .leagueInfo![controller.leagueIndex1]
                          .scope!
                          .length, (index) {
                    return GestureDetector(
                      onTap: () {
                        controller.changeScope2(index);
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          height: 22,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              color: controller.scopeIndex2 == index
                                  ? Colours.main_color
                                  : Colours.greyF5F5F5),
                          // width: 52,
                          child: Text(
                            (controller
                                        .yearData![controller.yearIndex2]
                                        .leagueInfo![controller.leagueIndex2]
                                        .scope![index]
                                        .scopeName ??
                                    '') +
                                (controller
                                        .yearData![controller.yearIndex2]
                                        .leagueInfo![controller.leagueIndex2]
                                        .scope![index]
                                        .stageName ??
                                    ''),
                            style: TextStyle(
                                color: controller.scopeIndex2 == index
                                    ? Colours.white
                                    : Colours.grey_color,
                                fontSize: 12),
                          )),
                    );

                    // Container(
                    //   margin: EdgeInsets.only(right: 10),
                    //   // padding: EdgeInsets.symmetric(horizontal: 8),
                    //   height: 22,
                    //   // width: 52,
                    //   child: CommonButton(
                    //     onPressed: () {
                    //       controller.changeScope2(index);
                    //     },
                    // text: (controller
                    //             .yearData![controller.yearIndex2]
                    //             .leagueInfo![controller.leagueIndex2]
                    //             .scope![index]
                    //             .scopeName ??
                    //         '') +
                    //     (controller
                    //             .yearData![controller.yearIndex2]
                    //             .leagueInfo![controller.leagueIndex2]
                    //             .scope![index]
                    //             .stageName ??
                    //         ''),
                    //     textStyle: TextStyle(
                    //         fontWeight: FontWeight.w400, fontSize: 12),
                    //     padding: EdgeInsets.symmetric(horizontal: 8),
                    //     backgroundColor: controller.scopeIndex2 == index
                    //         ? Colours.main_color
                    //         : Colours.greyF5F5F5,
                    //     foregroundColor: controller.scopeIndex2 == index
                    //         ? Colours.white
                    //         : Colours.grey_color,
                    //     // radius: 6,
                    //   ),
                    // );
                  }),
                ),
              ),
            ),
            SizedBox(width: 10),
            SizedBox(
                height: 22,
                width: 61,
                child: _selectButton(
                    Utils.parseYear(controller
                            .yearData![controller.yearIndex2].seasonYear ??
                        ''), () async {
                  final yearList = controller.yearData!
                      .map((e) => Utils.parseYear(e.seasonYear!))
                      .toList();
                  final result = await Get.bottomSheet(CupertinoPickerWidget(
                    yearList,
                    title: '选择年份',
                    initialIndex: controller.yearIndex2,
                  ));
                  if (result != null) {
                    controller.changeYear2(result);
                  }
                })),
          ],
        ),
        SizedBox(height: 16),
        Wrap(
          children: [
            data('得分', '${controller.teamData?.points ?? '-'}',
                rank: controller.teamData?.pointsRank),
            data('篮板', '${controller.teamData?.rebounds ?? '-'}',
                rank: controller.teamData?.reboundsRank),
            data('助攻', '${controller.teamData?.assists ?? '-'}',
                rank: controller.teamData?.assistsRank),
            data('抢断', '${controller.teamData?.steals ?? '-'}',
                rank: controller.teamData?.stealsRank),
            data('盖帽', '${controller.teamData?.blocks ?? '-'}',
                rank: controller.teamData?.blocksRank),
            data('失误', '${controller.teamData?.turnovers ?? '-'}',
                rank: controller.teamData?.turnoversRank),
            data('投篮命中率', controller.teamData?.fieldGoalsAccuracy ?? '-',
                rank: controller.teamData?.fieldGoalsAccuracyRank),
            data('三分命中率', controller.teamData?.threePointsAccuracy ?? '-',
                rank: controller.teamData?.threePointsAccuracyRank)
          ],
          spacing: (Get.width - 56 - 240 - 1) / 3,
          runSpacing: 16,
          // alignment: WrapAlignment.end,
          // crossAxisAlignment: WrapCrossAlignment.end,
          // runAlignment: WrapAlignment.center,
        )
      ]),
    );
  }

  Widget data(String title, String data, {String? rank}) {
    return Container(
      width: 60,
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            data,
            style: TextStyle(
                fontSize: 18,
                color: Colours.text_color1,
                fontFamily: 'Din',
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colours.grey66),
          ),
          if (rank != null)
            Text(
              rank,
              style: TextStyle(fontSize: 12, color: Colours.main),
            )
        ],
      ),
    );
  }

  Widget _selectButton(String title, Function f) {
    return TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          side: MaterialStateProperty.all<BorderSide>(
            BorderSide(width: 0.5, color: Colours.grey_color),
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        onPressed: () => f(),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 12,
                color: Colours.grey_color,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(width: 4),
          Image.asset(Utils.getImgPath('down_arrow.png'))
        ]));
  }
}
