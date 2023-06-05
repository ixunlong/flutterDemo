import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/service/um_service.dart';
import 'package:sports/model/expert/expert_views_entity.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/expert/expert_record_tag.dart';

import '../../res/colours.dart';

class ViewType {
  static const int scheduleView = 1;
  static const int startView = 2;
  static const int historyView = 3;
  static const int unknownView = 4;

  int typeCheck(int status) {
    switch (status) {
      case 1:
        return 1;
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
        return 2;
      case 7:
      case 8:
        return 3;
      default:
        return 4;
    }
  }

  int typeCheckByTime(int time, int planStatus) {
    if (DateTime.now().millisecondsSinceEpoch < time) {
      return 1;
    } else if (DateTime.now().millisecondsSinceEpoch >= time &&
        planStatus == 0) {
      return 2;
    } else {
      return 3;
    }
  }

  static String playType(String type) {
    switch (type) {
      case "1001":
      case "1002":
        return "胜平负";
      case "1004":
        return "总进球";
      case "1005":
        return "半全场";
      case "1006": //让球
        return "让球";
      case "1007": // 大小球
        return "进球数";
      case "1008":
        return "胜平负";
      case "2001":
        return "胜负";
      case "2002":
        return "让分";
      case "2003":
        return "大小";
      default:
        return "未知";
    }
  }
}

class ExpertListItem extends StatelessWidget {
  ExpertListItem(
      {super.key,
      required this.entity,
      this.isExpertDetailView = false,
      this.isMatchView = false,
      this.tabIndex});

  final bool isExpertDetailView;
  final bool isMatchView;
  final Rows entity;
  final int? tabIndex;

  final List<Widget> viewStatus = [
    Container(),
    Image.asset(Utils.getImgPath("expert_hong.png")),
    Image.asset(Utils.getImgPath("expert_hei.png")),
    Image.asset(Utils.getImgPath("result_quxiao.png")),
    Image.asset(Utils.getImgPath("expert_zou.png")),
    Image.asset(Utils.getImgPath("plan_21.png")),
    Image.asset(Utils.getImgPath("plan_31.png")),
    Image.asset(Utils.getImgPath("plan_32.png"))
  ];

