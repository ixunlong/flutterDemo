import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:sports/model/home/home_news_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/local_read_history.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/home/news_view.dart';

class NewsListCell extends StatelessWidget {
  
  final HomeNewsEntity e;
  final int? classId;
  final bool inHome;
  final int? imgStyle;
  final void Function()? afterRoute;
  final bool bottomDivider;

  const NewsListCell(this.e, {super.key,this.classId,this.inHome = true,this.imgStyle,this.afterRoute,this.bottomDivider = true});

  @override
  Widget build(BuildContext context) {
    return _cell();
  }

  _cell() {
    // final c = _cell3(e);
    late Widget c;
    final style = imgStyle ?? e.imgStyle ?? 1;
    if (style == 1) {
      c = _cell1(e);
    } else if (style == 2) {
      c = _cell2(e);
    } else {
      c = _cell3(e);
    }

    return GestureDetector(
      onTap: () {

        int? classId = this.classId;
        if (e.imgStyle == 4) {
          Utils.onEvent("sypd_djzj", params: {"sypd_djzj": 1});
          Get.toNamed(Routes.homeVideoNews,
              arguments: e.id,
              parameters:{'classId': "$classId"}
            )?.then((value) {
              afterRoute?.call();
            });
        } else {
          Utils.onEvent("sypd_djzj", params: {"sypd_djzj": 0});
          // Get.to(NewsView(data: e));
          Get.toNamed(Routes.homenews,arguments: e.id,parameters: {'classId':"$classId"}, preventDuplicates: false)?.then((value) {
            afterRoute?.call();
          });
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          c.paddingSymmetric(horizontal: 16, vertical: 12),
          if (bottomDivider)
          const Divider(
            height: 0.5,
            color: Color(0xffeeeeee),
          ).paddingSymmetric(horizontal: 16)
        ],
      ),
    );
  }

  Widget _title(HomeNewsEntity e) {
    final readed = e.isRead == 1 ? true : LocalReadHistory.hasReadedNews("${e.id}");
    final color = readed ? Colours.grey_color1 : Colours.text_color1;
    return Text(
      e.title ?? "",
      style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.normal,
          color: color,
          height: 1.4),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.left,
    ).marginOnly(bottom: 8);
  }

  Widget _bottomRow(HomeNewsEntity e) {
    final l = [e.publicerName?.trim(), e.pv?.trim(), if(inHome)e.publicTime?.trim()];
    l.removeWhere((element) => element?.isEmpty ?? true);
    return DefaultTextStyle(
      maxLines: 1,
      style: const TextStyle(
          fontSize: 11, color: Colours.grey_color1, height: 1.4),
      child: Text.rich(TextSpan(children: [
        if ((e.top ?? 0) >= 1 && inHome)
          const TextSpan(
              text: "置顶  ", style: TextStyle(color: Colours.main_color)),
        ...l.map((e) => TextSpan(text: "$e  "))
      ])),
      // Row(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     // SizedBox(width: 100),
      //     if ((e.top ?? 0) >= 1)
      //     const Text("置顶",style: TextStyle(color: Colours.main_color)).marginOnly(right: 6),
      //     ...l.map((e) => Text(e!)
      //         .marginOnly(right: 6))
      //   ],
      // ),
    );
  }

  _cell1(HomeNewsEntity e) {
    return SizedBox(
      child: Row(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title(e),
              // Text(
              //     "${e.publicerName != null ? "${e.publicerName?.trim()}\u0020\u0020" : ""}"
              //     "${e.pv != null ? "${e.pv?.trim()}\u0020\u0020" : ""}"
              //     "${e.publicTime != null ? "${e.publicTime?.trim()}" : ""}",
              //     style:
              //         const TextStyle(fontSize: 11, color: Colours.grey_color1))
              _bottomRow(e)
            ],
          )),
        ],
      ),
    );
  }

  _cell2(HomeNewsEntity e) {
    return Container(
      height: 72,
      // padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _title(e)),
              // Text(
              //   "${e.publicerName != null ? "${e.publicerName?.trim()}\u0020\u0020" : ""}"
              //   "${e.pv != null ? "${e.pv?.trim()}\u0020\u0020" : ""}"
              //   "${e.publicTime != null ? "${e.publicTime?.trim()}" : ""}",
              //   style:
              //       const TextStyle(fontSize: 11, color: Colours.grey_color1),
              // ),
              _bottomRow(e)
            ],
          )),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
            clipBehavior: Clip.hardEdge,
            width: 116,
            height: 72,
            child: CachedNetworkImage(
              imageUrl: e.imgs ?? "",
              fit: BoxFit.cover,
              errorWidget: (context, url, error) =>
                  Container(color: Colors.white),
              placeholder: ((context, url) => Container(color: Colors.white)),
            ),
          ).marginOnly(left: 5),
        ],
      ),
    );
  }

  _cell3(HomeNewsEntity e) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(e),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.hardEdge,
          child: AspectRatio(
              aspectRatio: 686 / 292,
              child: CachedNetworkImage(
                  imageUrl: e.imgs ?? "",
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      Container(color: Colors.white),
                  placeholder: ((context, url) =>
                      Container(color: Colors.white)))),
        ),

        const SizedBox(height: 10),
        // Text(
        //   "${e.publicerName != null ? "${e.publicerName?.trim()}\u0020\u0020" : ""}"
        //   "${e.pv != null ? "${e.pv?.trim()}\u0020\u0020" : ""}"
        //   "${e.publicTime != null ? "${e.publicTime?.trim()}" : ""}",
        //   style: const TextStyle(fontSize: 11, color: Colours.grey_color1),
        // )
        _bottomRow(e)
      ],
    );
  }
}
