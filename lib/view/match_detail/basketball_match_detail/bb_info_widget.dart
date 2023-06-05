import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/basketball/bb_match_info_controller.dart';

import '../../../res/colours.dart';
import '../../../res/styles.dart';
import '../../../util/utils.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/loading_check_widget.dart';

class BbInfoWidget extends StatefulWidget {
  BbInfoWidget({Key? key}) : super(key: key);

  @override
  State<BbInfoWidget> createState() => _BbInfoWidgetState();
}

class _BbInfoWidgetState extends State<BbInfoWidget> {
  final controller = Get.put(BbMatchInfoController(), tag: '${Get.arguments}');

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BbMatchInfoController>(
        tag: '${Get.arguments}',
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
                    Container(height: 10),
                    block<String>(
                        data: (controller.data?.homeInjury ?? "") +
                            (controller.data?.guestInjury ?? ""),
                        child: suspend()),
                    block<int>(
                        data: controller.totalLength, child: _intelligence()),
                    Container(height: 30)
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget suspend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("球员伤停", style: Styles.mediumText(fontSize: 16)),
        Container(height: 16),
        Row(children: [
          Expanded(child: suspendHead(false)),
          Expanded(child: suspendHead(true))
        ]),
        Container(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LoadingCheckWidget<String>(
                isLoading: false,
                data: controller.data?.guestInjury ?? "",
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
                                        ? 16
                                        : 0),
                            child: suspendPlayer(
                                controller.guestSuspend[index].split(RegExp(r"[ \n]+")), false),
                          )),
                ),
              ),
            ),
            Container(width: 10),
            Expanded(
              child: LoadingCheckWidget<String>(
                isLoading: false,
                data: controller.data?.homeInjury ?? "",
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
                                        ? 16
                                        : 0),
                            child: suspendPlayer(
                                controller.homeSuspend[index].split(RegExp(r"[ \n]+")), true),
                          )),
                ),
              ),
            )
          ],
        ),
        Container(height: 18)
      ],
    );
  }

  Widget _intelligence() {
    return Column(
      children: [
        _intelligenceTitle(),
        Container(height: 16),
        controller.currentIndex == 1
            ? _intelligenceContent(true, controller.intelligence?[4])
            : Column(
                children: [
                  _intelligenceContent(
                      false,
                      controller.currentIndex == 0
                          ? (controller.intelligence?[1])
                          : controller.intelligence?[3]),
                  Container(height: 16),
                  _intelligenceContent(
                      true,
                      controller.currentIndex == 0
                          ? (controller.intelligence?[0])
                          : controller.intelligence?[2]),
                ],
              )
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
              3,
              (index) => CommonButton(
                    minWidth: 52,
                    minHeight: 22,
                    onPressed: () async {
                      controller.currentIndex = index;
                    },
                    text: controller.typeList[index],
                    backgroundColor: controller.currentIndex == index
                        ? Colours.main
                        : Colours.greyF5F5F5,
                    textStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: controller.currentIndex == index
                            ? Colours.white
                            : Colours.grey66),
                  ).paddingOnly(right: index != 2 ? 10 : 0)),
        )
      ],
    );
  }

  Widget _intelligenceContent(bool isHome, List<String>? info) {
    return info?.length == 0
        ? Container()
        : Column(
            children: [
              controller.currentIndex == 1
                  ? Container()
                  : Row(children: [
                      CachedNetworkImage(
                          width: 20,
                          height: 20,
                          placeholder: (context, url) =>
                              Styles.placeholderIcon(),
                          errorWidget: (
                            context,
                            url,
                            error,
                          ) =>
                              Image.asset(
                                  Utils.getImgPath("basket_team_logo.png")),
                          imageUrl: isHome
                              ? controller.detail.detail?.homeTeamLogo ?? ""
                              : controller.detail.detail?.awayTeamLogo ?? ""),
                      Container(width: 5),
                      Text(
                          isHome
                              ? controller.detail.detail?.homeTeamName ?? ""
                              : controller.detail.detail?.awayTeamName ?? "",
                          style: Styles.normalText(fontSize: 14)),
                    ]).paddingOnly(bottom: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    info?.length ?? 0,
                    (index) => info?[index] != null
                        ? _paragraph(info?[index] ?? '')
                        : Container()),
              )
            ],
          );
  }

  Widget suspendHead(bool isHome) {
    var list = [
      Text(
          isHome
              ? controller.detail.detail?.homeTeamName ?? ""
              : controller.detail.detail?.awayTeamName ?? "",
          style: Styles.normalText(fontSize: 14)),
      Container(width: 4),
      CachedNetworkImage(
          width: 32,
          height: 32,
          placeholder: (context, url) => Styles.placeholderIcon(),
          errorWidget: (
            context,
            url,
            error,
          ) =>
              Image.asset(Utils.getImgPath("basket_team_logo.png")),
          imageUrl: isHome
              ? controller.detail.detail?.homeTeamLogo ?? ""
              : controller.detail.detail?.awayTeamLogo ?? "")
    ];
    return Row(
      mainAxisAlignment:
          isHome ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: isHome ? list : list.reversed.toList(),
    );
  }

  Widget suspendPlayer(List<String>? list, bool isHome) {
    return (list?.length ?? 0) < 4
        ? Container()
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: isHome
                            ? Colours.main_color
                            : Colours.guestColorBlue,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(2))),
                    child: Text(
                      list?[2] ?? "",
                      strutStyle: Styles.centerStyle(fontSize: 10),
                      style: const TextStyle(
                          fontSize: 10, color: Colours.white, height: 1),
                    ),
                  )
                ],
              ),
              Container(height: 8),
              RichText(
                  softWrap: true,
                  strutStyle: Styles.centerStyle(fontSize: 10),
                  text: TextSpan(children: [
                    WidgetSpan(
                        child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            height: 14,
                            padding: const EdgeInsets.symmetric(horizontal: 2),
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
                      ],
                    ).paddingOnly(right: 2)),
                    TextSpan(
                      text: list?[3] ?? "",
                      style:
                          const TextStyle(fontSize: 11, color: Colours.grey99),
                    )
                  ]))
            ],
          );
  }

  Widget block<T>({required T data, required Widget child, Widget? noData}) {
    return LoadingCheckWidget<T>(
      isLoading: false,
      data: data,
      noData: noData ?? Container(),
      child: Container(
        decoration: BoxDecoration(
            color: Colours.white, borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        margin: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
        child: child,
      ),
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
    return Row(
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
    );
  }
}
