import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/match/basket_match_data_controller.dart';
import 'package:sports/model/match/basket_match_data_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/date_utils_extension.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/common_button.dart';
import 'package:sports/widgets/cupertino_picker_widget.dart';
import 'package:sports/widgets/ladder_path.dart';
import 'dart:math' as math;

import 'package:sports/widgets/no_data_widget.dart';

class BbDetailDataView extends StatefulWidget {
  const BbDetailDataView({super.key});

  @override
  State<BbDetailDataView> createState() => _BbDetailDataViewState();
}

class _BbDetailDataViewState extends State<BbDetailDataView> {
  final controller =
      Get.put(BasketMatchDataController(), tag: '${Get.arguments}');

  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BasketMatchDataController>(
        tag: '${Get.arguments}',
        builder: (_) {
          return controller.firstInit
              ? Container()
              : (controller.isEmpty()
                  ? NoDataWidget()
                  : ListView(
                      children: [
                        if (!controller.teamInfoEmpty() ||
                            !controller.teamAvgEmpty()) ...[
                          SizedBox(height: 10),
                          ratio(),
                        ],
                        if (controller.data?.vsHistory.hasValue == true) ...[
                          const SizedBox(height: 10),
                          Container(
                            color: Colours.white,
                            padding:
                                EdgeInsets.only(left: 16, top: 16, bottom: 16),
                            child: Text('两队交锋',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16)),
                          ),
                          _matchTable(0),
                        ],
                        if (controller.data?.homeHistory.hasValue == true ||
                            controller.data?.awayHistory.hasValue == true) ...[
                          const SizedBox(height: 10),
                          Container(
                            color: Colours.white,
                            padding:
                                EdgeInsets.only(left: 16, top: 16, bottom: 16),
                            child: Text('近期战绩',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16)),
                          ),
                        ],
                        if (controller.data?.homeHistory.hasValue == true)
                          _matchTable(1),
                        if (controller.data?.awayHistory.hasValue == true)
                          _matchTable(2),
                        if (controller.data?.homeFuture.hasValue == true ||
                            controller.data?.awayFuture.hasValue == true) ...[
                          const SizedBox(height: 10),
                          Container(
                            color: Colours.white,
                            padding:
                                EdgeInsets.only(left: 16, top: 16, bottom: 16),
                            child: Text('近期比赛',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16)),
                          ),
                        ],
                        if (controller.data?.homeFuture.hasValue == true)
                          _recentMatch(0),
                        if (controller.data?.awayFuture.hasValue == true)
                          _recentMatch(1),
                        SizedBox(height: 50)
                      ],
                    ));
        });
  }

  Widget ratio() {
    return GetBuilder<BasketMatchDataController>(
        tag: '${Get.arguments}',
        builder: (_) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipPath(
                      clipper: LadderPath(false),
                      child: Container(
                          width: Get.width / 2,
                          height: 34,
                          color: controller.currentTab == 0
                              ? Colours.white
                              : Colours.transparent,
                          alignment: Alignment.center,
                          child: Text("球队对比",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: controller.currentTab == 0
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: controller.currentTab == 0
                                    ? Colours.main
                                    : Colours.grey66,
                              )))).tap(() {
                    controller.currentTab = 0;
                    update();
                    // tabController.animateTo(0);
                  }),
                  ClipPath(
                      clipper: LadderPath(true),
                      child: Container(
                          width: Get.width / 2,
                          height: 34,
                          color: controller.currentTab == 1
                              ? Colours.white
                              : Colours.transparent,
                          alignment: Alignment.center,
                          child: Text("场均对比",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: controller.currentTab == 1
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: controller.currentTab == 1
                                    ? Colours.main
                                    : Colours.grey66,
                              )))).tap(() {
                    controller.currentTab = 1;
                    update();

                    // tabController.animateTo(1);
                  }),
                ],
              ),
              Container(
                color: Colours.white,
                child: Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(children: [
                        CachedNetworkImage(
                          imageUrl:
                              controller.teamData?.awayInfo?.teamLogo ?? '',
                          width: 32,
                        ),
                        SizedBox(width: 2),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.teamData?.awayInfo?.teamName ?? '',
                              style: TextStyle(color: Colours.text_color1),
                            ),
                            Text(
                              '${controller.teamData?.awayInfo?.record ?? ''} ${controller.teamData?.awayInfo?.recentRecord ?? ''}',
                              style: TextStyle(
                                  color: Colours.grey99, fontSize: 12),
                            )
                          ],
                        )
                      ]),
                    ),
                    Spacer(),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              controller.teamData?.homeInfo?.teamName ?? '',
                              style: TextStyle(color: Colours.text_color1),
                            ),
                            Text(
                              '${controller.teamData?.homeInfo?.recentRecord ?? ''} ${controller.teamData?.homeInfo?.record ?? ''}',
                              style: TextStyle(
                                  color: Colours.grey99, fontSize: 12),
                            )
                          ],
                        ),
                        SizedBox(width: 2),
                        CachedNetworkImage(
                          imageUrl:
                              controller.teamData?.homeInfo?.teamLogo ?? '',
                          width: 32,
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
              if (controller.currentTab == 0) teamInfo() else teamAvg(),

              // SizedBox(
              //   height: 36 * 5 + 30,
              //   child: TabBarView(
              //       controller: tabController,
              //       physics: NeverScrollableClampingScrollPhysics(),
              //       children: List.generate(2, (index) => _lineupList())),
              // ),
              // Container(
              //   color: Colours.white,
              //   height: 36,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text("首发", style: Styles.normalText(fontSize: 12)),
              //       Container(width: 16),
              //       Text("在场", style: Styles.normalText(fontSize: 12))
              //     ],
              //   ),
              // )
            ],
          );
        });
  }

  Widget teamInfo() {
    List<List> data = controller.getTeamInfoData();
    int length = (data.length > 5 && !expanded) ? 5 : data.length;
    return controller.teamInfoEmpty(includeRecent: false)
        ? Container(
            color: Colours.white,
            child: NoDataWidget(
              needPic: false,
            ))
        : AnimatedSize(
            duration: Duration(milliseconds: 300),
            alignment: Alignment.topCenter,
            child: Container(
              color: Colours.white,
              padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Column(children: [
                ...List.generate(length, (index) {
                  return _techLine(data[index][0],
                      leftNum: data[index][1], rightNum: data[index][2]);
                }),
                if (data.length > 5) ...[
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      expanded = !expanded;
                      update();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          expanded ? '收起数据' : "更多数据",
                          style: TextStyle(color: Colours.main, fontSize: 12),
                        ),
                        Icon(
                          expanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: Colours.main,
                        )
                      ],
                    ),
                  )
                ]
              ]),
            ),
          );
  }

  Widget teamAvg() {
    List<List> data = controller.getTeamAvgData();
    // if (data.length == 0) {
    //   return Container();
    // }

    int length = (data.length > 5 && !expanded) ? 5 : data.length;
    return controller.teamAvgEmpty()
        ? Container(color: Colours.white, child: NoDataWidget(needPic: false))
        : AnimatedSize(
            duration: Duration(milliseconds: 300),
            alignment: Alignment.topCenter,
            child: Container(
              color: Colours.white,
              padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Column(children: [
                ...List.generate(length, (index) {
                  return _techLine(data[index][0],
                      leftNum: data[index][1], rightNum: data[index][2]);
                }),
                if (data.length > 5) ...[
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      expanded = !expanded;
                      update();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          expanded ? '收起数据' : "更多数据",
                          style: TextStyle(color: Colours.main, fontSize: 12),
                        ),
                        Icon(
                          expanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: Colours.main,
                        )
                      ],
                    ),
                  )
                ]
              ]),
            ),
          );
  }

  Widget _techLine(String name, {String leftNum = '0', String rightNum = '0'}) {
    double left = double.parse(leftNum);
    double right = double.parse(rightNum);
    bool leftWin = left > right;
    String leftStr = '$left';
    String rightStr = '$right';
    if (name == '胜率' || name == '近10场' || name == '主场' || name == '客场') {
      leftStr += '%';
      rightStr += '%';
    }
    return Container(
      // height: 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                leftStr,
                style: TextStyle(
                    color: left >= right ? Colours.black : Colours.grey66,
                    fontFamily: "Din",
                    fontSize: 16),
              ),
              Text(
                "$name",
                style: TextStyle(fontSize: 12, color: Colours.grey66),
              ),
              Text(
                rightStr,
                style: TextStyle(
                    color: left > right ? Colours.grey66 : Colours.black,
                    fontFamily: "Din",
                    fontSize: 16),
              )
            ],
          ),
          SizedBox(height: 6),
          Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                    color: Colours.greyF7,
                    borderRadius: BorderRadius.all(Radius.circular(2))),
              ),
              Positioned(
                left: 0,
                right: (Get.width - 32) / 2,
                child: Row(children: [
                  Spacer(),
                  Container(
                    height: 6,
                    width:
                        (left == 0 && right == 0 ? 0 : left / (left + right)) *
                            ((Get.width - 32) / 2),
                    decoration: BoxDecoration(
                        color: left >= right
                            ? Colours.guestColorBlue
                            : Colours.greyD7,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(2),
                            bottomLeft: Radius.circular(2))),
                  )
                ]),
              ),
              Positioned(
                left: (Get.width - 32) / 2,
                right: 0,
                child: Row(children: [
                  Container(
                    height: 6,
                    width:
                        (left == 0 && right == 0 ? 0 : right / (left + right)) *
                            ((Get.width - 32) / 2),
                    decoration: BoxDecoration(
                        color: left > right ? Colours.greyD7 : Colours.main,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(2),
                            bottomRight: Radius.circular(2))),
                  ),
                  Spacer()
                ]),
              )
            ],
          ),
          SizedBox(height: 6),
        ],
      ),
    );
  }

  ///两队比赛数据表
  ///0 交锋
  ///1 主队战绩
  ///2 客队战绩
  Widget _matchTable(int type) {
    // final title = type == 0 ? '两队交锋' : '近期战绩';
    bool sameHome = false;
    bool sameLeague = false;
    List<VsList> vsList = [];
    // int zhishuType = 0;
    int matchNumType = 0;
    if (type == 0) {
      vsList = controller.vsList ?? [];
      sameHome = controller.jiaofengSameHomeVs;
      sameLeague = controller.jiaofengsSameLeagueVs;
      // zhishuType = controller.vsType1;
      matchNumType = controller.vsType2;
    } else if (type == 1) {
      vsList = controller.homeRecentVs ?? [];
      sameHome = controller.homeSameHomeRecent;
      sameLeague = controller.homeSameLeagueRecent;
      // zhishuType = controller.homeRecentType1;
      matchNumType = controller.homeRecentType2;
    } else {
      vsList = controller.guestRecentVs ?? [];
      sameHome = controller.guestSameHomeRecent;
      sameLeague = controller.guestSameLeagueRecent;
      // zhishuType = controller.guestRecentType1;
      matchNumType = controller.guestRecentType2;
    }
    // List goalAndLost = controller.getGoalAndLost(type);
    List winPercentage = controller.getOddsWinPercentage(type);
    List ahPercentage = controller.getAhWinPercentage(type);
    List sbPercentage = controller.getSbWinPercentage(type);
    List dlPercentage = controller.getDlPercentage(type);
    final tableTitle = [
      '日期/赛事',
      '客队',
      '比分',
      '主队',
      '让分',
      '总分',
    ];
    // final type1 = [
    //   '初指',
    //   '终指',
    // ];
    final type2 = [
      '近6场',
      '近10场',
      '近20场',
    ];
    return Container(
      color: Colours.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visibility(
          //   visible: type != 2,
          //   child: Text(title,
          //       style:
          //           const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
          // ),
          // Visibility(
          //   visible: type != 2,
          //   child: const SizedBox(height: 15),
          // ),
          Visibility(
            visible: type != 0,
            child: Row(
              children: [
                CachedNetworkImage(
                  width: 21,
                  height: 21,
                  imageUrl: (type == 1
                          ? controller.data?.currentMatchInfo?.homeLogo
                          : controller.data?.currentMatchInfo?.awayLogo) ??
                      '',
                  placeholder: (context, url) => Styles.placeholderIcon(),
                  errorWidget: (context, url, error) => Image.asset(
                    Utils.getImgPath('basket_team_logo.png'),
                    width: 21,
                    height: 21,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  (type == 1
                          ? controller.data?.currentMatchInfo?.homeName
                          : controller.data?.currentMatchInfo?.awayName) ??
                      '',
                  style:
                      const TextStyle(fontSize: 14, color: Colours.text_color1),
                )
              ],
            ),
          ),
          Visibility(visible: type != 0, child: const SizedBox(height: 10)),
          Row(
            children: [
              SizedBox(
                height: 22,
                width: 52,
                child: CommonButton(
                  onPressed: () {
                    Utils.onEvent('lqbspd_lqbsxq',
                        params: {'lqbspd_lqbsxq': '8'});
                    if (type == 0) {
                      controller.jiaofengSameHomeVs =
                          !controller.jiaofengSameHomeVs;
                    } else if (type == 1) {
                      controller.homeSameHomeRecent =
                          !controller.homeSameHomeRecent;
                    } else {
                      controller.guestSameHomeRecent =
                          !controller.guestSameHomeRecent;
                    }
                  },
                  text: '同主客',
                  textStyle:
                      TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                  backgroundColor:
                      sameHome ? Colours.main_color : Colours.greyF5F5F5,
                  foregroundColor:
                      sameHome ? Colours.white : Colours.grey_color,
                  // radius: 6,
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 22,
                width: 52,
                child: CommonButton(
                  onPressed: () {
                    Utils.onEvent('lqbspd_lqbsxq',
                        params: {'lqbspd_lqbsxq': '9'});
                    if (type == 0) {
                      controller.jiaofengsSameLeagueVs =
                          !controller.jiaofengsSameLeagueVs;
                    } else if (type == 1) {
                      controller.homeSameLeagueRecent =
                          !controller.homeSameLeagueRecent;
                    } else {
                      controller.guestSameLeagueRecent =
                          !controller.guestSameLeagueRecent;
                    }
                  },
                  text: '同赛事',
                  textStyle:
                      TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                  backgroundColor:
                      sameLeague ? Colours.main_color : Colours.greyF5F5F5,
                  foregroundColor:
                      sameLeague ? Colours.white : Colours.grey_color,
                  // radius: 6,
                ),
              ),
              const Spacer(),
              const SizedBox(width: 10),
              SizedBox(
                  height: 22,
                  width: 65,
                  child: _selectButton('${type2[matchNumType]}', () async {
                    var initialIndex = 0;
                    String? eventId;
                    if (type == 0) {
                      initialIndex = controller.vsType2;
                    } else if (type == 1) {
                      initialIndex = controller.homeRecentType2;
                    } else {
                      initialIndex = controller.guestRecentType2;
                    }
                    final result = await Get.bottomSheet(CupertinoPickerWidget(
                      type2,
                      title: '选择场数',
                      initialIndex: initialIndex,
                    ));
                    if (result != null) {
                      if (result == 1) {
                        Utils.onEvent('lqbspd_lqbsxq',
                            params: {'lqbspd_lqbsxq': '6'});
                      } else if (result == 2) {
                        Utils.onEvent('lqbspd_lqbsxq',
                            params: {'lqbspd_lqbsxq': '7'});
                      }
                      controller.selectMatchNumType(type, result);
                    }
                  })),
            ],
          ),
          const SizedBox(height: 10),
          vsList.isEmpty
              ? Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: Text(
                    '暂无近期记录',
                    style: TextStyle(color: Colours.grey66),
                  ),
                )
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: Colours.greyD9,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(2),
                                      topRight: Radius.circular(2))),
                              width: 41,
                              height: 20,
                              alignment: Alignment.center,
                              child: Text(type == 0 ? '主队' : '近',
                                  style: TextStyle(fontSize: 12))),
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(2),
                                      bottomRight: Radius.circular(2)),
                                  border: Border.all(
                                      width: 1, color: Colours.greyD9)),
                              width: 41,
                              height: 20,
                              alignment: Alignment.center,
                              child: Text('${vsList.length}场',
                                  style: TextStyle(fontSize: 12))),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                const Text(
                                  '胜率 ',
                                  style: TextStyle(
                                      fontSize: 12, color: Colours.text_color),
                                ),
                                Text(
                                  '${winPercentage[0]}%',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colours.main_color),
                                ),
                              ]),
                          Text(
                            '${winPercentage[1]}胜${winPercentage[2]}负',
                            style: const TextStyle(
                                fontSize: 10, color: Colours.grey_color1),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                const Text(
                                  '赢率 ',
                                  style: TextStyle(
                                      fontSize: 12, color: Colours.text_color),
                                ),
                                Text(
                                  '${ahPercentage[0]}%',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colours.main_color),
                                ),
                              ]),
                          Text(
                            '${ahPercentage[1]}赢${ahPercentage[2]}走${ahPercentage[3]}输',
                            style: const TextStyle(
                                fontSize: 10, color: Colours.grey_color1),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                const Text(
                                  '大率 ',
                                  style: TextStyle(
                                      fontSize: 12, color: Colours.text_color),
                                ),
                                Text(
                                  '${sbPercentage[0]}%',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colours.main_color),
                                ),
                              ]),
                          Text(
                            '${sbPercentage[1]}大${sbPercentage[2]}走${sbPercentage[3]}小',
                            style: const TextStyle(
                                fontSize: 10, color: Colours.grey_color1),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                const Text(
                                  '单率 ',
                                  style: TextStyle(
                                      fontSize: 12, color: Colours.text_color),
                                ),
                                Text(
                                  '${dlPercentage[0]}%',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colours.main_color),
                                ),
                              ]),
                          Text(
                            '${dlPercentage[1]}单${dlPercentage[2]}双',
                            style: const TextStyle(
                                fontSize: 10, color: Colours.grey_color1),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Table(
                    // defaultColumnWidth: const FixedColumnWidth(50),
                    columnWidths: const {
                      0: FixedColumnWidth(80),
                      // 1: FixedColumnWidth(80),
                      2: FixedColumnWidth(70),
                      // 3: FixedColumnWidth(80),
                      4: FixedColumnWidth(35),
                      5: FixedColumnWidth(40),
                    },
                    children: [
                      TableRow(
                          decoration:
                              const BoxDecoration(color: Colours.greyF5F7FA),
                          children: List.generate(tableTitle.length, (index) {
                            TextAlign align = TextAlign.center;
                            if (index == 0 || index == 3) {
                              align = TextAlign.left;
                            } else if (index == 1) {
                              align = TextAlign.right;
                            }
                            return TableCell(
                                child: Padding(
                              padding: index == 0
                                  ? EdgeInsets.fromLTRB(8, 6, 0, 6)
                                  : EdgeInsets.symmetric(vertical: 6),
                              child: Text(tableTitle[index],
                                  style: const TextStyle(
                                      fontSize: 12, color: Colours.text_color1),
                                  textAlign: align),
                            ));
                          })),
                      ...List.generate(vsList.length, (index) {
                        return TableRow(
                            decoration: BoxDecoration(
                                color: index % 2 == 0
                                    ? Colours.white
                                    : Colours.greyF5F7FA),
                            children:
                                List.generate(tableTitle.length, (index1) {
                              VsList vs = vsList[index];
                              Widget widget;
                              if (index1 == 0) {
                                widget = Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text(
                                    DateUtilsExtension.formatDateString(
                                                vs.matchTime!, 'yyyy')
                                            .substring(2) +
                                        '/' +
                                        DateUtilsExtension.formatDateString(
                                            vs.matchTime!, 'MM/dd') +
                                        '\n' +
                                        '${vs.leagueName}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colours.text_color1),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                  ),
                                );
                              } else if (index1 == 1) {
                                Color color = Colours.text_color1;
                                if (type == 1 &&
                                    controller.data?.currentMatchInfo
                                            ?.homeQxbTeamId ==
                                        vs.awayQxbId) {
                                } else if (type == 2 &&
                                    controller.data?.currentMatchInfo
                                            ?.awayQxbTeamId ==
                                        vs.awayQxbId) {
                                } else {
                                  color = Colours.grey66;
                                }
                                widget = Text(vs.awayName!,
                                    style:
                                        TextStyle(fontSize: 12, color: color),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right);
                              } else if (index1 == 2) {
                                widget = Column(
                                  children: [
                                    Text(
                                      '${vs.awayScore}-${vs.homeScore}',
                                      style: TextStyle(
                                          color:
                                              controller.getColor(vs.homeWin),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                        '(${vs.awayHalfScore}-${vs.homeHalfScore})',
                                        style: const TextStyle(
                                            color: Colours.grey_color1,
                                            fontSize: 11))
                                  ],
                                );
                              } else if (index1 == 3) {
                                Color color = Colours.text_color1;
                                if (type == 1 &&
                                    controller.data?.currentMatchInfo
                                            ?.homeQxbTeamId ==
                                        vs.homeQxbId) {
                                } else if (type == 2 &&
                                    controller.data?.currentMatchInfo
                                            ?.awayQxbTeamId ==
                                        vs.homeQxbId) {
                                } else {
                                  color = Colours.grey66;
                                }
                                widget = Text(vs.homeName!,
                                    style:
                                        TextStyle(fontSize: 12, color: color),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left);
                              } else if (index1 == 4) {
                                widget = Text(controller.getAhWin(vs, type),
                                    style: TextStyle(
                                        color:
                                            controller.getYpColor(vs.ypStatus),
                                        fontSize: 12),
                                    textAlign: TextAlign.center);
                              } else {
                                widget = Text(controller.getSbWin(vs, type),
                                    style: TextStyle(
                                        color:
                                            controller.getDxColor(vs.dxStatus),
                                        fontSize: 12),
                                    textAlign: TextAlign.center);
                              }
                              return TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      child: GestureDetector(
                                          onTap: () {
                                            if (vs.matchQxbId != null &&
                                                vs.matchQxbId != 0) {
                                              Get.toNamed(
                                                  Routes.basketMatchDetail,
                                                  arguments: vs.matchQxbId,
                                                  preventDuplicates: false);
                                            }
                                          },
                                          child: widget)));
                            })

                            // controller.vsList!.map((e) {
                            //   return TableCell(child: Text(e));
                            // }).toList());
                            );
                      })
                    ],
                  ),
                ])
        ],
      ),
    );
  }

  //0主队 1客队
  Widget _recentMatch(int type) {
    final title = [
      '日期/赛事',
      '主队',
      '',
      '客队',
      '相隔',
    ];
    List<RecentMatch> list = [];
    if (type == 0) {
      list = controller.data!.homeFuture ?? [];
    } else {
      list = controller.data!.awayFuture ?? [];
    }
    return Visibility(
      visible: list.isNotEmpty,
      child: Container(
        color: Colours.white,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  width: 21,
                  height: 21,
                  imageUrl: (type == 0
                          ? controller.data?.currentMatchInfo?.homeLogo
                          : controller.data?.currentMatchInfo?.awayLogo) ??
                      '',
                  placeholder: (context, url) => Styles.placeholderIcon(),
                  errorWidget: (context, url, error) => Image.asset(
                    Utils.getImgPath('basket_team_logo.png'),
                    width: 21,
                    height: 21,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  (type == 0
                          ? controller.data?.currentMatchInfo?.homeName
                          : controller.data?.currentMatchInfo?.awayName) ??
                      '',
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colours.text_color1,
                      fontWeight: FontWeight.w400),
                )
              ],
            ),
            const SizedBox(height: 10),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
                2: FixedColumnWidth(40),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(1)
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                    decoration: const BoxDecoration(color: Colours.greyF5F7FA),
                    children: List.generate(title.length, (index) {
                      TextAlign align = TextAlign.center;
                      if (index == 0 || index == 3) {
                        align = TextAlign.left;
                      } else if (index == 1) {
                        align = TextAlign.right;
                      }
                      return TableCell(
                          child: Padding(
                              padding: index == 0
                                  ? EdgeInsets.fromLTRB(8, 6, 0, 6)
                                  : EdgeInsets.symmetric(vertical: 6),
                              child: Text(title[index],
                                  style: const TextStyle(
                                      fontSize: 12, color: Colours.text_color1),
                                  textAlign: align)));
                    })),
                ...List.generate(list.length, (index) {
                  return TableRow(
                      decoration: BoxDecoration(
                          color: index % 2 == 0
                              ? Colours.white
                              : Colours.greyF5F7FA),
                      children: List.generate(5, (index1) {
                        RecentMatch vs = list[index];
                        Widget widget;
                        if (index1 == 0) {
                          widget = Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              DateUtilsExtension.formatDateString(
                                          vs.matchTime!, 'yyyy')
                                      .substring(2) +
                                  '/' +
                                  DateUtilsExtension.formatDateString(
                                      vs.matchTime!, 'MM/dd') +
                                  '\n' +
                                  '${vs.leagueName}',
                              style: const TextStyle(
                                  fontSize: 12, color: Colours.text_color1),
                              textAlign: TextAlign.left,
                            ),
                          );
                        } else if (index1 == 1) {
                          Color color = Colours.text_color1;
                          if (type == 0 &&
                              controller
                                      .data?.currentMatchInfo?.homeQxbTeamId ==
                                  vs.awayQxbId) {
                          } else if (type == 1 &&
                              controller
                                      .data?.currentMatchInfo?.awayQxbTeamId ==
                                  vs.awayQxbId) {
                          } else {
                            color = Colours.grey66;
                          }
                          widget = Text(vs.awayName!,
                              style: TextStyle(fontSize: 12, color: color),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right);
                        } else if (index1 == 2) {
                          widget = const Text('vs',
                              style: TextStyle(
                                  fontSize: 12, color: Colours.text_color1),
                              textAlign: TextAlign.center);
                        } else if (index1 == 3) {
                          Color color = Colours.text_color1;
                          if (type == 0 &&
                              controller
                                      .data?.currentMatchInfo?.homeQxbTeamId ==
                                  vs.homeQxbId) {
                          } else if (type == 1 &&
                              controller
                                      .data?.currentMatchInfo?.awayQxbTeamId ==
                                  vs.homeQxbId) {
                          } else {
                            color = Colours.grey66;
                          }
                          widget = Text(vs.homeName!,
                              style: TextStyle(fontSize: 12, color: color),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left);
                        } else {
                          widget = Text('${vs.offsetDay}天',
                              style: const TextStyle(
                                  fontSize: 12, color: Colours.text_color1),
                              textAlign: TextAlign.center);
                        }
                        return GestureDetector(
                          onTap: () {
                            if (vs.matchQxbId != null && vs.matchQxbId != 0) {
                              Get.toNamed(Routes.basketMatchDetail,
                                  arguments: vs.matchQxbId,
                                  preventDuplicates: false);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: widget,
                          ),
                        );
                      }));
                }),
              ],
            ),
          ],
        ),
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
