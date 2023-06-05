import 'dart:developer';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sports/model/home/home_news_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:get/get.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/local_read_history.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/home/home_video_news_page.dart';
import 'package:sports/view/home/news_list_cell.dart';
import 'package:sports/view/home/news_view.dart';

class NewsListView extends StatefulWidget {
  const NewsListView(
      {super.key, required this.data, this.maxHeight, required this.classId});
  final List<HomeNewsEntity> data;

  final double? maxHeight;
  final int classId;

  @override
  State<NewsListView> createState() => _NewsListViewState();
}

class _NewsListViewState extends State<NewsListView>
    with AutomaticKeepAliveClientMixin {
  List<HomeNewsEntity> get wdata => widget.data;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    List<HomeNewsEntity> data = [];
    Map<int, HomeNewsEntity> maps = {};

    for (HomeNewsEntity element in wdata) {
      final id = element.id ?? 0;
      if (maps[id] == null) {
        data.add(element);
      }
      maps[id] = element;
    }
    // List<HomeNewsEntity> data = List.from(wdata);

    final count = data.length > 0 ? data.length : 0;
    // log("build news list = ${data.map((e) => e.toJson())}");
    if (data.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Image.asset(
            Utils.getImgPath("nodata.png"),
            width: 200,
            height: 200,
          ),
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate((content, index) {
        return NewsListCell(data[index],inHome: true,classId: widget.classId,afterRoute: () => update());
        // return GestureDetector(
        //   onTap: () {
        //     if (data[index].imgStyle == 4) {
        //       Utils.onEvent("sypd_djzj",params: {"sypd_djzj":1});
        //       Get.toNamed(Routes.homeVideoNews,
        //           arguments: data[index].id,
        //           parameters: {'classId': widget.classId.toString()});
        //     } else {
        //       Utils.onEvent("sypd_djzj",params: {"sypd_djzj":0});
        //       // Get.to(NewsView(data: data[index]))?.then((value) => update());
        //       Get.toNamed(Routes.homenews,arguments: data[index].id ,parameters: {'classId':'${widget.classId}'})?.then((value) => update());
        //     }
        //   },
        //   behavior: HitTestBehavior.opaque,
        //   child: _cell(data[index]),
        // );
      }, childCount: count),
    );
  }

  // _cell(HomeNewsEntity e) {
  //   // final c = _cell3(e);
  //   late Widget c;
  //   final style = e.imgStyle ?? 1;
  //   if (style == 1) {
  //     c = _cell1(e);
  //   } else if (style == 2) {
  //     c = _cell2(e);
  //   } else {
  //     c = _cell3(e);
  //   }

  //   return Column(
  //     children: [
  //       c.paddingSymmetric(horizontal: 16, vertical: 12),
  //       const Divider(
  //         height: 0.5,
  //         color: Color(0xffeeeeee),
  //       ).paddingSymmetric(horizontal: 16)
  //     ],
  //   );
  // }

  // Widget _title(HomeNewsEntity e) {
  //   final readed = LocalReadHistory.hasReadedNews("${e.id}");
  //   final color = readed ? Colours.grey_color1 : Colours.text_color1;
  //   return Text(
  //     e.title ?? "",
  //     style: TextStyle(
  //         fontSize: 17,
  //         fontWeight: FontWeight.normal,
  //         color: color,
  //         height: 1.4),
  //     maxLines: 2,
  //     overflow: TextOverflow.ellipsis,
  //     textAlign: TextAlign.left,
  //   ).marginOnly(bottom: 8);
  // }

  // Widget _bottomRow(HomeNewsEntity e) {
  //   final l = [e.publicerName?.trim(), e.pv?.trim(), e.publicTime?.trim()];
  //   l.removeWhere((element) => element?.isEmpty ?? true);
  //   return DefaultTextStyle(
  //     maxLines: 1,
  //     style: const TextStyle(
  //         fontSize: 11, color: Colours.grey_color1, height: 1.4),
  //     child: Text.rich(TextSpan(children: [
  //       if ((e.top ?? 0) >= 1)
  //         const TextSpan(
  //             text: "置顶  ", style: TextStyle(color: Colours.main_color)),
  //       ...l.map((e) => TextSpan(text: "$e  "))
  //     ])),
  //     // Row(
  //     //   crossAxisAlignment: CrossAxisAlignment.center,
  //     //   children: [
  //     //     // SizedBox(width: 100),
  //     //     if ((e.top ?? 0) >= 1)
  //     //     const Text("置顶",style: TextStyle(color: Colours.main_color)).marginOnly(right: 6),
  //     //     ...l.map((e) => Text(e!)
  //     //         .marginOnly(right: 6))
  //     //   ],
  //     // ),
  //   );
  // }

  // _cell1(HomeNewsEntity e) {
  //   return SizedBox(
  //     child: Row(
  //       children: [
  //         Expanded(
  //             child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             _title(e),
  //             // Text(
  //             //     "${e.publicerName != null ? "${e.publicerName?.trim()}\u0020\u0020" : ""}"
  //             //     "${e.pv != null ? "${e.pv?.trim()}\u0020\u0020" : ""}"
  //             //     "${e.publicTime != null ? "${e.publicTime?.trim()}" : ""}",
  //             //     style:
  //             //         const TextStyle(fontSize: 11, color: Colours.grey_color1))
  //             _bottomRow(e)
  //           ],
  //         )),
  //       ],
  //     ),
  //   );
  // }

  // _cell2(HomeNewsEntity e) {
  //   return Container(
  //     height: 72,
  //     // padding: EdgeInsets.symmetric(vertical: 12),
  //     child: Row(
  //       children: [
  //         Expanded(
  //             child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Expanded(child: _title(e)),
  //             // Text(
  //             //   "${e.publicerName != null ? "${e.publicerName?.trim()}\u0020\u0020" : ""}"
  //             //   "${e.pv != null ? "${e.pv?.trim()}\u0020\u0020" : ""}"
  //             //   "${e.publicTime != null ? "${e.publicTime?.trim()}" : ""}",
  //             //   style:
  //             //       const TextStyle(fontSize: 11, color: Colours.grey_color1),
  //             // ),
  //             _bottomRow(e)
  //           ],
  //         )),
  //         Container(
  //           decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
  //           clipBehavior: Clip.hardEdge,
  //           width: 116,
  //           height: 72,
  //           child: CachedNetworkImage(
  //             imageUrl: e.imgs ?? "",
  //             fit: BoxFit.cover,
  //             errorWidget: (context, url, error) =>
  //                 Container(color: Colors.white),
  //             placeholder: ((context, url) => Container(color: Colors.white)),
  //           ),
  //         ).marginOnly(left: 5),
  //       ],
  //     ),
  //   );
  // }

  // _cell3(HomeNewsEntity e) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _title(e),
  //       Container(
  //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
  //         clipBehavior: Clip.hardEdge,
  //         child: AspectRatio(
  //             aspectRatio: 686 / 292,
  //             child: CachedNetworkImage(
  //                 imageUrl: e.imgs ?? "",
  //                 fit: BoxFit.cover,
  //                 errorWidget: (context, url, error) =>
  //                     Container(color: Colors.white),
  //                 placeholder: ((context, url) =>
  //                     Container(color: Colors.white)))),
  //       ),

  //       const SizedBox(height: 10),
  //       // Text(
  //       //   "${e.publicerName != null ? "${e.publicerName?.trim()}\u0020\u0020" : ""}"
  //       //   "${e.pv != null ? "${e.pv?.trim()}\u0020\u0020" : ""}"
  //       //   "${e.publicTime != null ? "${e.publicTime?.trim()}" : ""}",
  //       //   style: const TextStyle(fontSize: 11, color: Colours.grey_color1),
  //       // )
  //       _bottomRow(e)
  //     ],
  //   );
  // }
}
