import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/home/home_news_entity.dart';
import 'package:sports/model/home/index_class_entity.dart';
import 'package:sports/model/home/lbt_entiry.dart';
import 'package:sports/model/match/hot_match_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/local_read_history.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/home/announce_view.dart';
import 'package:sports/view/home/focus_match_view.dart';
import 'package:sports/view/home/lbt_view.dart';
import 'package:sports/view/home/news_list_view.dart';
import 'package:sports/widgets/loading_check_widget.dart';
import 'package:sports/widgets/no_data_widget.dart';
// import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../res/styles.dart';
import '../loading/loading_home_widget.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  // late SVGAAnimationController _svgController;

  // BottomNavigationBarItem refreshTabbarItem(double imageSize) =>
  //     BottomNavigationBarItem(
  //       icon: Image.asset(Utils.getImgPath("home_unselect.png"),
  //           width: imageSize, height: imageSize),
  //       activeIcon: SizedBox(
  //         width: imageSize,
  //         height: imageSize,
  //         child: SVGAImage(_svgController),
  //       ),
  //       label: "首页",
  //     );

  doRefresh() {
    _stream.add("refresh");
  }

  final _stream = StreamController.broadcast();

  // late SVGAAnimationController _svgController;

  // BottomNavigationBarItem refreshTabbarItem(double imageSize) =>
  //     BottomNavigationBarItem(
  //       icon: Image.asset(Utils.getImgPath("home_unselect.png"),
  //           width: imageSize, height: imageSize),
  //       activeIcon: SizedBox(
  //         width: imageSize,
  //         height: imageSize,
  //         child: SVGAImage(_svgController),
  //       ),
  //       label: "首页",
  //     );

  // late SVGAAnimationController _svgController;

  // BottomNavigationBarItem refreshTabbarItem(double imageSize) =>
  //     BottomNavigationBarItem(
  //       icon: Image.asset(Utils.getImgPath("home_unselect.png"),
  //           width: imageSize, height: imageSize),
  //       activeIcon: SizedBox(
  //         width: imageSize,
  //         height: imageSize,
  //         child: SVGAImage(_svgController),
  //       ),
  //       label: "首页",
  //     );

  @override
  State<HomePage> createState() => _HomePageState();
}

class PageWrap {
  PageWrap(this.id, {this.page = 1, this.size = 20});

  final int id;
  int page;
  final int size;
  int? total;
  List<HomeNewsEntity> data = [];

  bool get isEnd {
    if (page == 1) {
      return false;
    }
    return data.length < size * (page - 1);
  }

