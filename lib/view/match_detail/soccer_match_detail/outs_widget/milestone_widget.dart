import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/model/match/match_event_entity.dart';
import 'package:sports/model/match/match_info_entity.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/match_detail/soccer_match_detail/match_nodata_widget.dart';

import '../../../../res/colours.dart';

class MilestoneWidget extends StatefulWidget {
  const MilestoneWidget({super.key, required this.events, this.match});

  final List<MatchEventEntity> events;
  final MatchInfoEntity? match;

  @override
  State<MilestoneWidget> createState() => _MilestoneWidgetState();
}

enum MatchEvent {
  changeup,
  changedown,
  cardYellow,
  cardRed,
  cardYR,
  goal,
  kick,
  own,
  corner,
  loose,
  evVar,
  half,
  zhugong,
  end
}

class MatchEventModel {
  MatchEventModel(
      this.eventTime, this.isHome, this.eventType, this.eventContent);
  final String eventTime;
  final bool isHome;
  final MatchEvent eventType;
  final String? eventContent;

  Image get image {
    switch (eventType) {
      case MatchEvent.cardRed:
        return _MilestoneWidgetState.iconRed;
      case MatchEvent.cardYellow:
        return _MilestoneWidgetState.iconYellow;
      case MatchEvent.cardYR:
        return _MilestoneWidgetState.iconYR;
      case MatchEvent.goal:
        return _MilestoneWidgetState.iconGoal;
      case MatchEvent.corner:
        return _MilestoneWidgetState.iconConer;
      case MatchEvent.kick:
        return _MilestoneWidgetState.iconKick;
      case MatchEvent.own:
        return _MilestoneWidgetState.iconOwn;
      case MatchEvent.changeup:
        return _MilestoneWidgetState.iconUp;
      case MatchEvent.changedown:
        return _MilestoneWidgetState.iconDown;
      case MatchEvent.evVar:
        return _MilestoneWidgetState.iconVAR;
      case MatchEvent.loose:
        return _MilestoneWidgetState.iconLoose;
      case MatchEvent.zhugong:
        return _MilestoneWidgetState.iconZg;
      default:
        return _MilestoneWidgetState.iconGoal;
    }
  }

  static List<MatchEventModel> getFromEntity(MatchEventEntity ee) {
    //1 : 进球  2 : 红牌  3 : 黄牌  37 : 罚失点球  7 : 点球  8 : 乌龙   9 : 两黄变红  11 : 换人  14 : VAR 21 : 助攻
    List<MatchEventModel> l = [];
    switch (ee.kind) {
      case 1:
        l.add(MatchEventModel(ee.eventTime ?? "", (ee.isHome ?? 0) > 0,
            MatchEvent.goal, ee.playerCh));
        break;
      case 2:
        l.add(MatchEventModel(ee.eventTime ?? "", (ee.isHome ?? 0) > 0,
            MatchEvent.cardRed, ee.playerCh));
        break;
      case 3:
        l.add(MatchEventModel(ee.eventTime ?? "", (ee.isHome ?? 0) > 0,
            MatchEvent.cardYellow, ee.playerCh));
        break;
      case 37:
        l.add(MatchEventModel(ee.eventTime ?? "", (ee.isHome ?? 0) > 0,
            MatchEvent.corner, ee.playerCh));
        break;
      case 7:
        l.add(MatchEventModel(ee.eventTime ?? "", (ee.isHome ?? 0) > 0,
            MatchEvent.kick, ee.playerCh));
        break;
      case 8:
        l.add(MatchEventModel(ee.eventTime ?? "", (ee.isHome ?? 0) > 0,
            MatchEvent.own, ee.playerCh));
        break;
      case 9:
        l.add(MatchEventModel(ee.eventTime ?? "", (ee.isHome ?? 0) > 0,
            MatchEvent.cardYR, ee.playerCh));
        break;
      case 11:
        final arr = ee.playerCh?.split(RegExp("[↑↓]"))
          ?..removeWhere((element) => element.isEmpty);
        l.add(MatchEventModel(ee.eventTime ?? "", (ee.isHome ?? 0) > 0,
            MatchEvent.changeup, arr?.first ?? ""));
        l.add(MatchEventModel(ee.eventTime ?? "", (ee.isHome ?? 0) > 0,
            MatchEvent.changedown, arr?.last ?? ""));
        break;
      case 13:
        l.add(MatchEventModel(ee.eventTime ?? "", (ee.isHome ?? 0) > 0,
            MatchEvent.loose, ee.playerCh));
        break;
      case 14:
        l.add(MatchEventModel(ee.eventTime ?? "", (ee.isHome ?? 0) > 0,
            MatchEvent.evVar, ee.playerCh));
        break;
      case 53:
        l.add(MatchEventModel(ee.eventTime ?? ee.halfScore ?? ee.allScore ?? "",
            (ee.isHome ?? 0) > 0, MatchEvent.half, ee.playerCh));
        break;
      case 5:
        l.add(MatchEventModel(ee.eventTime ?? ee.halfScore ?? ee.allScore ?? "",
            (ee.isHome ?? 0) > 0, MatchEvent.end, ee.playerCh));
        break;
      case 21: 
        l.add(MatchEventModel(ee.eventTime ?? ee.halfScore ?? ee.allScore ?? "",
            (ee.isHome ?? 0) > 0, MatchEvent.zhugong, ee.playerCh));
            break;
      default:
        log("ignore event ${ee.kind}");
    }
    return l;
  }
}

