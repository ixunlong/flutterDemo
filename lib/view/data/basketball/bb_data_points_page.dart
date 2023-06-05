import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:sports/model/data/basket/basket_schedule_entity.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/data/basketball/bb_data_schedule_item.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../logic/data/basketball/bb_data_points_controller.dart';
import '../../../model/data/basket/basket_points_entity.dart';
import '../../../res/colours.dart';
import '../../../res/styles.dart';
import '../../../widgets/ladder_path.dart';
import '../../../widgets/loading_check_widget.dart';
import 'bb_data_list_item.dart';
import 'bb_data_points_chart.dart';

class BbDataPointsPage extends StatefulWidget {
  const BbDataPointsPage({Key? key,this.leagueId, required this.tag}) : super(key: key);

  final int? leagueId;
  final String tag;

  @override
  State<BbDataPointsPage> createState() => _BbDataPointsPageState();
}

class _BbDataPointsPageState extends State<BbDataPointsPage>
    with AutomaticKeepAliveClientMixin{
  late BbDataPointsController controller;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<BbDataPointsController>(
      tag: widget.tag,
      initState: (state){
        controller = Get.put(BbDataPointsController(
            widget.leagueId,
            seasonTag: widget.tag),
            tag: widget.tag);
      },
      didUpdateWidget: (oldWidget,state){
        if(controller.visible) {
          controller = Get.put(BbDataPointsController(
              widget.leagueId, seasonTag: widget.tag),
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
            child: controller.isLoading?Container()
            :EasyRefresh(
              controller: controller.refreshController,
              onRefresh: controller.requestData,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _matchList(),
                    controller.entity?.introduce != null
                      && controller.entity?.introduce != ""
                      ?_leagueIntroduce():Container()
                  ],
                )
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _leagueIntroduce(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 50,top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16,right: 16),
            child: Text("赛事介绍",style: Styles.mediumText(fontSize: 14)),
          ),
          Container(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 8,right: 8),
            child: Html(
              data: controller.formIntroduce(controller.entity?.introduce?.trim() ?? ""),
              style: {
                "div": Style(
                  fontSize: FontSize(14),
                  color: Colours.grey66,
                  textAlign: TextAlign.justify,
                  letterSpacing: -0.25,
                  margin: Margins.zero,
                  padding: const EdgeInsets.all(0)
                ),
                "p": Style(
                  padding: const EdgeInsets.all(0),
                  margin: Margins.all(0),
                  lineHeight: const LineHeight(1.6)
                )
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _matchList(){
    return Column(
      children: List.generate(
        controller.matchList?.length ?? 0,
        (index) => Column(
          children: [
            if(controller.matchList?[index].name.isNullOrEmpty == false
              && controller.matchList?[index].name !="排名")
            Container(
              margin: EdgeInsets.only(top: index!=0?10:0),
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(controller.matchList?[index].name ?? "",
                style: Styles.mediumText(fontSize: 13)),
            ),
            _typeCheck(controller.matchList?[index])
          ],
        )),
    );
  }

  Widget _typeCheck(MatchList? matchList){
    if(matchList?.road != null){
      return BbDataPointsChart(road: matchList?.road);
    }else if(matchList?.scheduleList != null){
      return _schedule(matchList?.scheduleList ?? []);
    }else{
      return _points(matchList?.matchRank, matchList?.areaRank);
    }
  }

  Widget _points(List<Points>? match,List<Points>? area){
    var tab = ["常规赛排行","分区排行"];
    var type = 3;
    if(match != null && area != null){
      type = 2;
    }else if(match == null && area != null){
      type = 1;
    }else if(match != null && area == null){
      type = 0;
    }
    return type ==3?Container():Column(
      children: [
        if(type == 2)
        Container(
          color: Colours.greyF7,
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(2, (index) =>
            ClipPath(
              clipper: LadderPath(false),
              child: Container(
                width: Get.width/2,
                height: 34,
                color: controller.currentTab == index
                  ? Colours.white
                  : Colours.transparent,
                alignment: Alignment.center,
                child: Text(tab[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: controller.currentTab == index
                      ? FontWeight.w600
                      : FontWeight.w400,
                    color: controller.currentTab == index
                      ? Colours.main
                      : Colours.grey66,
                  )
                )
              )
            ).tap(() => controller.currentTab = index)
            )
          ),
        ),
        if(type <=1)
          Container(
            height: 38,
            alignment: Alignment.center,
            child: Text(tab[type].substring(0,tab[type].length-2),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colours.text_color1)
            ),
          ),
        if(controller.currentTab == 0)
        Column(
          children: List.generate(match?.length ?? 0, (index) => _pointsList(match?[index]))
        ),
        if(controller.currentTab == 1)
          Column(
              children: List.generate(area?.length ?? 0, (index) => _pointsList(area?[index]))
          )
      ],
    );
  }

  Widget _schedule(List<ScheduleList> schedule){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(schedule.length, (index) =>
          BbDataScheduleSingleItem(scheduleList: schedule[index])
        )
      ),
    );
  }

  Widget _pointsList(Points? pointsList){
    var qualify = controller.formQualify(pointsList?.qualifying ?? []);
    return Container(
      color: Colours.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10,bottom: 10,right: 16),
            child: pointsList?.groupName != ""?
            BbDataListHeader(headType: pointsList!.groupName!)
            :const BbDataListHeader(headType: "球队"),
          ),
          Column(
            children: List.generate(
              pointsList?.teamStanding?.length ?? 0,
              (childIndex) {
                if(childIndex == 0){
                  controller.qualifyIndex = 0;
                }
                if(qualify.length != 0) {
                  if (childIndex > ((qualify[controller.qualifyIndex]
                    .endRank ?? 10000) - 1)
                    && controller.qualifyIndex <
                      ((pointsList?.qualifying?.length ?? 0) - 1)) {
                    controller.qualifyIndex += 1;
                  }
                }
                return BbDataListItem(
                  index: childIndex,
                  qualify: qualify.isNotEmpty
                      ?(qualify[controller.qualifyIndex]):null,
                  team: pointsList?.teamStanding?[childIndex]);
              }
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