  static PageWrap? fromJson(Map<String, dynamic> json) {
    try {
      final page = PageWrap(json['id'], size: json['size'], page: json['page']);
      page.total = json['total'];
      page.data = (json['data'] as List)
          .map((e) => HomeNewsEntity.fromJson(e))
          .toList();
      return page;
    } catch (err) {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['id'] = id;
    json['page'] = page;
    json['size'] = size;
    json['total'] = total;
    json['data'] = data.map((e) => e.toJson()).toList();
    return json;
  }
}

mixin _HomePageMixin on State<HomePage> {
  makeTabController() {}
  List<LbtEntity> lbts = [];
  List<IndexClassEntity> classes = [];
  List<LbtEntity> announces = [];
  List<HotMatchEntity> hotMatches = [];
  Map<int, PageWrap> pages = {};
  DateTime? refreshTime = null;
  bool tabdiv = false;

  final scrollController1 = ScrollController();
  double _topHeight = 0;
  bool visible = false;
  bool isRefreshing = false;
  late List<bool> isLoading = classes.length >0?List.generate(classes.length, (index) => true):[true];
  late Timer _hotTimer;

  PageWrap getPage(int id) {
    return pages[id] ??
        () {
          final p = PageWrap(id);
          pages[id] = p;
          return p;
        }.call();
  }

  PageWrap? curNewsPage() {
    final idx = _controller.index;
    if (classes.length <= idx) {
      return null;
    }
    final id = classes[idx].id;
    return id == null ? null : getPage(id);
  }

  late TabController _controller;
  late EasyRefreshController _refreshController;

  clearUnusedPage() {
    pages.removeWhere((key, value) => classes.fold(
        true, (previousValue, element) => element.id != key && previousValue));
  }

  Future<bool> _getLbt() async {
    final l = await Utils.tryOrNullf(
        () async => await Api.getAppList("app_index_lbt"));
    if (l == null) {
      return false;
    }
    // log("get lbts = ${l.map((e) => e.toJson())}");
    lbts = l;
    update();
    return true;
  }

  Future<bool> _getHotMatches() async {
    final l = await Utils.tryOrNullf(() async {
      final res = await Api.getHotMatches();
      List d = res.data['d'] ?? [];
      return d.map((e) => HotMatchEntity.fromJson(e)).toList();
    });

    hotMatches = (l?.length ?? 0) == 0 ? [] : l!;
    update();
    return true;
  }

  Future<bool> _getIndexClasses() async {
    final l = await Utils.tryOrNullf(() async => await Api.getClassInfoList());
    if (l == null) {
      return false;
    }

    classes = l;
    for (var i = 1; i<= classes.length-1; i++) {
      isLoading.add(true);
    };
    clearUnusedPage();
    makeTabController();
    update();
    return true;
  }

  Future<bool> _getGb() async {
    final l = await Utils.tryOrNullf(
        () async => await Api.getAppList("app_index_gb"));
    if (l == null) {
      return false;
    }
    announces = l;
    update();
    return true;
  }

  Future<bool> _getHomeNews() async {
    final p = curNewsPage();
    // log("get home news p = ${p?.toJson()}");
    if (p == null || p.isEnd) {
      return true;
    }

    final ep = p;
    final page = ep.page;
    final size = ep.size;
    final data = await Utils.tryOrNullf(() async {
      final r = await Api.getHomeNews(ep.id, page, size);
      Map<String, dynamic> d = r.data['d'];
      int total = d['total'];
      log("home news 0 ${d['rows'][0]}");
      final data =
          (d["rows"] as List).map((e) => HomeNewsEntity.fromJson(e)).toList();
      isLoading[classes.indexWhere((element) => element.id == ep.id)] = false;
      return {"total": total, "data": data};
    });
    if (data == null || ep.page != page) {
      return false;
    }
    int total = data["total"] as int;
    final newsList = data["data"] as List<HomeNewsEntity>;
    log("get home news length = ${newsList.length} total = $total");
    ep.total = total;
    if (page == 1) {
      ep.data = newsList;
    } else {
      ep.data.addAll(newsList);
    }
    ep.page += 1;
    return true;
  }

  doSaveHomeData() {
    final json = <String, dynamic>{};
    json['ltbs'] = lbts.map((e) => e.toJson()).toList();
    json['classes'] = classes.map((e) => e.toJson()).toList();
    json['announces'] = announces.map((e) => e.toJson()).toList();
    json['pages'] = pages.map((key, value) => MapEntry("$key", value.toJson()));
    jsonEncode(json['pages']);
    SpUtils.homeData = json;
  }

  doFetchdataFromSp() {
    try {
      Map<String, dynamic>? json = SpUtils.homeData;
      // log("hom data = $json");
      if (json == null) {
        return;
      }
      lbts = (json['ltbs'] as List).map((e) => LbtEntity.fromJson(e)).toList();
      classes = (json['classes'] as List)
          .map((e) => IndexClassEntity.fromJson(e))
          .toList();
      announces = (json['announces'] as List)
          .map((e) => LbtEntity.fromJson(e))
          .toList();
      pages = (json['pages'] as Map<String, dynamic>).map((key, value) =>
          MapEntry(int.parse(key),
              PageWrap.fromJson(value as Map<String, dynamic>)!..page = 1));
    } catch (err) {
      log("fetch home data err $err");
    }
  }

  bool shouldRefresh() {
    if (refreshTime == null) {
      return true;
    }
    final minutes = DateTime.now().difference(refreshTime!).inMinutes;
    return minutes > 3;
  }

  Future<bool> doRefreshData({bool pull = false}) async {
    if (isRefreshing) {
      return false;
    }
    isRefreshing = true;
    for (var e in pages.values) {
      e.page = 1;
      e.total = null;
    }
    // log("do refresh cur page = ${curNewsPage()?.page}");
    final results = await Future.wait(
        [_getLbt(), _getIndexClasses(), _getHotMatches(), _getGb()]);
    // await Future.delayed(Duration(seconds: 3));
    _getHomeNews();
    isRefreshing = false;
    if (!results.contains(true)) {
      return false;
    }
    refreshTime = DateTime.now();
    return true;
  }
}

class _HomePageState extends State<HomePage>
    with
        TickerProviderStateMixin,
        _HomePageMixin,
        AutomaticKeepAliveClientMixin,
        WidgetsBindingObserver {
  @override
  bool get wantKeepAlive => lbts.isNotEmpty;
  StreamSubscription? refreshSub;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      doSaveHomeData();
      LocalReadHistory.save();
    }
  }

  @override
  void initState() {
    super.initState();
    LocalReadHistory.load();
    refreshSub = widget._stream.stream.listen((event) {
      // doRefreshData(pull: true);
      _refreshController.callRefresh(
          scrollController: PrimaryScrollController.of(context));
    });
    doFetchdataFromSp();
    WidgetsBinding.instance.addObserver(this);
    _controller = TabController(
      length: classes.length,
      vsync: this,
    );
    makeTabController();
    _refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );

    _hotTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!visible) {
        return;
      }
      _getHotMatches();
    });

    // scrollController1.addListener(
    //   () {
    //     // final padTop = 0;
    //     final taboffset = scrollController1.position.maxScrollExtent -
    //         scrollController1.offset;
    //     // log("scroll listen $taboffset");
    //     if (taboffset == 0) {
    //       tabdiv = true;
    //       update();
    //     } else if (tabdiv) {
    //       tabdiv = false;
    //       update();
    //     }
    //   },
    // );
    doRefreshData();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void scrollListener() {
    final taboffset =
        PrimaryScrollController.of(context).position.maxScrollExtent -
            PrimaryScrollController.of(context).offset;
    // log("scroll listen $taboffset");
    if (taboffset == 0) {
      tabdiv = true;
      update();
    } else if (tabdiv) {
      tabdiv = false;
      update();
    }
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  void dispose() {
    refreshSub?.cancel();
    _hotTimer.cancel();
    _refreshController.dispose();
    _controller.dispose();
    scrollController1.dispose();
    WidgetsBinding.instance.removeObserver(this);
    log("home page dispose");
    super.dispose();
  }

  @override
  makeTabController() {
    final index = _controller.index;
    _controller.dispose();
    _controller = TabController(
      length: classes.length,
      vsync: this,
    );
    if (index < classes.length) {
      _controller.index = index;
    }
    _controller.addListener(() {
      _refreshController.finishLoad((curNewsPage()?.isEnd ?? false)
          ? IndicatorResult.noMore
          : IndicatorResult.success);
      _getHomeNews().then((value) => update());
    });
    _getHomeNews().then((value) => update());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PrimaryScrollController(
      controller: ScrollController(),
      child: Scaffold(
          backgroundColor: const Color(0xFFffffff),
          body: VisibilityDetector(
            key: const Key("home key"),
            onVisibilityChanged: (info) {
              visible = !info.visibleBounds.isEmpty;
              log("home visible event $visible");
              if (visible) {
                // PrimaryScrollController.of(context).addListener(scrollListener);
                SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
                    statusBarIconBrightness: Brightness.dark,
                    statusBarBrightness: Brightness.light));
                if (shouldRefresh()) {
                  doRefreshData();
                }
              } else {
                // PrimaryScrollController.of(context)
                //     .removeListener(scrollListener);
              }
            },
            child: Column(
              children: [
                SafeArea(child: Container()),
                Expanded(child: _refreshWidget()),
              ],
            ),
          )),
    );
  }

  Widget _refreshWidget() {
    return EasyRefresh.builder(
        header: const ClassicHeader(
          position: IndicatorPosition.locator,
          clamping: true,
          dragText: "下拉刷新",
          armedText: "松开刷新",
          failedText: "刷新失败",
          readyText: "正在刷新...",
          processingText: "正在刷新...",
          processedText: "刷新完成",
          messageText: '',
          showMessage: false,
          iconTheme: IconThemeData(color: Colours.text_color),
          textStyle: TextStyle(fontSize: 12),
          // progressIndicatorSize: 16.0
        ),
        footer: ClassicFooter(
          position: IndicatorPosition.locator,
          dragText: "上拉加载",
          armedText: "松开加载",
          failedText: "加载失败",
          readyText: "正在加载更多的数据...",
          processingText: "正在加载更多的数据...",
          processedText: "加载完成",
          noMoreText: "没有更多内容了～",
          showMessage: false,
          iconDimension: 0,
          // showText: false,
          succeededIcon: Container(),
          failedIcon: Container(),
          noMoreIcon: Container(),
          messageText: '',
          textStyle: TextStyle(fontSize: 12, color: Colours.grey_color1),
          messageStyle: TextStyle(fontSize: 10),
          // progressIndicatorSize: 32.0
        ),
        controller: _refreshController,
        onRefresh: () async {
          final b = await doRefreshData();
          _refreshController.finishRefresh(
              b ? IndicatorResult.success : IndicatorResult.fail);
        },
        onLoad: () async {
          await _getHomeNews();
          _refreshController.finishLoad((curNewsPage()?.isEnd ?? false)
              ? IndicatorResult.noMore
              : IndicatorResult.success);
          setState(() {});
        },
        childBuilder: (context, physics) => _scrollContent(physics));
  }

  bool get hasData => (lbts.isNotEmpty ||
      classes.isNotEmpty ||
      // hotMatches.isNotEmpty ||
      announces.isNotEmpty);

  Widget _scrollContent(ScrollPhysics physics) {
    return LoadingCheckWidget<int>(
      isLoading: isLoading[0],
      data: lbts.length + pages.length,
      loading: const LoadingHomeWidget(),
      noData: NoDataWidget(tip: "网络不稳定，请检查网络",buttonText: "点击重试", onTap: () async {
        final state = await Connectivity().checkConnectivity();
        if (state == ConnectivityResult.none) {
          ToastUtils.show("请连接网络");
        }
        doRefreshData(pull: true);
      }),
      child: ScrollConfiguration(
        behavior: const ERScrollBehavior(),
        child: ExtendedNestedScrollView(
          physics: physics,
          onlyOneScrollInBody: true,
          controller: PrimaryScrollController.of(context),
          pinnedHeaderSliverHeightBuilder: () {
            return 0;
          },
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              const HeaderLocator.sliver(clearExtent: false),
              SliverToBoxAdapter(child: _headerBox()),
            ];
          },
          body: !hasData
              ? NoDataWidget(tip: "网络不稳定，请检查网络",buttonText: "点击重试", onTap: () async {
                  final state = await Connectivity().checkConnectivity();
                  if (state == ConnectivityResult.none) {
                    ToastUtils.show("请连接网络");
                  }
                  doRefreshData(pull: true);
                })
              : Column(
                  children: [
                    SizedBox(height: _topHeight),
                    SizedBox(
                        height: 40,
                        child: Styles.defaultTabBar(
                            tabs: classes.map((f) {
                              return Text(
                                f.name ?? "",
                                maxLines: 1,
                              );
                            }).toList(),
                            onTap: (value) {
                              Utils.onEvent('sypdzx',
                                  params: {'sypdzx': classes[value].name});
                            },
                            controller: _controller,
                            fontSize: 16,
                            labelPadding:
                                const EdgeInsets.symmetric(horizontal: 13),
                            isScrollable: true)),
                    if (tabdiv)
                      const Divider(
                        height: 0.5,
                        color: Color(0xffeeeeee),
                      ),
                    Expanded(
                      child: TabBarView(
                        controller: _controller,
                        children: List.generate(classes.length, (index) =>
                          LoadingCheckWidget<int>(
                            isLoading: isLoading[index],
                            loading: const LoadingHomeWidget().loadingHomeList(),
                            data: getPage(classes[index].id!).data.length,
                            child: LayoutBuilder(
                                builder: (p0, p1) {
                                  // log("layout builder max height = ${p1.maxHeight}");
                                  return CustomScrollView(
                                    physics: physics,
                                    slivers: [
                                      const SliverToBoxAdapter(
                                          child: SizedBox(height: 0)),
                                      NewsListView(
                                          data: getPage(classes[index].id!).data,
                                          classId: classes[index].id!,
                                          maxHeight: p1.maxHeight),
                                      const FooterLocator.sliver(),
                                    ],
                                  );
                                },
                              ),
                          )
                        )
                        // classes.map((f) {
                        //   return LoadingCheckWidget<int>(
                        //         isLoading: isLoading[f.sort!],
                        //         loading: const LoadingHomeWidget().loadingHomeList(),
                        //         data: getPage(f.id!).data.length,
                        //         child: LayoutBuilder(
                        //             builder: (p0, p1) {
                        //               // log("layout builder max height = ${p1.maxHeight}");
                        //               return CustomScrollView(
                        //                 physics: physics,
                        //                 slivers: [
                        //                   const SliverToBoxAdapter(
                        //                       child: SizedBox(height: 0)),
                        //                   NewsListView(
                        //                       data: getPage(f.id!).data,
                        //                       classId: f.id!,
                        //                       maxHeight: p1.maxHeight),
                        //                   const FooterLocator.sliver(),
                        //                 ],
                        //               );
                        //             },
                        //           ),
                        //       );
                        //   // return Center(child: HeadLinePage());
                        // }).toList(),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _headerBox() {
    return Column(
      children: [
        const SizedBox(height: 10),
        if (lbts.isNotEmpty) LbtView(lbts: lbts).marginOnly(bottom: 18),
        if (announces.isNotEmpty)
          AnnounceView(
            announces: announces,
            click: (p0) {
              p0.doJump();
            },
          ).marginOnly(bottom: 18),
        if (hotMatches.isNotEmpty)
          FocusMatchView(
              matches: hotMatches,
              click: (p0) {
                final id = p0.id;
                if (id == null) {
                  return;
                }
                Get.toNamed(Routes.soccerMatchDetail, arguments: id);
              }).marginOnly(bottom: 18),
      ],
    );
  }
}