  @override
  Widget build(BuildContext context) {
    int trueType = ViewType().typeCheckByTime(
        DateTime.parse(entity.matchBries![0].matchTime!).millisecondsSinceEpoch,
        entity.planStatus!);
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (isMatchView) {
            Utils.onEvent('bsxq_gd_djgd');
          } else {
            Utils.onEvent('tjpd_djgd');
            if (Get.currentRoute == Routes.navigation) {
              Get.find<UmService>().payOriginRoute = 'tj_rmgd';
            }
          }
          User.needLogin(() {
            Get.toNamed(Routes.viewpoint,
                arguments: entity.planId, preventDuplicates: false);
          });
        },
        child: trueType == ViewType.unknownView
            ? Container()
            : Stack(children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 6),
                      child: isExpertDetailView
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                    child: _expertInfoWidget(),
                                    onTap: () {
                                      Get.find<UmService>().payOriginRoute =
                                          'zjzy';
                                      Get.toNamed(Routes.expertDetail,
                                          arguments: entity.expertId,
                                          parameters: {
                                            "index":
                                                "${(entity.sportsId ?? 1) - 1}"
                                          });
                                    }),
                                entity.expertBackRatio.isNullOrEmpty ||
                                        (tabIndex == 4 &&
                                            entity.expertWinRatio.isNullOrEmpty)
                                    ? Container(height: 50)
                                    : _returnRateWidget()
                              ],
                            ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _contentWidget(),
                        isMatchView
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: entity.sportsId == 1
                                    ? _soccerMatchInfoWidget()
                                    : _bbMatchInfoWidget(),
                              )
                      ],
                    ),
                    Container(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _timeAndViewsWidget(),
                        Expanded(child: Container()),
                        entity.matchBries?[0].status == null
                            ? Container()
                            : Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 0.5,
                                    color: Colours.main_color,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(2),
                                  ),
                                ),
                                child: Text(
                                  ViewType.playType(entity.playType ?? ' '),
                                  strutStyle: Styles.centerStyle(fontSize: 10),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colours.main_color,
                                    height: 1,
                                  ),
                                ),
                              ),
                        trueType == ViewType.scheduleView
                            ? _moneyWidget()
                            : trueType == ViewType.startView
                                ? Row(
                                    children: const [
                                      Text(
                                        "查看",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colours.grey666666,
                                        ),
                                      ),
                                    ],
                                  )
                                : trueType == ViewType.historyView
                                    ? Row(
                                        children: const [
                                          Text(
                                            "查看",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colours.grey666666,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                      ],
                    ),
                    Container(height: 15),
                  ],
                ),
                trueType == ViewType.historyView
                    ? Positioned(
                        right: 0,
                        bottom: isMatchView ? 35 : 50,
                        child: viewStatus[entity.planStatus ?? 0])
                    : Container()
              ]));
  }

  Widget _expertInfoWidget() {
    return Row(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colours.grey_color2,
                  width: 0.5,
                  strokeAlign: BorderSide.strokeAlignOutside),
              shape: BoxShape.circle),
          child: CachedNetworkImage(
              fit: BoxFit.cover,
              width: 40,
              height: 40,
              placeholder: (context, url) => Container(),
              errorWidget: (context, url, error) => Container(),
              imageUrl: entity.expertLogo ?? ''),
        ),
        Container(width: 7),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entity.expertName ?? '',
                style: const TextStyle(fontWeight: FontWeight.w500)),
            Container(height: 2),
            Row(
              children: [
                entity.firstTag == null || entity.firstTag == ''
                    ? Container()
                    : ExpertRecordTag(
                        tagType: TagType.firstTag, text: entity.firstTag),
                Container(width: 6),
                entity.secondTag == null || entity.secondTag == ''
                    ? Container()
                    : ExpertRecordTag(
                        tagType: TagType.secondTag, text: entity.secondTag)
              ],
            )
          ],
        )
      ],
    );
  }

  Widget _returnRateWidget() {
    return Container(
      // color: Colours.green,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
              text: TextSpan(
                  style: const TextStyle(
                    color: Colours.main_color,
                  ),
                  children: [
                tabIndex != 4
                    ? const WidgetSpan(child: Text(''))
                    : const WidgetSpan(
                        baseline: TextBaseline.alphabetic,
                        alignment: PlaceholderAlignment.baseline,
                        child: Text("%",
                            style: TextStyle(
                                fontSize: 9, color: Colours.transparent))),
                WidgetSpan(
                    baseline: TextBaseline.alphabetic,
                    alignment: PlaceholderAlignment.top,
                    child: Text(
                        "${double.parse(tabIndex == 4 ? entity.expertWinRatio!.trim() : entity.expertBackRatio!.trim()).toInt()}",
                        style: const TextStyle(
                            fontSize: 30,
                            fontFamily: "Din",
                            fontWeight: FontWeight.w700,
                            color: Colours.main_color,
                            letterSpacing: -2,
                            height: 1))),
                const WidgetSpan(
                    baseline: TextBaseline.alphabetic,
                    alignment: PlaceholderAlignment.baseline,
                    child: Text("%",
                        style:
                            TextStyle(fontSize: 9, color: Colours.main_color)))
              ])),
          Text(
            tabIndex == 4 ? "命中率" : "近${entity.expertBackRatioN!.trim()}场回报",
            style: const TextStyle(
                color: Colours.main_color, fontSize: 9, height: 1),
          )
        ],
      ),
    );
  }

  Widget _contentWidget() {
    return RichText(
        maxLines: 2,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(children: [
          // WidgetSpan(
          //     alignment: PlaceholderAlignment.middle,
          //     child: entity.matchBries?[0].status == null
          //         ? Container()
          //         : Container(
          //             padding: const EdgeInsets.all(2),
          //             decoration: BoxDecoration(
          //                 border: Border.all(
          //                   width: 0.5,
          //                   color: Colours.main_color,
          //                 ),
          //                 borderRadius:
          //                     const BorderRadius.all(Radius.circular(2))),
          //             child: Text(
          //               ViewType.playType(entity.playType ?? ' '),
          //               strutStyle: Styles.centerStyle(fontSize: 10),
          //               style: const TextStyle(
          //                   fontSize: 10, color: Colours.main_color, height: 1),
          //             ),
          //           )),
          // const TextSpan(text: "\u2000"),
          TextSpan(
            text: entity.planTitle == '' || entity.planTitle == null
                ? "暂无内容"
                : entity.planTitle!,
            style: const TextStyle(fontSize: 16, color: Colours.text_color),
          )
        ]));
  }

  Widget _soccerMatchInfoWidget() {
    return Container(
        width: Get.width,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: Colours.greyF5F7FA, borderRadius: BorderRadius.circular(5)),
        child: Column(
            children: List.generate(
          entity.matchBries?.length ?? 0,
          (index) => Container(
              padding: const EdgeInsets.symmetric(vertical: 4.5),
              decoration: BoxDecoration(
                  border: index != (entity.matchBries?.length ?? 0) - 1
                      ? const Border(
                          bottom: BorderSide(color: Colours.greyEE, width: 0.5))
                      : null),
              child: _matchInfoItem(entity.matchBries?[index])),
        )));
  }

  Widget _matchInfoItem(MatchBries? match) {
    List<bool> co = [false, false, false];
    int league = (match?.leagueName ?? "未知联赛").length;
    int guest = (match?.guestName ?? "主队未知").length;
    int home = (match?.guestName ?? "主队未知").length;
    var length = home + guest + league;
    if (length > 16) {
      var m = max(guest, home);
      if (length - m + 6 <= 16) {
        m == guest ? co[1] = true : co[2] = true;
      } else if (league + 12 <= 16) {
        co[1] = co[2] = true;
      } else {
        co = [true, true, true];
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("[足]\u2000",
            style: const TextStyle(fontSize: 12, color: Colours.grey666666)),
        // Text(
        //   "${DateTime.parse(match?.matchTime ?? '').formatedString("MM/dd HH:mm") ?? "时间暂无"}\u2000",
        //   style: const TextStyle(
        //       fontSize: 12, color: Colours.grey666666, height: 1.5),
        // ),
        Container(
            width: 0.5,
            height: 10,
            alignment: Alignment.center,
            color: Colours.greyE0E1E5),
        Text(
          "\u2000${match?.leagueName ?? "未知联赛"}\u2000",
          style: const TextStyle(fontSize: 12, color: Colours.grey666666),
        ),
        Container(
          constraints: const BoxConstraints(maxWidth: 12 * 7),
          child: Text(
            match?.homeName ?? "主队未知",
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Colours.grey666666),
          ),
        ),
        const Text("\u2000"),
        match?.status == 1 || entity.planStatus == 3
            ? Text(
                "${DateTime.parse(match?.matchTime ?? '').formatedString("MM/dd HH:mm") ?? "时间暂无"}\u2000",
                style: const TextStyle(
                    fontSize: 12, color: Colours.grey666666, height: 1.5),
              )
            // const Text("vs",
            //     style: TextStyle(fontSize: 12, color: Colours.grey666666))
            : Text(
                "${match?.homeScore90}:${match?.guestScore90}",
                style: const TextStyle(fontSize: 12, color: Colours.grey_color),
              ),
        const Text("\u2000"),
        Container(
          constraints: const BoxConstraints(maxWidth: 12 * 7),
          child: Text(
            match?.guestName ?? "客队未知",
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Colours.grey666666),
          ),
        ),
      ],
    );
  }

  Widget _bbMatchInfoWidget() {
    List<bool> co = [false, false, false];
    var match = (entity.matchBries?[0].leagueName ?? "未知联赛").length;
    var guest = (entity.matchBries?[0].guestName ?? "主队未知").length;
    var home = (entity.matchBries?[0].guestName ?? "主队未知").length;
    var length = home + guest + match;
    if (length > 16) {
      var m = max(guest, home);
      if (length - m + 6 <= 16) {
        m == guest ? co[1] = true : co[2] = true;
      } else if (match + 12 <= 16) {
        co[1] = co[2] = true;
      } else {
        co = [true, true, true];
      }
    }
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
      decoration: BoxDecoration(
          color: Colours.greyF5F7FA, borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("[篮]\u2000",
              style: const TextStyle(fontSize: 12, color: Colours.grey666666)),
          Text(
            "${DateTime.parse(entity.matchBries?[0].matchTime ?? '').formatedString("MM/dd HH:mm") ?? "时间暂无"}\u2000",
            style: const TextStyle(
                fontSize: 12, color: Colours.grey666666, height: 1.5),
          ),
          Container(
              width: 0.5,
              height: 10,
              alignment: Alignment.center,
              color: Colours.greyE0E1E5),
          Text(
            "\u2000${entity.matchBries?[0].leagueName ?? "未知联赛"}\u2000",
            style: const TextStyle(fontSize: 12, color: Colours.grey666666),
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 12 * 7),
            child: Text(
              entity.matchBries?[0].guestName ?? "主队未知",
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Colours.grey666666),
            ),
          ),
          const Text("\u2000"),
          entity.matchBries?[0].status == 1 || entity.planStatus == 3
              ? const Text("vs",
                  style: TextStyle(fontSize: 12, color: Colours.grey666666))
              : Text(
                  "${entity.matchBries?[0].guestScore}:${entity.matchBries?[0].homeScore}",
                  style:
                      const TextStyle(fontSize: 12, color: Colours.grey_color),
                ),
          const Text("\u2000"),
          Container(
            constraints: const BoxConstraints(maxWidth: 12 * 7),
            child: Text(
              entity.matchBries?[0].homeName ?? "客队未知",
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Colours.grey666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeAndViewsWidget() {
    return Row(
      children: [
        Text(
            Utils.formatTime(DateTime.parse(entity.planPublicTime ?? "")
                .millisecondsSinceEpoch),
            style: const TextStyle(fontSize: 12, color: Colours.grey_color1)),
        Container(
          width: 8,
        ),
        Text("${entity.pv}人已浏览",
            style: const TextStyle(fontSize: 12, color: Colours.grey_color1))
      ],
    );
  }

  Widget _moneyWidget() {
    return Row(
      children: [
        entity.priceReal == entity.price
            ? Container()
            : Text(
                (entity.price == '' || entity.price == null
                    ? ''
                    : "${checkMoney(entity.price!)}球币"),
                style: const TextStyle(
                    fontSize: 12,
                    color: Colours.grey666666,
                    decoration: TextDecoration.lineThrough,
                    decorationStyle: TextDecorationStyle.solid),
              ),
        Container(width: 10),
        Text(
          entity.priceCoupon != '' && entity.priceCoupon != null
              ? "券后${checkMoney(entity.priceCoupon!)}球币"
              : entity.priceReal == '' || entity.priceReal == null
                  ? ''
                  : entity.priceReal == "0.00"
                      ? "免费查看"
                      : "${checkMoney(entity.priceReal!)}球币",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: entity.priceReal == "0.00"
                  ? Colours.yellow_color
                  : Colours.main_color),
        ),
        entity.activityName != null && entity.activityName != ''
            ? Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Image.asset(Utils.getImgPath("refund_icon.png")),
              )
            : Container()
      ],
    );
  }
  //     entity.priceReal == entity.price
  //         ? Container()
  //         : Text(
  //             (entity.price == '' || entity.price == null
  //                 ? ''
  //                 : "${checkMoney(entity.price!)}红钻"),
  //             style: const TextStyle(
  //                 fontSize: 12,
  //                 color: Colours.grey666666,
  //                 decoration: TextDecoration.lineThrough,
  //                 decorationStyle: TextDecorationStyle.solid),
  //           ),
  //     Container(width: 10),
  //     Text(
  //       entity.priceCoupon != '' && entity.priceCoupon != null
  //           ? "券后${checkMoney(entity.priceCoupon!)}红钻"
  //           : entity.priceReal == '' || entity.priceReal == null
  //               ? ''
  //               : entity.priceReal == "0.00"
  //                   ? "免费查看"
  //                   : "${checkMoney(entity.priceReal!)}红钻",
  //       style: TextStyle(
  //           fontSize: 12,
  //           fontWeight: FontWeight.w500,
  //           color: entity.priceReal == "0.00"
  //               ? Colours.yellow_color
  //               : Colours.main_color),
  //     ),
  //     entity.activityName != null && entity.activityName != ''
  //         ? Padding(
  //             padding: const EdgeInsets.only(left: 8),
  //             child: Image.asset(Utils.getImgPath("refund_icon.png")),
  //           )
  //         : Container()
  //   ],
  // );
  // }

  checkMoney(String price) {
    var check = price.split('.');
    if (check[1] == '00') {
      return check[0];
    } else if (check[1].split('')[0] != '0' && check[1].split('')[1] == '0') {
      return "${check[0]}.${check[1].split('')[0]}";
    } else {
      return price;
    }
  }
}
