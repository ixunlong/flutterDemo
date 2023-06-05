import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/basketball/bb_match_lineup_controller.dart';
import 'package:sports/widgets/loading_check_widget.dart';

import '../../../model/basketball/bb_lineup_entity.dart';
import '../../../model/basketball/bb_match_detail_entity.dart';
import '../../../res/colours.dart';
import '../../../res/styles.dart';
import '../../../util/utils.dart';
import '../../../widgets/ladder_path.dart';

class BbLineupWidget extends StatefulWidget {
  const BbLineupWidget({Key? key}) : super(key: key);

  @override
  State<BbLineupWidget> createState() => _BbLineupWidgetState();
}

class _BbLineupWidgetState extends State<BbLineupWidget> {
  final controller = Get.put(BbLineupController(), tag: '${Get.arguments}');

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BbLineupController>(
        tag: '${Get.arguments}',
        builder: (controller) {
          return LoadingCheckWidget<bool>(
            isLoading: controller.isLoading,
            loading: Container(),
            data: List.generate(3, (index) => controller.keyScore(index)).every(
                    (element) => element.every((element) => element == 0)) &&
                controller.data.every((element) =>
                    element.every((element) => element.toJson().isEmpty)) &&
                controller.suspend.every((element) => element.isEmpty),
            child: EasyRefresh.builder(
              onRefresh: () async {
                await controller.requestData();
              },
              controller: EasyRefreshController(),
              childBuilder: (context, physics) => ListView(
                physics: physics,
                children: [
                  Container(height: 10),
                  LoadingCheckWidget<int>(
                      isLoading: controller.isLoading,
                      data: controller.trends?.appMatchTrends?.length,
                      noData: Container(),
                      child: chartBox()),
                  LoadingCheckWidget<int>(
                      isLoading: controller.isLoading,
                      data: controller.trends?.appMatchTrends?.length,
                      noData: Container(),
                      child: score1234()),
                  LoadingCheckWidget<int>(
                      isLoading: controller.isLoading,
                      data: controller.trends?.appMatchItems?.length,
                      noData: Container(),
                      child: techBox()),
                  LoadingCheckWidget<bool>(
                      isLoading: controller.isLoading,
                      data: List.generate(
                              3, (index) => controller.keyScore(index))
                          .every((element) =>
                              element.every((element) => element == 0)),
                      noData: Container(),
                      child: keyData()),
                  LoadingCheckWidget<bool>(
                      isLoading: controller.isLoading,
                      data: controller.data.every((element) =>
                          element.every((element) => element.toJson().isEmpty)),
                      noData: Container(),
                      child: lineup().paddingOnly(bottom: 10)),
                  LoadingCheckWidget<bool>(
                      isLoading: controller.isLoading,
                      data: controller.suspend
                          .every((element) => element.isEmpty),
                      noData: Container(),
                      child: suspend())
                ],
              ),
            ),
          );
        });
  }

  Widget keyData() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colours.white,
      ),
      margin: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
      padding: EdgeInsets.only(top: 16, left: 12, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("关键数据", style: Styles.mediumText(fontSize: 16)),
          Column(
              children: List.generate(
                  3,
                  (index) => confrontMap(
                      controller.keyData(index),
                      controller.keyScore(index),
                      controller.keyDataType(index))))
        ],
      ),
    );
  }

  Widget confrontMap(List<KeyDataInfo?> entity, List<int> score, String title) {
    return score[0] == 0 || entity[1] == 0
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: Styles.normalSubText(fontSize: 12)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CachedNetworkImage(
                      width: 30,
                      height: 40,
                      fit: BoxFit.fitHeight,
                      imageUrl: entity[0]?.logo ?? "",
                      errorWidget: (context, url, error) =>
                          Image.asset(Utils.getImgPath("basket_team_logo.png")),
                      placeholder: (context, url) => Styles.placeholderIcon(),
                    ),
                    Container(width: 4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entity[0]?.playerName ?? "",
                              style: TextStyle(fontSize: 12),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis),
                          Text(
                              entity[0]?.shirtNumber == null
                                  ? ""
                                  : "${entity[0]?.shirtNumber}号",
                              style: TextStyle(
                                  fontSize: 12, color: Colours.grey99)),
                        ],
                      ),
                    ),
                    Container(width: 6),
                    Container(
                      width: 45,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: int.parse("${score[0]}") >=
                                  int.parse("${score[1]}")
                              ? Colours.guestColorBlue
                              : Colours.greyF7),
                      child: Text("${score[0]}",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Din",
                              fontWeight: FontWeight.w600,
                              color: int.parse("${score[0]}") >=
                                      int.parse("${score[1]}")
                                  ? Colours.white
                                  : Colours.grey66)),
                    ),
                    Container(width: 5),
                    Container(
                      width: 45,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: int.parse("${score[0]}") <=
                                  int.parse("${score[1]}")
                              ? Colours.main
                              : Colours.greyF7),
                      child: Text("${score[1]}",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Din",
                              fontWeight: FontWeight.w600,
                              color: int.parse("${score[0]}") <=
                                      int.parse("${score[1]}")
                                  ? Colors.white
                                  : Colours.grey66)),
                    ),
                    Container(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(entity[1]?.playerName ?? "",
                              style: TextStyle(fontSize: 12),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis),
                          Text(
                              entity[1]?.shirtNumber == null
                                  ? ""
                                  : "${entity[1]?.shirtNumber}号",
                              style: const TextStyle(
                                  fontSize: 12, color: Colours.grey99)),
                        ],
                      ),
                    ),
                    Container(width: 4),
                    CachedNetworkImage(
                      width: 30,
                      height: 40,
                      fit: BoxFit.fitHeight,
                      imageUrl: entity[1]?.logo ?? "",
                      errorWidget: (context, url, error) =>
                          Image.asset(Utils.getImgPath("basket_team_logo.png")),
                      placeholder: (context, url) => Styles.placeholderIcon(),
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  Widget lineup() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipPath(
                clipper: LadderPath(false),
                child: Container(
                    width: 188,
                    height: 34,
                    color: controller.currentTab == 0
                        ? Colours.white
                        : Colours.transparent,
                    alignment: Alignment.center,
                    child: Text(controller.detail.detail?.awayTeamName ?? "",
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
              controller.tabController.animateTo(0);
            }),
            ClipPath(
                clipper: LadderPath(true),
                child: Container(
                    width: 188,
                    height: 34,
                    color: controller.currentTab == 1
                        ? Colours.white
                        : Colours.transparent,
                    alignment: Alignment.center,
                    child: Text(controller.detail.detail?.homeTeamName ?? "",
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
              controller.tabController
                  .animateTo(1, duration: Duration(milliseconds: 500));
            }),
          ],
        ),
        SizedBox(
          height: 36 * (controller.data[controller.currentTab].length) + 30,
          child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: controller.tabController,
              children: List.generate(
                  2, (index) => lineupList(controller.data[index]))),
        ),
        Container(
          color: Colours.white,
          height: 36,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                  width: 16, height: 16, Utils.getImgPath("bb_first.png")),
              Container(width: 6),
              Text("首发", style: Styles.normalText(fontSize: 12)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 16),
                  Image.asset(
                      fit: BoxFit.cover,
                      width: 16,
                      height: 16,
                      Utils.getImgPath("bb_in_match.png")),
                  Container(width: 6),
                  Text("在场", style: Styles.normalText(fontSize: 12))
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget lineupList(List<BbLineupDataEntity> list) {
    return Container(
      color: Colours.white,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 30,
                  padding: const EdgeInsets.only(left: 16),
                  alignment: Alignment.center,
                  child: Text("球员", style: TextStyle(fontSize: 12))),
              Column(
                children: List.generate(list.length,
                    (index) => lineupPlayerList(list[index], index)),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                          controller.dataType.length,
                          (index) => Container(
                              width: 40,
                              height: 30,
                              alignment: Alignment.center,
                              child: Text(controller.dataType[index],
                                  style: Styles.normalText(fontSize: 12))))),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(list.length,
                        (index) => lineupDataList(list[index], index)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget lineupPlayerList(BbLineupDataEntity entity, int index) {
    return Container(
      height: 36,
      color: index % 2 != 0 ? Colours.white : Colours.greyF5F7FA,
      padding: const EdgeInsets.only(right: 4),
      child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(width: 16),
            SizedBox(
              width: 16,
              height: 16,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  entity.first == 0
                      ? Image.asset(Utils.getImgPath("bb_first.png"))
                      : Image.asset(Utils.getImgPath("bb_shirt_grey.png")),
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(entity.shirtNumber.toString(),
                        style: TextStyle(
                            fontSize: 10,
                            color: entity.first == 0
                                ? Colors.white
                                : Colours.grey66)),
                  ))
                ],
              ),
            ),
            const SizedBox(width: 6),
            ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: 12 * 7, minWidth: 12 * 7),
              child: Text(
                entity.playerName ?? "",
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: Colours.text_color,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(width: 3),
            entity.played == 0
                ? Image.asset(
                    width: 16, height: 16, Utils.getImgPath("bb_in_match.png"))
                : Container(width: 16)
          ]),
    );
  }

  Widget lineupDataList(BbLineupDataEntity entity, int index) {
    return Container(
      color: index % 2 != 0 ? Colours.white : Colours.greyF5F7FA,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
            controller.dataType.length,
            (childIndex) => Container(
                width: 40,
                height: 36,
                alignment: Alignment.center,
                child: Text(controller.lineupData(entity)[childIndex],
                    style: Styles.normalText(fontSize: 12)))),
      ),
    );
  }

  Widget suspend() {
    return Container(
      color: Colours.white,
      padding: const EdgeInsets.only(bottom: 10, top: 16),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text('伤病及禁赛球员',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colours.text_color,
                      fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                  2,
                  (index) => Flexible(
                      child:
                          suspendList(controller.suspend[index], index == 1))),
            ),
          ]),
    );
  }

  Widget suspendList(List<TeamInfo> entity, bool isHome) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                stops: const [0, 0.85],
                colors: isHome
                    ? [Colours.redFFDBDB, Colours.white]
                    : [Colours.blueE1ECFF, Colours.white]),
          ),
          child: Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                    width: 26,
                    height: 26,
                    errorWidget: (
                      context,
                      url,
                      error,
                    ) =>
                        Image.asset(Utils.getImgPath("basket_team_logo.png")),
                    placeholder: (context, url) => Styles.placeholderIcon(),
                    imageUrl: isHome
                        ? "${controller.detail.detail?.homeTeamLogo}"
                        : "${controller.detail.detail?.awayTeamLogo}"),
              ),
              Container(width: 11),
              Text(
                  isHome
                      ? (controller.detail.detail?.homeTeamName ?? "")
                      : controller.detail.detail?.awayTeamName ?? "",
                  style: Styles.mediumText(fontSize: 14))
            ],
          ),
        ),
        LoadingCheckWidget<int>(
          isLoading: false,
          data: entity.length,
          noData: Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Text('暂无数据',
                style: TextStyle(fontSize: 11, color: Colours.grey_color1)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: List.generate(entity.length,
                  (index) => suspendPlayer(isHome, entity[index])),
            ),
          ),
        ),
      ],
    );
  }

  Widget suspendPlayer(bool isHome, TeamInfo player) {
    var reasonImage = '';
    if (player.type == 2 || player.type == 3) {
      reasonImage = 'icon_jinsai.png';
    } else if (player.type == 1) {
      reasonImage = 'icon_shangbing.png';
    }
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                child: Image.asset(
                    fit: BoxFit.fitWidth,
                    color:
                        isHome ? Colours.homeColorRed : Colours.guestColorBlue,
                    Utils.getImgPath("bb_shirt.png")),
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(player.shirtNumber.toString(),
                    style: TextStyle(fontSize: 13, color: Colors.white)),
              ))
            ],
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      (player.playerName) ?? '',
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colours.text_color,
                          fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  if (reasonImage.isNotEmpty)
                    Image.asset(Utils.getImgPath(reasonImage))
                ],
              ),
              Text(
                '${Utils.basketPositionCn(player.position)} ${player.reason ?? ''}',
                style:
                    const TextStyle(fontSize: 11, color: Colours.grey_color1),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        )
      ]),
    );
  }

  Widget chartBox() {
    return Container(
      height: 180,
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Container(
            height: 55,
            alignment: Alignment.centerLeft,
            child: Text("比分走势", style: Styles.mediumText(fontSize: 15)),
          ),
          Expanded(
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CachedNetworkImage(
                        width: 24,
                        height: 24,
                        imageUrl: controller.detail.detail?.awayTeamLogo ?? "",
                        placeholder: (context, url) => Styles.placeholderIcon(),
                        errorWidget: (context, url, error) => Image.asset(
                            Utils.getImgPath('basket_team_logo.png'))),
                    CachedNetworkImage(
                        width: 24,
                        height: 24,
                        imageUrl: controller.detail.detail?.homeTeamLogo ?? "",
                        placeholder: (context, url) => Styles.placeholderIcon(),
                        errorWidget: (context, url, error) => Image.asset(
                            Utils.getImgPath('basket_team_logo.png'))),
                    const SizedBox(height: 10)
                  ],
                ).sized(width: 30),
                Expanded(child: chart())
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget chart() {
    // 分钟
    int perTime = (controller.trends?.appMatchTrends?.isEmpty ?? true)
        ? 0
        : (controller.trends?.appMatchTrends!.first.per ?? 0);
    // 比赛节数
    int matchCount = controller.trends?.periodCount ?? 0;
    final chartsdata = chartsData();
    double max = 0;
    for (var element in chartsdata) {
      final abs = element.y.abs();
      if (abs > max) {
        max = abs;
      }
    }
    double maxX = perTime * matchCount.toDouble();
    final chart = LineChart(LineChartData(
        maxY: max,
        minY: -max,
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: maxX,
        gridData: FlGridData(
          drawHorizontalLine: false,
          verticalInterval: () {
            final v = perTime.toDouble();
            return v == 0 ? null : v;
          }.call(),
          getDrawingVerticalLine: (value) =>
              FlLine(color: const Color(0xFFD7D7D7), strokeWidth: 0.5),
        ),
        lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData:
                LineTouchTooltipData(tooltipBgColor: Colors.white)),
        lineBarsData: [
          LineChartBarData(
              gradient: LinearGradient(colors: [
                Color(0xFF2766D6).withOpacity(0.5),
                Color(0xFF06F0FF).withOpacity(0.5)
              ]),
              spots: chartsdata,
              isCurved: true,
              dotData: FlDotData(show: false),
              aboveBarData: BarAreaData(
                  show: true,
                  cutOffY: 0,
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color.fromARGB(0xff, 245, 63, 67)
                            .withOpacity(0.3),
                        const Color.fromARGB(0, 245, 63, 63)
                      ]),
                  applyCutOffY: true),
              belowBarData: BarAreaData(
                  show: true,
                  cutOffY: 0,
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        const Color.fromARGB(0xff, 39, 102, 214)
                            .withOpacity(0.3),
                        const Color.fromARGB(0, 39, 102, 214)
                      ]),
                  // color: Colors.grey.withOpacity(0.3),
                  applyCutOffY: true))
        ],
        titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              // reservedSize: 20,
              interval: max == 0 ? null : max,
              getTitlesWidget: (value, meta) {
                final text = "${value.abs().toStringAsFixed(0)}";
                return Text(
                  text,
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 12, color: Colours.grey99),
                );
              },
            )),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
              interval: ((controller.trends?.appMatchTrends?.isEmpty ?? true)
                          ? 0
                          : (controller.trends?.appMatchTrends!.first.per ??
                                  0) ??
                              0) >
                      0
                  ? perTime.toDouble()
                  : 1,
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final text = (value == maxX && value > 0)
                    ? "FT"
                    : "${value.toStringAsFixed(0)}";
                return Text(
                  text,
                  style: const TextStyle(fontSize: 12, color: Colours.grey99),
                );
              },
            )),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)))));
    return Stack(
      children: [
        Positioned.fill(
            child: Container(
          child: Column(
            children: [
              Expanded(child: Container(color: const Color(0xFFF9FBFE))),
              Expanded(child: Container(color: const Color(0xFFEEF3FC))),
              Expanded(child: Container(color: const Color(0xFFFEF0F0))),
              Expanded(child: Container(color: const Color(0xFFFFF9F9))),
              const SizedBox(
                height: 23,
              )
            ],
          ).marginOnly(right: 20),
        )),
        chart
      ],
    );
  }

  List<FlSpot> chartsData() {
    final trendsl = controller.trends?.appMatchTrends ?? [];
    if (trendsl.isEmpty) {
      return [];
    }
    final trends = trendsl.first;
    final data = trends.data ?? "";
    final per = trends.per ?? 0;
    final List<FlSpot> list = [FlSpot.zero];
    try {
      List l = jsonDecode(data);
      for (var i = 0; i < l.length; i++) {
        List l1 = l[i];
        for (var j = 0; j < per; j++) {
          final idx = i * per + j + 1;
          if (j < l1.length) {
            int num = l1[j];
            list.add(FlSpot(idx.toDouble(), -num.toDouble()));
          } else {
            list.add(FlSpot.nullSpot);
          }
        }
      }
    } catch (err) {
      log("$err");
    }
    return list;
  }

  Widget compareScoreCol(String s1,int? n1,int? n2,{ double width = 80,Alignment alignment = Alignment.centerLeft}) {
    final c1 = (n1 ?? 0) >= (n2 ?? 0) ? Colours.text_color1 : Colours.grey99;
    final c2 = (n1 ?? 0) <= (n2 ?? 0) ? Colours.text_color1 : Colours.grey99;
    return scoreCol(s1, n1 == null ? "-" : "$n1", n2 == null ? "-" : "$n2",alignment: alignment,width: width,color1: c1,color2: c2,w1: FontWeight.w500);
  }

  Widget scoreCard(String text1,String text2,{int type = 0}) {
    final color = type == 1 ? const Color(0xFFFFF8F8) : const Color(0xFFF5F7FA);
    return Expanded(
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text1,style: const TextStyle(fontSize: 12,color: Color(0xff444444)),),
            const SizedBox(height: 4,),
            Text(text2,style: const TextStyle(fontSize: 12,color: Colours.text_color1),),
          ],
        ),
      ),
    );
  }

  List<Widget> scoreScrollChildren(BoxConstraints p1) {

    List<Widget> children = [];

    var scores = controller.trends?.scoreArray() ?? [];

    final fixScores = (controller.trends?.periodCount == 2) ?
    const [BbScoreItem("上半场"),BbScoreItem("下半场")] :
    const [BbScoreItem("一"),BbScoreItem("二"),BbScoreItem("三"),BbScoreItem("四")];

    for (var i = scores.length; i < (controller.trends?.periodCount ?? 0); i++) {
      scores.add(fixScores[i]);
    }

    final w = (controller.trends?.periodCount == 2) ? p1.maxWidth/2 : p1.maxWidth / 4.5;
    children = scores.map((e) => compareScoreCol(e.name, e.away, e.home,width: w,alignment: Alignment.center)).toList();

    var fixWidth = p1.maxWidth - w * children.length;
    fixWidth = fixWidth > 0 ? fixWidth : 0;
    if (fixWidth > 0) {
      children.add(scoreCol("", "", "",width: fixWidth/2));
      children.insert(0,scoreCol("", "", "",width: fixWidth/2));
    }

    return children;
  }

  Widget score1234() {
    final score = controller.trends?.appMatchScore;
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
      padding: const EdgeInsets.only(left: 12,right: 12,bottom: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
        children: [
          Container(
            height: 55,
            alignment: Alignment.centerLeft,
            child: Text("各节比分", style: Styles.mediumText(fontSize: 15)),
          ),
          Row(
            children: [
              scoreCol("球队", controller.trends?.awayTeamName ?? "", controller.trends?.homeTeamName ?? ""),
              Expanded(child: LayoutBuilder(
                  builder: (context,p1) {
                    log("max width = ${p1.maxWidth} maxheight = ${p1.maxHeight}");
                    return Container(
                      // width: p1.maxWidth,
                      // height: p1.maxHeight,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(),
                        child: Row(children: scoreScrollChildren(p1),),
                      ),
                    );
                  }
              )),
              compareScoreCol("总分", int.tryParse(score?.awayScore ?? ""), int.tryParse(score?.homeScore ?? ""),width: 50,alignment: Alignment.center),
            ],
          ),
          if ((controller.trends?.statusId ?? 0) < 10)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                scoreCard("剩余暂停 ${score?.awayTimeOut}","本节犯规 ${score?.awayFoul}"),
                const SizedBox(width: 11),
                scoreCard("剩余暂停 ${score?.homeTimeOut}","本节犯规 ${score?.homeFoul}",type: 1)
              ],
            ).marginSymmetric(vertical: 8)
        ],
      ),
    );
  }

  Widget scoreCol(String s1,String s2,String s3,{
    double width = 100,Alignment alignment = Alignment.centerLeft,
    Color? color1,Color? color2,FontWeight? w1}) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(height: 30,alignment: alignment,child: Text(s1,maxLines: 1,style: const TextStyle(fontSize: 12,color: Colours.text_color1))),
          const Divider(height: 0.5),
          Container(height:30,alignment: alignment, child: Text(s2,maxLines: 1,style: TextStyle(fontSize: 14,fontWeight: w1,color: color1 ?? Colours.text_color1))),
          Container(height: 30,alignment: alignment,child: Text(s3,maxLines: 1,style: TextStyle(fontSize: 14,fontWeight: w1,color: color2 ?? Colours.text_color1)))
        ],
      ),
    );
  }

  Widget techLineString(String name,
      { required String left, required String right,
        double leftPer = 0.0, double rightPer = 0.0,
        bool leftHighlight = false, bool rightHighlight = false}){
    const blue = Color(0xFF2766D6);
    const red = Color(0xFFF53F3F);
    const grey = Color(0xFFD7D7D7);
    const bg = Color(0xFFF7F7F7);
    return SizedBox(
      height: 42,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(left,style: TextStyle(fontSize: 16,fontFamily: "din", color: leftHighlight ? const Color(0xff000000) : Colours.grey66)),
              Text(name,style: const TextStyle(fontSize: 12,color: Colours.grey66,)),
              Text(right,style: TextStyle(fontSize: 16,fontFamily: "din", color: rightHighlight ? const Color(0xff000000) : Colours.grey66),)
            ],
          ),
          const SizedBox(height: 2,),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2)
            ),
            clipBehavior: Clip.hardEdge,
            child: Row(
              children: [
                Expanded(child: Transform.rotate(angle: math.pi,child:
                myLinearProgress(
                  color: leftHighlight ? blue : grey,
                  minHeight: 6,
                  backgroundColor: bg,
                  value: leftPer,
                ))),
                Expanded(child: myLinearProgress(
                  minHeight: 6,
                  backgroundColor: bg,
                  color: rightHighlight ? red : grey,
                  value: rightPer,
                )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget techLine(String name,{int left = 0,int right = 0,String? leftDesc,String? rightDesc}) {
    left = left >= 0 ? left : 0;
    right = right >= 0 ? right : 0;
    final total = left + right;
    final isLeft = left >= right;
    final isRight = right >= left;
    double leftPer = total == 0 ? 0 : left / total;
    double rightPer = total == 0 ? 0 : right / total;
    return techLineString(name, left: "$leftDesc" , right: "$rightDesc",leftHighlight: isLeft,rightHighlight: isRight,leftPer: leftPer,rightPer: rightPer);
  }

  Widget myLinearProgress({required double minHeight,required Color backgroundColor,required Color color,required double value}) {
    return LayoutBuilder(
        builder: (context,p1) {
          return Container(
            width: p1.maxWidth,
            height: minHeight,
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(2),bottomRight: Radius.circular(2))
            ),
            alignment: Alignment.centerLeft,
            child: Container(
              width: p1.maxWidth * value,
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(2),bottomRight: Radius.circular(2))
              ),
            ),
          );
        }
    );
  }

  Widget techBox() {
    final techsItems = controller.trends?.appMatchItems ?? [];
    double height = 326;
    final techs = [
      ...techsItems.map((e) => techLine(
          e.name ?? "",
          left: int.tryParse(e.away ?? "0") ?? 0,
          right: int.tryParse(e.home ?? "0") ?? 0,
          leftDesc: e.awayVis,
          rightDesc: e.homeVis
      ))
    ];
    if (controller.showMore) {
      height = techs.length * 42 + 24 + 40 + 44;
    }

    return techs.isEmpty ? Container() : AnimatedContainer(
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)
      ),
      duration: const Duration(milliseconds: 200),
      height: height,
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          Expanded(
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: controller.showMore,
                children: [
                  Row(
                    children: [
                      CachedNetworkImage(
                        width: 32,
                        height: 32,
                        imageUrl: controller.detail.detail?.awayTeamLogo ?? "",
                        placeholder: (context, url) => Styles.placeholderIcon(),
                        errorWidget: (context, url, error) => Image.asset(
                          Utils.getImgPath('basket_team_logo.png'))),
                      const SizedBox(width: 4),
                      Text(controller.trends?.awayTeamName ?? "",style: TextStyle(fontSize: 14,color: Colours.text_color1),),
                      const Spacer(),
                      Text(controller.trends?.homeTeamName ?? "",style: TextStyle(fontSize: 14,color: Colours.text_color1)),
                      const SizedBox(width: 4),
                      CachedNetworkImage(
                        width: 32,
                        height: 32,
                        imageUrl: controller.detail.detail?.homeTeamLogo ?? "",
                        placeholder: (context, url) => Styles.placeholderIcon(),
                        errorWidget: (context, url, error) => Image.asset(
                          Utils.getImgPath('basket_team_logo.png')))
                    ],
                  ).sized(height: 40),
                  ...techs
                ],
              )
          ),
          Container(
            alignment: Alignment.bottomCenter,
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.showMore ? "收起数据" : "更多数据",style: TextStyle(color: Colours.main,fontSize: 12),),
                Icon(controller.showMore ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,color: Colours.main,)
              ],
            ),
          ).tap(() => controller.showMore = !controller.showMore)
        ],
      ),
    );
  }
}
