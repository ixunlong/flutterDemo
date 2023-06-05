import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/match/soccer_match_data_controller.dart';
import 'package:sports/logic/match/soccer_match_detail_controller.dart';
import 'package:sports/model/match/match_data_entity.dart';
import 'package:sports/model/match/match_point_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/date_utils_extension.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/common_button.dart';
import 'package:sports/widgets/cupertino_picker_widget.dart';
import 'package:sports/widgets/no_data_widget.dart';

class SoccerMatchDataView extends StatefulWidget {
  const SoccerMatchDataView({super.key});

  @override
  State<SoccerMatchDataView> createState() => _SoccerMatchDataViewState();
}

class _SoccerMatchDataViewState extends State<SoccerMatchDataView>
    with AutomaticKeepAliveClientMixin {
  // final tag = DateTime.now().formatedString("HH:mm:ss");
  late SoccerMatchDataController controller;
  final matchDetailController =
      Get.find<SoccerMatchDetailController>(tag: '${Get.arguments}');

  @override
  void initState() {
    controller = Get.put(SoccerMatchDataController(), tag: '${Get.arguments}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SoccerMatchDataController>(
      tag: '${Get.arguments}',
      builder: (_) {
        return controller.firstInit
            ? Container()
            : (controller.isEmpty()
                ? const NoDataWidget()
                : Container(
                    color: Colours.greyF5F5F5,
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: [
                        Visibility(
                            visible: controller.data?.shootTimeList != null,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: _jingqiufenbu(),
                            )),
                        // if (controller.standingList1 != null &&
                        //     controller.standingList1?.length != 0) ...[
                        //   const SizedBox(height: 10),
                        //   _leagueTable(controller.standingList1!)
                        // ],
                        if (controller.standingList1 != null ||
                            controller.standingList2 != null ||
                            controller.standingCupList1 != null ||
                            controller.standingCupList2 != null) ...[
                          const SizedBox(height: 10),
                          _leaguePoints()
                        ],
                        if (controller.data?.vsList != null &&
                            controller.data?.vsList?.length != 0) ...[
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
                        if (controller.data?.homeVsList != null ||
                            controller.data?.guestVsList != null) ...[
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
                        if (controller.data?.homeVsList != null) _matchTable(1),
                        if (controller.data?.guestVsList != null)
                          _matchTable(2),
                        // if (controller.data?.homeVsList != null &&
                        //     controller.data?.guestVsList != null) ...[
                        //   _matchTable(1),
                        //   _matchTable(2),
                        // ],
                        if (controller.data?.homeMatchList != null ||
                            controller.data?.guestMatchList != null) ...[
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
                        if (controller.data?.homeMatchList != null)
                          _recentMatch(0),
                        if (controller.data?.guestMatchList != null)
                          _recentMatch(1),
                        // const SizedBox(height: 10),
                        // if (controller.data?.homeMatchList != null &&
                        //     controller.data?.guestMatchList != null) ...[
                        //   _recentMatch(0),
                        //   _recentMatch(1)
                        // ]
                        SizedBox(height: 50)
                      ],
                    ),
                  ));
      },
    );
  }

  //进球分布
  Widget _jingqiufenbu() {
    final title = [
      '00\'',
      '10\'',
      '20\'',
      '30\'',
      '40\'',
      '50\'',
      '60\'',
      '70\'',
      '80\'',
      '90\''
    ];
    final shootType1 = ['全部', '主场', '客场'];
    final shootType2 = ['全部进球', '首粒进球'];
    // final shootType3 = ['总场次', '主场场次', '客场场次'];

    return Container(
      color: Colours.white,
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('进球分布',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('统计本赛季同赛事数据',
                style: TextStyle(color: Colours.grey_color1, fontSize: 12)),
            const Spacer(),
            SizedBox(
                height: 22,
                width: 51,
                child: _selectButton(
                    '${shootType1[controller.shootTimeType1 - 1]}', () async {
                  final result = await Get.bottomSheet(CupertinoPickerWidget(
                    shootType1,
                    title: '选择主客场',
                    initialIndex: controller.shootTimeType1 - 1,
                    eventId: 'bsxq_sj_jqfb1',
                  ));
                  if (result != null) {
                    controller.shootTimeType1 = result + 1;
                  }
                })),
            const SizedBox(width: 10),
            SizedBox(
                height: 22,
                width: 74,
                child: _selectButton(
                    '${shootType2[controller.shootTimeType2 - 1]}', () async {
                  final result = await Get.bottomSheet(CupertinoPickerWidget(
                    shootType2,
                    title: '进球选择',
                    initialIndex: controller.shootTimeType2 - 1,
                    eventId: 'bsxq_sj_jqfb2',
                  ));
                  if (result != null) {
                    controller.shootTimeType2 = result + 1;
                  }
                })),
          ],
        ),
        const SizedBox(height: 8),
        Column(
          children: [
            Container(
              color: Colours.greyF5F7FA,
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  const SizedBox(
                      width: 80,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text('球队',
                            style: TextStyle(
                                fontSize: 12, color: Colours.text_color)),
                      )),
                  const SizedBox(
                      width: 20,
                      child: Text('总',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12, color: Colours.text_color))),
                  ...title
                      .map((e) => Flexible(
                          fit: FlexFit.tight,
                          child: Container(
                            child: Text(e,
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                    fontSize: 12, color: Colours.text_color)),
                          )))
                      .toList(),
                ],
              ),
            ),
            const SizedBox(height: 6),
            _fenbuqiudui(true),
            const SizedBox(height: 6),
            _fenbuqiudui(false),
            const SizedBox(height: 4),
          ],
        )
      ]),
    );
  }

  //进球分布 球队
  Widget _fenbuqiudui(bool isHome) {
    final goal = controller.goalList(isHome);
    final homeName = isHome
        ? matchDetailController.info!.baseInfo!.homeName
        : matchDetailController.info!.baseInfo!.guestName;
    final totalGoal = isHome
        ? controller.homeShootTime?.total
        : controller.guestShootTime?.total;
    return Row(
      children: [
        SizedBox(
            width: 80,
            child: Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(homeName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(fontSize: 12, color: Colours.text_color)),
            )),
        SizedBox(
            width: 20,
            child: Text('$totalGoal',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 12, color: Colours.text_color))),
        const SizedBox(width: 14),
        ...List.generate(goal.length, (index) {
          final e = goal[index];
          return Flexible(
              fit: FlexFit.tight,
              child: Container(
                  height: 24,
                  alignment: Alignment.center,
                  color: isHome
                      ? (index % 2 == 0
                          ? Colours.pinkFAF0F0
                          : Colours.pinkF4E6E6)
                      : (index % 2 == 0
                          ? Colours.greyF2F8FC
                          : Colours.greyE1EBF1),
                  child: Text('$e',
                      style: const TextStyle(
                          fontSize: 12, color: Colours.text_color))));
        }),
        const SizedBox(width: 14),
      ],
    );
  }

  Widget _leaguePoints() {
    return Column(
      children: [
        if ((controller.standingList1 != null ||
                controller.standingList2 != null) &&
            (controller.standingCupList1 != null ||
                controller.standingCupList2 != null))
          Container(
            color: Colours.white,
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                Text('积分排名',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                Spacer(),
                if ((controller.standingList1 != null ||
                        controller.standingList2 != null) &&
                    (controller.standingCupList1 != null ||
                        controller.standingCupList2 != null))
                  Container(
                    // constraints: const BoxConstraints(maxWidth: 53,maxHeight: 23),
                    decoration: BoxDecoration(
                        // color: Colours.redFFF2F2,
                        borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      height: 22,
                      decoration: BoxDecoration(
                          color: Colours.redFFF2F2,
                          borderRadius: BorderRadius.circular(15)),
                      child: ToggleButtons(
                        splashColor: Colours.transparent,
                        borderRadius: BorderRadius.circular(15),
                        constraints:
                            const BoxConstraints(minWidth: 52, minHeight: 22),
                        onPressed: (index) => controller.changePointType(index),
                        isSelected: [
                          controller.pointType == 0,
                          controller.pointType == 1
                        ],
                        borderColor: Colours.main,
                        color: Colours.redFFF2F2,
                        selectedBorderColor: Colours.main,
                        fillColor: Colours.main,
                        children: [
                          Text("杯赛",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: controller.pointType == 0
                                      ? Colours.white
                                      : Colours.main)),
                          Text("联赛",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: controller.pointType == 1
                                      ? Colours.white
                                      : Colours.main)),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        if (controller.pointType == 0 && controller.standingCupList1 != null)
          _leagueTable(controller.standingCupList1!, true),
        if (controller.pointType == 0 && controller.standingCupList2 != null)
          _leagueTable(controller.standingCupList2!, false),
        if (controller.pointType == 1 && controller.standingList1 != null)
          _leagueTable(
              controller.leagueHomeType == 0
                  ? controller.standingList1!
                  : (controller.leagueHomeType == 1
                      ? controller.standingHomeList1!
                      : controller.standingHomeList2!),
              true),
        if (controller.pointType == 1 && controller.standingList2 != null)
          _leagueTable(
              controller.leagueGuestType == 0
                  ? controller.standingList2!
                  : (controller.leagueGuestType == 1
                      ? controller.standingGuestList1!
                      : controller.standingGuestList2!),
              false),
      ],
    );
  }

  Widget _leagueTable(List<StandingPointList> list, bool isHome) {
    List title = ['球队', '已赛', '胜/平/负', '进/失', '净', '积分', '排名'];
    List<String> type = ['全部', '主场', '客场'];
    // final type1 = ['全部', '主场', '客场'];
    return Container(
      color: Colours.white,
      padding: EdgeInsets.fromLTRB(
          16,
          ((controller.standingList1 != null &&
                      controller.standingList2 != null) ||
                  (controller.standingCupList1 != null &&
                      controller.standingCupList2 != null))
              ? 10
              : 16,
          16,
          16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('${list.first.leagueName}${list.first.groupCn ?? ''}积分',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: ((controller.standingList1 != null &&
                                  controller.standingList2 != null) ||
                              (controller.standingCupList1 != null &&
                                  controller.standingCupList2 != null))
                          ? 14
                          : 16)),
              const Spacer(),
              if (controller.pointType == 1)
                SizedBox(
                    height: 22,
                    width: 51,
                    child: _selectButton(
                        isHome
                            ? type[controller.leagueHomeType]
                            : type[controller.leagueGuestType], () async {
                      final result =
                          await Get.bottomSheet(CupertinoPickerWidget(
                        type,
                        title: '全部',
                        initialIndex: isHome
                            ? controller.leagueHomeType
                            : controller.leagueGuestType,
                        eventId: 'bsxq_sj_lsjf',
                      ));
                      if (result != null) {
                        controller.changeLeagueType(result, isHome);
                      }
                    }))
            ],
          ),
          const SizedBox(height: 10),
          Table(
            columnWidths: {
              0: const FlexColumnWidth(1),
              1: const FixedColumnWidth(40),
              2: const FixedColumnWidth(68),
              3: const FixedColumnWidth(50),
              4: const FixedColumnWidth(34),
              5: const FixedColumnWidth(34),
              6: const FixedColumnWidth(34)
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                  decoration: const BoxDecoration(color: Colours.greyF5F7FA),
                  children: List.generate(title.length, (index) {
                    return TableCell(
                        child: Padding(
                            padding: index == 0
                                ? EdgeInsets.fromLTRB(8, 6, 0, 6)
                                : EdgeInsets.symmetric(vertical: 6),
                            child: Text(title[index],
                                style: const TextStyle(
                                    fontSize: 12, color: Colours.text_color1),
                                textAlign: index == 0
                                    ? TextAlign.left
                                    : TextAlign.center)));
                  })),
              ...List.generate(list.length, (index) {
                StandingPointList data = list[index];
                return TableRow(
                    children: List.generate(7, (index1) {
                  Widget widget;
                  if (index1 == 0) {
                    widget = Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        data.teamName ?? '',
                        style: TextStyle(
                            fontSize: 12,
                            color: data.tag == 1
                                ? Colours.main
                                : (data.tag == 2
                                    ? Colours.guestColorBlue
                                    : Colours.text_color1)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                    );
                  } else {
                    String title = '';
                    if (index1 == 1) {
                      title = '${data.totalCount}';
                    } else if (index1 == 2) {
                      title =
                          '${data.winCount}/${data.drawCount}/${data.loseCount}';
                    } else if (index1 == 3) {
                      title = '${data.getScore}/${data.loseScore}';
                    } else if (index1 == 4) {
                      title = '${data.goalDifference}';
                    } else if (index1 == 5) {
                      title = '${data.integral}';
                    } else {
                      title = '${data.rank}';
                    }
                    widget = Text(title,
                        style: TextStyle(
                            fontSize: 12,
                            color: data.tag == 1
                                ? Colours.main
                                : (data.tag == 2
                                    ? Colours.guestColorBlue
                                    : Colours.text_color1)),
                        textAlign: TextAlign.center);
                  }
                  return Padding(
                    padding: index == 0
                        ? EdgeInsets.only(top: 10, bottom: 5)
                        : EdgeInsets.only(top: 5, bottom: 5),
                    child: widget,
                  );
                }));
              }),
            ],
          ),
          SizedBox(height: 20),
          CommonButton.large(
            onPressed: () {
              Utils.onEvent("bsxq_sj_lsjf", params: {"bsxq_sj_lsjf": 4});
              Get.toNamed(Routes.dataSecond,
                  arguments: list.first.leagueId.toString());
            },
            backgroundColor: Colours.greyF2,
            minHeight: 30,
            widget: Row(mainAxisSize: MainAxisSize.min, children: [
              Text('查看完整排名',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colours.grey_color,
                      fontWeight: FontWeight.w400)),
              SizedBox(width: 6),
              Image.asset(Utils.getImgPath('arrow_right.png'),
                  width: 6, height: 10)
            ]),
            // text: '查看完整排名 ',
            // textStyle: TextStyle(fontSize: 12, color: Colours.grey_color),
          )
        ],
      ),
    );
  }

  ///两队比赛数据表
  ///0 交锋
  ///1 主队战绩
  ///2 客队战绩
  Widget _matchTable(int type) {
    final title = type == 0 ? '两队交锋' : '近期战绩';
    bool sameHome = false;
    bool sameLeague = false;
    List<VsList> vsList = [];
    int zhishuType = 0;
    int matchNumType = 0;
    if (type == 0) {
      vsList = controller.vsList ?? [];
      sameHome = controller.jiaofengSameHomeVs;
      sameLeague = controller.jiaofengsSameLeagueVs;
      zhishuType = controller.vsType1;
      matchNumType = controller.vsType2;
    } else if (type == 1) {
      vsList = controller.homeRecentVs ?? [];
      sameHome = controller.homeSameHomeRecent;
      sameLeague = controller.homeSameLeagueRecent;
      zhishuType = controller.homeRecentType1;
      matchNumType = controller.homeRecentType2;
    } else {
      vsList = controller.guestRecentVs ?? [];
      sameHome = controller.guestSameHomeRecent;
      sameLeague = controller.guestSameLeagueRecent;
      zhishuType = controller.guestRecentType1;
      matchNumType = controller.guestRecentType2;
    }
    List goalAndLost = controller.getGoalAndLost(type);
    List winPercentage = controller.getOddsWinPercentage(type);
    List ahPercentage = controller.getAhWinPercentage(type);
    List sbPercentage = controller.getSbWinPercentage(type);
    final tableTitle = [
      '日期/赛事',
      '主队',
      '比分',
      '客队',
      '胜负',
      '让球',
      '进球',
      '角球',
      '红牌'
    ];
    final type1 = [
      '初指',
      '终指',
    ];
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
                          ? matchDetailController.info?.baseInfo?.homeLogo
                          : matchDetailController.info?.baseInfo?.guestLogo) ??
                      '',
                  placeholder: (context, url) => Styles.placeholderIcon(),
                  errorWidget: (context, url, error) => Image.asset(
                    Utils.getImgPath('team_logo.png'),
                    width: 21,
                    height: 21,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  (type == 1
                          ? matchDetailController.info?.baseInfo?.homeName
                          : matchDetailController.info?.baseInfo?.guestName) ??
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
                    if (type == 0) {
                      Utils.onEvent('bsxq_sj_ldjf1',
                          params: {'bsxq_sj_ldjf1': '1'});
                      controller.jiaofengSameHomeVs =
                          !controller.jiaofengSameHomeVs;
                    } else if (type == 1) {
                      Utils.onEvent('bsxq_sj_jqzj_z1',
                          params: {'bsxq_sj_jqzj_z1': '1'});
                      controller.homeSameHomeRecent =
                          !controller.homeSameHomeRecent;
                    } else {
                      Utils.onEvent('bsxq_sj_jqzj_k1',
                          params: {'bsxq_sj_jqzj_k1': '1'});
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
                    if (type == 0) {
                      Utils.onEvent('bsxq_sj_ldjf1',
                          params: {'bsxq_sj_ldjf1': '2'});
                      controller.jiaofengsSameLeagueVs =
                          !controller.jiaofengsSameLeagueVs;
                    } else if (type == 1) {
                      Utils.onEvent('bsxq_sj_jqzj_z1',
                          params: {'bsxq_sj_jqzj_z1': '2'});
                      controller.homeSameLeagueRecent =
                          !controller.homeSameLeagueRecent;
                    } else {
                      Utils.onEvent('bsxq_sj_jqzj_k1',
                          params: {'bsxq_sj_jqzj_k1': '2'});
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
              SizedBox(
                  height: 22,
                  width: 51,
                  child: _selectButton('${type1[zhishuType]}', () async {
                    var initialIndex = 0;
                    if (type == 0) {
                      initialIndex = controller.vsType1;
                    } else if (type == 1) {
                      initialIndex = controller.homeRecentType1;
                    } else {
                      initialIndex = controller.guestRecentType1;
                    }
                    final result = await Get.bottomSheet(CupertinoPickerWidget(
                        type1,
                        title: '选择指数',
                        initialIndex: initialIndex));
                    if (result != null) {
                      controller.selectZhishu(type, result);
                    }
                  })),
              const SizedBox(width: 10),
              SizedBox(
                  height: 22,
                  width: 65,
                  child: _selectButton('${type2[matchNumType]}', () async {
                    var initialIndex = 0;
                    String? eventId;
                    if (type == 0) {
                      initialIndex = controller.vsType2;
                      eventId = 'bsxq_sj_ldjf2';
                    } else if (type == 1) {
                      initialIndex = controller.homeRecentType2;
                      eventId = 'bsxq_sj_jqzj_z2';
                    } else {
                      initialIndex = controller.guestRecentType2;
                      eventId = 'bsxq_sj_jqzj_k2';
                    }
                    final result = await Get.bottomSheet(CupertinoPickerWidget(
                      type2,
                      title: '选择场数',
                      initialIndex: initialIndex,
                      eventId: eventId,
                    ));
                    if (result != null) {
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
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                    width: 50,
                                    height: 20,
                                    alignment: Alignment.center,
                                    child: Text(type == 0 ? '主队近' : '近',
                                        style: TextStyle(fontSize: 12))),
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(2),
                                            bottomRight: Radius.circular(2)),
                                        border: Border.all(
                                            width: 1, color: Colours.greyD9)),
                                    width: 50,
                                    height: 20,
                                    alignment: Alignment.center,
                                    child: Text('${vsList.length}场',
                                        style: TextStyle(fontSize: 12))),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Column(
                              children: [
                                Text(
                                  '${goalAndLost[0]}/${goalAndLost[1]}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colours.main_color),
                                ),
                                const Text(
                                  '进球/失球',
                                  style: TextStyle(
                                      fontSize: 10, color: Colours.grey_color1),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Column(
                              children: [
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      const Text(
                                        '胜率 ',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colours.text_color),
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
                                  '${winPercentage[1]}胜${winPercentage[2]}平${winPercentage[3]}负',
                                  style: const TextStyle(
                                      fontSize: 10, color: Colours.grey_color1),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Column(
                              children: [
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      const Text(
                                        '赢率 ',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colours.text_color),
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
                            const SizedBox(width: 16),
                            Column(
                              children: [
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      const Text(
                                        '大 ',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colours.text_color),
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
                          ],
                        ),
                        const SizedBox(height: 10),
                        Table(
                          defaultColumnWidth: const FixedColumnWidth(50),
                          columnWidths: const {
                            0: FixedColumnWidth(70),
                            1: FixedColumnWidth(80),
                            2: FixedColumnWidth(50),
                            3: FixedColumnWidth(80),
                          },
                          children: [
                            TableRow(
                                decoration: const BoxDecoration(
                                    color: Colours.greyF5F7FA),
                                children:
                                    List.generate(tableTitle.length, (index) {
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
                                            fontSize: 12,
                                            color: Colours.text_color1),
                                        textAlign: align),
                                  ));
                                })),

                            // tableTitle.map((e) {

                            //   return TableCell(
                            //       child: Padding(
                            //     padding:
                            //         const EdgeInsets.symmetric(vertical: 4),
                            //     child: Text(e,
                            //         style: const TextStyle(
                            //             fontSize: 12,
                            //             color: Colours.text_color1),
                            //         textAlign: TextAlign.center),
                            //   ));
                            // }).toList()),
                            ...List.generate(vsList.length, (index) {
                              return TableRow(
                                  decoration: BoxDecoration(
                                      color: index % 2 == 0
                                          ? Colours.white
                                          : Colours.greyF5F7FA),
                                  children: List.generate(9, (index1) {
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
                                              DateUtilsExtension
                                                  .formatDateString(
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
                                          controller.data?.homeId ==
                                              vs.homeId) {
                                      } else if (type == 2 &&
                                          controller.data?.guestId ==
                                              vs.homeId) {
                                      } else {
                                        color = Colours.grey66;
                                      }
                                      widget = Text(vs.homeName!,
                                          style: TextStyle(
                                              fontSize: 12, color: color),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.right);
                                    } else if (index1 == 2) {
                                      widget = Column(
                                        children: [
                                          Text(
                                            '${vs.homeScore}-${vs.guestScore}',
                                            style: TextStyle(
                                                color:
                                                    controller.getColor(vs.win),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                              '(${vs.homeHalfScore}-${vs.guestHalfScore})',
                                              style: const TextStyle(
                                                  color: Colours.grey_color1,
                                                  fontSize: 11))
                                        ],
                                      );
                                    } else if (index1 == 3) {
                                      Color color = Colours.text_color1;
                                      if (type == 1 &&
                                          controller.data?.homeId ==
                                              vs.guestId) {
                                      } else if (type == 2 &&
                                          controller.data?.guestId ==
                                              vs.guestId) {
                                      } else {
                                        color = Colours.grey66;
                                      }
                                      widget = Text(vs.guestName!,
                                          style: TextStyle(
                                              fontSize: 12, color: color),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left);
                                    } else if (index1 == 4) {
                                      widget = Text(
                                          controller.getOddsWin(vs, type),
                                          style: TextStyle(
                                              color:
                                                  controller.getColor(vs.win),
                                              fontSize: 12),
                                          textAlign: TextAlign.center);
                                    } else if (index1 == 5) {
                                      widget = Text(
                                          controller.getAhWin(vs, type),
                                          style: TextStyle(
                                              color: controller
                                                  .getColor(vs.ah1Win),
                                              fontSize: 12),
                                          textAlign: TextAlign.center);
                                    } else if (index1 == 6) {
                                      widget = Text(
                                          controller.getSbWin(vs, type),
                                          style: TextStyle(
                                              color: controller
                                                  .getColor(vs.sb1Win),
                                              fontSize: 12),
                                          textAlign: TextAlign.center);
                                    } else if (index1 == 7) {
                                      widget = Text(
                                          vs.homeCorner == null
                                              ? '-\n-'
                                              : '${vs.homeCorner! + vs.guestCorner!}\n${vs.homeCorner}-${vs.guestCorner}',
                                          style: const TextStyle(
                                              color: Colours.text_color1,
                                              fontSize: 12),
                                          textAlign: TextAlign.center);
                                    } else {
                                      widget = Text(
                                          vs.homeRed == null
                                              ? '-\n-'
                                              : '${vs.homeRed! + vs.guestRed!}\n${vs.homeRed}-${vs.guestRed}',
                                          style: const TextStyle(
                                              color: Colours.text_color1,
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
                                                // onTap: () {
                                                //   if (vs.matchId != null &&
                                                //       vs.matchId != 0) {
                                                //     Get.toNamed(
                                                //         Routes
                                                //             .soccerMatchDetail,
                                                //         arguments: vs.matchId,
                                                //         preventDuplicates:
                                                //             false);
                                                //   }
                                                // },
                                                child: widget)));
                                  })

                                  // controller.vsList!.map((e) {
                                  //   return TableCell(child: Text(e));
                                  // }).toList());
                                  );
                            })
                          ],
                        ),
                      ]),
                )
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
    List<MatchList> list = [];
    if (type == 0) {
      list = controller.data!.homeMatchList ?? [];
    } else {
      list = controller.data!.guestMatchList ?? [];
    }
    return Visibility(
      visible: list.isNotEmpty,
      child: Container(
        color: Colours.white,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Visibility(
            //   visible: type == 0,
            //   child: const Text('近期比赛',
            //       style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
            // ),
            // Visibility(visible: type == 0, child: const SizedBox(height: 17)),
            Row(
              children: [
                CachedNetworkImage(
                  width: 21,
                  height: 21,
                  imageUrl: (type == 0
                          ? matchDetailController.info?.baseInfo?.homeLogo
                          : matchDetailController.info?.baseInfo?.guestLogo) ??
                      '',
                  placeholder: (context, url) => Styles.placeholderIcon(),
                  errorWidget: (context, url, error) => Image.asset(
                    Utils.getImgPath('team_logo.png'),
                    width: 21,
                    height: 21,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  (type == 0
                          ? matchDetailController.info?.baseInfo?.homeName
                          : matchDetailController.info?.baseInfo?.guestName) ??
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
                // title
                //     .map((e) => TableCell(
                //         child: Padding(
                //             padding:
                //                 const EdgeInsets.symmetric(vertical: 4),
                //             child: Text(e,
                //                 style: const TextStyle(
                //                     fontSize: 12,
                //                     color: Colours.text_color1),
                //                 textAlign: TextAlign.center))))
                //     .toList()),
                ...List.generate(list.length, (index) {
                  return TableRow(
                      decoration: BoxDecoration(
                          color: index % 2 == 0
                              ? Colours.white
                              : Colours.greyF5F7FA),
                      children: List.generate(5, (index1) {
                        MatchList vs = list[index];
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
                              controller.data?.homeId == vs.homeId) {
                          } else if (type == 1 &&
                              controller.data?.guestId == vs.homeId) {
                          } else {
                            color = Colours.grey66;
                          }
                          widget = Text(vs.homeName!,
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
                              controller.data?.homeId == vs.guestId) {
                          } else if (type == 1 &&
                              controller.data?.guestId == vs.guestId) {
                          } else {
                            color = Colours.grey66;
                          }
                          widget = Text(vs.guestName!,
                              style: TextStyle(fontSize: 12, color: color),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left);
                        } else {
                          widget = Text('${vs.days}天',
                              style: const TextStyle(
                                  fontSize: 12, color: Colours.text_color1),
                              textAlign: TextAlign.center);
                        }
                        return GestureDetector(
                          onTap: () {
                            if (vs.matchId != null && vs.matchId != 0) {
                              Get.toNamed(Routes.soccerMatchDetail,
                                  arguments: vs.matchId,
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
            // const SizedBox(height: 20),
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

  @override
  bool get wantKeepAlive => true;
}
