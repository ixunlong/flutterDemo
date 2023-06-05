import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/local_read_history.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/home/comment/comment_input_widget.dart';
import 'package:sports/view/home/comment/news_comments_view.dart';
import 'package:sports/view/home/news_list_cell.dart';
import 'package:sports/widgets/app_news_float2_widget.dart';
import 'package:sports/widgets/app_news_float_widget.dart';
import 'package:sports/widgets/picture_preview_widget.dart';

import '../../model/home/home_news_entity.dart';
import '../../res/styles.dart';

class NewsView extends StatefulWidget {
  const NewsView({super.key});

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  HomeNewsEntity? data;

  List<HomeNewsEntity> get recommendList => data?.list ?? [];

  late int? id = Utils.getGetxIntId;

  late int? classId = int.tryParse(Get.parameters['classId'] ?? "");

  fetchNews() {
    Api.getNews2(id!, classId: classId).then((value) {
      data = value;
      data?.classId = classId;
      _makeContentView();
      // fetchRecommend();
      commentsController.updateNews(data);
      update();
    }).catchError((err) {});
  }

  late final commentsController = NewsCommentsController(id ?? 0);
  final scrollController = ScrollController();
  final topAreaKey = GlobalKey();
  double commentAreaOffset() {
    final box = topAreaKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) {
      return 0;
    }
    final y = box.globalToLocal(Offset.zero).dy + box.size.height;
    return y;
  }
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

  @override
  void initState() {
    super.initState();
    commentsController.fetchCommentds();
    log("news id = $id");
    if (id != null) {
      fetchNews();
    } else {
      Get.back();
    }
    // AppNewsFloat2Widget.delNews(id);
    LocalReadHistory.readNews("$id");
  }

  @override
  void dispose() {
    if (AppNewsFloatWidget.needCollect) {
      AppNewsFloat2Widget.addNews(data);
    }
    scrollController.dispose();
    super.dispose();
  }

  String getData() {
    var regC = RegExp(r"[\u4e00-\u9fa5]");
    var regCom = RegExp(r'<\/p>[.\n\s]*<p>');
    var regP = RegExp(r'\/>[.\n\s]*<p>');
    var regImg = RegExp(r'\/>[.\n\s]*<img');
    var regBody = RegExp(r'\/p>[.\n\s]*</body');
    String append = '';
    String? com = data?.content
            ?.split("<p>&nbsp;</p>")
            .join("<div style= 'height: 25;width: 200px;'>  </div>")
            .split(regCom)
            .join("</p><div style= 'height: 25;width: 200px;'>  </div><p>")
            .split(regP)
            .join("/><div style= 'height: 25;width: 200px;'>  </div><p>")
            .split(regImg)
            .join("/><div style= 'height: 25;width: 200px;'>  </div><img")
            .split(regBody)
            .join("/p><div style= 'height: 25;width: 200px;'>  </div></body") ??
        "";
    if (com.endsWith("v>") != true) {
      com = "$com<div style= 'height: 25;width: 200px;'>  </div>";
    }
    log(com);
    com.split("").forEach((element) {
      if (regC.hasMatch(element)) {
        append += "$element\u200A";
      } else {
        append += element;
      }
    });
    var newData = "";
    newData = """
    <!DOCTYPE html>
      <html>
        <body style="margin: 8 20 11 20">
        <p style="font-size:22px;line-height: 1.2;margin: 0;font-weight: 500;">${data?.title ?? ""}</p>
        <div style="font-size:14px;color:#999;margin:9 0 10 0;text-align-last:left;">
        <span>${(data?.publicerName == "" || data?.publicerName == null) ? "" : "${data!.publicerName!}\u2007"}${data?.publicTime ?? ""}</span>
        </div>
        <div style="color: #333;margin: 0;font-size: 18px;line-height: 1.3;letter-spacing: -1px;white-space: normal;text-align: justify;">$append</div>
        ${data?.media == null || data?.media == '' ? '' : "<p style='color: #999;font-size: 12px;line-height: 1.4;white-space: normal;text-align: justify;font-weight:300;margin:0;'>"
            "${"转\u200A载\u200A自\u200A：\u200A${data?.media?.split('').join("\u200A")}"}"
            "</p>"}
        <p style="font-size:12px;color:#999;text-align: justify;font-weight: 300;">${data?.disclaimer?.split('').join("\u200A") ?? ''}</p>
        </body>
      </html>
      <style>
      img{
        max-width: 100%;
        height: auto;
        display:block;
        margin:0 auto;
        text-align: center;
      }
      </style>
    """;
    return newData;
  }

  _makeContentView() {
    _content = Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Html(
        data: getData(),
        onImageTap: (url, context, attributes, element) {
          Get.dialog(PicturePreview(imageUrl: url ?? ""), useSafeArea: false);
        },
        style: {
          "body": Style(letterSpacing: -0.5),
          "p": Style(margin: Margins.all(0))
        },
      ),
    );
  }

  Widget _content = Container();

  @override
  Widget build(BuildContext context) {
    bool loading = data.toString().isEmpty;
    return loading
        ? const CircularProgressIndicator()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: Styles.appBar(
                title: Image.asset(Utils.getImgPath("qxb_title.png")),
                actions: [
                  IconButton(
                      onPressed: () async {
                        if (AppNewsFloat2Widget.existNews(data?.id ?? -1)) {
                          AppNewsFloat2Widget.delNews(data?.id ?? -1);
                        } else {
                          AppNewsFloat2Widget.addNews(data);
                        }
                        update();
                      },
                      icon: Image.asset(
                        AppNewsFloat2Widget.existNews(data?.id ?? -1)
                            ? Utils.getImgPath("comment_fuchuang2.png")
                            : Utils.getImgPath("comment_fuchuang1.png"),
                        width: 24,
                        height: 24,
                      ))
                ]),
            body: Column(
              children: [
                Expanded(
                  child: EasyRefresh(
                    // noMoreRefresh: true,
                    // noMoreLoad: commentsController.commentEnd,
                    onLoad: commentsController.commentEnd
                        ? null
                        : () async {
                            await commentsController.fetchCommentds();
                            update();
                          },
                    child: ListView(controller: scrollController, children: [
                      Column(
                        key: topAreaKey,
                        children: [
                          _content,
                          if (recommendList.isNotEmpty) _recommendView(),
                        ],
                      ),
                      // _commentds(),
                      Container(
                          color: Colours.scaffoldBg,
                          padding: const EdgeInsets.only(top: 10),
                          constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height),
                          child: NewsCommentsView(
                              controller: commentsController,
                              paddingTop: MediaQuery.of(context).padding.top))
                    ]),
                  ),
                ),
                SafeArea(
                    top: false,
                    child: CommentInputWidget(
                        afterShare: () => update(),
                        canInput: (bool isbtn) {
                          if (isbtn) {
                            if (scrollController.offset == 0) {
                              Future.delayed(const Duration(milliseconds: 100))
                                  .then((value) {
                                scrollController.animateTo(commentAreaOffset(),
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.linear);
                              });
                              return false;
                            } else {
                              scrollController.animateTo(0,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.linear);
                              return false;
                            }
                          }
                          return true;
                        },
                        news: data,
                        cid: classId,
                        textId: "$id",
                        commentController: commentsController))
              ],
            ),
          ).tap(() {
            FocusScope.of(context).unfocus();
          });
  }

  Widget _recommendView() {
    return Container(
      color: Colours.scaffoldBg,
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "相关推荐",
              style: TextStyle(
                  color: Colours.text_color1,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ).marginSymmetric(horizontal: 16).marginOnly(top: 16),
            ...List.generate(
                recommendList.length,
                (index) => NewsListCell(
                      recommendList[index],
                      classId: classId,
                      inHome: false,
                      imgStyle: 2,
                      bottomDivider: index != recommendList.length - 1,
                      afterRoute: () => update(),
                    )),
            // ...recommendList.map((e) => NewsListCell(e,classId: classId,inHome: false,afterRoute: () => update(),))
          ],
        ),
      ),
    );
  }
}