const eventsKindImportant = [ 1,  2,  3,  37,  7,  8,  9,  11,  13,  14,  21,  53,  5 ];

class _MilestoneWidgetState extends State<MilestoneWidget> {
  // final scroll = ScrollController();

  // final detail = Get.find<SoccerMatchDetailController>();

  bool onlyScore = false;

  MatchInfoEntity? get info => widget.match;

  get match => widget.match;
  List<MatchEventEntity> get events => widget.events;
  List<MatchEventEntity> get eventsImportant => List.from(events)
    ..removeWhere(
        (element) => !eventsKindImportant.contains(element.kind ?? 0));
  List<MatchEventEntity> get eventsGoal => List.from(eventsImportant)
    ..removeWhere((element) =>
        element.kind != 1 && element.kind != 5 && element.kind != 53 && element.kind != 7 && element.kind != 8);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<List<MatchEventModel>> makeEventsList({bool beforeHalf = true}) {
    final l = List<List<MatchEventModel>>.generate(0, (index) => []);

    final events1 =
        onlyScore ? List.from(eventsGoal) : List.from(eventsImportant);
    var time = "";
    for (var i = 0; i < events1.length; i++) {
      final e = events1[i];
      if (e.eventTime == time) {
        l.last.addAll(MatchEventModel.getFromEntity(e));
      } else {
        time = e.eventTime ?? "";
        l.add(MatchEventModel.getFromEntity(e));
      }
    }
    // l.removeWhere((element) => element.length == 0);
    return l;
  }

  String? get halfScore => info?.halfScoreRate;
  bool get isMatchFinish => info?.isMatchFinish ?? false;

