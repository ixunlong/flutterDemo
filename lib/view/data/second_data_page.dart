import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/data/second_data_controller.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/data/season_page.dart';

import '../../res/colours.dart';

class SecondDataPage extends StatelessWidget {
  SecondDataPage({Key? key}) : super(key: key);
  final int tag = Random().nextInt(100000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SecondDataController>(
          init: SecondDataController(),
          tag: tag.toString(),
          builder: (controller) {
            return controller.isLoading
                ? Container()
                : ExtendedNestedScrollView(
                    onlyOneScrollInBody: true,
                    floatHeaderSlivers: true,
                    physics: const NeverScrollableScrollPhysics(),
                    controller: controller.scrollController,
                    pinnedHeaderSliverHeightBuilder: () =>
                        kToolbarHeight + MediaQuery.of(context).padding.top,
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        Obx(
                          () => SliverAppBar(
                            pinned: true,
                            toolbarHeight: kToolbarHeight,
                            collapsedHeight: kToolbarHeight,
                            expandedHeight: controller.expendedHeight,
                            titleSpacing: 0.0,
                            backgroundColor: Colours.main,
                            iconTheme:
                                const IconThemeData(color: Colours.white),
                            title: Opacity(
                                opacity: controller.num,
                                child: Text(controller.entity?.nameChs ?? "",
                                    style: TextStyle(
                                        fontSize: 17, color: Colours.white))),
                            flexibleSpace: FlexibleSpaceBar(
                              centerTitle: true,
                              collapseMode: CollapseMode.pin,
                              background: Container(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).padding.top),
                                height: 80,
                                width: Get.width,
                                color: Colours.main,
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CachedNetworkImage(
                                        width: 54,
                                        height: 54,
                                        fit: BoxFit.fitWidth,
                                        imageUrl:
                                            controller.entity?.leagueLogo ?? "",
                                        placeholder: (context, url) =>
                                            Styles.placeholderIcon(),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                              fit: BoxFit.fitHeight,
                                              Utils.getImgPath('team_logo.png'),
                                              height: 54,
                                              width: 54,
                                            )),
                                    Container(height: 4),
                                    Text(controller.entity?.nameChs ?? '',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Colours.white)),
                                    Text(controller.entity?.nameEn ?? "",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colours.white.withOpacity(0.8))),
                                    Container(height: 4),
                                    DefaultTextStyle(
                                      style: TextStyle(fontSize: 12,color: Colors.white),
                                      child: Container(
                                        height: 16,
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(DateTime.tryParse(controller.entity?.startTime ?? "")?.formatedString("yyyy/MM/dd") ?? "",
                                              style: TextStyle(color: Colors.white.withOpacity(0.8))),
                                            Text(DateTime.tryParse(controller.entity?.endTime ?? "")?.formatedString("yyyy/MM/dd") ?? "",
                                              style: TextStyle(color: Colors.white.withOpacity(0.8)))
                                          ],
                                        ).paddingSymmetric(horizontal: 16),
                                      ),
                                    ),
                                    Container(
                                      width: Get.width,
                                      height: 16,
                                      padding: EdgeInsets.all(2),
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.symmetric(horizontal: 16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colours.red7D0000.withOpacity(0.16)
                                      ),
                                      child: LayoutBuilder(
                                        builder: (BuildContext context, BoxConstraints constraints) {
                                          return Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Container(
                                                clipBehavior: Clip.antiAlias,
                                                width: constraints.maxWidth*((controller.entity?.progress ?? 0)/100),
                                                height: 16,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Image.asset(height:14,fit: BoxFit.fitHeight,Utils.getImgPath("league_progress.png"))),
                                              Positioned(
                                                left: (controller.entity?.progress ?? 0) < 10?0:null,
                                                right: (controller.entity?.progress ?? 0) < 10?null:0,
                                                top: 0,
                                                bottom: 0,
                                                child: Text(
                                                controller.progress,
                                                strutStyle: Styles.centerStyle(fontSize: 10),
                                                style: TextStyle(fontSize: 10,color: Colors.white)).paddingSymmetric(horizontal: 6))
                                            ],
                                          );
                                        }
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: Container(
                        color: Colours.main,
                        child: Container(
                            decoration: const BoxDecoration(
                                color: Colours.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10))),
                            child: SeasonPage(
                                data: controller.entity,
                                type: controller.random))));
          }),
    );
  }
}
