import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/match/basket_match_filter_controller.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/common_button.dart';
import 'package:sports/widgets/no_data_widget.dart';

class BasketFilterPage extends StatefulWidget {
  const BasketFilterPage({super.key});

  @override
  State<BasketFilterPage> createState() => _BasketFilterPageState();
}

class _BasketFilterPageState extends State<BasketFilterPage>
    with TickerProviderStateMixin {
  late BasketMatchFilterController leagueController;
  final List<String> _tabs = [
    '全部',
    '热门',
    '竞篮',
  ];
  late TabController _controller;

  @override
  void initState() {
    super.initState();

    var matchType = MatchType.all;
    int tabIndex = Get.arguments;
    if (tabIndex == 0) {
      leagueController = Get.find<BasketMatchFilterController>(
          tag: Constant.matchFilterTagFocus);
      matchType = MatchType.focus;
    } else if (tabIndex == 1) {
      leagueController = Get.find<BasketMatchFilterController>(
          tag: Constant.matchFilterTagAll);
      matchType = MatchType.all;
    } else if (tabIndex == 2) {
      leagueController = Get.find<BasketMatchFilterController>(
          tag: Constant.matchFilterTagBegin);
      matchType = MatchType.begin;
    } else if (tabIndex == 3) {
      leagueController = Get.find<BasketMatchFilterController>(
          tag: Constant.matchFilterTagSchedule);
      matchType = MatchType.schedule;
    } else if (tabIndex == 4) {
      leagueController = Get.find<BasketMatchFilterController>(
          tag: Constant.matchFilterTagResult);
      matchType = MatchType.end;
    }
    _controller = TabController(
        length: _tabs.length,
        vsync: this,
        initialIndex: leagueController.leagueType.index);
    // leagueController.leagueType = LeagueType.all;
    leagueController.initLeague(matchType);
  }

  @override
  Widget build(BuildContext context) {
    // showList = [];
    // List<MatchTypeEntity> samePinyinList = [];
    // String tag = '';
    // matchList.forEach((element) {
    //   if (element.tagIndex == tag) {
    //     samePinyinList.add(element);
    //   } else {
    //     showList.add(samePinyinList);
    //     samePinyinList = [element];
    //     tag = element.tagIndex!;
    //   }
    // });
    return Scaffold(
        appBar: Styles.appBar(
          title: const Text('赛事筛选'),
        ),
        // backgroundColor: Colours.greyEDEDED,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                color: Colours.white,
                height: 34,
                child: Styles.defaultTabBar(
                  tabs: _tabs.map((f) {
                    return Text(f);
                  }).toList(),
                  onTap: (value) => tapTabbar(value),
                  // labelColor: Colours.white,
                  controller: _controller,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  unselectedFontWeight: FontWeight.w400,
                  unselectedLabelColor: Colours.grey66,
                ),
              ),
              Divider(height: 0.5, color: Colours.greyEE),
              Expanded(
                  child: TabBarView(
                      controller: _controller,
                      children: List.generate(_tabs.length, (index) {
                        if (index == 0) {
                          return const MatchFilterView();
                        } else {
                          return MatchFilterView1(LeagueType.values[index]);
                        }
                      }))),
              Divider(height: 0.5, color: Colours.greyEE),
              bottomBar()
            ],
          ),
        ));
  }

  void tapTabbar(index) {
    var leagueType = LeagueType.all;
    if (index == 1) {
      leagueType = LeagueType.rm;
    } else if (index == 2) {
      leagueType = LeagueType.jc;
    }
    leagueController.onSelectLeagueType(leagueType);
  }

  Widget bottomBar() {
    String tag = '';
    int tabIndex = Get.arguments;
    if (tabIndex == 0) {
      tag = Constant.matchFilterTagFocus;
    } else if (tabIndex == 1) {
      tag = Constant.matchFilterTagAll;
    } else if (tabIndex == 2) {
      tag = Constant.matchFilterTagBegin;
    } else if (tabIndex == 3) {
      tag = Constant.matchFilterTagSchedule;
    } else if (tabIndex == 4) {
      tag = Constant.matchFilterTagResult;
    }
    return GetBuilder<BasketMatchFilterController>(
        tag: tag,
        builder: (controller) {
          return Container(
            // height: 50,
            color: Colours.white,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(children: [
              CommonButton(
                onPressed: () {
                  Utils.onEvent('lqsxy_sxan', params: {'lqsxy_sxan': '0'});
                  leagueController.selectOneLevel();
                },
                text: '一级',
                foregroundColor: Colours.grey66,
                backgroundColor: Colours.greyF7,
                textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                radius: 4,
                minWidth: 52,
                minHeight: 40,
                // textStyle: TextStyle(),
              ),
              SizedBox(width: 8),
              CommonButton(
                  onPressed: () {
                    Utils.onEvent('lqsxy_sxan', params: {'lqsxy_sxan': '1'});
                    leagueController.selectAll();
                  },
                  text: '全选',
                  foregroundColor: Colours.grey66,
                  backgroundColor: Colours.greyF7,
                  textStyle:
                      TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                  radius: 4,
                  minWidth: 52,
                  minHeight: 40),
              SizedBox(width: 8),
              CommonButton(
                  onPressed: () {
                    Utils.onEvent('lqsxy_sxan', params: {'lqsxy_sxan': '2'});
                    leagueController.selectReverse();
                  },
                  text: '反选',
                  foregroundColor: Colours.grey66,
                  backgroundColor: Colours.greyF7,
                  textStyle:
                      TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                  radius: 4,
                  minWidth: 52,
                  minHeight: 40),
              SizedBox(width: 8),
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: '隐藏',
                    style: TextStyle(fontSize: 11, color: Colours.grey_color1)),
                TextSpan(
                    text: '${leagueController.hideMatch}',
                    style: TextStyle(fontSize: 11, color: Colours.main)),
                TextSpan(
                    text: '场',
                    style: TextStyle(fontSize: 11, color: Colours.grey_color1))
              ])),
              Spacer(),
              CommonButton(
                onPressed: () {
                  Utils.onEvent('sxy_qd');
                  leagueController.onConfirm();
                },
                text: '确定',
                radius: 4,
                minHeight: 40,
                minWidth: 92,
                foregroundColor: Colours.white,
                backgroundColor: Colours.main_color,
                // side: BorderSide(width: 1),
              )
            ]),
          );
        });
  }
}

