import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/model/data/basket/basket_schedule_entity.dart';
import 'package:sports/res/routes.dart';

import '../../../model/data/basket/basket_points_entity.dart';
import '../../../res/colours.dart';
import '../../../res/styles.dart';
import '../../../util/utils.dart';
import '../../../widgets/max_bottom_sheet.dart';

class BbDataPointsChart extends StatelessWidget {
  const BbDataPointsChart({Key? key, required this.road}) : super(key: key);

  final Road? road;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        road?.roadVs16 == null
          ? Container()
          : Padding(
            padding: const EdgeInsets.only(bottom: 8), child: round(16)),
        road?.roadVs8 == null
          ? Container()
          : Padding(
            padding: const EdgeInsets.only(bottom: 8), child: round(8)),
        road?.roadVs4 == null
          ? Container()
          : Padding(
            padding: const EdgeInsets.only(bottom: 8), child: round(4)),
        champion(road?.roadVs?[0], road?.roadVs?[0].winTeamId),
        road?.roadVs4 == null
          ? Container()
          : Padding(
            padding: const EdgeInsets.only(top: 8),
            child: round(4, reverse: true)),
        road?.roadVs8 == null
          ? Container()
          : Padding(
            padding: const EdgeInsets.only(top: 8),
            child: round(8, reverse: true)),
        road?.roadVs16 == null
          ? Container()
          : Padding(
            padding: const EdgeInsets.only(top: 8),
            child: round(16, reverse: true)),
      ],
    );
  }

  Widget round(int round, {bool reverse = false}) {
    List<GroupList>? entity;
    switch (round) {
      case 16:
        entity = road!.roadVs16!;
        break;
      case 8:
        entity = road!.roadVs8!;
        break;
      case 4:
        entity = road!.roadVs4!;
        break;
    }
    List<Widget> widgetList = [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          round ~/ 2,
          (index) =>
            matchTeams(round,entity!)[reverse?(index+round~/2):index])),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          round ~/ 4,
          (index) => score(round,entity!)[reverse?index+round~/4:index]
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          round ~/ 4,
          (index) => line(round, entity!,reverse)[reverse?index+round~/4:index]),
      )
    ];
    return Column(
      children: reverse?widgetList.reversed.toList():widgetList);
  }

  List <Widget> line(int round,List<GroupList> entity,bool reverse){
    List<Widget> list = [];
    var change = false;
    if(round~/2 != entity.length){
      change = true;
    }
    for (var e = 0; e < entity.length; e++) {
      if(change){
        list.add(SizedBox(width: Get.width/(round~/2)));
      }
      list.add(SizedBox(
        width: Get.width/(round~/2),
        child: promotionLine(
          reverse: reverse,
          isHomeWin: teamCheck(round~/2)[e] != '' && entity[e].winTeamId != 0
            ?(entity[e].homeTeamId==entity[e].winTeamId):null)));
    }
    return list;
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

  Widget champion(GroupList? info, int? winTeamId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              info?.homeTeamId == info?.winTeamId && info?.winTeamId != 0 && info?.winTeamId != null
                  ? Container(height: 13)
                  : Container(),
              Container(
                width: 100,
                alignment: Alignment.centerRight,
                child: Text(
                  info?.homeName ?? "待定",
                  style: Styles.normalText(fontSize: 12),
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              info?.homeTeamId == info?.winTeamId && info?.winTeamId != 0 && info?.winTeamId != null
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
                  Image.asset(Utils.getImgPath("basket_team_logo.png")),
              imageUrl: info?.homeLogo ?? ''),
        ),
        Container(width: 10),
        info?.awayScore != null
            ? Text("${info!.homeScore!}-${info.awayScore!}",
                style: Styles.boldText(fontSize: 22))
            : Image.asset(Utils.getImgPath("trophy_icon.png")).tap(() => Get.bottomSheet(bottomSheet(info),isScrollControlled: true)),
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
                  Image.asset(Utils.getImgPath("basket_team_logo.png")),
              imageUrl: info?.awayLogo ?? ''),
        ),
        Container(width: 6),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              info?.awayTeamId == info?.winTeamId && info?.winTeamId != 0 && info?.winTeamId != null
                  ? Container(height: 13)
                  : Container(),
              Container(
                width: 100,
                alignment: Alignment.centerLeft,
                child: Text(
                  info?.awayName ?? "待定",
                  style: Styles.normalText(fontSize: 12),
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              info?.awayTeamId == info?.winTeamId && info?.winTeamId != 0 && info?.winTeamId != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Image.asset(Utils.getImgPath("win_icon.png")),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> matchTeams(int round,List<GroupList> entity) {
    List<Widget> list = [];
    var change = false;
    if(round~/2 != entity.length){
      change = true;
    }
    for (var e = 0; e < entity.length; e++) {
      if(change){
        for (var i = 0; i < 2; i++) {
          list.add(Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: Container()
          ));
        }
      }
      for (var i = 0; i < 2; i++) {
        list.add(Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: GestureDetector(
            onTap: () {
              if(i==0 && entity[e].homeTeamId != null && entity[e].homeTeamId != 0) {
                Get.toNamed(Routes.basketTeamDetail,arguments: entity[e].homeTeamId);
              }else if(i==1 && entity[e].awayTeamId != null && entity[e].awayTeamId != 0){
                Get.toNamed(Routes.basketTeamDetail,arguments: entity[e].awayTeamId);

              }
            },
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
                      Image.asset(Utils.getImgPath("basket_team_logo.png")),
                    imageUrl: i == 0
                      ? (entity[e].homeLogo ?? '')
                      : (entity[e].awayLogo ?? "")),
                ),
                Container(height: 4),
                Text(
                  i == 0 ? (entity[e].homeName ?? '待定')
                    : (entity[e].awayName ?? '待定'),
                  style: Styles.normalText(
                    fontSize: Get.width / 8 < 47 &&
                      (i == 0 ? (entity[e].homeName ?? '待定')
                        .split('').length > 3 : (entity[e].awayName ?? '待定')
                        .split('').length > 3) ? 11 : 12),
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
    return list;
  }

  List<Widget> score(int round, List<GroupList> entity) {
    List<Widget> list = [];
    var change = false;
    if(round~/2 != entity.length){
      change = true;
    }
    for (var e = 0; e < entity.length; e++) {
      if(change){
        list.add(Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: Container()
        ));
      }
      list.add(Flexible(
        flex: 1,
        fit: FlexFit.tight,
        child: GestureDetector(
          onTap: () {
            if(entity[e].matchList != null && entity[e].matchList?.length != 0) {
              Get.bottomSheet(bottomSheet(entity[e]),isScrollControlled: true);
            }
          },
          child: entity[e].homeScore != null?Text(
              "${(entity[e].homeScore ?? 0)}-${(entity[e].awayScore ?? 0)}",
              style: Styles.boldText(fontSize: 12)).center:
          Text((entity[e].matchList?.length != 0?
          DateTime.tryParse(entity[e].matchList![0].matchTime ?? "")?.formatedString("MM/dd"):""),
            style: Styles.normalSubText(fontSize: 12)).center
        ),
      ));
    }
    return list;
  }

  bool? isHomeWin(List<ScheduleList> info, int? winTeamId) {
    if (info.isEmpty || winTeamId == 0) {
      return null;
    } else {
      return info[0].awayTeamId == winTeamId;
    }
  }

  Widget bottomSheet(GroupList? info) {
    return MaxBottomSheet(
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10))),
      onClosing: () {  },
      builder: (BuildContext context) => SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 16,right:  16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 15.5),
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
                                  Image.asset(Utils.getImgPath("basket_team_logo.png")),
                              imageUrl: info?.homeLogo ?? ''),
                        ),
                        Container(height: 4),
                        Text(info?.homeName ?? '',
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
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(info?.name ?? "", style: Styles.normalSubText(fontSize: 12)),
                      info?.awayScore != null ? Text(
                          "${info?.homeScore ?? 0}-${info?.awayScore ?? 0}",
                          style: Styles.boldText(fontSize: 20))
                        : Text("vs", style: Styles.boldText(fontSize: 20)),
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
                                  Image.asset(Utils.getImgPath("basket_team_logo.png")),
                              imageUrl: info?.awayLogo ?? ""),
                        ),
                        Container(height: 4),
                        Text(info?.awayName ?? '',
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
                mainAxisSize: MainAxisSize.min,
                children: List.generate(info?.matchList?.length ?? 0, (index) {
                  var away = info?.awayTeamId;
                  var needChange = false;
                  if(info?.matchList?[index].awayTeamId != away) needChange = true;
                  return GestureDetector(
                  onTap: () => info?.matchList?[index].id != null
                    ? Get.toNamed(Routes.basketMatchDetail,
                      arguments: info?.matchList?[index].id):null,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: index!=0?8:0, left: 14, right: 14),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colours.greyF5F7FA),
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      info?.matchList?[index].statusId == 10
                                        ? Row(
                                          children: [
                                            Text(
                                              "${!needChange? (info?.matchList?[index].homeScore) : (info?.matchList?[index].awayScore)}",
                                              style: Styles.boldText(
                                                fontSize: 20)),
                                            Container(width: 2),
                                            Text(!needChange? "(主)" : "",
                                              style: Styles.normalSubText(
                                                fontSize: 10))
                                          ],
                                        )
                                        : Row(
                                          children: [
                                            Text("-", style: Styles.boldText(fontSize: 20)),
                                            Container(width: 2),
                                            Text(!needChange? "(主)" : "",
                                              style: Styles.normalSubText(
                                                fontSize: 10))
                                        ],
                                      ),
                                      needChange ? Container(width: 15)
                                        : Container(),
                                      ],
                                    )
                                )
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${DateTime.parse(info?.matchList?[index].matchTime ?? "").formatedString("MM月dd日 hh:mm")}",
                                    style: Styles.normalText(fontSize: 12))),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    info?.matchList?[index].statusId == 10
                                      ? Row(
                                        children: [
                                          Text(
                                            "${!needChange? (info?.matchList?[index].awayScore) : (info?.matchList?[index].homeScore)}",
                                            style: Styles.boldText(fontSize: 20)),
                                          Container(width: 2),
                                          Text(
                                            needChange?"(主)":"",
                                            style: Styles.normalSubText(fontSize: 10)),
                                          !needChange ? Container(width: 15)
                                            : Container()
                                        ],
                                      )
                                      : Row(
                                      children: [
                                        Text("-", style: Styles.boldText(
                                          fontSize: 20)),
                                        Container(width: 2),
                                        Text(
                                          needChange?"(主)":"",
                                          style: Styles.normalSubText(
                                            fontSize: 10)),
                                        !needChange ? Container(width: 15)
                                          : Container()
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ]
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
                );
                }),
              ),
              Container(height: 12)
            ],
          ),
        ),
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
              ? (entity?[e].homeName ?? '')
              : (entity?[e].awayName ?? ''));
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
