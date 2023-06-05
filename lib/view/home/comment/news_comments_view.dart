import 'dart:async';
import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:sports/http/apis/comments.dart';
import 'package:sports/model/home/home_news_entity.dart';
import 'package:sports/model/home/news_comment_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/home/comment/news_comment_cell.dart';
import 'package:sports/view/home/comment/news_comments_sheet.dart';
import 'package:sports/widgets/no_data_widget.dart';

class NewsCommentsController {
  NewsCommentsController(this.id);

  final int id;
  int commentPage = 1;
  bool commentEnd = false;
  int commentSort = 1;
  int _commentsCount = 0;
  int get commentsCount => news?.commentNum ?? _commentsCount;
  List<NewsCommentEntity> _comments = [];
  List<NewsCommentEntity> get comments => _comments;
  Map<int,bool> existMap = {};
  HomeNewsEntity? news;
  updateNews(HomeNewsEntity? n) {
    news = n;
    update?.call(this);
  }

  FutureOr<bool> doSndComment(String comment) async {
    final r = await NewsComments.add(id, comment);
    if (r.data['c'] == 200) {
      final c = NewsCommentEntity.fromJson(r.data['d']);
      comments.insert(0, c);
      update?.call(this);
      return true;
    }
    return false;
  }

  Future fetchCommentds({bool refresh = false,int refreshAppend = 0}) async {
    try {
      final page = commentPage;
      final r = await NewsComments.list(id,type: commentSort,page: refresh ? 1 : page,size: 20);
      List<NewsCommentEntity> l = r.data['d']['rows'].map<NewsCommentEntity>((e) => NewsCommentEntity.fromJson(e)).toList();
      _commentsCount = r.data['d']['total'];
      if (refresh) {
        _comments = []; 
        existMap = {};
        commentPage = 2;
      } else {
        if (page != commentPage) { return; }
        if (page == 1) { _comments = []; existMap = {}; }
        commentPage += 1;
      }

      commentEnd = l.isEmpty;
      l.removeWhere((element) {
        if (existMap[element.id ?? 0] ?? false) {
          return true;
        }
        existMap[element.id ?? 0] = true;
        return false;
      });
      comments.addAll(l);
      
      update?.call(this);
    } catch (err) {
      log("message $err");
    }
  }

  void Function(NewsCommentsController)? update;

}

class NewsCommentsView extends StatefulWidget {

  const NewsCommentsView({super.key,required this.controller,this.showTop = true,this.paddingTop = 0});

  final NewsCommentsController controller;
  final bool showTop;
  final double paddingTop;

  @override
  State<NewsCommentsView> createState() => _NewsCommentsViewState();
}

class _NewsCommentsViewState extends State<NewsCommentsView> {
  NewsCommentsController get controller => widget.controller;
  int get id => controller.id;
  
  // bool commentEnd = false;
  int get commentSort => controller.commentSort;
  int get commentsCount => controller.commentsCount;
  List<NewsCommentEntity> get comments => controller.comments;

  @override
  void initState() {
    widget.controller.update = (c) {
      if (c != widget.controller) { return; }
      update();
    };
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NewsCommentsView oldWidget) {
    widget.controller.update = (c) {
      if (c != widget.controller) { return; }
      update();
    };
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colours.scaffoldBg,
      // padding: const EdgeInsets.only(top: 10),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
        child: Column(
          children: [
            if (widget.showTop)
            Row(children: [
              const Text("评论",style: TextStyle(fontSize: 16,color: Colours.text_color1,fontWeight: FontWeight.w500),),
              if (commentsCount > 0)
              Text("($commentsCount)",style: const TextStyle(fontSize: 12,color: Colours.grey66),).marginSymmetric(horizontal: 5),
              const Spacer(),
              Row(
                children: [
                  Image.asset(Utils.getImgPath("comment_sort.png"),width: 10,height: 10).marginOnly(right: 5),
                  Text( commentSort == 1 ? "按热度" : "按时间",style: const TextStyle(color: Colours.grey66,fontSize: 13),)
                ],
              ).sized(height: 30).tap(() {
                    controller.commentSort = commentSort == 1 ? 2 : 1;
                    controller.fetchCommentds(refresh: true);
              }),
            ],),
            if (comments.isEmpty)
            const NoDataWidget(tip: '还没有评论哦').sized(height: 250),
            ...comments.map((e) => NewsCommentCell(comment: e,newsId: id,reply: () {
              NewsCommentsSheet.show(context, e,newsId: id,reply: true,topPaading: widget.paddingTop);  
            }).tap(() {
                 NewsCommentsSheet.show(context, e,newsId: id,topPaading: widget.paddingTop);
            })),
            if (controller.commentEnd && controller.comments.isNotEmpty)
            const Text("已显示全部评论",style: TextStyle(color: Colours.grey99,fontSize: 12)).marginOnly(top: 30,bottom: 20)
          ],
        ),
      ),
    );
  }

}