class MatchFilterView extends StatefulWidget {
  const MatchFilterView({super.key});

  @override
  State<MatchFilterView> createState() => _MatchFilterViewState();
}

class _MatchFilterViewState extends State<MatchFilterView> {
  late BasketMatchFilterController leagueController;
  late final controllerTag;
  @override
  void initState() {
    super.initState();
    int tabIndex = Get.arguments;

    if (tabIndex == 0) {
      controllerTag = Constant.matchFilterTagFocus;
    } else if (tabIndex == 1) {
      controllerTag = Constant.matchFilterTagAll;
    } else if (tabIndex == 2) {
      controllerTag = Constant.matchFilterTagBegin;
    } else if (tabIndex == 3) {
      controllerTag = Constant.matchFilterTagSchedule;
    } else if (tabIndex == 4) {
      controllerTag = Constant.matchFilterTagResult;
    }
    leagueController =
        Get.find<BasketMatchFilterController>(tag: controllerTag);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BasketMatchFilterController>(
      tag: controllerTag,
      builder: (_) {
        return Container(
          // color: Colours.greyEDEDED,
          child: leagueController.indexLeagueEntity.length == 0
              ? NoDataWidget()
              : AzListView(
                  data: leagueController.indexLeagueEntity,
                  itemCount: leagueController.indexLeagueEntity.length,
                  itemBuilder: ((context, index) {
                    return groupLeague(index);
                  }),
                  physics: const BouncingScrollPhysics(),
                  indexBarData: SuspensionUtil.getTagIndexList(
                      leagueController.indexLeagueEntity),
                  // indexBarHeight: 500,
                  indexBarWidth: 26,
                  indexBarOptions: IndexBarOptions(
                    textStyle:
                        TextStyle(color: Colours.text_color1, fontSize: 10),
                    // needRebuild: true,
                    // selectItemDecoration:
                    //     BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                  ),
                ),
        );
      },
    );
  }

  Widget groupLeague(index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Offstage(
          offstage:
              leagueController.indexLeagueEntity[index].isShowSuspension !=
                  true,
          child: Container(
              padding: EdgeInsets.only(left: 16, top: 12),
              width: double.infinity,
              // color: Colours.greyEDEDED,
              child: Text(
                index == 0 &&
                        (leagueController.indexLeagueEntity[index].tagIndex ==
                            '★')
                    ? '热门赛事'
                    : leagueController.indexLeagueEntity[index].tagIndex,
                style: TextStyle(
                    color: Colours.text_color1,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              )),
        ),
        Container(
          // color: Colours.greyEDEDED,
          width: double.infinity,
          // decoration: BoxDecoration(color: Colors.red),
          padding: const EdgeInsets.fromLTRB(16, 8, 26, 0),
          child: Wrap(
              spacing: 12,
              runSpacing: 10,
              children: leagueController.indexLeagueEntity[index].leagues
                  .map((e) => GestureDetector(
                        onTap: () => leagueController.selectLeague(e),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          decoration: BoxDecoration(
                              color: e.isSelected
                                  ? Colours.redFFF5F5
                                  : Colours.greyF7,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: e.isSelected
                                      ? Colours.redFA9F9F
                                      : Colours.transparent,
                                  width: 0.5)),
                          width: (Get.width - 67) / 3,
                          height: 34,
                          child: Row(children: [
                            Expanded(
                              child: Text(
                                e.leagueName!,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: e.isSelected
                                        ? Colours.main
                                        : Colours.text_color1),
                              ),
                            ),
                            Text('${e.matchNum}场',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: e.isSelected
                                        ? Colours.main
                                        : Colours.grey66))
                          ]),
                        ),
                      ))
                  .toList()),
        ),
      ],
    );
  }
}

