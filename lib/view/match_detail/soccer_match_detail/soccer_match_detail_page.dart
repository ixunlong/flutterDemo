import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/match/soccer_match_detail_controller.dart';
import 'package:sports/model/match/match_info_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/util/web_socket_connection.dart';
import 'package:sports/view/match_detail/soccer_match_detail/detail_widgets/detail_header.dart';
import 'package:sports/view/match_detail/soccer_match_detail/fullscreen_live_page.dart';
import 'package:sports/view/match_detail/soccer_match_detail/soccer_match_outs_view.dart';
import 'package:sports/widgets/custom_indicator.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../res/routes.dart';
import '../../../res/styles.dart';

class SoccerMatchDetailPage extends StatefulWidget {
  const SoccerMatchDetailPage({super.key});

  @override
  State<SoccerMatchDetailPage> createState() => _SoccerMatchDetailPageState();
}

class _SoccerMatchDetailPageState extends State<SoccerMatchDetailPage>
    with SingleTickerProviderStateMixin {
  late SoccerMatchDetailController scontroller;
  late final scrollController = ScrollController();
  final livescrollcontroller = ScrollController(initialScrollOffset: 30);
  bool visible = true;
  late Timer t = Timer.periodic(Duration(seconds: 30), (timer) {
    if (!visible) {
      return;
    }
    _getMatchInfo();
  });
  bool isStarAnimate = false;
  bool showTitle = false;
  MatchInfoEntity? info;
  late int matchId = () {
    if (Get.arguments is int) {
      return Get.arguments;
    } else if (Get.arguments is String) {
      final v = int.tryParse(Get.arguments);
      if (v != null) {
        return v;
      }
    }
    Utils.alertQuery("参数错误").then((value) {
      Get.back();
    });
    return 0;
  }.call();

  StreamSubscription? subLiveText = null;
  StreamSubscription? subEvent = null;

  String? liveAnimationUrl;
  bool liveAnimation = false;
  bool liveFullScreen = false;

  double toff = 0.0;

  Future _getMatchInfo() async {
    final data = await Utils.tryOrNullf(() async {
      final result = await Api.getMatchInfo(matchId);
      final data = MatchInfoEntity.fromJson(result.data['d']);
      return data;
    });
    // log("get match info : ${data?.toJson()}");
    scontroller.info = data ?? scontroller.info;
    info = data ?? info;
    scontroller.updateTabController();
    // for (List element in scontroller.tabList) {
    //   if (element[0] == "赛况") {
    //     element[1] = SoccerMatchOutsView(
    //       info: info,
    //       matchId: matchId,
    //     );
    //   }
    // }
    update();
  }

  Future _getAnimationUrl() async {
    final r = await Api.getMatchAnalive(matchId);
    if (r.data['d'] != null) {
      final url = r.data['d']['fjUrl'];
      if (url != null && url is String) {
        liveAnimationUrl = url;
        update();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    scontroller = Get.put(SoccerMatchDetailController(), tag: '$matchId');
    _getMatchInfo();
    // _getAnimationUrl();
    t;
    scrollController.addListener(() {
      if (liveAnimation) {
        return;
      }
      final show = scrollController.offset >=
          scrollController.position.maxScrollExtent - 5;
      if (show != showTitle) {
        showTitle = show;
        update();
      }
      toff = scrollController.offset;
      if (liveAnimation) {
        update();
      }
    });
    subLiveText = WsConnection.liveStream(matchId).listen((event) {
      log("live text event $event");
    });
    subEvent = WsConnection.eventStream(matchId).listen((event) {
      log("live evnt ${event}");
    });
  }

  @override
  void dispose() {
    t.cancel();
    scrollController.dispose();
    subEvent?.cancel();
    subLiveText?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = GetBuilder<SoccerMatchDetailController>(
        tag: '$matchId',
        builder: (controller) {
          log("re build tab length = ${controller.tabList.length} ${controller.tabController.length}");
          return PrimaryScrollController(
            controller: scrollController,
            child: Scaffold(
              appBar: liveAnimation ? null : _appBar(),
              backgroundColor: liveAnimation
                  ? Color(0xff3b4053)
                  : info?.topColor ?? Colours.red_color,
              body: ExtendedNestedScrollView(
                pinnedHeaderSliverHeightBuilder: liveAnimation
                    ? () =>
                        140 +
                        (Platform.isAndroid ? 12 : 0) +
                        50 +
                        MediaQuery.of(context).padding.top
                    : null,
                controller: scrollController,
                onlyOneScrollInBody: true,
                physics: NeverScrollableScrollPhysics(),
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  if (liveAnimation)
                    SliverAppBar(
                      pinned: true,
                      title: _barTitle1(),
                      toolbarHeight: 44,
                      expandedHeight: 140 +
                          (Platform.isAndroid ? 12 : 0) +
                          MediaQuery.of(context).padding.top,
                      collapsedHeight: 140 +
                          (Platform.isAndroid ? 12 : 0) +
                          MediaQuery.of(context).padding.top,
                      backgroundColor: Colours.grey3B4053,
                      foregroundColor: Colors.white,
                      titleTextStyle: const TextStyle(color: Colors.white),
                      iconTheme: IconThemeData(color: Colors.white),
                      leading: IconButton(
                        onPressed: () {
                          liveAnimation = false;
                          update();
                        },
                        icon: Icon(Platform.isIOS
                            ? Icons.arrow_back_ios
                            : Icons.arrow_back),
                      ),
                      actions: [
                        IconButton(
                            onPressed: () {
                              Get.to(
                                  () => FullScreenLivePage(
                                      liveAnimationUrl: liveAnimationUrl!),
                                  transition: Transition.noTransition,
                                  duration: Duration(milliseconds: 100));
                              update();
                            },
                            icon: Icon(Icons.fullscreen_outlined))
                      ],
                      flexibleSpace: Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 15),
                            height:
                                140 + 56 + MediaQuery.of(context).padding.top,
                            child: ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.8,
                                      child: InAppWebView(
                                        initialUrlRequest: URLRequest(
                                            url: Uri.parse(liveAnimationUrl!)),
                                        onLoadStart: (webController, url) {
                                          controller.setLoad(true);
                                        },
                                        onLoadStop: (webController, url) {
                                          Future.delayed(const Duration(
                                                  milliseconds: 100))
                                              .then((value) =>
                                                  controller.setLoad(false));
                                        },
                                        onLoadError: (webController, url, code,
                                            message) {
                                          message = '加载失败';
                                        },
                                      ),
                                    ),
                                    controller.loadUrl
                                        ? Container(
                                            width: Get.width,
                                            height: 140 + 56 - 15,
                                            color: Colours.grey3B4053,
                                            alignment: Alignment.center,
                                            child: const Text("正在加载",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colours.white)),
                                          )
                                        : Container(),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  SliverToBoxAdapter(
                      child: liveAnimation
                          ? null
                          : DetailHeaderWidget(
                              info: info,
                              liveAnimation: liveAnimationUrl != null,
                              // animatelivePress: () async {
                              // Utils.onEvent('bsxq_dhzb');
                              // liveAnimation = true;
                              // scrollController.jumpTo(
                              //     scrollController.position.maxScrollExtent);
                              // update();

                              // },
                              // videoList: controller.videoList,
                            ))
                ],
                body: Container(
                  decoration: const BoxDecoration(
                      color: Colours.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: TabBar(
                          controller: controller.tabController,
                          tabs: List.generate(
                              controller.tabList.length,
                              (index) =>
                                  Tab(text: controller.tabList[index][0])),
                          indicator: const CustomIndicator(
                              borderSide: BorderSide(
                                  width: 2, color: Colours.main_color),
                              indicatorBottom: 1,
                              indicatorWidth: 15),
                          labelColor: Colours.main_color,
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 5),
                          unselectedLabelColor: Colours.grey_color,
                          labelStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                          unselectedLabelStyle: const TextStyle(fontSize: 16),
                          onTap: (value) {
                            Utils.onEvent('bsxq_qhl',
                                params: {'bsxq_qhl': '${value + 1}'});
                          },
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                            controller: controller.tabController,
                            children: List.generate(controller.tabList.length,
                                (index) => controller.tabList[index][1])),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
    return VisibilityDetector(
        key: Key("soccer match detail"),
        child: s,
        onVisibilityChanged: (info) {
          visible = !info.visibleBounds.isEmpty;
          log("soccer detail visible = $visible info = $info");
        });
  }

  _appBar() {
    return Styles.appBar(
      // leading: Container(width: 0),
      leadingColor: Colours.white,
      iconTheme: const IconThemeData(color: Colors.white),
      title: showTitle ? _barTitle() : _barTitle1(),
      foregroundColor: Colors.white,
      titleTextStyle: const TextStyle(color: Colors.white),
      backgroundColor: liveAnimation
          ? Color(0xff3b4053)
          : info?.topColor ?? Colours.red_color,
      actions: [
        if (liveAnimation)
          IconButton(
              onPressed: () {
                log("click");
                Get.to(
                    () =>
                        FullScreenLivePage(liveAnimationUrl: liveAnimationUrl!),
                    transition: Transition.noTransition,
                    duration: Duration(milliseconds: 100));
                update();
              },
              icon: const Icon(Icons.fullscreen)),
        IconButton(
            onPressed: () async {
              isStarAnimate = true;
              if (User.isFollow(matchId)) {
                Utils.onEvent('bsxq_gz', params: {'bsxq_gz': '0'});
                User.unFollow(matchId).then((value) {
                  if (User.isFollow(matchId)) {
                    ToastUtils.showDismiss("取消关注失败");
                  } else {
                    ToastUtils.showDismiss("取消关注成功");
                  }
                  update();
                });
              } else {
                Utils.onEvent('bsxq_gz', params: {'bsxq_gz': '1'});
                User.follow(matchId).then((value) {
                  if (User.isFollow(matchId)) {
                    ToastUtils.showDismiss("关注成功");
                  } else {
                    ToastUtils.showDismiss("关注失败");
                  }
                  update();
                });
              }
            },
            iconSize: 24,
            icon: Image.asset(Utils.getImgPath(
                User.isFollow(matchId) ? "star.png" : "star_border.png")))
      ],
    );
  }

  _barTitle1() {
    final width = MediaQuery.of(context).size.width - 160;
    final time = info?.state != MatchState.notStart;
    return Container(
      width: width,
      child: GestureDetector(
        onTap: () => Get.toNamed(Routes.dataSecond,
            arguments: info?.baseInfo?.leagueId.toString()),
        child: Column(
          children: [
            time
                ? Text(
                    "${info?.time ?? ""}",
                    style: const TextStyle(fontSize: 14),
                  )
                : Container(),
            Text(
              "${info?.baseInfo?.nameChs ?? ""}",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  _barTitle() {
    final width = MediaQuery.of(context).size.width - 140;
    String center = "VS";
    Widget? centerW;
    if (info?.state == MatchState.notStart) {
      center = info?.time ?? "";
    } else if (info?.state == MatchState.inMatch) {
      center =
          "${info?.homeScore}  ${info?.runningTime ?? info?.baseInfo?.statusName}  ${info?.awayScore}";
      centerW = Row(
        children: [
          Container(
              width: 15,
              height: 16,
              color: Colors.white,
              alignment: Alignment.center,
              child: Text("${info?.homeScore}",
                  style: TextStyle(color: info?.topColor, fontSize: 12))),
          info?.runningTime != null
              ? Row(
                  children: [
                    Text(info?.runningTime?.replaceAll("'", "") ?? ""),
                    const Text("'")
                        .animate(
                          onPlay: (controller) => controller.repeat(),
                        )
                        .fade(duration: 1000.ms)
                  ],
                ).paddingSymmetric(horizontal: 5)
              : Text("${info?.runningTime ?? info?.baseInfo?.statusName}")
                  .paddingSymmetric(horizontal: 5),
          Container(
              color: Colors.white,
              width: 15,
              height: 16,
              alignment: Alignment.center,
              child: Text("${info?.awayScore}",
                  style: TextStyle(color: info?.topColor, fontSize: 12)))
        ],
      );
    } else if (info?.state == MatchState.end) {
      center = info?.scoreRate ?? "VS";
    } else {
      center = info?.baseInfo?.statusName ?? "VS";
    }

    final box = SizedBox(
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: _titleTeamInfo(
                  info?.baseInfo?.homeName ?? "", info?.baseInfo?.homeRanking)),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: centerW ??
                  Text(
                    center,
                    style: TextStyle(fontSize: 12, height: 1.4),
                    textAlign: TextAlign.center,
                  )),
          Expanded(
              child: _titleTeamInfo(
                  info?.baseInfo?.guestName ?? "", info?.baseInfo?.guestRanking,
                  left: false))
        ],
      ),
    );

    return DefaultTextStyle(
      style: const TextStyle(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      child: box,
    );
  }

  _titleTeamInfo(String name, String? rank, {bool left = true}) {
    final tName = Container(
      constraints: const BoxConstraints(maxWidth: 80),
      child: Text(
        name,
        style: const TextStyle(fontSize: 14, height: 1.4),
        overflow: TextOverflow.ellipsis,
        textAlign: left ? TextAlign.end : TextAlign.start,
        // textDirection: left ? TextDirection.rtl : TextDirection.ltr,
      ),
    );
    // final tRank = rank?.isEmpty ?? true
    //     ? Container()
    //     : Text("[${rank!}]", style: TextStyle(fontSize: 10));
    var children = [tName];
    if (left) {
      children = children.reversed.toList();
    }
    return Row(
        mainAxisAlignment:
            left ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: children);
  }
}
