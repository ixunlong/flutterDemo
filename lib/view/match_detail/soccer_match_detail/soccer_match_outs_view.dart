import 'dart:async';
import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/match/match_event_entity.dart';
import 'package:sports/model/match/match_info_entity.dart';
import 'package:sports/model/match/match_technic_entity.dart';
import 'package:sports/model/match/match_text_live_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/match_detail/soccer_match_detail/outs_widget/live_widget.dart';
import 'package:sports/view/match_detail/soccer_match_detail/outs_widget/milestone_widget.dart';
import 'package:sports/view/match_detail/soccer_match_detail/outs_widget/statistics_widget.dart';
import 'package:sports/widgets/rate_circle_widget.dart';

class SoccerMatchOutsView extends StatefulWidget {
  const SoccerMatchOutsView({super.key, this.info, this.matchId});

  final MatchInfoEntity? info;
  final int? matchId;

  @override
  State<SoccerMatchOutsView> createState() => _SoccerMatchOutsViewState();
}

enum _OutsSubType { text, important, statistics }

mixin _OutsStateMixin on State<SoccerMatchOutsView> {
  var subType = 2;
}

const _homeColor = Color(0xFFF53F3F);
const _guestColor = Color(0xFF2766D6);

class _SoccerMatchOutsViewState extends State<SoccerMatchOutsView>
    with _OutsStateMixin, AutomaticKeepAliveClientMixin {
  // SoccerMatchDetailController contr1 = Get.find();

  MatchInfoEntity? get info => widget.info;
  int? get matchId => widget.matchId;

  @override
  bool get wantKeepAlive => true;

  MatchTechEntity? tech;
  Map<int, TechnicDetail> topDetails = {};
  List<MatchEventEntity> events = [];
  List<MatchLiveTextEntity> texts = [];
  int count = 0;
  late Timer liveTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
    if (info?.state != MatchState.inMatch) {
      return;
    }
    _getTextLive();
    if (timer.tick % 4 == 0) {
      _getEvents();
      _getTechInfo();
    }
  });

  Future _getTechInfo() async {
    final id = matchId;
    if (id == null) {
      return;
    }
    final model = await Utils.tryOrNullf(() async {
      final response = await Api.getMatchTech(id);
      final model = MatchTechEntity.fromJson(response.data['d']);
      // log("model = ${model.toJson()}");
      return model;
    });
    tech = model;
    model?.topDetail?.forEach((element) {
      topDetails[element.kind ?? 0] = element;
    });
    update();
  }

  Future _getEvents() async {
    final id = matchId;
    if (id == null) {
      return;
    }
    final events = await Utils.tryOrNullf(() async {
      final response = await Api.getMatchEvent(id, 1);
      final l = response?.data['d'] as List;
      final events = l.map((e) => MatchEventEntity.fromJson(e)).toList();
      log("get events = ${events.map((e) => "${e.kind}").join(",")}");
      return events;
    });
    this.events = events ?? [];
    if (subType == 1) {
      update();
    }
  }

  Future _getTextLive({bool all = false}) async {
    final mid = matchId;
    if (mid == null) {
      return;
    }
    final getTexts = await Utils.tryOrNullf(() async {
      final id = this.texts.isEmpty ? null : this.texts.first.liveId;
      final response = await Api.getMatchTextLive(mid, isAll: all, liveId: id);
      final l = response.data['d'] as List;
      final texts = l.map((e) => MatchLiveTextEntity.fromJson(e)).toList();
      return texts;
    });
    if (all) {
      texts = List.from(getTexts ?? [], growable: true);
    } else if ((getTexts?.length ?? 0) > 0) {
      final lt = getTexts!.last;
      final idx = texts.indexWhere((element) =>
          element.processTime == lt.processTime &&
          element.content == lt.content);
      if (idx == -1) {
        texts.insertAll(0, getTexts);
      } else {
        texts.removeRange(0, idx + 1);
        texts.insertAll(0, getTexts);
      }
    }
    if (subType == 0) {
      update();
    }
  }

  Future<dynamic> doFetchData() async {
    await Future.wait([_getTechInfo(), _getEvents(), _getTextLive(all: true)]);
  }

  @override
  void initState() {
    super.initState();
    doFetchData().then((value) {
      if (texts.isNotEmpty && info?.state == MatchState.inMatch) {
        subType = 0;
      } else if (events.isNotEmpty) {
        subType = 1;
      }
      update();
    });
    liveTimer;
  }

  @override
  void dispose() {
    liveTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return EasyRefresh.builder(
      onRefresh: () async {
        await doFetchData();
      },
      childBuilder: (ctx,p) => ListView(
        // physics: const ClampingScrollPhysics(),
        physics: p,
        padding: EdgeInsets.zero,
        children: [_header(), _subBtns(), _subWidget(), Container(height: 50,color: Colors.white,)],
      ),
    );
  }

  _subBtns() {
    return Container(
      color: Colors.white,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        color: const Color(0xFFFDF8F8),
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (texts.isNotEmpty)
              Expanded(
                  child: _subBtn(0, "文字直播", () {
                Utils.onEvent('bsxq_sk_qhl', params: {'bsxq_sk_qhl': '1'});
                subType = 0;
                update();
              })),
            Expanded(
                child: _subBtn(1, "重要事件", () {
              Utils.onEvent('bsxq_sk_qhl', params: {'bsxq_sk_qhl': '2'});
              subType = 1;
              update();
            })),
            Expanded(
                child: _subBtn(2, "技术统计", () {
              Utils.onEvent('bsxq_sk_qhl', params: {'bsxq_sk_qhl': '3'});
              subType = 2;
              update();
            })),
          ],
        ),
      ),
    );
  }

  Widget _subWidget() {
    if (subType == 0) {
      return TextLiveWidget(texts: texts, info: info);
    } else if (subType == 1) {
      return MilestoneWidget(events: events, match: info);
    } else if (subType == 2) {
      return StatisticsWidget(tech: tech, info: info);
    }
    return Container();
  }

  Widget _subBtn(int type, String text, void Function() onPress) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
            color: type == subType ? Colours.main_color : Colors.transparent,
            borderRadius: BorderRadius.circular(2)),
        alignment: Alignment.center,
        child: Text(text,
            style: TextStyle(
                fontSize: 14,
                color: type == subType ? Colors.white : Colours.main_color)),
      ),
    );
  }

  Widget _compare(String title, int left, int right, {bool berate = false}) {
    final total = left + right;
    final double rate = total == 0 ? 0.5 : left / total;
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colours.grey_color),
        ).marginOnly(bottom: 10),
        Row(
          children: [
            SizedBox(
                width: 30,
                child: Text(
                    berate
                        ? "${(left * 100 / (left + right)).toStringAsFixed(0)}%"
                        : "$left",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12))),
            SizedBox(
              width: 44,
              height: 44,
              child: RateCircleWidget(
                  color1: total == 0 ? Colors.grey : _homeColor,
                  color2: total == 0 ? Colors.grey : _guestColor,
                  radius: 22,
                  rate: rate,
                  width: 5),
            ),
            SizedBox(
                width: 30,
                child: Text(
                    berate
                        ? "${(right * 100 / (left + right)).toStringAsFixed(0)}%"
                        : "$right",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12)))
          ],
        )
      ],
    );
  }

  Widget _row9(Widget l1, Widget l2, Widget l3, Widget l4, Widget m, Widget r1,
      Widget r2, Widget r3, Widget r4) {
    final double itemWidth = 30;
    final ll = [l1, l2, l3, l4];
    final rl = [r1, r2, r3, r4];
    return Container(
      height: 30,
      child: DefaultTextStyle(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...ll.map((e) => SizedBox(width: itemWidth, child: e)),
              Expanded(child: m),
              ...rl.map((e) => SizedBox(width: itemWidth, child: e))
            ],
          )),
    );
  }

  Widget _header() {
    final homeShoot1 = int.tryParse(topDetails[4]?.homeData ?? "") ?? 0;
    final gustShoot1 = int.tryParse(topDetails[4]?.guestData ?? "") ?? 0;
    final rate1 = (homeShoot1 + gustShoot1) == 0
        ? 0.5
        : homeShoot1 / (homeShoot1 + gustShoot1);
    final homeShoot2 = int.tryParse(topDetails[34]?.homeData ?? "") ?? 0;
    final gustShoot2 = int.tryParse(topDetails[34]?.guestData ?? "") ?? 0;
    final rate2 = (homeShoot2 + gustShoot2) == 0
        ? 0.5
        : homeShoot2 / (homeShoot2 + gustShoot2);

    final homeYellow = int.tryParse(topDetails[11]?.homeData ?? "") ?? 0;
    final guestYellow = int.tryParse(topDetails[11]?.guestData ?? "") ?? 0;
    final homeCorner = int.tryParse(topDetails[6]?.homeData ?? "") ?? 0;
    final guestCorner = int.tryParse(topDetails[6]?.guestData ?? "") ?? 0;
    final homeRed = int.tryParse(topDetails[13]?.homeData ?? "") ?? 0;
    final guestRed = int.tryParse(topDetails[13]?.guestData ?? "") ?? 0;

    return Container(
      padding: EdgeInsets.only(top: 10),
      color: Colours.greyF5F5F5,
      child: Container(
        color: Colors.white,
        height: 208,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(info?.baseInfo?.homeName ?? ""),
                    Container(color: _homeColor, width: 14, height: 6)
                        .marginOnly(left: 5)
                  ],
                ),
                Row(
                  children: [
                    Container(color: _guestColor, width: 14, height: 6)
                        .marginOnly(right: 5),
                    Text(info?.baseInfo?.guestName ?? ""),
                  ],
                )
              ],
            ).marginOnly(bottom: 10, top: 5, left: 10, right: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _compare(
                    topDetails[43]?.technicCn ?? "进攻",
                    int.tryParse(
                            topDetails[43]?.homeData?.replaceAll("%", "") ??
                                "") ??
                        0,
                    int.tryParse(
                            topDetails[43]?.guestData?.replaceAll("%", "") ??
                                "") ??
                        0),
                _compare(
                    topDetails[44]?.technicCn ?? "危险进攻",
                    int.tryParse(
                            topDetails[44]?.homeData?.replaceAll("%", "") ??
                                "") ??
                        0,
                    int.tryParse(
                            topDetails[44]?.guestData?.replaceAll("%", "") ??
                                "") ??
                        0),
                _compare(
                    topDetails[14]?.technicCn ?? "控球率",
                    int.tryParse(
                            topDetails[14]?.homeData?.replaceAll("%", "") ??
                                "") ??
                        0,
                    int.tryParse(
                            topDetails[14]?.guestData?.replaceAll("%", "") ??
                                "") ??
                        0),
              ],
            ).marginOnly(bottom: 20),
            _row9(
                const Icon(Icons.flag, size: 15, color: _homeColor),
                Image.asset(Utils.getImgPath("yellow_flag.png"),
                    width: 13, height: 13),
                Image.asset(Utils.getImgPath("red_flag.png"),
                    width: 13, height: 13),
                Text("$homeShoot1",
                    strutStyle: Styles.centerStyle(fontSize: 14)),
                Column(children: [
                  const Text("射正球门",
                          style: TextStyle(
                              fontSize: 12, color: Colours.grey_color))
                      .marginOnly(bottom: 3),
                  LinearProgressIndicator(
                          value: rate1,
                          backgroundColor: _guestColor,
                          color: _homeColor)
                      .rounded(2)
                ]),
                Text("$gustShoot1",
                    strutStyle: Styles.centerStyle(fontSize: 14)),
                Image.asset(Utils.getImgPath("red_flag.png"),
                    width: 13, height: 13),
                Image.asset(Utils.getImgPath("yellow_flag.png"),
                    width: 13, height: 13),
                const Icon(Icons.flag, size: 15, color: _guestColor)),
            _row9(
                Text("$homeCorner",
                    strutStyle: Styles.centerStyle(fontSize: 14)),
                Text("$homeYellow",
                    strutStyle: Styles.centerStyle(fontSize: 14)),
                Text("$homeRed", strutStyle: Styles.centerStyle(fontSize: 14)),
                Text("$homeShoot2",
                    strutStyle: Styles.centerStyle(fontSize: 14)),
                Column(children: [
                  const Text("射偏球门",
                          style: TextStyle(
                              fontSize: 12, color: Colours.grey_color))
                      .marginOnly(bottom: 3),
                  LinearProgressIndicator(
                          value: rate2,
                          backgroundColor: _guestColor,
                          color: _homeColor)
                      .rounded(2)
                ]),
                Text("$gustShoot2",
                    strutStyle: Styles.centerStyle(fontSize: 14)),
                Text("$guestRed", strutStyle: Styles.centerStyle(fontSize: 14)),
                Text("$guestYellow",
                    strutStyle: Styles.centerStyle(fontSize: 14)),
                Text("$guestCorner",
                    strutStyle: Styles.centerStyle(fontSize: 14)))
          ],
        ),
      ),
    );
  }
}