class MatchFilterView1 extends StatelessWidget {
  LeagueType type;
  MatchFilterView1(this.type, {super.key});

  @override
  Widget build(BuildContext context) {
    int tabIndex = Get.arguments;
    String tag = '';
    if (tabIndex == 0) {
      tag = Constant.matchFilterTagFocus;
    } else if (tabIndex == 1) {
      tag = Constant.matchFilterTagAll;
    } else if (tabIndex == 2) {
      tag = Constant.matchFilterTagBegin;
    } else if (tabIndex == 3) {
      tag = Constant.matchFilterTagSchedule;
    } else if (tabIndex == 4) {
      tag = Constant.matchFilterTagResult;
    }
    return GetBuilder<BasketMatchFilterController>(
      tag: tag,
      builder: (controller) {
        return controller.getLeague(type).length == 0
            ? NoDataWidget()
            : Container(
                // color: Colours.greyEDEDED,
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Wrap(
                      spacing: 20,
                      runSpacing: 10,
                      children: controller
                          .getLeague(type)
                          .map((e) => GestureDetector(
                                onTap: () => controller.selectLeague(e),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: e.isSelected
                                          ? Colours.redFFF5F5
                                          : Colours.greyF7,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: e.isSelected
                                              ? Colours.redFA9F9F
                                              : Colours.transparent,
                                          width: 0.5)),
                                  width: (Get.width - 80) / 3 - 1,
                                  height: 34,
                                  child: Row(children: [
                                    Expanded(
                                      child: Text(
                                        e.leagueName!,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: e.isSelected
                                                ? Colours.main
                                                : Colours.text_color1),
                                      ),
                                    ),
                                    Text('${e.matchNum}',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: e.isSelected
                                                ? Colours.main
                                                : Colours.grey66))
                                  ]),
                                ),
                              ))
                          .toList()),
                ),
              );
      },
    );
  }
}
