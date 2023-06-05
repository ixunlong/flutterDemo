import 'dart:async';
import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:sports/http/apis/comments.dart';
import 'package:sports/model/home/news_comment_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/home/comment/comment_input_widget.dart';
import 'package:sports/view/home/comment/news_comment_cell.dart';
import 'package:sports/widgets/no_data_widget.dart';
import 'package:sticky_headers/sticky_headers.dart';

class NewsCommentsSheet extends StatefulWidget {
  const NewsCommentsSheet({super.key,required this.comment,required this.newsId,this.reply = false});

  static show(BuildContext context,NewsCommentEntity comment,{required int newsId,bool reply = false,double topPaading = 0}) => showModalBottomSheet(
        context: context,
        clipBehavior: Clip.hardEdge,
        constraints: BoxConstraints.tightFor(width:MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height - topPaading),
        isScrollControlled: true,
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        backgroundColor: Colors.transparent, 
        builder: (context) => NewsCommentsSheet(comment: comment,newsId: newsId,reply: reply),);

  final NewsCommentEntity comment;
  final int newsId;
  final bool reply;

  @override
  State<NewsCommentsSheet> createState() => _NewsCommentsSheetState();
}

class _NewsCommentsSheetState extends State<NewsCommentsSheet> {

  int page = 1;
  List<NewsCommentEntity> comments = [];
  bool commentEnd = false;
  Map<int,bool> existMap = {};
  fetchComments() async {
    try {
      final p = page;
      final r = await NewsComments.list(widget.newsId,page: p,size: 20,originId: widget.comment.id);
      List rows = r.data['d']['rows'];
      final l = rows.map<NewsCommentEntity>((e) => NewsCommentEntity.fromJson(e)).toList();
      if (p != page) { return; }
      if (p == 1) { comments = []; }
      page += 1;
      commentEnd = l.isEmpty;
      l.removeWhere((element) {
        if (existMap[element.id ?? 0] ?? false) {
          return true;
        }
        existMap[element.id ?? 0] = true;
        return false;
      });
      comments.addAll(l);
      update();
    } catch (err) {

    }
  }

  NewsCommentEntity? _from;
  NewsCommentEntity get from => _from ?? widget.comment;
  final textEditingController = TextEditingController();
  final focusNode = FocusNode();

  FutureOr Function()? doReplyAction;

  @override
  initState() {
    fetchComments();
    super.initState();
    if (widget.reply) {
      Future.delayed(const Duration(milliseconds: 100)).then((value) => doReplyAction?.call());
    }
  }

  @override
  dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.75,
      initialChildSize: 1,
      snap: true,
      builder: (context, scrollController) {
        return EasyRefresh(
          onLoad: commentEnd ? null : () async {
            fetchComments();
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(13),topRight: Radius.circular(13))),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 44,
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xffeeeeee),width: 0.5)),
                      color: Colors.white,
                    ),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Utils.getImgPath("comment_close_big.png"),width: 25,height: 25).tap(() {
                          Get.back();
                        }),
                        if ((widget.comment.commentNum ?? 0) > 0)
                        Expanded(child: Text("${widget.comment.commentNum}条回复",style: const TextStyle(color: Colours.text_color1,fontSize: 16,fontWeight: FontWeight.w500),textAlign: TextAlign.center,).marginOnly(right: 25))
                    ],).paddingSymmetric(horizontal: 16),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      controller: scrollController,
                      children: [
                        Column(
                          children: [
                            NewsCommentCell(comment: widget.comment,newsId: widget.newsId,isTop: true),
                              // .paddingSymmetric(horizontal: 16),
                            const Divider(height: 0.5,color: Color(0xffeeeeee)),
                            Row(children: const [
                              Text("全部回复",style: TextStyle(fontWeight: FontWeight.w600,color: Colours.text_color1),)
                            ],).marginOnly(left: 0,right: 0,top: 16,bottom: 6),  
                          ],
                        ),
                        // ...List.generate(30, (index) => Text("$index").marginSymmetric(horizontal: 16,vertical: 12))
                        if (comments.isEmpty)
                        const NoDataWidget(tip: '还没有回复哦').sized(height: 250),
                        ...comments.map((e) => NewsCommentCell(comment: e,newsId:widget.newsId,reply: () {
                          _from = e;
                          update();
                          Future.delayed(const Duration(milliseconds: 100)).then((value) async {
                            await doReplyAction?.call();
                            _from = null;
                          });
                        },)),
                        if (commentEnd && comments.isNotEmpty)
                        Container(
                          alignment: Alignment.center,
                          child: const Text("已显示全部评论",style: TextStyle(color: Colours.grey99,fontSize: 12)).marginOnly(top: 30,bottom: 20))
                      ],
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: CommentInputWidget(
                      onInit: (doFocus) => doReplyAction = doFocus,
                      textEditingController: textEditingController,
                      textId: "${widget.newsId}-${widget.comment.id}-${from.id}",
                      focusNode: focusNode,
                      hintText: _from == null ? null : "@${from.userName}",
                      clickSnd: (text) async {
                      final value = await NewsComments.add(widget.newsId, text,originId: widget.comment.id,fromId: from.id);
                      if (value.data['c'] == 200) {
                        final n = NewsCommentEntity.fromJson(value.data['d']);
                        comments.insert(0, n);
                        textEditingController.text = "";
                        _from = null;
                        update(); 
                        return true;
                      }
                    }),
                  )
                ],
              ),
            ).tap(() {
              _from = null;
              update();
              FocusScope.of(context).unfocus();
            }),
          ),
        );
      },
    );
  }
}