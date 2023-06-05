import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:extended_tabs/extended_tabs.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/http/apis/comments.dart';
import 'package:sports/model/home/home_news_entity.dart';
import 'package:sports/model/home/news_comment_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/local_read_history.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/home/comment/comment_input_widget.dart';
import 'package:sports/view/home/comment/news_comments_view.dart';
import 'package:sports/view/home/news_list_cell.dart';
import 'package:sports/view/home/news_list_view.dart';
import 'package:sports/view/home/news_view.dart';
import 'package:sports/view/home/video/video_player.dart' as player;
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:provider/provider.dart';

class HomeVideoNewsPage extends StatefulWidget {
  const HomeVideoNewsPage({super.key});

  @override
  State<HomeVideoNewsPage> createState() => _HomeVideoNewsPageState();
}

class _HomeVideoNewsPageState extends State<HomeVideoNewsPage>
    with TickerProviderStateMixin {
  int id = Utils.getGetxIntId!;
  int? classId = () {
    log("Get parameters = ${Get.parameters}");
    return Get.parameters['classId'] == null
        ? null
        : int.parse(Get.parameters['classId']!);
  }.call();
  HomeNewsEntity? data;

  List<HomeNewsEntity> get recommendList => data?.list ?? [];

  final tabs = ['简介', '评论'];
  late final tabController = TabController(length: tabs.length, vsync: this);
  late final commentController = NewsCommentsController(id);
  FlickManager? flickManager;
  VideoPlayerController? playerController;

  // fetchRecommend() async {
  //   Api.getNewsRecommendList(id, classId).then((value) {
  //     log("$value id = $id classId = $classId");
  //     final list = value.data['d'].map<HomeNewsEntity>((e) => HomeNewsEntity.fromJson(e)).toList();
  //     recommendList = list;
  //     update();
  //   }).catchError((err) {
  //     log("$err");
  //   });
  // }

  getData() async {
    HomeNewsEntity? result = await Api.getVideoNews(id, classId);
    if (result != null) {
      playerController = VideoPlayerController.network(result.video ?? '');
      flickManager = FlickManager(
        videoPlayerController: playerController!,
        getPlayerControlsTimeout: (
            {errorInVideo, isPlaying, isVideoEnded, isVideoInitialized}) {
          return Duration(seconds: 5);
        },
      );
      data = result;
      update();
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    getData();
    commentController.fetchCommentds();
    // fetchRecommend();
    LocalReadHistory.readNews("$id");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (flickManager!.flickControlManager!.isFullscreen) {
          flickManager!.flickControlManager!.exitFullscreen();
          return false;
        }
        return true;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: data == null
              ? Container()
              : Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colours.black,
                      child: SafeArea(
                          bottom: false,
                          child: player.VideoPlayer(data?.video ?? "",
                              flickManager!, playerController!)),
                    ),
                    Container(
                      color: Colors.white,
                      alignment: Alignment.centerLeft,
                      child: Styles.defaultTabBar(
                              isScrollable: true,
                              controller: tabController,
                              tabs: tabs.map((e) => Text("$e").marginSymmetric(horizontal: 8)).toList())
                          .sized(height: 44).marginOnly(left: 8)
                    ),
                    Expanded(
                      child: ExtendedTabBarView(
                          controller: tabController,
                          children: [
                            Container(
                              color: Colours.greyF7,
                              child: ListView(
                                padding: EdgeInsets.zero,
                                children: [
                                  // Container(color: Colors.blue,height: 80,)
                                  titleWidget(),
                                  const SizedBox(height: 10),
                                  Container(
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        ...List.generate(recommendList.length, (index) => 
                                          NewsListCell(recommendList[index],inHome: false,imgStyle: 2,classId: classId,bottomDivider: index < recommendList.length - 1))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Center(child: Text("1"),),
                            Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Expanded(
                                      child: EasyRefresh(
                                    onLoad: commentController.commentEnd
                                        ? null
                                        : () async {
                                            await commentController
                                                .fetchCommentds();
                                            update();
                                          },
                                    child: SingleChildScrollView(
                                        child: NewsCommentsView(
                                      controller: commentController,
                                      paddingTop: MediaQuery.of(context).padding.top,
                                      showTop: false,
                                    )),
                                  )),
                                  SafeArea(
                                      top: false,
                                      child: CommentInputWidget(
                                          numberBtn: false,
                                          news: data,
                                          cid: classId,
                                          textId: "$id",
                                          commentController: commentController))
                                ],
                              ),
                            )
                          ]),
                    )
                  ],
                ),
        ),
      ).tap(() {
        FocusScope.of(context).unfocus();
      }),
    );
  }

  titleWidget() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 14, 16, 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            data!.title!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 20,
                color: Colours.text_color1,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Stack(
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: data?.logo ?? '',
                      width: 32,
                      height: 32,
                    ),
                  ),
                  Positioned(
                      right: 0,
                      bottom: 0,
                      child: Image.asset(Utils.getImgPath('v.png')))
                ],
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data?.publicerName ?? '',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colours.text_color1,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    data?.info ?? '',
                    style: TextStyle(fontSize: 11, color: Colours.grey99),
                  ),
                ],
              )
            ],
          )
        ]),
      ),
    );
  }
}
