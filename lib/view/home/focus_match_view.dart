import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sports/logic/service/um_service.dart';
import 'package:sports/model/match/hot_match_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';
import 'package:get/get.dart';

// const _black = Colors.black;

// const _stat1 = "加时";
// const _stat2 = "点球";
// const _stat3 = "比赛推迟";
// const _stat7 = "延期";
// const _red = Color(0xFFF53F3F);

// const _stat4 = "中断";
// const _orange = Color(0xFFFF7D00);

// const _stat5 = "取消";
// const _stat6 = "腰斩";
// const _grey66 = Color(0xff666666);

// const _stat8 = "时间";
// const _grey99 = Color(0xff999999);

class FocusMatchView extends StatefulWidget {
  FocusMatchView({super.key, required this.matches, this.click});

  List<HotMatchEntity> matches;
  final void Function(HotMatchEntity)? click;

  @override
  State<FocusMatchView> createState() => _FocusMatchViewState();
}

class _FocusMatchViewState extends State<FocusMatchView> {
  final scrollController = ScrollController();
  List<HotMatchEntity> get matches => widget.matches;
  int _lastIndex = 0;

  Map<DateTime, List<HotMatchEntity>> mapOfMatches = {};
  DateTime? date;

  init() {
    mapOfMatches = {};
    for (var i = 0; i < matches.length; i++) {
      final match = matches[i];
      final date = match.getMatchDate?.nextStartDay(0);
      if (date == null) {
        continue;
      }
      if (this.date == null) {
        this.date = date;
      }
      List<HotMatchEntity> l = mapOfMatches[date] ?? [];
      l.add(match);
      mapOfMatches[date] = l;
    }
  }

  @override
  void initState() {
    super.initState();

    init();

    scrollController.addListener(() {
      final index = (scrollController.offset / 180).floor();
      if (index < 0 || index >= matches.length) {
        return;
      }
      if (index == _lastIndex) {
        return;
      }
      _lastIndex = index;
      date = matches[index].getMatchDate?.nextStartDay(0);
      update();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FocusMatchView oldWidget) {
    log("did update widget");
    init();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // matches = matches.sublist(0,2);
    // final num = matches.length;
    return LayoutBuilder(
      builder: (p0, p1) {
        double width = 170;
        // if (num > 2) {
        //   width = (p1.maxWidth - 30 - 32) / 2;
        // } else if (num == 2) {
        //   width = (p1.maxWidth - 10 - 32) / 2;
        // }

        return DefaultTextStyle(
            style: const TextStyle(fontSize: 12, color: Colors.black),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            child: Container(
              // duration: const Duration(milliseconds: 500),
              // margin: EdgeInsets.symmetric(horizontal: 16),
              height: widget.matches.isEmpty ? 0 : 98,
              child: Row(
                children: [
                  _leftDesc().marginOnly(left: 16),
                  Expanded(
                    child: Stack(
                      children: [
                        ListView.builder(
                          controller: scrollController,
                          itemCount: widget.matches.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, idx) {
                            final index = idx;
                            final isLast = (index == widget.matches.length - 1);
                            final isFirst = index == 0;
                            final e = widget.matches[index];
                            return GestureDetector(
                              onTap: () {
                                Utils.onEvent('sypd_rmbs');
                                Get.find<UmService>().payOriginRoute =
                                    'rmbs${index + 1}';
                                widget.click?.call(e);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: isFirst ? 10 : 0,
                                    right: isLast ? 16 : 10),
                                child: _card(e, width),
                              ),
                            );
                          },
                        ),
                        Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            width: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                Colors.white,
                                Colors.white.withOpacity(0.1)
                              ])),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  _card(HotMatchEntity e, double width) {
    Color c = HexColor(e.color ?? "#000000");
    bool isPlay = e.matchTime?.contains("'") ?? false;
    return SizedBox(
      width: width,
      child: Container(
        // padding: const EdgeInsets.all(10),
        // margin: const EdgeInsets.symmetric(vertical:5),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white, // 底色
          // boxShadow: const [
          //   BoxShadow(
          //       blurRadius: 3, //阴影范围
          //       spreadRadius: 2, //阴影浓度
          //       color: Colours.grey_color3 //阴影颜色
          //       ),
          // ],
          border: Border.all(color: Color(0xFFFFF2F2), width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            // padding: EdgeInsets.symmetric(horizontal: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 11),
              decoration: BoxDecoration(color: Color(0xFFFFF2F2)),
              height: 26,
              child: Row(
                children: [
                  Expanded(
                    child: Text("${e.matchNo} ${e.leagueName}",
                        style: const TextStyle(
                            fontSize: 11, color: Colours.text_color1)),
                  ),

                  // const Spacer(),
                  SizedBox(
                    width: 64,
                    child: Text(
                      "${e.matchTime}",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 10, color: c),
                    ),
                  ),
                  if (isPlay)
                    Image.asset(Utils.getImgPath("hotmatch_playing.gif"),
                            width: 10, height: 10)
                        .marginOnly(left: 4)
                  // TimeShowWidget(
                  //     time: DateTime.now().add(Duration(seconds: seconds))),
                ],
              ),
            ),
            const Divider(
              height: 0.5,
              color: Colours.grey_color2,
            ),
            const SizedBox(height: 10),
            _teamWidget(
                e.homeLogo, e.homeName, e.homeRanking, e.homeScore, c, width),
            const SizedBox(height: 8),
            _teamWidget(e.guestLogo, e.guestName, e.guestRanking, e.guestScore,
                c, width),
          ],
        ),
      ),
    );
  }

  Widget _leftDesc() {
    final date = this.date ?? DateTime.now().nextStartDay(0);
    return Container(
      width: 50,
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFFFF2F2), width: 1),
          borderRadius: BorderRadius.circular(4)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              alignment: Alignment.center,
              height: 26,
              color: Color(0xFFFFF2F2),
              child: Text(
                date.formatedString("MM/dd"),
                style: TextStyle(fontSize: 12, color: Colours.text_color1),
              )).marginOnly(bottom: 7),
          Image.asset(Utils.getImgPath("hot_match.png"))
              .sized(width: 36, height: 36),
          Container(
              height: 26,
              alignment: Alignment.center,
              child: Text(
                "${mapOfMatches[date]?.length ?? 0}场",
                style: TextStyle(color: Colours.main_color),
              ))
        ],
      ),
    );
  }

  Widget _teamWidget(String? icon, String? name, String? rank, String? score,
      Color color, double maxWidth) {
    const iconsize = 22.0;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 20,
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: CachedNetworkImage(
              imageUrl: icon ?? "",
              errorWidget: (context, error, stackTrace) => Image.asset(
                Utils.getImgPath('team_logo.png'),
                width: iconsize,
                height: iconsize,
              ),
              placeholder: (context, child) => Styles.placeholderIcon(),
              width: iconsize,
              height: iconsize,
            ),
          ),
          const SizedBox(width: 8),
          Container(
              constraints: BoxConstraints(maxWidth: maxWidth - 80),
              child: Text("$name",
                  style: const TextStyle(
                      fontSize: 15, color: Colours.text_color))),
          const SizedBox(width: 4),
          rank?.isEmpty ?? true
              ? Container()
              : Text("[$rank]",
                  style: const TextStyle(
                      fontSize: 10, color: Colours.grey_color1)),
          const Spacer(),
          Text(score ?? "-",
              style: TextStyle(
                  fontSize: 12, color: color, fontWeight: FontWeight.w500))
        ],
      ),
    );
  }
}