  @override
  Widget build(BuildContext context) {
    // log("events = ${events.map((e) => e.toJson())}");
    if (eventsImportant.isEmpty) {
      return MatchNodataWidget(info: info);
    }
    final datalist1 = makeEventsList(beforeHalf: true);
    final l1 = ListView.builder(
        // controller: scroll,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: datalist1.length,
        itemBuilder: ((context, index) {
          final list = datalist1[index];
          bool hasBottom = index < (datalist1.length - 1);
          if (halfScore == null && datalist1.length == index + 1) {
            hasBottom = false;
          }
          // log("build $index length ${list.length}");
          return _timeCell(true, hasBottom, list);
        }));
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _top(),
          Column(children: [
            const Text("开始"),
            const SizedBox(height: 5),
            Image.asset(Utils.getImgPath("ev_match_start.png"),
                width: 20, height: 20, fit: BoxFit.fill)
          ]).marginSymmetric(vertical: 10),
          l1,
          // _footer(),
          _iconWidget()
        ],
      ),
    );
  }

  Widget _eventCell(bool isLeft, MatchEventModel model) {
    final r = isLeft
        ? Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Expanded(
                child: Tooltip(
                    message: model.eventContent ?? "",
                    child: Text(model.eventContent ?? "",
                        textAlign: TextAlign.right))),
            const SizedBox(width: 5),
            model.image
          ])
        : Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            model.image,
            const SizedBox(width: 5),
            Expanded(
                child: Tooltip(
                    message: model.eventContent ?? "",
                    child: Text(model.eventContent ?? "",
                        textAlign: TextAlign.left)))
          ]);
    return r.sized(height: 21);
  }

  Widget _eventCellBox(bool isLeft, List<MatchEventModel> evs) {
    if (evs.isEmpty) {
      return Container();
    }
    double height = evs.length * 21 + 15;
    return Container(
        padding: const EdgeInsets.all(7.5),
        margin: EdgeInsets.only(left: isLeft ? 20 : 0, right: isLeft ? 0 : 20),
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2), color: Color(0xFFF5F7FA)),
        child: DefaultTextStyle(
          style: TextStyle(color: Color(0xFF292D32), fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          child: Column(
            children: [...evs.map((e) => _eventCell(isLeft, e))],
          ),
        ));
  }

  Widget _timeCell(bool hasTop, bool hasBottom, List<MatchEventModel> evs) {
    // log("evs length = ${evs.length}");
    if (evs.isEmpty) {
      return Container();
    }
    final first = evs.first;
    final mid = first.eventTime;
    Widget center = Container(
        width: 40,
        height: 32,
        alignment: Alignment.center,
        child: Text(" $mid´"));
    if (first.eventType == MatchEvent.half) {
      evs = [];
      center = Container(
          width: 200,
          height: 32,
          alignment: Alignment.center,
          child: Text(mid));
    } else if (first.eventType == MatchEvent.end) {
      evs = [];
      center = Container(
          width: 200,
          // height: ,
          alignment: Alignment.center,
          child: Column(children: [
            Image.asset(Utils.getImgPath("ev_match_end.png"),
                width: 20, height: 20, fit: BoxFit.fill),
            const SizedBox(height: 5),
            Text(mid)
          ]).marginSymmetric(vertical: 10));
    }

    List<MatchEventModel> leftList = [];
    List<MatchEventModel> rightList = [];
    for (var i = 0; i < evs.length; i++) {
      if (evs[i].isHome) {
        leftList.add(evs[i]);
      } else {
        rightList.add(evs[i]);
      }
    }
    final maxlen =
        leftList.length > rightList.length ? leftList.length : rightList.length;

    double height = maxlen * 21 + 15 + 20;
    height = height > 59 ? height : 59;
    if (first.eventType == MatchEvent.end) {
      height = 70;
    }
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(child: Center(
            child: leftList.isEmpty ? Container() :
            Container(
              margin: EdgeInsets.only(left: 20,top: 8,bottom: 8),
              padding: EdgeInsets.all(7.5),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: Color(0xFFF5F7FA)),
              child: DefaultTextStyle(
                style: TextStyle(color: Color(0xFF292D32), fontSize: 12),
                child: Column(
                  children: [
                    ...leftList.map((e) => Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Text(e.eventContent ?? "",maxLines: 99,textAlign: TextAlign.end,)),
                        SizedBox(width: 3,),
                        e.image.marginAll(2)
                      ],
                    ))
                  ],
                ),
              ),
            ),
          )),
          Column(
            children: [
              Expanded(child: Container(width: 1,color: hasTop ? Color(0xFFEEEEEE) : Colors.transparent,)),
              center,
              Expanded(child: Container(width: 1,color: hasBottom ? Color(0xFFEEEEEE) : Colors.transparent,)),
            ],
          ),
          Expanded(child: Center(
            child: rightList.isEmpty ? Container() :
            Container(
              margin: EdgeInsets.only(right: 20,top: 8,bottom: 8),
              padding: EdgeInsets.all(7.5),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: Color(0xFFF5F7FA)),
              child: DefaultTextStyle(
                style: TextStyle(color: Color(0xFF292D32), fontSize: 12),
                child: Column(
                  children: [
                    ...rightList.map((e) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        e.image.marginAll(2),
                        SizedBox(width: 3,),
                        Expanded(child: Text(e.eventContent ?? "",maxLines: 99,)),
                      ],
                    ))
                  ],
                ),
              ),
            ),
          )),
        ],
      ),
    );

    return Container(
      height: height,
      child: Row(
        children: [
          Expanded(
              child: Container(
            child: _eventCellBox(true, leftList),
          )),
          Column(
            children: [
              Expanded(
                  child: Container(
                width: 1,
                color: hasTop ? Color(0xFFEEEEEE) : Colors.transparent,
              )),
              center,
              Expanded(
                  child: Container(
                width: 1,
                color: hasBottom ? Color(0xFFEEEEEE) : Colors.transparent,
              )),
            ],
          ),
          Expanded(
              child: Container(
            child: _eventCellBox(false, rightList),
          ))
        ],
      ),
    );
  }

  Widget _top() {
    return Container(
      height: 40,
      margin: EdgeInsets.only(right: 12, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.translate(
            offset: Offset(0, 0),
            child: Text("只看进球",
                style: TextStyle(fontSize: 14, color: Colors.black)),
          ),
          Transform.scale(
            scale: 0.8,
            child: CupertinoSwitch(
                activeColor: Colors.red,
                value: onlyScore,
                onChanged: (v) {
                  onlyScore = v;
                  update();
                }),
          )
        ],
      ),
    );
  }

  _desc(Widget img, String desc) {
    return SizedBox(
      width: 45,
      height: 20,
      child: Row(
        children: [img, Text(desc).marginOnly(left: 5)],
      ),
    );
  }

  static get iconGoal => Image.asset(Utils.getImgPath("ev_match_soccer.png"),
      color: Colors.black, width: 14, height: 14);
  static get iconKick => Image.asset(Utils.getImgPath("ev_match_soccer.png"),
      width: 14, height: 14);
  static get iconOwn => Image.asset(Utils.getImgPath("ev_match_soccer.png"),
      color: Colors.red, width: 14, height: 14);
  static get iconLoose => Image.asset(Utils.getImgPath("ev_match_loose.png"),
      width: 14, height: 14);
  static get iconConer => Image.asset(Utils.getImgPath("ev_match_corner.png"),
      width: 14, height: 14);
  static get iconZg => Image.asset(Utils.getImgPath("ev_match_zg.png"),width: 14,height: 14);
  static get iconVAR =>
      Image.asset(Utils.getImgPath("ev_match_var.png"), width: 14, height: 14);
  static get iconRed =>
      Image.asset(Utils.getImgPath("red_flag.png"), width: 14, height: 14);
  static get iconYellow =>
      Image.asset(Utils.getImgPath("yellow_flag.png"), width: 14, height: 14);
  static get iconYR =>
      Image.asset(Utils.getImgPath("ev_match_yr.png"), width: 14, height: 14);
  static get iconDown =>
      Image.asset(Utils.getImgPath("ev_match_down.png"), width: 14, height: 14);
  static get iconUp =>
      Image.asset(Utils.getImgPath("ev_match_up.png"), width: 14, height: 14);

  List icon = [
    iconGoal,iconKick,iconOwn,iconLoose,iconVAR,iconRed,iconYellow,iconYR,iconDown,iconUp
  ];
  List title = ['进球', '点球', '乌龙', '失点', "VAR", '红牌', '黄牌', '两黄', '下场', '上场'];

  Widget _iconWidget() {
    return Container(
      height: 80,
      color: Colours.white,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                  5, (index) => Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      icon[index],
                      const SizedBox(width: 5),
                      Text(title[index],
                          style: const TextStyle(fontSize: 12, height: 1))
                    ],
                  ))),
          Container(height: 10),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                  5, (index) => Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      icon[5+index],
                      const SizedBox(width: 5),
                      Text(title[5 + index],
                          style: const TextStyle(fontSize: 12, height: 1))
                    ],
                  ))),
        ],
      ),
    );
  }

  Widget _footer() {
    return DefaultTextStyle(
        style: const TextStyle(fontSize: 12, color: Colors.black),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          // color: Colors.red,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _desc(iconGoal, "进球"),
                  _desc(iconKick, "点球"),
                  _desc(iconOwn, "乌龙"),
                  _desc(iconLoose, "失点"),
                  _desc(iconVAR, "VAR"),
                  // _desc(iconZg, "助攻"),
                ],
              ).sized(height: 25),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _desc(iconRed, "红牌"),
                  _desc(iconYellow, "黄牌"),
                  _desc(iconYR, "两黄"),
                  _desc(iconDown, "下场"),
                  _desc(iconUp, "上场"),
                ],
              ).sized(height: 25),
              // SizedBox(height: 16),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     _desc(iconVAR, "VAR"),
              //     _desc(Container(), ""),
              //     _desc(Container(), ""),
              //     _desc(Container(), ""),
              //     _desc(Container(), ""),
              //   ],
              // ).sized(height: 25)
            ],
          ),
        ));
  }
}
