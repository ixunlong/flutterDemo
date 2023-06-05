import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:sports/http/apis/comments.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/model/home/home_news_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/home/comment/news_comments_view.dart';
import 'package:sports/view/home/comment/news_share_sheet.dart';
import 'package:sports/widgets/app_news_float2_widget.dart';
import 'package:sports/widgets/common_dialog.dart';
import 'package:sports/widgets/right_arrow_widget.dart';

class CommentInputSheet extends StatefulWidget {
  const CommentInputSheet({super.key,
    required this.focusNode,
    required this.textEditingController,
    required this.textId,
    required this.hintText,
    required this.sndAction,
  });

  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final String textId;
  final String hintText;
  final void Function(String text) sndAction;

  @override
  State<CommentInputSheet> createState() => _CommentInputSheetState();
}

class _CommentInputSheetState extends State<CommentInputSheet> {

  doSndText() {
    Get.back();
    widget.sndAction.call(widget.textEditingController.text);
  }

  @override
  void initState() {
    super.initState();
    Get.find<ConfigService>().tipEnable = false;
    widget.textEditingController.text = CommentInputWidget.storedTexts[widget.textId] ?? "";
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      widget.focusNode.requestFocus();
      update();
    });
  }

  @override
  void dispose() {
    Get.find<ConfigService>().tipEnable = true;
    CommentInputWidget.storedTexts[widget.textId] = widget.textEditingController.text;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      backgroundColor: Colors.transparent,
      enableDrag: false,
      onClosing: () {
        
    }, builder: (context) {
      return Column(children: [
        Expanded(child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Get.back(),
          onPanStart: (details) => Get.back(),
        )),
        content
      ],);
    },);
  }

  Widget get content => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: const BoxDecoration(
          color: Colors.white,
          border:Border(top: BorderSide(color: Color(0xffeeeeee), width: 0.5))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: _inputWidget()),
            _sndButton()
          ],
        ),
      );

  Widget _sndButton() => () {
    final dosnd = widget.textEditingController.text.isNotEmpty; 
    return Text(dosnd ? '发送' : '发布',
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: dosnd ? Colours.main : Colours.grey99))
          .paddingOnly(left: 10, bottom: 6, top: 6)
          .tap(() {
            doSndText();
    });
  }.call();

  Widget _inputWidget() => Container(
    decoration: BoxDecoration(
      color: const Color(0xFFF2F2F2),
      borderRadius: BorderRadius.circular(6)
    ),
    child: CupertinoTextField(
      maxLines: 4,
      minLines: 1,
      controller: widget.textEditingController,
      focusNode: widget.focusNode,
      maxLength: 200,
      onChanged: (value) {
        update();
        if (value.characters.length == 200) {
          ToastUtils.show("评论最多输入200字");
        }
      },
      cursorColor: Colours.main,
      textInputAction: TextInputAction.send,
      prefix: Image.asset(Utils.getImgPath("comment_pencil.png")).marginOnly(left: 12),
      prefixMode: OverlayVisibilityMode.never,
      placeholder: widget.hintText,
      placeholderStyle: const TextStyle(fontSize: 14,color: Colours.grey99),
      onSubmitted: (value) {
        doSndText();
      },
      decoration: const BoxDecoration(
        color: Colors.transparent
      ),
    ),
  );
}

class CommentInputWidget extends StatefulWidget {
  const CommentInputWidget(
      {super.key,
      this.clickSnd,
      this.textEditingController,
      this.focusNode,
      this.news,
      this.cid,
      this.hintText,
      this.commentNum,
      required this.textId,
      this.commentController,
      this.onInit,
      this.canInput,
      this.numberBtn = true,
      this.afterShare});

  final NewsCommentsController? commentController;
  final FutureOr<bool?> Function(String text)? clickSnd;
  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  // final bool inNewsPage;
  final HomeNewsEntity? news;
  final int? cid;
  final String? hintText;
  final String textId;
  final int? commentNum;
  final bool Function(bool isbtn)? canInput;
  final bool numberBtn;
  final void Function()? afterShare;

  final void Function(FutureOr Function() doFocus)? onInit;

  static Map<String, String> storedTexts = {};

  @override
  State<CommentInputWidget> createState() => _CommentInputWidgetState();
}

class _CommentInputWidgetState extends State<CommentInputWidget> {
  final _tec = TextEditingController();
  final _focus = FocusNode();
  TextEditingController get tec => widget.textEditingController ?? _tec;
  FocusNode get focus => widget.focusNode ?? _focus;
  bool editing = false;
  bool get isLike => widget.news?.isLike == 1;
  int? get commentNum => widget.commentNum ?? widget.news?.commentNum;

