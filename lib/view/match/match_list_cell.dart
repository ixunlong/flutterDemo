import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/style.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/match/match_page_controller.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/logic/service/um_service.dart';
import 'package:sports/model/match/match_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/date_utils_extension.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/select_bottomsheet.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../logic/match/match_interest_controller.dart';
import '../../res/styles.dart';
import '../../util/user.dart';

class MatchListCell extends StatefulWidget {
  final MatchEntity match;

  const MatchListCell(this.match, {super.key});

  @override
  State<MatchListCell> createState() => _MatchListCellState();
}

class _MatchListCellState extends State<MatchListCell> {
  bool isStarAnimate = false;
  SoccerConfig config = Get.find<ConfigService>().soccerConfig;

  @override
  Widget build(BuildContext context) {
    //加时显示
    String finalString = '';
    if (widget.match.neutrality == 1) {
      finalString = '中立场';
      if (widget.match.locationCn.valuable) {
        finalString += '：${widget.match.locationCn}';
      }
    }
    if (widget.match.status == '7' && widget.match.homeScoreOt != null) {
      //优先显示加时信息
      finalString = '';
      finalString +=
          '90分钟[${widget.match.homeScore90}-${widget.match.guestScore90}],120分钟[${widget.match.homeScoreOt}-${widget.match.guestScoreOt}]';
      if (widget.match.homeScorePk != null) {
        finalString +=
            ',点球[${widget.match.homeScorePk}-${widget.match.guestScorePk}]';
      }
      int homeScore =
          widget.match.homeScoreOt! + (widget.match.homeScorePk ?? 0);
      int guestScore =
          widget.match.guestScoreOt! + (widget.match.guestScorePk ?? 0);
      if (homeScore > guestScore) {
        finalString += ',${widget.match.homeName}胜出';
      } else {
        finalString += ',${widget.match.guestName}胜出';
      }
      // finalString +=
    }

    return GestureDetector(
      onTap: () {
        Utils.onEvent('bspd_djdcbs', params: {"bspd_djdcbs": 0});
        Get.find<UmService>().payOriginRoute = 'bspd';
        Get.toNamed(Routes.soccerMatchDetail, arguments: widget.match.id);
      },
      child: Container(
        decoration: widget.match.lastMatchInDay
            ? null
            : BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colours.greyF7, width: 4))),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 9, 12, 9),
              child: Column(
                children: [
                  _buildHead(),
                  const SizedBox(height: 4),
                  _buildBody(),
                  const SizedBox(height: 4),
                  _buildBottom(),
                  // SizedBox(height: 9),
                ],
              ),
            ),
            if (finalString.isNotEmpty)
              Container(
                height: 23,
                alignment: Alignment.center,
                width: double.infinity,
                color: Colours.redFFF2F2,
                child: Text(
                  finalString,
                  maxLines: 1,
                  style: TextStyle(fontSize: 11, color: Colours.homeColorRed),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildHead() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
                widget.match.leagueName!,
                style: const TextStyle(
                    color:
                        // widget.match.leagueColor == null?
                        Colours.grey_color,
                    // : HexColor(widget.match.leagueColor!),
                    fontSize: 11),
                // strutStyle: StrutStyle(
                //     fontSize: 11, height: 1.1, forceStrutHeight: true),
              ),
              if (widget.match.rounds != null) ...[
                SizedBox(width: 6),
                Text(
                  '第${widget.match.rounds}轮',
                  style:
                      const TextStyle(color: Colours.grey_color, fontSize: 11),
                ),
              ],
              SizedBox(width: 6),
              Text(
                DateUtilsExtension.formatDateString(
                    widget.match.matchTime!, 'HH:mm'),
                style: const TextStyle(color: Colours.grey_color, fontSize: 11),
              ),
              SizedBox(width: 6),
              if (config.soccerList3 == 1)
                Text(
                    Get.find<MatchPageController>()
                        .getMatchController()
                        .getTicketName(widget.match),
                    style: const TextStyle(
                        color: Colours.grey_color, fontSize: 11))
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Center(
              child: (widget.match.status == '2' || widget.match.status == '4')
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${widget.match.show}',
                            style: TextStyle(
                                color: HexColor(widget.match.color!),
                                fontSize: 11)),
                        Text('\'',
                                style: TextStyle(
                                    color: HexColor(widget.match.color!),
                                    fontSize: 11))
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .fade(duration: 1000.ms)
                      ],
                    )
                  : Text(
                      widget.match.show ?? '',
                      style: TextStyle(
                          color: HexColor(widget.match.color!), fontSize: 11),
                    )),
        ),
        Flexible(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: widget.match.intelligence == 1,
                  child: GestureDetector(
                    onTap: () {
                      Utils.onEvent('bspd_djdcbs', params: {"bspd_djdcbs": 0});
                      Get.toNamed(Routes.soccerMatchDetail,
                          arguments: widget.match.id,
                          parameters: {'tabName': Constant.qingbao});
                    },
                    child: const Text(
                      Constant.qingbao,
                      style:
                          TextStyle(fontSize: 11, color: Colours.yellowFFB400),
                    ),
                  ),
                ),
                // const SizedBox(width: 4),
                Visibility(
                  visible: widget.match.lineup == 1,
                  child: GestureDetector(
                    onTap: () {
                      Utils.onEvent('bspd_djdcbs', params: {"bspd_djdcbs": 0});
                      Get.toNamed(Routes.soccerMatchDetail,
                          arguments: widget.match.id,
                          parameters: {'tabName': Constant.zhenrong});
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 6),
                      child: const Text(Constant.zhenrong,
                          style: TextStyle(
                              fontSize: 11, color: Colours.homeColorRed)),
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.match.planCnt != 0 && config.soccerList4 == 1,
                  child: GestureDetector(
                    onTap: () {
                      Utils.onEvent('bspd_djdcbs', params: {"bspd_djdcbs": 0});
                      Get.toNamed(Routes.soccerMatchDetail,
                          arguments: widget.match.id,
                          parameters: {'tabName': Constant.guandian});
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 6),
                      child: Text('${Constant.guandian}${widget.match.planCnt}',
                          style: TextStyle(
                              fontSize: 11, color: Colours.guestColorBlue)),
                    ),
                  ),
                )
              ],
            ))
      ],
    );
  }

  Widget _buildBody() {
    // double homeNameWidth = 0;
    // if ((widget.match.homeYellow == 0 || widget.match.homeYellow == null) &&
    //     (widget.match.homeRed == 0 || widget.match.homeRed == null)) {
    //   homeNameWidth = 98;
    // } else if ((widget.match.homeYellow != null &&
    //         widget.match.homeYellow! > 0) &&
    //     (widget.match.homeRed != null && widget.match.homeRed! > 0)) {
    //   homeNameWidth = 70;
    // } else {
    //   homeNameWidth = 84;
    // }
    // double guestNameWidth = 0;
    // if ((widget.match.guestYellow == 0 || widget.match.guestYellow == null) &&
    //     (widget.match.guestRed == 0 || widget.match.guestRed == null)) {
    //   guestNameWidth = 98;
    // } else if ((widget.match.guestYellow != null &&
    //         widget.match.guestYellow! > 0) &&
    //     (widget.match.guestRed != null && widget.match.guestRed! > 0)) {
    //   guestNameWidth = 70;
    // } else {
    //   guestNameWidth = 84;
    // }
    double nameWidth = (Get.width - 50 - 38 * 2) / 2;
    if (config.soccerList5 == 1) {
      nameWidth -= 14;
    }
    if (config.soccerList2 == 1) {
      nameWidth -= 28;
    }
    return SizedBox(
      height: 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
              flex: 1,
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () async {
                        isStarAnimate = true;
                        if (User.isFollow(widget.match.id!)) {
                          Utils.onEvent('bspd_gz', params: {'bspd_gz': '0'});
                          await User.unFollow(widget.match.id!);
                        } else {
                          Utils.onEvent('bspd_gz', params: {'bspd_gz': '1'});
                          await User.follow(widget.match.id!);
                        }
                        setState(() {});
                        try {
                          Get.find<MatchInterestController>().getMatch();
                        } catch (e) {}
                        // matchInterestController.getMatch();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: User.isFollow(widget.match.id!)
                            ? Image.asset(Utils.getImgPath("star.png"),
                                    color: Color(0xFFF53F3F),
                                    width: 18,
                                    height: 18)
                                .animate(
                                    onComplete: (controller) =>
                                        controller.reverse())
                                .scale(
                                    begin: 1,
                                    end: isStarAnimate ? 2 : 1,
                                    duration: 150.ms,
                                    curve: Curves.bounceInOut)
                            : Image.asset(Utils.getImgPath("star_border.png"),
                                color: Colors.grey, width: 18, height: 18),
                      )),
                  Spacer(),
                  if (widget.match.homeYellow != null &&
                      widget.match.homeYellow != 0 &&
                      config.soccerList5 == 1) ...[
                    _cardWidget(0, true),
                    const SizedBox(width: 4)
                  ],
                  if (widget.match.homeRed != null &&
                      widget.match.homeRed != 0 &&
                      config.soccerList5 == 1) ...[
                    _cardWidget(1, true),
                    const SizedBox(width: 4)
                  ],
                  if (config.soccerList2 == 1)
                    Text(
                      (widget.match.homeRanking == null ||
                              widget.match.homeRanking == '')
                          ? ''
                          : '[${widget.match.homeRanking}]',
                      style: const TextStyle(
                          color: Colours.grey_color1, fontSize: 11),
                    ),
                  SizedBox(width: 1),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: nameWidth),
                    child: Text(
                      widget.match.homeName ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          color: Colours.text_color1,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      strutStyle: StrutStyle(
                          forceStrutHeight: true, height: 1.2, fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 1),
                  CachedNetworkImage(
                      height: 14,
                      width: 15,
                      fit: BoxFit.fitHeight,
                      placeholder: (context, url) => Styles.placeholderIcon(),
                      errorWidget: (
                        context,
                        url,
                        error,
                      ) =>
                          Image.asset(Utils.getImgPath("team_logo.png")),
                      imageUrl: widget.match.homeLogo ?? "")
                ],
              )),
          SizedBox(
            width: 50,
            child: Text(
                widget.match.homeScore90 == null
                    ? 'VS'
                    : '${widget.match.homeScore90}-${widget.match.guestScore90}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: widget.match.status == '7'
                        ? Colours.text_color1
                        : (widget.match.homeScore90 == null
                            ? Colours.grey_color1
                            : Colours.main_color),
                    fontSize: 15,
                    fontWeight: FontWeight.w500)),
          ),
          Flexible(
              flex: 1,
              child: Row(
                children: [
                  CachedNetworkImage(
                      height: 14,
                      width: 15,
                      fit: BoxFit.fitHeight,
                      placeholder: (context, url) => Styles.placeholderIcon(),
                      errorWidget: (
                        context,
                        url,
                        error,
                      ) =>
                          Image.asset(Utils.getImgPath("team_logo.png")),
                      imageUrl: widget.match.guestLogo ?? ""),
                  const SizedBox(width: 1),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: nameWidth + 22),
                    child: Text(widget.match.guestName ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            color: Colours.text_color1,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        strutStyle:
                            StrutStyle(forceStrutHeight: true, height: 1.2)),
                  ),
                  SizedBox(width: 1),
                  if (config.soccerList2 == 1)
                    Text(
                        widget.match.guestRanking == null ||
                                widget.match.guestRanking == ''
                            ? ''
                            : '[${widget.match.guestRanking}]',
                        style: const TextStyle(
                            color: Colours.grey_color1, fontSize: 11)),
                  if (widget.match.guestRed != null &&
                      widget.match.guestRed != 0 &&
                      config.soccerList5 == 1) ...[
                    const SizedBox(width: 4),
                    _cardWidget(1, false),
                  ],
                  if (widget.match.guestYellow != null &&
                      widget.match.guestYellow != 0 &&
                      config.soccerList5 == 1) ...[
                    const SizedBox(width: 4),
                    _cardWidget(0, false),
                  ],
                  Spacer(),
                  Visibility(
                    visible: widget.match.video == 1,
                    child: GestureDetector(
                      onTap: () async {
                        Api.getVideoList(widget.match.id!, 1)
                            .then((value) async {
                          if (value != null && value.isNotEmpty) {
                            final index = await Get.bottomSheet(
                                SelectBottomSheet(
                                    value.map((e) => e.name ?? '').toList(),
                                    top: '请选择直播来源'));
                            if (index != null) {
                              launchUrlString(value[index].url ?? '',
                                  mode: LaunchMode.externalApplication);
                            }
                          }
                        });
                      },
                      child: Image.asset(
                        Utils.getImgPath("soccer_live_animation.png"),
                        width: 18,
                        height: 14,
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget _buildBottom() {
    if (widget.match.status == '1') {
      if (config.soccerList1 == 1) {
        List<OddsList>? oddsList = widget.match.oddsList;
        List<TextSpan> showList = [];
        if (oddsList != null) {
          oddsList = oddsList
              .where((element) => element.c == config.soccerList8)
              .toList();
          if (config.soccerList7.contains(0)) {
            List<TextSpan> span = [];
            for (OddsList odds in oddsList) {
              if (odds.p == 1001) {
                List<Map<String, dynamic>> jsonList;
                if (config.soccerList9 == 0) {
                  jsonList =
                      List<Map<String, dynamic>>.from(jsonDecode(odds.o1!));
                } else {
                  jsonList =
                      List<Map<String, dynamic>>.from(jsonDecode(odds.o2!));
                }
                span.add(TextSpan(
                    text: jsonList
                        .firstWhere((element) => element['i'] == 's')['o']!));
                span.add(TextSpan(
                    text: ' ' +
                        jsonList.firstWhere(
                            (element) => element['i'] == 'p')['o']!));
                span.add(TextSpan(
                    text: ' ' +
                        jsonList.firstWhere(
                            (element) => element['i'] == 'f')['o']!));
                // String str =
                //     jsonList.firstWhere((element) => element['i'] == 's')['o']!;
                // str += ' ' +
                //     jsonList.firstWhere((element) => element['i'] == 'p')['o']!;
                // str += ' ' +
                //     jsonList.firstWhere((element) => element['i'] == 'f')['o']!;
                showList.add(TextSpan(
                    children: span,
                    style: TextStyle(color: Colours.grey99, fontSize: 11)));
              }
            }
          }
          if (config.soccerList7.contains(1)) {
            List<TextSpan> span = [];
            for (OddsList odds in oddsList) {
              if (odds.p == 1006) {
                List<Map<String, dynamic>> jsonList;
                if (config.soccerList9 == 0) {
                  jsonList =
                      List<Map<String, dynamic>>.from(jsonDecode(odds.o1!));
                } else {
                  jsonList =
                      List<Map<String, dynamic>>.from(jsonDecode(odds.o2!));
                }
                // String str =
                //     jsonList.firstWhere((element) => element['i'] == 's')['o']!;
                // str += ' ' + (odds.l ?? '');
                // str += ' ' +
                //     jsonList.firstWhere((element) => element['i'] == 'f')['o']!;
                // showList.add(str);
                span.add(TextSpan(
                    text: jsonList
                        .firstWhere((element) => element['i'] == 's')['o']!));
                span.add(TextSpan(
                    text: ' ' + (odds.l ?? ''),
                    style: TextStyle(
                        color: Colours.grey66,
                        fontSize: 11,
                        fontWeight: FontWeight.w500)));
                span.add(TextSpan(
                    text: ' ' +
                        jsonList.firstWhere(
                            (element) => element['i'] == 'f')['o']!));
                showList.add(TextSpan(
                    children: span,
                    style: TextStyle(color: Colours.grey99, fontSize: 11)));
              }
            }
          }
          if (config.soccerList7.contains(2)) {
            List<TextSpan> span = [];
            for (OddsList odds in oddsList) {
              if (odds.p == 1007) {
                List<Map<String, dynamic>> jsonList;
                if (config.soccerList9 == 0) {
                  jsonList =
                      List<Map<String, dynamic>>.from(jsonDecode(odds.o1!));
                } else {
                  jsonList =
                      List<Map<String, dynamic>>.from(jsonDecode(odds.o2!));
                }
                // String str =
                //     jsonList.firstWhere((element) => element['i'] == 'd')['o']!;
                // str += ' ' + (odds.l ?? '');
                // str += ' ' +
                //     jsonList.firstWhere((element) => element['i'] == 'x')['o']!;
                // showList.add(str);
                span.add(TextSpan(
                    text: jsonList
                        .firstWhere((element) => element['i'] == 'd')['o']!));
                span.add(TextSpan(
                    text: ' ' + (odds.l ?? ''),
                    style: TextStyle(
                        color: Colours.grey66,
                        fontSize: 11,
                        fontWeight: FontWeight.w500)));
                span.add(TextSpan(
                    text: ' ' +
                        jsonList.firstWhere(
                            (element) => element['i'] == 'x')['o']!));
                showList.add(TextSpan(
                    children: span,
                    style: TextStyle(color: Colours.grey99, fontSize: 11)));
              }
            }
          }
        }
        return SizedBox(
            height: 15,
            child: Row(
                children: showList.length == 2
                    ? [
                        Flexible(
                          fit: FlexFit.tight,
                          child: RichText(
                            text: showList[0],
                            textAlign: TextAlign.end,
                          ),
                        ),
                        SizedBox(width: 50),
                        Flexible(
                          fit: FlexFit.tight,
                          child: RichText(
                            text: showList[1],
                            textAlign: TextAlign.start,
                          ),
                        )
                      ]
                    : List.generate(showList.length, (index) {
                        TextAlign align = TextAlign.start;
                        if (showList.length == 1 ||
                            (showList.length == 3 && index == 1)) {
                          align = TextAlign.center;
                        } else if ((showList.length == 3 && index == 2)) {
                          align = TextAlign.end;
                        }
                        return Flexible(
                          fit: FlexFit.tight,
                          child: RichText(
                            text: showList[index],
                            textAlign: align,
                          ),
                        );
                      })));
      }
    } else {
      return SizedBox(
        height: 15,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(width: 60),
            // Spacer(),
            Text(
                (widget.match.homeScoreHalf == null
                        ? ''
                        : '半:${widget.match.homeScoreHalf}-${widget.match.guestScoreHalf}  ') +
                    (widget.match.homeCorner == null || config.soccerList6 == 0
                        ? ''
                        : '角:${widget.match.homeCorner}-${widget.match.guestCorner}'),
                style:
                    const TextStyle(color: Colours.grey_color, fontSize: 11)),
            // Spacer(),
            // SizedBox(width: 60)
          ],
        ),
      );
    }
    return SizedBox(height: 15);
  }

  //0黄牌 1红牌
  Widget _cardWidget(int type, bool isHome) {
    int? card;
    if (isHome) {
      card = (type == 0 ? widget.match.homeYellow : widget.match.homeRed);
    } else {
      card = (type == 0 ? widget.match.guestYellow : widget.match.guestRed);
    }
    return Visibility(
      visible: card != null,
      child: Container(
        alignment: Alignment.center,
        // margin: EdgeInsets.only(top: 2),
        width: 10,
        height: 14,
        decoration: BoxDecoration(
            color: type == 0 ? Colours.yellow_color : Colours.red_color,
            borderRadius: BorderRadius.all(Radius.circular(1))),
        child: Text(
          '$card',
          strutStyle: const StrutStyle(
            fontSize: 10,
            // leading: 0,
            height: 1.1,
            forceStrutHeight: true,
          ),
          style: const TextStyle(fontSize: 10, color: Colours.white),
        ),
      ),
    );
  }
}
