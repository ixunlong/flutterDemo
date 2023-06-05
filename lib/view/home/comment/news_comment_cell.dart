
import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:sports/http/apis/comments.dart';
import 'package:sports/model/home/news_comment_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/common_dialog.dart';

class NewsCommentCell extends StatefulWidget {
   NewsCommentCell({
    super.key,
    required this.comment,
    required this.newsId,
    this.isTop = false,
    this.reply});

  final NewsCommentEntity comment;
  final int newsId;

  final FutureOr Function()? reply;
  final bool isTop;

  @override
  State<NewsCommentCell> createState() => _NewsCommentCellState();
}

class _NewsCommentCellState extends State<NewsCommentCell> {

  String get name => widget.comment.userName ?? "";
  String get logo => widget.comment.userLogo ?? "";
  String get content => widget.comment.comment ?? "";
  String get addr => widget.comment.addr ?? "";
  String get time => widget.comment.createTime ?? "";
  bool get isUser => (widget.comment.isUser ?? 0) > 0;
  bool get isDeleted => widget.comment.isDeleted || [2,3].contains(widget.comment.verifyStatus ?? 0);
  String get likeNum => () {
    final num = widget.comment.likeNum ?? 0;
    if (num == 0) { return '赞'; }
    return Utils.numW(num);
  }.call();
  int get commentNum => widget.comment.commentNum ?? 0;
  bool get isLike => (widget.comment.isLike ?? 0) != 0;

  NewsCommentEntity get comment => widget.comment;
  bool hided = false;
  final xKey = GlobalKey();

  // ignore: prefer_function_declarations_over_variables
  late final FutureOr Function()? delete = () async {

    if (isUser) {
      final a = await Utils.alertQuery("确认删除评论吗?") ?? false;
      if ( !a ) { return; }
      final r = await NewsComments.delete(comment.id!);
      if (r.data['c'] == 200) {
        comment.isDeleted = true;
        update();
      }
    } else {
      
      final opts = ["淫秽色情","营销广告","网络暴力","违法信息","虚假谣言"];
      final s = await Utils.sheetSelect(opts) ?? -1;
      if (s < 0 || s >= opts.length) { return; }
      NewsComments.support(comment.id!, type: 2,comment: opts[s], newsId: widget.newsId).then((value) {
        // if (value.data['c'] == 200) {
        //   Get.dialog(CommonDialog.hint("举报成功"));
        // }
      });
    }

  };

  @override
  void didUpdateWidget(covariant NewsCommentCell oldWidget) {
    hided = widget.comment.isDeleted;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (hided) { return Container(); }
    // log('build comment cell');
    final widget = DefaultTextStyle(
      style:  const TextStyle(fontSize: 16,color: Colours.text_color1),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        color: Colors.white,
        // height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(shape: BoxShape.circle),
              clipBehavior: Clip.hardEdge,
              child: CachedNetworkImage(
                imageUrl: logo,
                placeholder: (ctx,ll) =>  Styles.placeholderIcon(),
                width: 32,height: 32).marginOnly(right: 4).tap(() { })),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _line1().tap(() { }),
                  if ((comment.fromComment?.isNotEmpty ?? false))
                  Container(
                    padding: EdgeInsets.all(8),
                    color: Color(0xFFF5F7FA),
                    child: Text("${comment.fromComment}",style: TextStyle(color: Colours.grey66),),
                  ).marginOnly(top: 13,bottom: 4),
                  Text(content,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: [2,3].contains(comment.verifyStatus ?? 0) ? Colours.grey99 : Colours.text_color1),
                    textAlign: TextAlign.left,).paddingSymmetric(horizontal: 4,vertical: 4),
                  const SizedBox(height: 5),
                  _line2()
                ],
              ),
            )
          ],
        ),
      ),
    );
    return !comment.isDeleted ? widget : 
      widget.animate(onComplete: (controller) {
        hided = true;
        update();
      },).slide(duration: 200.ms,begin: Offset.zero,end: const Offset(1, 0));
  }

  Widget _line1() => Row(
    children: [
      const SizedBox(width: 4,),
      Text(name,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 16,color: Colours.text_color1),),
      const Spacer(),
      // if (!isDeleted)
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(
            width: 14,height : 14,
            Utils.getImgPath("comment_zan1.png"),color: isLike ? Colours.main : null,).marginSymmetric(horizontal: 3),
          Text(likeNum,style: TextStyle(fontSize: 13,color: isLike ? Colours.main : Colours.text_color1),)],
      ).sized(width: 60,height: 30).tap(() {
        if (isDeleted) { return;  }
        
        final e = widget.comment;
        final type = e.isLike == 0 ? 1 : 3;
        NewsComments.support(e.id!, type: type, newsId: widget.newsId).then((value) {
          if (value.data['c'] == 200) {
            e.likeNum = (e.likeNum ?? 0) + (type == 1 ? 1 : -1);
            e.isLike = type == 1 ? 1 : 0;
            if (e.isLike == 1) {
              ToastUtils.show("点赞成功");
            } else {
              ToastUtils.show("已取消点赞");
            }
            update();
          }
        });
      })
    ]
  );

  Widget _line2() => DefaultTextStyle(
    style: const TextStyle(
      color: Colours.grey99,
      fontSize: 12
    ),
    child: Row(
      children: [
        if (!widget.isTop)
        _replyBtn().marginOnly(right: 8),
        Text("$time • $addr"),
        const Spacer(),
        if (isUser && !widget.isTop && !isDeleted)
        const Text("删除").tap(delete),
        if (!isUser && !widget.isTop)
        Container(
          key: xKey,
          alignment: Alignment.centerRight,
          width: 50,
          height: 20,
          child: Image.asset(Utils.getImgPath("comment_close.png"),width: 10,height: 10),
        ).tap( delete ),

      ],
    ),
  );

  Widget _replyBtn() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    height: 24,
    decoration: BoxDecoration(
      color: Colours.greyF2,
      borderRadius: BorderRadius.circular(12)
    ),
    child: DefaultTextStyle(
      style: const TextStyle(color: Colours.text_color1,fontSize: 12,height: 1.3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (commentNum > 0)
          Text(Utils.numLimit(commentNum)),
          const Text("回复"),
          if (commentNum == 0)
          const Icon(Icons.arrow_forward_ios_rounded,size: 9,color: Colours.grey66,)
        ],
      ),
    ),
  ).tap(widget.reply);
}