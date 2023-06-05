import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/model/data/data_cup_points_entity.dart';
import 'package:sports/model/data/data_schedule_entity.dart';
import 'package:sports/res/routes.dart';

import '../../res/colours.dart';
import '../../res/styles.dart';
import '../../util/utils.dart';

class DataPointsChart extends StatelessWidget {
  const DataPointsChart({Key? key, required this.road}) : super(key: key);

  final Road? road;

  @override
  // Widget build(BuildContext context) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       road?.roadVs16 == null
  //           ? Container()
  //           : Padding(
  //               padding: const EdgeInsets.only(bottom: 8), child: round(16)),
  //       road?.roadVs8 == null
  //           ? Container()
  //           : Padding(
  //               padding: const EdgeInsets.only(bottom: 8), child: round(8)),
  //       road?.roadVs4 == null
  //           ? Container()
  //           : Padding(
  //               padding: const EdgeInsets.only(bottom: 8), child: round(4)),
  //       champion(road?.roadVs?[0].teamList, road?.roadVs?[0].winTeamId),
  //       road?.roadVs4 == null
  //           ? Container()
  //           : Padding(
  //               padding: const EdgeInsets.only(top: 8),
  //               child: round(4, reverse: true)),
  //       road?.roadVs8 == null
  //           ? Container()
  //           : Padding(
  //               padding: const EdgeInsets.only(top: 8),
  //               child: round(8, reverse: true)),
  //       road?.roadVs16 == null
  //           ? Container()
  //           : Padding(
  //               padding: const EdgeInsets.only(top: 8),
  //               child: round(16, reverse: true)),
  //     ],
  //   );
  // }

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        (road?.roadVs16?.length ?? 0) > 7
            ? Padding(
                padding: const EdgeInsets.only(bottom: 8), child: round(16))
            : Container(),
        (road?.roadVs8?.length ?? 0) > 3
            ? Padding(
                padding: const EdgeInsets.only(bottom: 8), child: round(8))
            : Container(),
        (road?.roadVs4?.length ?? 0) > 1
            ? Padding(
                padding: const EdgeInsets.only(bottom: 8), child: round(4))
            : Container(),
        champion(road?.roadVs?[0].teamList, road?.roadVs?[0].winTeamId),
        (road?.roadVs4?.length ?? 0) > 1
            ? Padding(
                padding: const EdgeInsets.only(top: 8),
                child: round(4, reverse: true))
            : Container(),
        (road?.roadVs8?.length ?? 0) > 3
            ? Padding(
                padding: const EdgeInsets.only(top: 8),
                child: round(8, reverse: true))
            : Container(),
        (road?.roadVs16?.length ?? 0) > 7
            ? Padding(
                padding: const EdgeInsets.only(top: 8),
                child: round(16, reverse: true))
            : Container(),
      ],
    );
  }

  Widget round(int round, {bool reverse = false}) {
    List<GroupList>? entity;
    switch (round) {
      case 16:
        entity = road?.roadVs16;
        break;
      case 8:
        entity = road?.roadVs8;
        break;
      case 4:
        entity = road?.roadVs4;
        break;
    }
    List<Widget> widgetList = [
      Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
              round ~/ 2,
              (index) =>
                  matchTeams(round)[reverse ? index + round ~/ 2 : index])),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
            round ~/ 4,
            (index) => score(
                entity?[reverse ? index + round ~/ 4 : index].teamList ?? [])),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
            round ~/ 4,
            (index) => SizedBox(
                width: Get.width / (round ~/ 2),
                child: promotionLine(
                    reverse: reverse,
                    isHomeWin: teamCheck(round ~/ 2)[index] != ''
                        ? isHomeWin(
                            entity?[reverse ? index + round ~/ 4 : index]
                                    .teamList ??
                                [],
                            entity?[reverse ? index + round ~/ 4 : index]
                                .winTeamId)
                        : null))),
      )
    ];
    return Column(
        children: reverse ? widgetList.reversed.toList() : widgetList);
  }

  Widget promotionLine({bool reverse = false, bool? isHomeWin}) {
    return LayoutBuilder(builder: (context, constraints) {
      return Transform.rotate(
        angle: reverse ? pi : 0,
        child: CustomPaint(
          size: Size(constraints.maxWidth, 20),
          painter: PromotionLine(constraints.maxWidth,
              isHomeWin: reverse
                  ? isHomeWin != null
                      ? !isHomeWin
                      : isHomeWin
                  : isHomeWin),
        ),
      );
    });
  }

  Widget champion(List<TeamList>? info, int? winTeamId) {
    return GestureDetector(
      onTap: () => info?[0].matchId == null
          ? null
          : Get.toNamed(Routes.soccerMatchDetail, arguments: info?[0].matchId),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                isHomeWin(info ?? [], winTeamId) == true
                    ? Container(height: 13)
                    : Container(),
                Container(
                  width: 100,
                  alignment: Alignment.centerRight,
                  child: Text(
                    info?[0].homeName ?? "待定",
                    style: Styles.normalText(fontSize: 12),
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                isHomeWin(info ?? [], winTeamId) == true
                    ? Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Image.asset(Utils.getImgPath("win_icon.png")),
                      )
                    : Container(),
              ],
            ),
          ),
          Container(width: 6),
          Container(
            alignment: Alignment.center,
            width: 36,
            height: 36,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: CachedNetworkImage(
                fit: BoxFit.fitWidth,
                placeholder: (context, url) => Styles.placeholderIcon(),
                errorWidget: (context, url, error) =>
                    Image.asset(Utils.getImgPath("team_logo.png")),
                imageUrl: info?[0].homeLogo ?? ''),
          ),
          Container(width: 10),
          info?[0].status == 7
              ? score(info ?? [], 22)
              : Image.asset(Utils.getImgPath("trophy_icon.png")),
          Container(width: 10),
          Container(
            alignment: Alignment.center,
            width: 36,
            height: 36,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: CachedNetworkImage(
                fit: BoxFit.fitWidth,
                placeholder: (context, url) => Styles.placeholderIcon(),
                errorWidget: (context, url, error) =>
                    Image.asset(Utils.getImgPath("team_logo.png")),
                imageUrl: info?[0].guestLogo ?? ''),
          ),
          Container(width: 6),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isHomeWin(info ?? [], winTeamId) == false
                    ? Container(height: 13)
                    : Container(),
                Container(
                  width: 100,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    info?[0].guestName ?? "待定",
                    style: Styles.normalText(fontSize: 12),
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                isHomeWin(info ?? [], winTeamId) == false
                    ? Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Image.asset(Utils.getImgPath("win_icon.png")),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> matchTeams(round) {
    List<GroupList>? entity;
    switch (round) {
      case 16:
        entity = road?.roadVs16;
        break;
      case 8:
        entity = road?.roadVs8;
        break;
      case 4:
        entity = road?.roadVs4;
        break;
    }
    List<Widget> list = [];
    if (entity?.length != 0) {
      for (var e = 0; e < round ~/ 2; e++) {
        for (var i = 0; i < 2; i++) {
          if (e >= entity!.length) continue;
          list.add(Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: GestureDetector(
              onTap: () => entity?[e].teamList?[0].matchId == null
                  ? null
                  : (entity?[e].teamList?.length ?? 0) < 2
                      ? Get.toNamed(Routes.soccerMatchDetail,
                          arguments: entity?[e].teamList?[0].matchId)
                      : showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          constraints: BoxConstraints(
                              maxWidth: Get.width, maxHeight: Get.height * 0.4),
                          context: Get.context!,
                          builder: (context) =>
                              bottomSheet(entity?[e].teamList)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: CachedNetworkImage(
                        fit: BoxFit.fitWidth,
                        placeholder: (context, url) => Styles.placeholderIcon(),
                        errorWidget: (context, url, error) =>
                            Image.asset(Utils.getImgPath("team_logo.png")),
                        imageUrl: i == 0
                            ? (entity?[e].teamList?[0].homeLogo ?? '')
                            : (entity?[e].teamList?[0].guestLogo ?? "")),
                  ),
                  Container(height: 4),
                  Text(
                    entity?[e].name != null
                        ? entity![e].name!
                        : i == 0
                            ? (entity?[e].teamList?[0].homeName ?? '')
                            : (entity?[e].teamList?[0].guestName ?? ''),
                    style: Styles.normalText(
                        fontSize: Get.width / 8 < 47 &&
                                (i == 0
                                    ? (entity?[e].teamList?[0].homeName ?? '')
                                            .split('')
                                            .length >
                                        3
                                    : (entity?[e].teamList?[0].guestName ?? '')
                                            .split('')
                                            .length >
                                        3)
                            ? 11
                            : 12),
                    softWrap: true,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          ));
        }
      }
    }
    return list;
  }

  Widget score(List<TeamList> info, [double? size]) {
    List<Widget> list = [];
    for (var i = 0; i < info.length; i++) {
      list.add(
        info[i].status == 7
            ? Text(
                info[i].homeScore90 != null
                    ? i == 1
                        ? "${(info[i].guestScore90 ?? 0)}-${(info[i].homeScore90 ?? 0)}"
                        : "${(info[i].homeScore90 ?? 0)}-${(info[i].guestScore90 ?? 0)}"
                    : "",
                style: Styles.boldText(fontSize: size ?? 12))
            : Text(
                DateTime.parse(info[i].matchTime ?? '').formatedString("MM/dd"),
                style: Styles.normalSubText(fontSize: size ?? 12)),
      );
    }
    if (info.length == 1 &&
        (info[0].homeScoreOt != null || info[0].guestScorePk != null)) {
      list.add(Text(
        (info[0].homeScoreOt != null
                ? "加时${info[0].homeScoreOt}-${info[0].guestScoreOt} "
                : "") +
            (info[0].homeScorePk != null
                ? "点球${info[0].homeScorePk}-${info[0].guestScorePk}"
                : ""),
        style: Styles.normalSubText(fontSize: 9),
      ));
    }
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: GestureDetector(
        onTap: () => info[0].matchId == null
            ? null
            : info.length < 2
                ? Get.toNamed(Routes.soccerMatchDetail,
                    arguments: info[0].matchId)
                : showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    constraints: BoxConstraints(
                        maxWidth: Get.width, maxHeight: Get.height * 0.4),
                    context: Get.context!,
                    builder: (context) => bottomSheet(info)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: list,
        ),
      ),
    );
  }

  bool? isHomeWin(List<TeamList> info, int? winTeamId) {
    if (info.isEmpty || winTeamId == 0) {
      return null;
    } else {
      return info[0].homeId == winTeamId;
    }
  }

  Widget bottomSheet(List<TeamList>? info) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(Utils.getImgPath("bottomsheet_close.png")).tap(Get.back),
          Container(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: CachedNetworkImage(
                          fit: BoxFit.fitWidth,
                          placeholder: (context, url) =>
                              Styles.placeholderIcon(),
                          errorWidget: (context, url, error) =>
                              Image.asset(Utils.getImgPath("team_logo.png")),
                          imageUrl: info?[0].homeLogo ?? ''),
                    ),
                    Container(height: 4),
                    Text(
                      info?[0].homeName ?? '',
                      style: Styles.normalText(fontSize: 14),
                      softWrap: true,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("${info?[0].leagueName ?? ""}${info?[0].round ?? ""}",
                      style: Styles.normalSubText(fontSize: 12)),
                  info?[0].status == 7
                      ? Text(
                          "${(info?[0].homeScore90 ?? 0) + (info?[1].guestScore90 ?? 0)}-"
                          "${(info?[0].guestScore90 ?? 0) + (info?[1].homeScore90 ?? 0)}",
                          style: Styles.boldText(fontSize: 20))
                      : Text("vs", style: Styles.boldText(fontSize: 20)),
                  info?[0].homeScoreOt != null
                      ? Text(
                          "加时${(info?[0].homeScoreOt ?? 0) + (info?[1].guestScoreOt ?? 0)}-"
                          "${(info?[0].guestScoreOt ?? 0) + (info?[1].homeScoreOt ?? 0)}",
                          style: Styles.normalSubText(fontSize: 10))
                      : Container(),
                  info?[0].homeScorePk != null
                      ? Text(
                          "点球${(info?[0].homeScorePk ?? 0) + (info?[1].guestScorePk ?? 0)}-"
                          "${(info?[0].guestScorePk ?? 0) + (info?[1].homeScorePk ?? 0)}",
                          style: Styles.normalSubText(fontSize: 10))
                      : Container(),
                ],
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: CachedNetworkImage(
                          fit: BoxFit.fitWidth,
                          placeholder: (context, url) =>
                              Styles.placeholderIcon(),
                          errorWidget: (context, url, error) =>
                              Image.asset(Utils.getImgPath("team_logo.png")),
                          imageUrl: info?[0].guestLogo ?? ""),
                    ),
                    Container(height: 4),
                    Text(
                      info?[0].guestName ?? '',
                      style: Styles.normalText(fontSize: 14),
                      softWrap: true,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              )
            ],
          ),
          Container(height: 18),
          Column(
            children: List.generate(
                2,
                (index) => GestureDetector(
                      onTap: () => info?[index].matchId != null
                          ? Get.toNamed(Routes.soccerMatchDetail,
                              arguments: info?[index].matchId)
                          : null,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: index == 1 ? 8 : 0, left: 14, right: 14),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colours.greyF5F7FA),
                          child: Stack(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              index == 0
                                                  ? Container(width: 15)
                                                  : Container(),
                                              info?[index].status == 7
                                                  ? Row(
                                                      children: [
                                                        Text(
                                                            "${index == 0 ? (info?[index].homeScore90) : (info?[index].guestScore90)}",
                                                            style:
                                                                Styles.boldText(
                                                                    fontSize:
                                                                        20)),
                                                        Container(width: 2),
                                                        Text(
                                                            index == 0
                                                                ? "(主)"
                                                                : "",
                                                            style: Styles
                                                                .normalSubText(
                                                                    fontSize:
                                                                        10))
                                                      ],
                                                    )
                                                  : Container()
                                            ],
                                          ))),
                                  Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                              "${DateTime.parse(info?[index].matchTime ?? "").formatedString("MM月dd日 hh:mm")}",
                                              style: Styles.normalText(
                                                  fontSize: 12)))),
                                  Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              index == 1
                                                  ? Container(width: 15)
                                                  : Container(),
                                              info?[index].status == 7
                                                  ? Row(
                                                      children: [
                                                        Text(
                                                            "${index == 0 ? (info?[index].guestScore90) : (info?[index].homeScore90)}",
                                                            style:
                                                                Styles.boldText(
                                                                    fontSize:
                                                                        20)),
                                                        Container(width: 2),
                                                        Text(
                                                            index == 1
                                                                ? "(主)"
                                                                : "",
                                                            style: Styles
                                                                .normalSubText(
                                                                    fontSize:
                                                                        10))
                                                      ],
                                                    )
                                                  : Container()
                                            ],
                                          )))
                                ],
                              ),
                              Positioned(
                                  top: 0,
                                  bottom: 0,
                                  right: 5,
                                  child: Image.asset(
                                      Utils.getImgPath("arrow_right.png")))
                            ],
                          ),
                        ),
                      ),
                    )),
          )
        ],
      ),
    );
  }

  List<String> teamCheck(round) {
    List<GroupList>? entity;
    switch (round) {
      case 16:
        entity = road?.roadVs16;
        break;
      case 8:
        entity = road?.roadVs8;
        break;
      case 4:
        entity = road?.roadVs4;
        break;
      case 2:
        entity = road?.roadVs;
    }
    List<String> list = [];
    if (entity?.length != 0) {
      for (var e = 0; e < round ~/ 2; e++) {
        for (var i = 0; i < 2; i++) {
          list.add(i == 0
              ? (entity?[e].teamList?[0].homeName ?? '')
              : (entity?[e].teamList?[0].guestName ?? ''));
        }
      }
    }
    return list;
  }
}

class PromotionLine extends CustomPainter {
  final double width;
  final bool reverse;
  final bool? isHomeWin;
  PromotionLine(this.width, {this.isHomeWin, this.reverse = false});

  var losePen = Paint()
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke
    ..color = Colours.greyD9
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  var winPen = Paint()
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke
    ..color = Colours.main
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    Path path1 = Path();
    Path path2 = Path();
    path1.lineTo(0, 6);
    path1.arcToPoint(const Offset(1, 7), radius: const Radius.circular(100));
    path1.lineTo(width / 2, 7);
    path2.moveTo(width, 0);
    path2.lineTo(width, 6);
    path2.arcToPoint(Offset(width - 1, 7), radius: const Radius.circular(100));
    path2.lineTo(width / 2, 7);
    if (reverse) {
      canvas.translate(width, 18);
      canvas.rotate(pi);
    }
    canvas.drawPath(path1, isHomeWin == true ? winPen : losePen);
    canvas.drawPath(path2, isHomeWin == false ? winPen : losePen);
    canvas.drawLine(Offset(width / 2, 7), Offset(width / 2, 18),
        isHomeWin != null ? winPen : losePen);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
