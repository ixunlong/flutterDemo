import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sports/logic/match/basket_list_focus_controller.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/model/match/basket_list_entity.dart';
import 'package:sports/model/match/match_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/date_utils_extension.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/match_detail/basketball_match_detail/bb_detail_page.dart';

class BasketListCell extends StatefulWidget {
  BasketListEntity match;
  BasketListCell(this.match, {super.key});

  @override
  State<BasketListCell> createState() => _BasketListCellState();
}

class _BasketListCellState extends State<BasketListCell> {
  bool isStarAnimate = false;
  BasketConfig config = Get.find<ConfigService>().basketConfig;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.toNamed(Routes.b)
        Get.toNamed(Routes.basketMatchDetail, arguments: widget.match.id);
      },
      child: Container(
          // height: 50,
          // width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: widget.match.lastMatchInDay
              ? null
              : BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colours.greyF7, width: 4))),
          child: Column(
            children: [
              top(),
              SizedBox(height: 10),
              middle(),
            ],
          )),
    );
  }

  top() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          fit: FlexFit.tight,
          flex: 2,
          child: Row(
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text(
                widget.match.leagueName ?? '',
                style: const TextStyle(
                    color: Colours.grey_color,
                    // widget.match.leagueColor == null
                    //     ? Colours.grey_color
                    //     : HexColor(widget.match.leagueColor!),
                    fontSize: 11),
                // strutStyle: StrutStyle(
                //     fontSize: 11, height: 1.1, forceStrutHeight: true),
              ),
              // if (widget.match.rounds != null) ...[
              //   SizedBox(width: 6),
              //   Text(
              //     '第${widget.match.rounds}轮',
              //     style:
              //         const TextStyle(color: Colours.grey_color, fontSize: 11),
              //   ),
              // ],
              SizedBox(width: 6),
              Text(
                DateUtilsExtension.formatDateString(
                    widget.match.matchTime!, 'HH:mm'),
                style: const TextStyle(color: Colours.grey_color, fontSize: 11),
              ),
              SizedBox(width: 6),
              if (config.basketList3 == 1)
                Text(widget.match.jcNo ?? '',
                    style: const TextStyle(
                        color: Colours.grey_color, fontSize: 11))
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Center(
              child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${widget.match.show}',
                  style: TextStyle(
                      color: HexColor(widget.match.color!), fontSize: 11)),
              if (widget.match.statusId == '2' ||
                  widget.match.statusId == '4' ||
                  widget.match.statusId == '6' ||
                  widget.match.statusId == '8' ||
                  widget.match.statusId == '9')
                Text('\'',
                        style: TextStyle(
                            color: HexColor(widget.match.color!), fontSize: 11))
                    .animate(
                      onPlay: (controller) => controller.repeat(),
                    )
                    .fade(duration: 1000.ms)
            ],
          )),
        ),
        Flexible(
            flex: 2,
            child: !widget.match.hasBegin()
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Visibility(
                        visible: widget.match.intelligence == 1,
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.basketMatchDetail,
                                arguments: widget.match.id,
                                parameters: {'tabName': Constant.qingbao});
                          },
                          child: const Text(
                            Constant.qingbao,
                            style: TextStyle(
                                fontSize: 11, color: Colours.yellowFFB400),
                          ),
                        ),
                      ),
                      // const SizedBox(width: 4),
                      // Visibility(
                      //   visible: widget.match.lineup == 1,
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       Get.toNamed(Routes.basketMatchDetail,
                      //           arguments: widget.match.id,
                      //           parameters: {'tabName': Constant.zhenrong});
                      //     },
                      //     child: Container(
                      //       margin: EdgeInsets.only(left: 6),
                      //       child: const Text(Constant.zhenrong,
                      //           style: TextStyle(
                      //               fontSize: 11, color: Colours.homeColorRed)),
                      //     ),
                      //   ),
                      // ),
                      Visibility(
                        visible: widget.match.planCnt != 0,
                        child: Container(
                          margin: EdgeInsets.only(left: 6),
                          child: Text('方案${widget.match.planCnt}',
                              style: TextStyle(
                                  fontSize: 11, color: Colours.guestColorBlue)),
                        ),
                      )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '差 ${widget.match.matchPursueScore}  总 ${widget.match.matchScore}',
                        style: TextStyle(fontSize: 11, color: Colours.grey66),
                      )
                    ],
                  ))
      ],
    );
  }

  middle() {
    return Row(
      // mainAxisSize: MainAxisSize.max,
      children: [
        GestureDetector(
            onTap: () async {
              isStarAnimate = true;
              if (User.basketballFocuses.isFocus(widget.match.id!)) {
                // Utils.onEvent('bspd_gz', params: {'bspd_gz': '0'});
                await User.basketballFocuses.unFocus(widget.match.id!);
              } else {
                // Utils.onEvent('bspd_gz', params: {'bspd_gz': '1'});
                await User.basketballFocuses.focus(widget.match.id!);
              }
              setState(() {});
              try {
                Get.find<BasketListFocusController>().getMatch();
              } catch (e) {}
              // matchInterestController.getMatch();
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: User.basketballFocuses.isFocus(widget.match.id!)
                  ? Image.asset(Utils.getImgPath("star.png"),
                          color: Color(0xFFF53F3F), width: 18, height: 18)
                      .animate(onComplete: (controller) => controller.reverse())
                      .scale(
                          begin: 1,
                          end: isStarAnimate ? 2 : 1,
                          duration: 150.ms,
                          curve: Curves.bounceInOut)
                  : Image.asset(Utils.getImgPath("star_border.png"),
                      color: Colors.grey,
                      width: 18,
                      height: 18,
                      fit: BoxFit.scaleDown),
            )),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [team(false), SizedBox(height: 6), team(true)],
          ),
        ),
        teamRight()
      ],
    );
  }

  team(bool isHome) {
    bool isBegin = (widget.match.statusId != 1);
    double nameWidth =
        isBegin ? Get.width - 62 - 25 - 176 : Get.width - 63 - 100;
    final position =
        isHome ? widget.match.homePosition : widget.match.awayPosition;

    return Row(
      // mainAxisSize: MainAxisSize.max,
      children: [
        CachedNetworkImage(
          imageUrl: isHome
              ? widget.match.homeLogo ?? ''
              : widget.match.awayLogo ?? '',
          width: 20,
          height: 20,
          placeholder: (context, url) => Styles.placeholderIcon(),
          errorWidget: (context, url, error) =>
              Image.asset(Utils.getImgPath("basket_team_logo.png")),
        ),
        SizedBox(width: 4),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: nameWidth),
          child: Text(
              isHome
                  ? widget.match.homeName ?? ''
                  : widget.match.awayName ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 14,
                  color: Colours.text_color1,
                  fontWeight: FontWeight.w500),
              strutStyle: StrutStyle(
                  forceStrutHeight: true, height: 1.2, fontSize: 14)),
        ),
        SizedBox(width: 2),
        if (config.basketList2 == 1)
          Text(
            position.valuable == true ? '[$position]' : '',
            style: TextStyle(fontSize: 11, color: Colours.grey99),
          ),
      ],
    );
  }

  teamRight() {
    bool isBegin = (widget.match.statusId != 1);
    return isBegin
        ? Column(
            children: [teamScore(false), SizedBox(height: 6), teamScore(true)],
          )
        : (config.basketList1 == 1
            ? teamOdds()
            : Column(
                children: [recent(false), SizedBox(height: 9), recent(true)],
              ));
  }

  teamOdds() {
    List<OddsList>? oddsList = widget.match.oddsList;
    List<List<String>> showList = [];
    if (oddsList != null) {
      oddsList =
          oddsList.where((element) => element.c == config.basketList8).toList();
      if (config.basketList7.contains(0)) {
        List<String> span = [];
        for (OddsList odds in oddsList) {
          if (odds.p == 2001) {
            List<Map<String, dynamic>> jsonList;
            if (config.basketList9 == 0) {
              jsonList = List<Map<String, dynamic>>.from(jsonDecode(odds.o1!));
            } else {
              jsonList = List<Map<String, dynamic>>.from(jsonDecode(odds.o2!));
            }
            span.add(
                jsonList.firstWhere((element) => element['i'] == 's')['o']!);
            span.add('');
            span.add(' ' +
                jsonList.firstWhere((element) => element['i'] == 'f')['o']!);
            showList.add(span);
          }
        }
      }
      if (config.basketList7.contains(1)) {
        List<String> span = [];
        for (OddsList odds in oddsList) {
          if (odds.p == 2002) {
            List<Map<String, dynamic>> jsonList;
            if (config.basketList9 == 0) {
              jsonList = List<Map<String, dynamic>>.from(jsonDecode(odds.o1!));
            } else {
              jsonList = List<Map<String, dynamic>>.from(jsonDecode(odds.o2!));
            }
            span.add(
                jsonList.firstWhere((element) => element['i'] == 's')['o']!);
            span.add(' ' + (odds.l ?? ''));
            span.add(' ' +
                jsonList.firstWhere((element) => element['i'] == 'f')['o']!);
            showList.add(span);
          }
        }
      }

      if (config.basketList7.contains(2)) {
        List<String> span = [];
        for (OddsList odds in oddsList) {
          if (odds.p == 2003) {
            List<Map<String, dynamic>> jsonList;
            if (config.basketList9 == 0) {
              jsonList = List<Map<String, dynamic>>.from(jsonDecode(odds.o1!));
            } else {
              jsonList = List<Map<String, dynamic>>.from(jsonDecode(odds.o2!));
            }
            span.add(
                jsonList.firstWhere((element) => element['i'] == 'd')['o']!);
            span.add(
              ' ' + (odds.l ?? ''),
            );
            span.add(' ' +
                jsonList.firstWhere((element) => element['i'] == 'x')['o']!);
            showList.add(span);
          }
        }
      }
    }
    // if (showList.length == 1) {
    //   showList.add([]);
    // }
    List<Widget> list = showList
        .map((e) => SizedBox(
              height: 17,
              child: Row(
                children: List.generate(
                    e.length,
                    (index) => Container(
                        width: 50,
                        alignment: Alignment.center,
                        child: Text(
                          e[index],
                          style: TextStyle(
                              fontSize: 12,
                              color:
                                  index == 1 ? Colours.grey66 : Colours.grey99),
                        ))),
              ),
            ))
        .toList();
    if (list.length == 2) {
      list.insert(1, SizedBox(height: 9));
    } else if (list.length == 3) {
      list.insert(2, SizedBox(height: 2));
      list.insert(1, SizedBox(height: 2));
    }
    return Column(
      children: list,
    );
  }

  teamScore(bool isHome) {
    List<String> score = [];
    List<String> otherScore = [];
    bool ot = (widget.match.needPeriod ?? 0) > (widget.match.periodCount ?? 0);
    int showPeriod =
        ot ? widget.match.needPeriod! - 1 : widget.match.needPeriod!;

    List.generate(4, (index) {
      if (index < showPeriod) {
        if (index == 0) {
          if (isHome) {
            score.add('${widget.match.appMatchScore?.homeOne}');
            otherScore.add('${widget.match.appMatchScore?.awayOne}');
          } else {
            score.add('${widget.match.appMatchScore?.awayOne}');
            otherScore.add('${widget.match.appMatchScore?.homeOne}');
          }
        } else if (index == 1) {
          if (isHome) {
            score.add('${widget.match.appMatchScore?.homeTwo}');
            otherScore.add('${widget.match.appMatchScore?.awayTwo}');
          } else {
            score.add('${widget.match.appMatchScore?.awayTwo}');
            otherScore.add('${widget.match.appMatchScore?.homeTwo}');
          }
        } else if (index == 2) {
          if (isHome) {
            score.add('${widget.match.appMatchScore?.homeThree}');
            otherScore.add('${widget.match.appMatchScore?.awayThree}');
          } else {
            score.add('${widget.match.appMatchScore?.awayThree}');
            otherScore.add('${widget.match.appMatchScore?.homeThree}');
          }
        } else if (index == 3) {
          if (isHome) {
            score.add('${widget.match.appMatchScore?.homeFour}');
            otherScore.add('${widget.match.appMatchScore?.awayFour}');
          } else {
            score.add('${widget.match.appMatchScore?.awayFour}');
            otherScore.add('${widget.match.appMatchScore?.homeFour}');
          }
        }
      } else {
        score.add('');
        otherScore.add('');
      }
    });
    if (isHome) {
      score.add(ot ? '${widget.match.appMatchScore?.homeOt}' : '');
      score.add(widget.match.hasBegin() ? '${widget.match.homeScore}' : '');
      otherScore.add(ot ? '${widget.match.appMatchScore?.awayOt}' : '');
      otherScore
          .add(widget.match.hasBegin() ? '${widget.match.awayScore}' : '');
    } else {
      score.add(ot ? '${widget.match.appMatchScore?.awayOt}' : '');
      score.add(widget.match.hasBegin() ? '${widget.match.awayScore}' : '');
      otherScore.add(ot ? '${widget.match.appMatchScore?.homeOt}' : '');
      otherScore
          .add(widget.match.hasBegin() ? '${widget.match.homeScore}' : '');
    }
    return SizedBox(
      height: 20,
      child: Row(children: [
        ...List.generate(score.length - 1, (index) {
          bool win =
              (score[index].toInt() ?? 0) > (otherScore[index].toInt() ?? 0);
          bool equal =
              (score[index].toInt() ?? 0) == (otherScore[index].toInt() ?? 0);
          return SizedBox(
            width: 26,
            child: Text(score[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    color: equal
                        ? Colours.grey99
                        : (win ? Colours.grey66 : Colours.grey99))),
          );
        }),
        SizedBox(width: 2),
        SizedBox(
          width: 26,
          child: Text(score[5],
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: (score[5].toInt() ?? 0) > (otherScore[5].toInt() ?? 0)
                      ? Colours.main
                      : Colours.redFA9F9F)),
        ),
      ]),
    );
  }

  recent(bool isHome) {
    return Text(
        isHome
            ? (widget.match.homeInfoRecentRecord.valuable == true
                ? '近况： ${widget.match.homeInfoRecentRecord}'
                : '')
            : (widget.match.awayInfoRecentRecord.valuable == true
                ? '近况： ${widget.match.awayInfoRecentRecord}'
                : ''),
        style: TextStyle(color: Colours.grey66, fontSize: 12));
  }
}
