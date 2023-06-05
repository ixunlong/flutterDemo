import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/team/soccer_team_detail_controller.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/team/soccer_team_info_view.dart';
import 'package:sports/view/team/soccer_team_lineup_view.dart';
import 'package:sports/view/team/soccer_team_schedule_view.dart';

class SoccerTeamDetailPage extends StatefulWidget {
  const SoccerTeamDetailPage({super.key});

  @override
  State<SoccerTeamDetailPage> createState() => _SoccerTeamDetailPageState();
}

class _SoccerTeamDetailPageState extends State<SoccerTeamDetailPage>
    with TickerProviderStateMixin {
  int teamId = Get.arguments;
  late SoccerTeamDetailController controller;
  final tabs = ['资料', '赛程', '阵容'];
  late final pages = [
    SoccerTeamInfoView(),
    SoccerTeamScheduleView(teamId: teamId),
    SoccerTeamLineupView(teamId: teamId),
  ];
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SoccerTeamDetailController(), tag: teamId.toString());
    tabController = TabController(
      length: tabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.main,
      body: GetBuilder<SoccerTeamDetailController>(
          tag: teamId.toString(),
          builder: (controller) {
            return ExtendedNestedScrollView(
              key: controller.key,
              // physics: physics,
              controller: controller.scrollController,
              pinnedHeaderSliverHeightBuilder: () =>
                  MediaQuery.of(context).padding.top + kToolbarHeight,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  Obx(() => SliverAppBar(
                        pinned: true,
                        expandedHeight: 158,
                        titleSpacing: 0.0,
                        backgroundColor: Colours.main,
                        iconTheme: const IconThemeData(color: Colours.white),
                        title: Opacity(
                            opacity: controller.num,
                            child: Text(
                              controller.data?.nameChs ?? "",
                              style: const TextStyle(color: Colours.white),
                            )),
                        leading: GestureDetector(
                          onTap: Get.back,
                          behavior: HitTestBehavior.translucent,
                          child: Image.asset(
                            Utils.getImgPath('arrow_back.png'),
                            color: Colors.white,
                          ),
                        ),
                        actions: [
                          IconButton(
                              onPressed: () async {
                                int? result;
                                if (controller.data?.isFocus == 1) {
                                  result = await Api.focusTeam(teamId, 2);
                                  if (result == 200) {
                                    User.doFetchFocus();
                                    ToastUtils.showDismiss("取消关注成功");
                                  } else {
                                    ToastUtils.showDismiss("取消关注失败");
                                  }
                                } else {
                                  Utils.onEvent('sjpd_qdxq',
                                      params: {'sjpd_qdxq': '3'});
                                  result = await Api.focusTeam(teamId, 1);
                                  if (result == 200) {
                                    User.doFetchFocus();
                                    ToastUtils.showDismiss("关注成功");
                                  }
                                }
                                if (result == 200) {
                                  controller.data?.isFocus =
                                      (controller.data?.isFocus == 1) ? 0 : 1;
                                }

                                update();
                              },
                              iconSize: 24,
                              icon: Image.asset(Utils.getImgPath(
                                  controller.data?.isFocus == 1
                                      ? "star.png"
                                      : "star_border.png")))
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.pin,
                          background: topWidget(),
                        ),
                      )),
                ];
              },
              body: body(),
            );
          }),
    );
  }

  topWidget() {
    return Container(
      width: Get.width,
      // height: 158,
      // clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.only(
          left: 24,
          right: 30,
          top: kToolbarHeight + MediaQuery.of(context).padding.top),
      color: Colours.main,
      // decoration: BoxDecoration(
      //     image: DecorationImage(
      //         fit: BoxFit.fitWidth,
      //         image: AssetImage(Utils.getImgPath("expert_background.png")))),
      child: Row(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(controller.data?.nameChs ?? "",
                style: const TextStyle(
                    color: Colours.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500)),
            Text(controller.data?.nameEn ?? "",
                style: TextStyle(
                    color: Colours.white.withOpacity(0.8), fontSize: 14)),
            SizedBox(height: 14),
            Text('近期状态：${controller.getRecentStatus() ?? ''}',
                style: TextStyle(color: Colours.white, fontSize: 13))
          ],
        ),
        Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            controller.data?.logo == null
                ? Styles.placeholderIcon(width: 54, height: 54)
                : CachedNetworkImage(
                    imageUrl: controller.data?.logo ?? '',
                    width: 54,
                    height: 54,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Styles.placeholderIcon(),
                    errorWidget: (context, url, error) => Image.asset(
                      Utils.getImgPath("team_logo.png"),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
            SizedBox(height: 10),
            if (controller.data?.rank.valuable == true)
              Container(
                // width: 80,
                height: 18,
                padding: EdgeInsets.symmetric(horizontal: 6),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colours.black15,
                    borderRadius: BorderRadius.circular(9)),
                child: Text(
                  controller.data?.rank ?? '-',
                  style: TextStyle(color: Colours.white, fontSize: 10),
                  strutStyle: Styles.centerStyle(fontSize: 10),
                ),
              )
          ],
        )
      ]),
    );
  }

  body() {
    return Container(
        decoration: const BoxDecoration(
            color: Colours.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        child: Column(children: [
          SizedBox(
            height: 40,
            child: Styles.defaultTabBar(
                tabs: tabs.map((f) {
                  return Text(f);
                }).toList(),
                labelPadding: EdgeInsets.symmetric(vertical: 9),
                controller: tabController,
                onTap: (value) {
                  Utils.onEvent('sjpd_qdxq', params: {'sjpd_qdxq': '$value'});
                  // controller.currentIndex = value;
                },
                fontSize: 16,
                // labelPadding: const EdgeInsets.symmetric(horizontal: 13),
                isScrollable: false),
          ),
          Expanded(
              child: TabBarView(
                  controller: tabController,
                  children:
                      List.generate(tabs.length, (index) => pages[index])))
        ]));
  }
}
