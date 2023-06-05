import 'dart:async';
import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/http/apis/basketball.dart';
import 'package:sports/model/basketball/bb_detail_head_entity.dart';
import 'package:sports/model/basketball/bb_match_detail_entity.dart';
import 'package:sports/model/match/match_video_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/match_detail/basketball_match_detail/bb_detail_data_view.dart';
import 'package:sports/view/match_detail/basketball_match_detail/bb_detail_head_widget.dart';
import 'package:sports/view/match_detail/basketball_match_detail/bb_detail_outs_widget.dart';
import 'package:sports/view/match_detail/basketball_match_detail/bb_info_widget.dart';
import 'package:sports/view/match_detail/basketball_match_detail/bb_lineup_widget.dart';
import 'package:sports/view/match_detail/match_views_page.dart';
import 'package:sports/widgets/custom_indicator.dart';

import 'bb_odds_view.dart';

// Bb = Basketball

class BbDetailController extends GetxController {
  int matchId = Get.arguments;
  BbDetailHeadInfoEntity? detail;
}

class BbDetailPage extends StatefulWidget {
  const BbDetailPage({super.key});

  @override
  State<BbDetailPage> createState() => _BbDetailPageState();
}

extension ScaffoldTopTouch on Scaffold {
  Widget toptouch(FutureOr Function() tap) {
    return Stack(
      children: [
        this,
        Positioned(
            top: 0,
            // bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 20,
              color: Colors.blue,
            )).tap(() {
          tap.call();
        }),
      ],
    );
  }
}

