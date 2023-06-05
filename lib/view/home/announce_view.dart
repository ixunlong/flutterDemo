import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sports/logic/service/um_service.dart';
import 'package:sports/model/home/lbt_entiry.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/right_arrow_widget.dart';
import 'package:get/get.dart';

import '../../res/colours.dart';

class AnnounceView extends StatefulWidget {
  const AnnounceView({super.key, required this.announces, this.click});

  final List<LbtEntity> announces;

  final void Function(LbtEntity)? click;

  @override
  State<AnnounceView> createState() => _AnnounceViewState();
}

class _AnnounceViewState extends State<AnnounceView> {
  List<LbtEntity> get announces => widget.announces;

  int page = 0;

  @override
  Widget build(BuildContext context) {
    return widget.announces.length == 0
        ? Container()
        : Container(
            height: 32,
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colours.greyDB3F,
                  offset: Offset(0, 1.0),
                  blurRadius: 1.0,
                  spreadRadius: 1.0),
            ]),
            child: Row(
              children: [
                Image.asset(Utils.getImgPath("home_gb.png"),
                    width: 14, height: 14),
                SizedBox(width: 10),
                Expanded(child: _car())
              ],
            ),
          );
  }

  Widget _car() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 30,
        scrollPhysics: const NeverScrollableScrollPhysics(),
        viewportFraction: 1,
        scrollDirection: Axis.vertical,
        enableInfiniteScroll: announces.length <= 1 ? false : true,
        autoPlay: announces.length <= 1 ? false : true,
        onPageChanged: (index, reason) {
          page = index;
          update();
        },
        onScrolled: (value) {},
      ),
      items: [
        ...List.generate(announces.length, (i) {
          final lbt = announces[i];
          return GestureDetector(
              onTap: () {
                // log("click annouce href = ${lbt.href}");
                Utils.onEvent('sypd_gg', params: {'sypd_gg': '${i + 1}'});
                Get.find<UmService>().payOriginRoute = 'gc${i + 1}';
                widget.click?.call(lbt);
              },
              child: Row(
                children: [
                  Expanded(
                    child: Text(lbt.title ?? "",
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(width: 10),
                  (lbt.href?.isEmpty ?? true)
                      ? Container()
                      : Image.asset(Utils.getImgPath("arrow_right.png"))
                ],
              ));
        })
        // for (int i = 0; i < lbts.length; i++)
      ],
    );
  }
}
