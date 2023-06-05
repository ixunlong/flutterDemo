import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sports/model/expert/plan_Info_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/utils.dart';

const _grey99 = Color(0xff999999);
const _grey66 = Color(0xff666666);
const _greyEE = Color(0xffeeeeee);
const _textBlack = Color(0xff292d32);
const _textGrey = Color(0xffcccccc);
const _bgGrey = Color(0xfff2f2f2);
const _red1 = Color(0xFFF53F3F);

class ExpertInfoView{
  const ExpertInfoView({this.planInfo,this.toFocus,this.toDetail});

  final PlanInfoEntity? planInfo;
  final void Function()? toFocus;
  final void Function()? toDetail;
  
  bool get focus => (planInfo?.isFocus ?? 0) > 0;

  Widget _expertScore() => Row(
    children: [
      if (planInfo?.firstTag?.isNotEmpty ?? false)
        Container(
            height: 15,
            padding: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
                color: Color(0xFFFFF2F2),
                border: Border.all(color: Color(0xFFF53F3F), width: 0.5),
                borderRadius: BorderRadius.circular(8)),
            child: Text(
              planInfo?.firstTag ?? "",
              style: TextStyle(
                  fontSize: 10, color: Color(0xFFF53F3F), height: 1.4),
            )).marginOnly(right: 6),
      if (planInfo?.secondTag?.isNotEmpty ?? false)
        Container(
            height: 15,
            padding: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
                color: Color(0xFFFFEFE5),
                border: Border.all(color: Color(0xFFFF6E1D), width: 0.5),
                borderRadius: BorderRadius.circular(8)),
            child: Text(
              planInfo?.secondTag ?? "",
              style: TextStyle(
                  fontSize: 10, color: Color(0xFFFF6E1D), height: 1.4),
            )),
    ],
  );

  _expertName() => Text(
        planInfo?.expertName ?? "",
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF292D32)),
      ).tap(() {
        toDetail?.call();
      });

  _expertFocusBtn() => OutlinedButton(
      onPressed: toFocus,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(56, 24),
        fixedSize: Size(56, 24),
        maximumSize: Size(56, 24),
        elevation: 0,
        padding: EdgeInsets.zero,
        foregroundColor: focus ? _grey99 : Colors.white,
        backgroundColor: focus ? _greyEE : Colours.main_color,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        focus ? "已关注" : "关注",
        style: const TextStyle(height: 1.4, fontSize: 13),
      ));
  // CommonButton(
  //   onPressed: clickToFocus,
  //   text: focus ? "已关注" : "关注",
  //   minHeight: 24,
  //   minWidth: 56,
  //   textStyle: TextStyle(fontSize: 13,fontWeight: FontWeight.w400),
  //   foregroundColor: focus ? _grey99 : Colors.white,
  //   backgroundColor: focus ? _greyEE : Colours.main_color,
  // );

  _expertHead({double size = 40}) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: CachedNetworkImage(
          fit: BoxFit.cover,
          width: size,
          height: size,
          imageUrl: planInfo?.expertLogo ?? "",
          placeholder: (context, url) => Container(),
          errorWidget: (context, url, error) => Container()),
    ).tap(() {
      toDetail?.call();
    });
  }

  expertBar() {
    return Container(
      child: Row(
        children: [
          _expertHead(size: 30),
          const SizedBox(width: 16),
          _expertName(),
          Spacer(),
          _expertFocusBtn(),
          SizedBox(width: 16)
        ],
      ),
    );
  }

  Widget expertRow({GlobalKey? key}) {
    return Container(
      key: key,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: planInfo == null
          ? null
          : Row(
              children: [
                _expertHead(),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_expertName(), _expertScore().marginOnly(top: 2)],
                ),
                const Spacer(),
                _expertFocusBtn()
              ],
            ),
    );
  }

  
}