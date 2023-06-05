import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/loading_check_widget.dart';
import 'package:sports/widgets/score_prediction_widget.dart';

import '../../../logic/match/soccer_match_intelligence_controller.dart';
import '../../../res/colours.dart';
import '../../../widgets/common_button.dart';

class SoccerMatchInfoView extends StatefulWidget {
  const SoccerMatchInfoView({super.key});

  @override
  State<SoccerMatchInfoView> createState() => _SoccerMatchInfoViewState();
}

class _SoccerMatchInfoViewState extends State<SoccerMatchInfoView>
    with AutomaticKeepAliveClientMixin {
  final tag = DateTime.now().formatedString("HH:mm:ss");
  late SoccerMatchIntelligenceController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.put(SoccerMatchIntelligenceController(), tag: tag);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<SoccerMatchIntelligenceController>(
        tag: tag,
        builder: (controller) {
          return LoadingCheckWidget<int>(
            isLoading: false,
            data:
                controller.data?.toJson().values.map((e) => e).toList().join(),
            child: Container(
              color: Colours.greyF5F5F5,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    block<String>(
                            data: (controller.data?.homeNews ?? "") +
                                (controller.data?.guestNews ?? "") +
                                (controller.data?.matchData ?? "") +
                                (controller.data?.matchForecast ?? ""),
                            child: gen())
                        .paddingOnly(top: 10),
                    LoadingCheckWidget<String>(
                      isLoading: false,
                      data: (controller.data?.homeScore ?? "") +
                          (controller.data?.guestScore ?? ""),
                      noData: Container(),
                      child: ScorePredictionWidget(
                              homeLogo: controller.detail?.homeLogo ?? "",
                              homeName: controller.detail?.homeName ?? "",
                              guestLogo: controller.detail?.guestLogo ?? "",
                              guestName: controller.detail?.guestName ?? "",
                              homeScore: controller.data?.homeScore ?? "",
                              guestScore: controller.data?.guestScore ?? "")
                          .paddingOnly(left: 12, right: 12, bottom: 10),
                    ),
                    block<String>(
                        data: (controller.data?.homeAnalysis ?? "") +
                            (controller.data?.guestAnalysis ?? ""),
                        child: strength()),
                    block<String>(
                        data: (controller.data?.homeInjury ?? "") +
                            (controller.data?.guestInjury ?? ""),
                        child: suspend()),
                    block<int>(
                        data: controller.totalLength, child: _intelligence()),
                    block<String>(
                        data: (controller.data?.confident ?? "") +
                            (controller.data?.vsInfo ?? ""),
                        child: _favorSuggest()),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget block<T>({required T data, required Widget child}) {
    return LoadingCheckWidget<T>(
      isLoading: false,
      data: data,
      noData: Container(),
      child: Container(
        decoration: BoxDecoration(
            color: Colours.white, borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        margin: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
        child: child,
      ),
    );
  }

  Widget _favorSuggest() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("心水推荐", style: Styles.mediumText(fontSize: 16)),
        Container(height: 16),
        controller.data?.confident != ""
            ? Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _dot(),
                      Container(width: 3),
                      Text(controller.data?.confident ?? "",
                          style: const TextStyle(
                              fontSize: 15,
                              height: 1.4,
                              color: Color(0xFF444444))),
                      RatingBar(
                          initialRating:
                              controller.data?.stars?.toDouble() ?? 0,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 16,
                          ignoreGestures: true,
                          unratedColor: Colours.grey_color1,
                          ratingWidget: RatingWidget(
                              full: const Icon(Icons.star_rounded,
                                  color: Colours.yellow_color),
                              half: const Icon(Icons.star_half_rounded,
                                  color: Colours.yellow_color),
                              empty: const Icon(Icons.star_rounded,
                                  color: Colours.grey_color1)),
                          onRatingUpdate: (rating) => 0)
                    ]),
              )
            : Container(),
        controller.data?.vsInfo != ""
            ? _paragraph(controller.data?.vsInfo ?? "")
            : Container()
      ],
    );
  }

  Widget _intelligence() {
    return Column(
      children: [
        _intelligenceTitle(),
        Container(height: 16),
        _intelligenceContent(
            true,
            controller.currentIndex == 0
                ? (controller.intelligence?[0])
                : controller.intelligence?[1]),
        Container(height: 10),
        _intelligenceContent(
            false,
            controller.currentIndex == 0
                ? (controller.intelligence?[2])
                : controller.intelligence?[3]),
      ],
    );
  }

  Widget gen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("海外极品情报", style: Styles.mediumText(fontSize: 16)),
        Container(height: 16),
        _intelligenceContent(
            true, controller.data?.homeNews?.split(RegExp(r"[\f\r\n\t\v]+")),
            name: "主队新闻"),
        Container(height: 10),
        _intelligenceContent(
            false, controller.data?.guestNews?.split(RegExp(r"[\f\r\n\t\v]+")),
            name: "客队新闻"),
        Container(height: 10),
        _intelligenceContent(
            true, controller.data?.matchData?.split(RegExp(r"[\f\r\n\t\v]+")),
            name: "赛事数据",
            asset: Image.asset(Utils.getImgPath("match_data.png"))),
        Container(height: 10),
        _intelligenceContent(true,
            controller.data?.matchForecast?.split(RegExp(r"[\f\r\n\t\v]+")),
            name: "赛事预测",
            asset: Image.asset(Utils.getImgPath("match_predict.png")))
      ],
    );
  }

  Widget strength() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("实力定位", style: Styles.mediumText(fontSize: 16)),
        Container(height: 10),
        _intelligenceContent(true,
            controller.data?.homeAnalysis?.split(RegExp(r"[\f\r\n\t\v]+"))),
        Container(height: 10),
        _intelligenceContent(false,
            controller.data?.guestAnalysis?.split(RegExp(r"[\f\r\n\t\v]+"))),
      ],
    );
  }

  Widget _intelligenceTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("重要情报", style: Styles.mediumText(fontSize: 16)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
              2,
              (index) => CommonButton(
                    minWidth: 52,
                    minHeight: 22,
                    onPressed: () async {
                      controller.changeChoice(index);
                    },
                    text: controller.typeList[index],
                    backgroundColor: controller.isSelected[index]
                        ? Colours.main
                        : Colours.greyF5F5F5,
                    textStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: controller.isSelected[index]
                            ? Colours.white
                            : Colours.grey66),
                  ).paddingOnly(right: index == 0 ? 10 : 0)),
        )
      ],
    );
  }

  Widget _intelligenceContent(bool isHome, List? data,
      {String? name, Widget? asset}) {
    return data == null || data.length == 0
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: asset ??
                      CachedNetworkImage(
                          fit: BoxFit.fitWidth,
                          errorWidget: (
                            context,
                            url,
                            error,
                          ) =>
                              Image.asset(Utils.getImgPath("team_logo.png")),
                          placeholder: (context, url) =>
                              Styles.placeholderIcon(),
                          imageUrl: isHome
                              ? controller.detail?.homeLogo ?? ""
                              : controller.detail?.guestLogo ?? ""),
                ),
                Container(width: 5),
                Text(
                    name ??
                        (isHome
                            ? controller.detail?.homeName ?? ""
                            : controller.detail?.guestName ?? ""),
                    style: Styles.normalText(fontSize: 14),
                    strutStyle: Styles.centerStyle(fontSize: 14)),
              ]),
              Container(height: 10),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      data.length ?? 0,
                      (index) => data[index] != ""
                          ? _paragraph(data[index])
                          : Container()))
            ],
          );
  }

  Widget suspend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("球员伤停", style: Styles.mediumText(fontSize: 16)),
        Container(height: 16),
        Row(children: [
          Expanded(child: suspendHead(true)),
          Expanded(child: suspendHead(false))
        ]),
        Container(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LoadingCheckWidget<int>(
                isLoading: false,
                data: controller.homeSuspend.length,
                noData: Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Text('暂无数据',
                      style:
                          TextStyle(fontSize: 11, color: Colours.grey_color1)),
                ),
                child: Column(
                  children: List.generate(
                      controller.homeSuspend.length,
                      (index) => Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    index < controller.homeSuspend.length - 1
                                        ? 4
                                        : 0),
                            child: suspendPlayer(
                                controller.homeSuspend[index].split(" "), true),
                          )),
                ),
              ),
            ),
            Container(width: 10),
            Expanded(
              child: LoadingCheckWidget<int>(
                isLoading: false,
                data: controller.guestSuspend.length,
                noData: Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Text('暂无数据',
                      style:
                          TextStyle(fontSize: 11, color: Colours.grey_color1)),
                ),
                child: Column(
                  children: List.generate(
                      controller.guestSuspend.length,
                      (index) => Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    index < controller.guestSuspend.length - 1
                                        ? 4
                                        : 0),
                            child: suspendPlayer(
                                controller.guestSuspend[index].split(" "),
                                false),
                          )),
                ),
              ),
            )
          ],
        ),
        Container(height: 10),
        _intelligenceContent(false,
            controller.data?.injuryAnalysis?.split(RegExp(r"[\f\r\n\t\v]+")),
            name: "伤停解读",
            asset: Image.asset(Utils.getImgPath("suspend_analysis.png"))),
      ],
    );
  }

  Widget _dot() {
    return Container(
        width: 10,
        height: 4,
        alignment: Alignment.centerLeft,
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colours.main));
  }

  Widget _paragraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 3),
            child: _dot(),
          ),
          Flexible(
              child: Text(
            text.split(" ").join().split("").join("\u200A").trim(),
            style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Color(0xFF444444),
                letterSpacing: -0.3),
            textAlign: TextAlign.justify,
            softWrap: true,
          )),
        ],
      ),
    );
  }

  Widget suspendHead(bool isHome) {
    var list = [
      CachedNetworkImage(
          width: 32,
          height: 32,
          errorWidget: (
            context,
            url,
            error,
          ) =>
              Image.asset(Utils.getImgPath("team_logo.png")),
          placeholder: (context, url) => Styles.placeholderIcon(),
          imageUrl: isHome
              ? controller.detail?.homeLogo ?? ""
              : controller.detail?.guestLogo ?? ""),
      Container(width: 4),
      Text(
          isHome
              ? controller.detail?.homeName ?? ""
              : controller.detail?.guestName ?? "",
          style: Styles.normalText(fontSize: 14))
    ];
    return Row(
      mainAxisAlignment:
          isHome ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: isHome ? list : list.reversed.toList(),
    );
  }

  Widget suspendPlayer(List<String>? list, bool isHome) {
    return (list?.length ?? 0) < 5
        ? Container()
        : SizedBox(
            height: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(list?[0] ?? "",
                            style: Styles.normalText(fontSize: 14),
                            overflow: TextOverflow.ellipsis)),
                    Container(
                      height: 14,
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: isHome
                              ? Colours.main_color
                              : Colours.guestColorBlue,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(2))),
                      child: Text(
                        list?[4] ?? "",
                        strutStyle: Styles.centerStyle(fontSize: 10),
                        style: const TextStyle(
                            fontSize: 10, color: Colours.white, height: 1),
                      ),
                    )
                  ],
                ),
                Container(height: 8),
                Row(
                  children: [
                    Container(
                        height: 14,
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 0.5,
                                color: isHome
                                    ? Colours.main_color
                                    : Colours.guestColorBlue),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(2))),
                        child: Text(
                          list?[1] ?? "",
                          strutStyle: Styles.centerStyle(fontSize: 10),
                          style: TextStyle(
                              fontSize: 10,
                              color: isHome
                                  ? Colours.main_color
                                  : Colours.guestColorBlue,
                              height: 1),
                        )),
                    Container(width: 4),
                    Container(
                      height: 14,
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.5,
                              color: isHome
                                  ? Colours.main_color
                                  : Colours.guestColorBlue),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(2))),
                      child: Text(
                        list?[3] ?? "",
                        strutStyle: Styles.centerStyle(fontSize: 10),
                        style: TextStyle(
                            fontSize: 10,
                            color: isHome
                                ? Colours.main_color
                                : Colours.guestColorBlue,
                            height: 1),
                      ),
                    ),
                    Container(width: 4),
                    Text(list?[2] ?? "",
                        style: const TextStyle(
                            fontSize: 11, color: Colours.grey99))
                  ],
                )
              ],
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
