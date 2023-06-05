import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/match/soccer_data_controller.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/loading_check_widget.dart';
import 'package:sports/widgets/no_data_widget.dart';

import '../../../res/colours.dart';
import '../../../widgets/common_button.dart';

class SoccerDataBottomDialog extends StatefulWidget {
  const SoccerDataBottomDialog({super.key});

  @override
  State<SoccerDataBottomDialog> createState() => _SoccerDataBottomDialogState();
}

class _SoccerDataBottomDialogState extends State<SoccerDataBottomDialog> {
  final controller = Get.put(SoccerDataController());
  final DraggableScrollableController scrollController =
      DraggableScrollableController();
  int flag = 0;

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.size < 0.85) {
        if (flag == 0) {
          Get.back();
          flag++;
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SoccerDataController>(builder: (controller) {
      return GestureDetector(
        onTap: () => Get.back(),
        child: Container(
            color: Colours.transparent,
            width: Get.width,
            height: Get.height,
            child: GestureDetector(onTap: () => log(""), child: _sheet())),
      );
    });
  }

  Widget _sheet() {
    return DraggableScrollableSheet(
        maxChildSize: 0.92,
        initialChildSize: 0.92,
        minChildSize: 0,
        controller: scrollController,
        builder: (context, scrollController) {
          return Container(
            width: Get.width,
            constraints: BoxConstraints(maxHeight: Get.height * 0.95),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                color: Colours.white),
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 7, bottom: 8),
                        child: Container(
                          width: 40,
                          height: 3,
                          decoration: BoxDecoration(
                              color: Colours.transparent,
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          physics: const ClampingScrollPhysics(),
                          child: LoadingCheckWidget<String>(
                            isLoading: controller.isLoading,
                            loading: Container(
                                width: Get.width,
                                height: Get.height * 0.95 - 18,
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(
                                    color: Colours.main, strokeWidth: 3)),
                            data: controller.data?.nameChs,
                            noData: Container(
                                height: Get.height * 0.95,
                                alignment: Alignment.center,
                                child: NoDataWidget()),
                            child: Column(children: [
                              _soccerHead(),
                              Container(height: 20),
                              Column(
                                children: List.generate(
                                    controller.data?.countArray?.length ?? 0,
                                    (index) => controller.data
                                                    ?.countArray?[index].info !=
                                                null ||
                                            controller.data?.countArray?[index]
                                                    .info !=
                                                ""
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Row(
                                              children: [
                                                Image.asset(controller
                                                            .data
                                                            ?.countArray?[index]
                                                            .type ==
                                                        1
                                                    ? Utils.getImgPath(
                                                        "yellow_star.png")
                                                    : Utils.getImgPath(
                                                        "grey_star.png")),
                                                Container(width: 4),
                                                Text(
                                                    controller
                                                            .data
                                                            ?.countArray?[index]
                                                            .info ??
                                                        "",
                                                    style: Styles.normalSubText(
                                                        fontSize: 13))
                                              ],
                                            ),
                                          )
                                        : Container()),
                              ),
                              Container(height: 20),
                              Column(
                                children: soccerData(),
                              )
                            ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _soccerHead() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 26),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Stack(
                      children: [
                        ClipOval(
                          child: CachedNetworkImage(
                              width: 56,
                              height: 56,
                              placeholder: (context, url) =>
                                  Styles.placeholderIcon(),
                              errorWidget: (context, url, error) => Image.asset(
                                  Utils.getImgPath("team_logo.png")),
                              imageUrl: controller.data?.photo ?? ""),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: ClipOval(
                            child: CachedNetworkImage(
                                width: 20,
                                height: 20,
                                placeholder: (context, url) =>
                                    Styles.placeholderIcon(),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                        Utils.getImgPath("team_logo.png")),
                                imageUrl: controller.data?.logo ?? ""),
                          ),
                        ),
                      ],
                    ),
                    Container(width: 10),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(controller.data?.nameChs ?? "",
                              style: Styles.mediumText(fontSize: 17)),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                // ClipOval(
                                //   child: CachedNetworkImage(
                                //       width: 18,
                                //       height: 18,
                                //       errorWidget: (context,url,error) => Image.asset(Utils.getImgPath("team_logo.png")),
                                //       imageUrl: controller.data?.photo ?? ""),
                                // ),
                                Text(controller.data?.countryCn ?? "",
                                    style: Styles.normalSubText(fontSize: 12)),
                              ],
                            ),
                          ),
                          Text(controller.soccerInfo,
                              style: Styles.normalSubText(fontSize: 12))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CommonButton(
                    minWidth: 44,
                    minHeight: 20,
                    onPressed: () {},
                    text: controller.data?.rating ?? "-",
                    backgroundColor: Colours.main_color,
                    textStyle: Styles.mediumText(fontSize: 14)
                        .copyWith(color: Colours.white),
                  ),
                  Container(height: 2),
                  Text(
                    "本场评分",
                    style: Styles.normalSubText(fontSize: 10),
                  )
                ],
              )
            ],
          ),
        ),
        controller.data?.isBest == true
            ? Positioned(
                top: 0,
                right: 54,
                child: Image.asset(
                    width: 60, height: 53, Utils.getImgPath("mvp.png")))
            : Container()
      ],
    );
  }

  List<Widget> soccerData() {
    List<Widget> result = [];
    var title = controller.soccerData.keys.toList();
    var i = 0;
    for (var element in controller.soccerData.values) {
      if (i == 1) {
        if (controller.data?.positionCn == "守门员") {
          result.add(soccerDataItem(
              element.values.toList(), element.keys.toList(), title[i]));
        }
      } else {
        result.add(soccerDataItem(
            element.values.toList(), element.keys.toList(), title[i]));
      }
      i++;
    }
    return result;
  }

  Widget soccerDataItem(List data, List item, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title == ''
            ? Container()
            : Container(
                height: 46.5,
                alignment: Alignment.centerLeft,
                child: Text(title, style: Styles.mediumText(fontSize: 16)),
              ),
        Wrap(
          children: List.generate(
              data.length,
              (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      width: (Get.width - 32) / 4,
                      height: 60,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(data[index],
                              style: Styles.mediumText(fontSize: 16)),
                          Text(item[index],
                              style: Styles.normalSubText(fontSize: 12))
                        ],
                      ),
                    ),
                  )),
        ),
        Container(height: 10),
        const Divider(height: 0.5, color: Colours.greyEE)
      ],
    );
  }
}
