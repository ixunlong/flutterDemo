import 'dart:async';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/model/home/lbt_entiry.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/my/web_game_page.dart';
import 'package:sports/widgets/common_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GameEntryWidget extends StatefulWidget {
  const GameEntryWidget({super.key, required this.lbts,this.scroll = true,this.carouselController});

  final List<LbtEntity> lbts;
  final bool scroll;
  final CarouselController? carouselController;

  @override
  State<GameEntryWidget> createState() => _GameEntryWidgetState();
}

class _GameEntryWidgetState extends State<GameEntryWidget> {
  double page = 0;
  late Timer t;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _gameCell();
  }

  Widget _gameCell() {
    final lbts = widget.lbts;
    final double indWidth = (12 * lbts.length).toDouble();
    return Container(
      height: 91,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Expanded(child: LayoutBuilder(builder: (context, p1) {
            return CarouselSlider(
              carouselController: widget.carouselController,
              options: CarouselOptions(
                viewportFraction: 1,
                autoPlay: widget.scroll,
                aspectRatio: p1.maxWidth / p1.maxHeight,
                // enlargeCenterPage: true,
                // autoPlayInterval: const Duration(seconds: 4),
                onScrolled: (value) {
                  page = (value ?? 0) % lbts.length;
                  update();
                },
              ),
              items: [...lbts.map((e) => _gameEntryBtn(e))],
            );
          })),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 4),
            child: Container(
              width: indWidth,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: Colours.greyF2,
                  borderRadius: BorderRadius.circular(2)),
              child: Row(
                children: [
                  SizedBox(width: page * indWidth / widget.lbts.length),
                  Container(
                      decoration: BoxDecoration(
                          color: Colours.main,
                          borderRadius: BorderRadius.circular(8)),
                      width: 12,
                      height: 4),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _gameEntryBtn(LbtEntity lbt) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
            clipBehavior: Clip.hardEdge,
            child: CachedNetworkImage(
              imageUrl: lbt.imgUrl ?? "",
              errorWidget: (context, url, error) => Container(
                color: const Color(0xFFD9D9D9),
              ),
              placeholder: (context, url) => Container(
                color: const Color(0xFFD9D9D9),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(lbt.button ?? "",
                  style:
                      const TextStyle(fontSize: 16, color: Colours.text_color1),
                  maxLines: 1),
              const SizedBox(
                height: 2,
              ),
              Text(lbt.content ?? "",
                  style: const TextStyle(fontSize: 12, color: Colours.grey99),
                  maxLines: 1)
            ],
          )),
          const SizedBox(
            width: 5,
          ),
          CommonButton(
            onPressed: () {
              // Utils.doRoute(lbt.href ?? "");
              // Get.to(WebGamePage(), arguments: lbt.href ?? '');
              launchUrl(Uri.parse(lbt.href ?? ""),
                  mode: LaunchMode.externalApplication);
            },
            text: "进入",
            textStyle:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            foregroundColor: Colors.white,
            backgroundColor: Colours.main_color,
            minWidth: 56,
            minHeight: 24,
          )
        ],
      ),
    );
  }
}
