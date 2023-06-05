import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:sports/model/data/data_schedule_entity.dart';
import 'package:sports/view/data/data_points_chart.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../logic/data/data_points_controller.dart';
import '../../model/data/data_cup_points_entity.dart';
import '../../res/colours.dart';
import '../../res/styles.dart';
import '../../widgets/loading_check_widget.dart';
import 'data_list_item.dart';
import 'data_schedule_item.dart';

class DataPointsPage extends StatefulWidget {
  const DataPointsPage({Key? key, this.leagueId, required this.tag})
      : super(key: key);

  final int? leagueId;
  final String tag;

  @override
  State<DataPointsPage> createState() => _DataPointsPageState();
}

class _DataPointsPageState extends State<DataPointsPage>
    with AutomaticKeepAliveClientMixin {
  late DataPointsController controller;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<DataPointsController>(
        tag: widget.tag,
        initState: (state) {
          controller = Get.put(
              DataPointsController(widget.leagueId, seasonTag: widget.tag),
              tag: widget.tag);
        },
        didUpdateWidget: (oldWidget, state) {
          if (controller.visible) {
            controller = Get.put(
                DataPointsController(widget.leagueId, seasonTag: widget.tag),
                tag: widget.tag);
            controller.requestData();
          }
        },
        builder: (controller) {
          return VisibilityDetector(
            key: Key(widget.tag),
            onVisibilityChanged: (VisibilityInfo info) {
              controller.visible = !info.visibleBounds.isEmpty;
            },
            child: LoadingCheckWidget<int>(
              isLoading: controller.isLoading,
              loading: Container(),
              data: controller.entity?.matchList?.length,
              child: controller.isLoading
                  ? Container()
                  : EasyRefresh(
                      controller: controller.refreshController,
                      onRefresh: controller.requestData,
                      child: SingleChildScrollView(
                          child: Column(
                        children: [
                          _matchList(),
                          // controller.entity?.introduce != null
                          //   && controller.entity?.introduce != ""
                          //   ?_leagueIntroduce():Container()
                        ],
                      )),
                    ),
            ),
          );
        });
  }

  Widget _leagueIntroduce() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Text("赛事介绍", style: Styles.mediumText(fontSize: 14)),
          ),
          Container(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Html(
              data: controller
                  .formIntroduce(controller.entity?.introduce?.trim() ?? ""),
              style: {
                "div": Style(
                  fontSize: FontSize(14),
                  color: Colours.grey66,
                  lineHeight: const LineHeight(1.6),
                  textAlign: TextAlign.justify,
                  letterSpacing: -0.25,
                ),
                "p": Style(margin: Margins(bottom: Margin(5)))
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _matchList() {
    return Column(
      children: List.generate(
          controller.matchList?.length ?? 0,
          (index) => Column(
                children: [
                  controller.matchList?[index].name?.length != 0 &&
                          controller.matchList?.length != 1
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(controller.matchList?[index].name ?? "",
                              style: Styles.mediumText(fontSize: 13)),
                        )
                      : Container(),
                  _typeCheck(controller.matchList?[index])
                ],
              )),
    );
  }

  Widget _typeCheck(MatchList? matchList) {
    if (matchList?.road != null) {
      return DataPointsChart(road: matchList?.road);
    } else if (matchList?.pointsList != null) {
      return Column(
        children: List.generate(matchList?.pointsList?.length ?? 0, (index) {
          if (matchList?.pointsList?[index].groupList?.length != 0 &&
              matchList?.pointsList?[index].groupList != null) {
            return Column(
                children: List.generate(
                    matchList?.pointsList?[index].groupList?.length ?? 0,
                    (childIndex) => doubleMatch(
                        matchList?.pointsList?[index].groupList?[childIndex])));
          } else if (matchList
                  ?.pointsList?[index].standingList?.teamStanding?.length !=
              0) {
            return _pointsList(matchList?.pointsList?[index]);
          } else {
            return Container();
          }
        }),
      );
    } else {
      return Container();
    }
  }

  Widget _pointsList(PointsList? pointsList) {
    var qualify =
        controller.formQualify(pointsList?.standingList?.qualifying ?? []);
    return Container(
      color: Colours.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 16),
            child: pointsList?.name != "" && pointsList?.name != "联赛"
                ? DataListHeader(headType: pointsList?.name ?? '球队')
                : const DataListHeader(headType: "球队"),
          ),
          Column(
            children: List.generate(
                pointsList?.standingList?.teamStanding?.length ?? 0,
                (childIndex) {
              if (childIndex == 0) {
                controller.qualifyIndex = 0;
              }
              if (qualify.length != 0) {
                if (childIndex >
                        ((qualify[controller.qualifyIndex].endRank ?? 10000) -
                            1) &&
                    controller.qualifyIndex <
                        ((pointsList?.standingList?.qualifying?.length ?? 0) -
                            1)) {
                  controller.qualifyIndex += 1;
                }
              }
              return DataListItem(
                  index: childIndex,
                  qualify: qualify.isNotEmpty
                      ? (qualify[controller.qualifyIndex])
                      : null,
                  team: pointsList?.standingList?.teamStanding?[childIndex]);
            }),
          ),
        ],
      ),
    );
  }

  Widget doubleMatch(GroupList? entity) {
    int? homeScore;
    int? guestScore;
    for (var i = 0; i < (entity?.teamList?.length ?? 0); i++) {
      var element = entity!.teamList![i];
      if (element.status == 7) {
        homeScore = (homeScore ?? 0) +
            (i == 0
                ? (element.homeScore90 ?? 0) +
                    (element.homeScoreOt ?? 0) +
                    (element.homeScorePk ?? 0)
                : (element.guestScore90 ?? 0) +
                    (element.guestScoreOt ?? 0) +
                    (element.guestScorePk ?? 0));
        guestScore = (guestScore ?? 0) +
            (i == 1
                ? (element.homeScore90 ?? 0)
                : (element.guestScore90 ?? 0) +
                    (element.guestScoreOt ?? 0) +
                    (element.guestScorePk ?? 0));
      }
    }
    TeamList head = TeamList(
        homeId: entity?.teamList?[0].homeId,
        guestId: entity?.teamList?[0].guestId,
        homeLogo: entity?.teamList?[0].homeLogo,
        guestLogo: entity?.teamList?[0].guestLogo,
        homeName: entity?.teamList?[0].homeName,
        guestName: entity?.teamList?[0].guestName,
        homeScore90: homeScore,
        guestScore90: guestScore,
        status: (entity?.teamList?.length ?? 0) > 1
            ? (entity?.teamList?[1].status)
            : entity?.teamList?[0].status);
    return (entity?.teamList?.length ?? 0) > 1
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: DataScheduleSingleItem(teamList: head),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colours.greyF5F7FA),
                  child: Column(
                    children: [
                      DataScheduleSingleItem(
                          teamList: entity?.teamList?[0],
                          color: Colours.transparent),
                      DataScheduleSingleItem(
                          teamList: entity?.teamList?[1],
                          color: Colours.transparent),
                    ],
                  ),
                )
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DataScheduleSingleItem(teamList: entity?.teamList?[0]),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