  @override
  void initState() {
    super.initState();
    widget.onInit?.call(() async {
      await toInput(false);
    });
  }

  @override
  void dispose() {
    _tec.dispose();
    _focus.dispose();
    super.dispose();
  }

  _doSndAction() async {
    User.needLogin(() async {
      if (focus.hasFocus) {
        focus.unfocus();
        final text = tec.text.trim();
        if (text.isEmpty) {
          return;
        }
        final r = await widget.clickSnd?.call(text) ??
            await widget.commentController?.doSndComment(text) ??
            false;
        if (r) {
          tec.text = "";
          CommentInputWidget.storedTexts[widget.textId] = "";
        }
      } else {
        focus.requestFocus();
      }
    });
  }
  
  bool inputing = false;
  toInput(bool isbtn) async {
    if (inputing) { return; }
    if (!(widget.canInput?.call(isbtn) ?? true)) {
      return;
    }
    inputing = true;
    update();
    await Get.bottomSheet(
      CommentInputSheet(
        focusNode: focus, 
        textEditingController: tec,
        textId: widget.textId,
        hintText: widget.hintText ?? "友善评论",
        sndAction: (text) {
          focus.unfocus();
          _doSndAction();
        },),
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      enableDrag: false
    );
    inputing = false;
    update();
  } 

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      height: 44,
      decoration: const BoxDecoration(
          border:
              Border(top: BorderSide(color: Color(0xffeeeeee), width: 0.5))),
      child: Row(
        crossAxisAlignment: (!editing && widget.news != null)
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.end,
        children: [
          Expanded(child: _inputWidget()),
          if (!editing && widget.news != null) _btns(),
          if (editing || widget.news == null) _sndButton()
        ],
      ),
    );
  }

  Widget _btns() => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.numberBtn)
          Image.asset(Utils.getImgPath("comment_num.png"),width: 22, height: 22)
              .badge((commentNum ?? 0) == 0 ? null : Utils.numLimit(commentNum ?? 0),border: true)
              .tap(() {
            toInput(true);
          }).marginOnly(left: 30),
          const SizedBox(width: 30),
          Image.asset(Utils.getImgPath("comment_zan_big1.png"),width: 22, height: 22, color: isLike ? Colours.main : null)
              .tap(() {
            if (isLike) {
              NewsComments.newsSupport(widget.news?.id ?? 0, type: 4)
                  .then((value) {
                if (value.data['c'] == 200) {
                  widget.news?.isLike = 0;
                  ToastUtils.show("已取消点赞");
                  update();
                }
              });
            } else {
              NewsComments.newsSupport(widget.news?.id ?? 0, type: 2).then((value) {
                if (value.data['c'] == 200) {
                  widget.news?.isLike = 1;
                  ToastUtils.show("点赞成功");
                  update();
                }
              });
            }
          }),
          if (widget.news?.h5url?.isNotEmpty ?? false)
          Image.asset(Utils.getImgPath("comment_share.png"),width: 22, height: 22)
              .tap(() {
                final news = widget.news;
                final classId = widget.cid;
                if (news == null) {
                  return;
                }
                Get.bottomSheet(NewsShareBottomSheet(news: news, classId: classId)).then((value) {
                  widget.afterShare?.call();
                });
          }).marginOnly(left: 30),
        ],
      ).sized(height: 44);

  Widget _sndButton() =>  const Text(
      '发布',
      style: TextStyle( fontWeight: FontWeight.w500, color: Colours.grey99))
    .paddingOnly(left: 10, bottom: 6, top: 6)
    .tap(() { toInput(false); });
  

  Widget _inputWidget() => Container(
    decoration: BoxDecoration(
      color: const Color(0xFFF2F2F2),
      borderRadius: editing ? BorderRadius.circular(6) : BorderRadius.circular(30)
    ),
    height: 32,
    child: CupertinoTextField(
      onTap: () => toInput(false),
      readOnly: true,
      prefix: Image.asset(Utils.getImgPath("comment_pencil.png")).marginOnly(left: 12),
      prefixMode: OverlayVisibilityMode.notEditing,
      placeholder: "友善评论",
      placeholderStyle: const TextStyle(fontSize: 14,color: Colours.grey99),
      decoration: const BoxDecoration(
        color: Colors.transparent
      ),
    ),
  );
}