class _BbDetailPageState extends State<BbDetailPage>
    with TickerProviderStateMixin {
  late TabController tabController;

  Timer? t;

  List tabitems = [];
  final scrollController = ScrollController();

  BbDetailHeadInfoEntity? detail;
  // List<MatchVideoEntity>? videoList;
  final logic = Get.put(BbDetailController(), tag: Get.arguments.toString());
  late bool isFocus = User.basketballFocuses.isFocus(logic.matchId);
  bool showTitle = false;

  getMatchDetail() async {
    final response = await BasketballApi.matchDetailHead(logic.matchId);
    try {
      final needMakeTabController = detail == null;
      detail = BbDetailHeadInfoEntity.fromJson(response.data['d']);
      logic.detail = detail;

      if (needMakeTabController) {
        makeTabcontroller();
      }

      update();
    } catch (err) {
      log("篮球获取比赛头部信息出错 $err");
      log("$err");
    }
  }

  // getVideoList() async {
  //   final result = await Api.getVideoList(logic.matchId, 2);
  //   if (result != null && result.isNotEmpty) {
  //     videoList = result;
  //     update();
  //   }
  // }

  makeTabcontroller() {
    //info	情报	boolean	injure	伤禁	boolean	lineup	阵容(统计)	boolean
    //live	赛况	boolean	odds	指数	boolean	plan	观点  booleandata	数据	boolean

    tabitems = [
      // if (detail?.live ?? false)
      //   [
      //     Constant.saikuang,
      //     BbDetailOutsWidget(id: logic.matchId),
      //   ],
      // if (detail?.injure ?? false)
      //   [
      //     Constant.shangjin,
      //     BbLineupWidget(),
      //   ],
      // if (detail?.lineup ?? false)
      //   [
      //     Constant.tongji,
      //     BbLineupWidget(),
      //   ],
      if (detail?.data ?? false)
        [
          Constant.shuju,
          BbDetailDataView(),
        ],
      if (detail?.plan ?? false)
        [
          Constant.guandian,
          MatchViewsPage(),
        ],
      // if (detail?.info ?? false) [Constant.qingbao, BbInfoWidget()],
      if (detail?.odds ?? false) [Constant.zhishu, BbOddsView()],
    ];

    int idx = 0;
    if (Get.parameters.isNotEmpty) {
      idx = tabitems
          .indexWhere((element) => element[0] == Get.parameters['tabName']!);
    } else {
      if (detail?.statusId == 1) {
        if (detail?.planCnt != 0 && detail?.planCnt != null) {
          idx =
              tabitems.indexWhere((element) => element[0] == Constant.guandian);
        } else {
          idx = tabitems.indexWhere((element) => element[0] == Constant.shuju);
        }
      } else {
        idx = tabitems.indexWhere((element) => element[0] == Constant.tongji);
      }
    }

    // int idx = tabitems.indexWhere((element) => element[0] == stab);
    if (idx < 0 || idx >= tabitems.length) {
      idx = 0;
    }

    tabController.dispose();
    tabController =
        TabController(length: tabitems.length, vsync: this, initialIndex: idx);
    // if ((detail?.data ?? false) && (detail?.statusId ?? 0) == 1) {
    //   tabController.animateTo(
    //       tabitems.indexWhere((element) => element[0] == Constant.shuju));
    // }
  }

  @override
  void initState() {
    super.initState();

    getMatchDetail();
    // getVideoList();
    t = Timer.periodic(const Duration(seconds: 30), (timer) {
      if ((detail?.statusId ?? 0) > 1 && (detail?.statusId ?? 0) < 10) {
        getMatchDetail();
      }
    });
    tabController = TabController(length: tabitems.length, vsync: this);

    scrollController.addListener(() {
      scrollController.position.maxScrollExtent;
      scrollController.offset;
      if (scrollController.offset >=
          scrollController.position.maxScrollExtent - 10) {
        if (!showTitle) {
          showTitle = true;
          update();
        }
      } else {
        if (showTitle) {
          showTitle = false;
          update();
        }
      }
    });
  }

  @override
  void dispose() {
    t?.cancel();
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScrollController(
        controller: scrollController,
        child: Scaffold(
            appBar: Styles.appBar(
              backgroundColor: Colours.main_color,
              leadingColor: Colors.white,
              title: showTitle ? _barTitle2() : _barTtitle1(),
              iconTheme: IconThemeData(color: Colors.white),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      isFocus = !isFocus;

                      () async {
                        if (isFocus) {
                          Utils.onEvent('lqbspd_lqbsxq',
                              params: {'lqbspd_lqbsxq': '4'});
                          await User.basketballFocuses.focus(logic.matchId);
                        } else {
                          await User.basketballFocuses.unFocus(logic.matchId);
                          Utils.onEvent('lqbspd_lqbsxq',
                              params: {'lqbspd_lqbsxq': '5'});
                        }
                        isFocus = User.basketballFocuses.isFocus(logic.matchId);
                        update();
                      }.call();

                      update();
                    },
                    icon: Image.asset(Utils.getImgPath(
                        isFocus ? "star.png" : "star_border.png")))
              ],
            ),
            backgroundColor: Colours.main_color,
            body: NestedScrollView(
              controller: scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                      child: BbDetailHeadWidget(
                    detail: detail,
                    id: logic.matchId,
                    // videoList: videoList,
                  ))
                ];
              },
              body: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10))),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: TabBar(
                        controller: tabController,
                        tabs: List.generate(tabitems.length,
                            (index) => Tab(text: tabitems[index][0])),
                        indicator: const CustomIndicator(
                            borderSide:
                                BorderSide(width: 2, color: Colours.main_color),
                            indicatorBottom: 1,
                            indicatorWidth: 15),
                        labelColor: Colours.main_color,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                        unselectedLabelColor: Colours.grey_color,
                        labelStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                        unselectedLabelStyle: const TextStyle(fontSize: 16),
                        onTap: (value) {
                          Utils.onEvent('lqbspd_lqbsxq',
                              params: {'lqbspd_lqbsxq': '$value'});
                        },
                      ),
                    ),
                    Expanded(
                        child: Container(
                      color: const Color(0xFFF7F7F7),
                      child: TabBarView(
                          controller: tabController,
                          children: List.generate(
                              tabitems.length, (index) => tabitems[index][1])),
                    )),
                  ],
                ),
              ),
            )));
  }

  Widget _barTtitle1() {
    final kind = {
      1: '常规赛',
      2: '季后赛',
      3: '季前赛',
      4: '全明星',
      5: '杯赛',
      6: '附加赛'
    }[detail?.kind ?? 0];
    return Column(
      children: [
        DefaultTextStyle(
          style:
              const TextStyle(color: Colors.white, fontSize: 14, height: 1.2),
          child: Column(
            children: [
              if ((detail?.statusId ?? -1) >= 10) Text(detail?.timeDesc ?? ""),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(detail?.leagueName ?? ""),
                  if (kind != null)
                    Text(
                      kind,
                    ).marginOnly(left: 6)
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _barTitle2() {
    final statusid = detail?.statusId ?? 0;
    // log("detail status id = ${statusid}");
    Widget mid = Container();
    if (statusid == 1) {
      mid = Text("${detail?.timeDesc}");
    } else if (statusid == 10) {
      mid = Text("${detail?.awayScore}-${detail?.homeScore}");
    } else if ((statusid < 1) || (statusid > 8)) {
      mid = Text(detail?.statusMap[statusid] ?? "");
    } else {
      mid = Column(
        children: [
          Text(detail?.statusMap[statusid] ?? ""),
          Text("${detail?.awayScore}-${detail?.homeScore}")
        ],
      );
    }

    return DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        child: Row(
          children: [
            Expanded(child: Text(detail?.awayTeamName ?? "")),
            const SizedBox(width: 5),
            mid,
            const SizedBox(width: 5),
            Expanded(child: Text("${detail?.homeTeamName}[主]")),
          ],
        ));
  }
}
