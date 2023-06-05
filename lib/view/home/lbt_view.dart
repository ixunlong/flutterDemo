import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:sports/logic/service/um_service.dart';
import 'package:sports/model/home/lbt_entiry.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sports/util/utils.dart';

class LbtView extends StatefulWidget {
  const LbtView({super.key, required this.lbts});

  final List<LbtEntity> lbts;

  @override
  State<LbtView> createState() => _LbtViewState();
}

class _LbtViewState extends State<LbtView> {
  List<LbtEntity> get lbts => widget.lbts;

  int page = 0;

  LbtEntity get current => lbts[page];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 686 / 292,
            viewportFraction: 1,
            enableInfiniteScroll: lbts.length <= 1 ? false : true,
            autoPlay: lbts.length <= 1 ? false : true,
            onPageChanged: (index, reason) {
              page = index;
              update();
            },
            onScrolled: (value) {},
          ),
          items: [
            ...List.generate(lbts.length, (i) {
              // log("${lbts.map((e) => e.toJson())}");
              final lbt = lbts[i];
              final titleEmpty = lbt.title?.trim().isEmpty ?? true;
              return GestureDetector(
                onTap: () {
                  // Utils.alertQuery("click 轮播图 ${i} ${lbt.title}");
                  Utils.onEvent('sypd_lbt', params: {'sypd_lbt': '${i + 1}'});
                  Get.find<UmService>().payOriginRoute = 'lbt${i + 1}';
                  lbt.doJump();
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  clipBehavior: Clip.hardEdge,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  // color: Colors.red,
                  child: CachedNetworkImage(
                    imageUrl: lbts[i].imgUrl ?? "",
                    imageBuilder: (context, imageProvider) => 
                        makeContent(lbt, i, imageProvider, titleEmpty),
                    errorWidget: (context, url, error) =>
                        makeContent(lbt, i, null, titleEmpty),
                    placeholder: ((context, url) =>
                        makeContent(lbt, i, null, titleEmpty)),
                  ),
                ),
              );
            })
            // for (int i = 0; i < lbts.length; i++)
          ],
        ),
        // Positioned(
        //     bottom: 8,
        //     right: 20,
        //     left: 8,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         ...lbts.map((e) => AnimatedContainer(
        //             duration: Duration(milliseconds: 100),
        //             width: current == e ? 6 : 6,
        //             height: 6,
        //             margin: EdgeInsets.symmetric(horizontal: 4),
        //             decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(3),
        //                 color: current == e
        //                     ? Colors.white
        //                     : Colors.white.withAlpha(0x80))))
        //       ],
        //     ))
      ],
    );
  }

  Widget makeContent(LbtEntity lbt,int i,ImageProvider<Object>? imageProvider,bool titleEmpty) {
    return Container(
                      // padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                      decoration: BoxDecoration(
                        image: imageProvider != null ? DecorationImage(
                            image: imageProvider, fit: BoxFit.cover) : null,
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 12, right: 6, top: 8, bottom: 8),
                        decoration: BoxDecoration(
                            gradient: titleEmpty ? null : LinearGradient(
                                colors: [
                              Colors.black.withAlpha((0xff * 0.8).toInt()),
                              Colors.black.withAlpha((0xff * 0.5).toInt()),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent
                            ],
                            // stops: [0.2,0.5],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                lbt.title ?? "",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 17,height: 1.2),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      bottomRight: Radius.circular(4)),
                                  color: Colors.black.withAlpha(0x80),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 0),
                                child: Row(
                                  children: [
                                    Text(
                                      "${i + 1}",
                                      style: const TextStyle(
                                          color: Color(0xffdddddd),
                                          fontSize: 12),
                                    ),
                                    Text(
                                      "/${lbts.length}",
                                      style: const TextStyle(
                                          color: Color(0xff999999),
                                          fontSize: 12),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
                    );
  }
}
