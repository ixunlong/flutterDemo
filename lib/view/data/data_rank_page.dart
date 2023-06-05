import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/data/data_rank_controller.dart';
import 'package:sports/res/routes.dart';

import '../../res/colours.dart';
import '../../res/styles.dart';
import '../../util/utils.dart';

class DataRankPage extends StatefulWidget {
  DataRankPage({Key? key, required this.tag})
      : controller = Get.put(DataRankController(), tag: tag),
        super(key: key);

  final String tag;
  final DataRankController controller;

  @override
  State<DataRankPage> createState() => _DataRankPageState();
}

class _DataRankPageState extends State<DataRankPage>
    with AutomaticKeepAliveClientMixin {
  late final DataRankController controller = widget.controller;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<DataRankController>(
        tag: widget.tag,
        initState: (state) async {
          widget.controller.tag = widget.tag;
          await controller.requestData();
        },
        builder: (controller) {
          return controller.isLoading
              ? Container()
              : Column(children: [
                  widget.tag == "俱乐部" ? Container() : _pageChoice(),
                  Expanded(
                    child: EasyRefresh.builder(
                      controller: EasyRefreshController(),
                      onRefresh: controller.requestData,
                      childBuilder: (BuildContext context, ScrollPhysics physics) {
                        return CustomScrollView(
                          physics: physics,
                          slivers: [
                            SliverToBoxAdapter(child: header()),
                            SliverList(
                              delegate: SliverChildListDelegate(List.generate(
                                controller.data.length,
                                  (index) => content(controller.data[index],index))))
                          ],
                        );
                      }
                    ))
                ]);
        });
  }

  Widget _pageChoice() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 8, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => controller.showTypePicker(),
            child: Container(
              key: ValueKey(widget.tag),
              height: 24,
              width: 57,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 6, right: 2),
              decoration: BoxDecoration(
                  color: Colours.greyF5F7FA,
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        widget.tag != "篮球"
                            ? controller.sexList[controller.sexIndex]
                            : controller.sexBbList[controller.sexIndex],
                        strutStyle: Styles.centerStyle(fontSize: 12),
                        style: const TextStyle(
                            fontSize: 12, color: Colours.text_color)),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Image.asset(Utils.getImgPath('down_arrow.png')),
                    )
                  ]),
            ),
          ),
          Container(width: 6),
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(
                    widget.tag != "篮球"
                        ? controller.typeList.length
                        : controller.typeBbList.length,
                    (childIndex) => Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () => controller.getType(childIndex),
                            child: Container(
                              height: 24,
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: controller.typeIndex == childIndex
                                      ? Colours.redFFECEE
                                      : Colours.white),
                              child: Text(
                                  widget.tag != "篮球"
                                      ? controller.typeList[childIndex]
                                      : controller.typeBbList[childIndex],
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: controller.typeIndex == childIndex
                                          ? Colours.main_color
                                          : Colours.grey66),
                                  strutStyle: Styles.centerStyle(fontSize: 14)),
                            ),
                          ),
                        )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget header() {
    return SizedBox(
      height: 38,
      child: Row(
        children: [
          Container(
              padding: const EdgeInsets.only(left: 16),
              child: Text(widget.tag == "俱乐部" ? "球队" : "国家/地区",
                  style: Styles.normalSubText(fontSize: 13)
                      .copyWith(color: Colours.grey666666))),
          const Spacer(),
          Container(
              width: 54,
              alignment: Alignment.center,
              child: Text("排名变化", style: Styles.normalSubText(fontSize: 13))),
          // Container(
          //     width: 54,
          //     alignment: Alignment.center,
          //     child: Text("积分变化",style: Styles.normalSubText(fontSize: 13))),
          GestureDetector(
            onTap: () => controller.showDatePicker(),
            child: Container(
                width: 90,
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        "${controller.months[controller.dateIndex].rankMonth!.split(RegExp(r'[0-9]*-')).join()}月积分",
                        style: Styles.normalSubText(fontSize: 13)),
                    const SizedBox(width: 2),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Image.asset(Utils.getImgPath('down_arrow.png')),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget content(entity,int index) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (widget.tag == '篮球') {
          Get.toNamed(Routes.basketTeamDetail, arguments: entity.teamQxbId);
        } else {
          Get.toNamed(Routes.soccerTeamDetail, arguments: entity.teamQxbId);
        }
      },
      child: Container(
        height: 50,
        color: controller.tag != "俱乐部" && index == 0 && controller.typeIndex <=1?Colours.redFEF2F3:null,
        alignment: Alignment.center,
        child: Row(
          children: [
            if (entity.rank == 1)
              Container(
                  width: 36,
                  alignment: Alignment.center,
                  child: Image.asset(Utils.getImgPath("rank_first.png"))),
            if (entity.rank == 2)
              Container(
                  width: 36,
                  alignment: Alignment.center,
                  child: Image.asset(Utils.getImgPath("rank_second.png"))),
            if (entity.rank == 3)
              Container(
                  width: 36,
                  alignment: Alignment.center,
                  child: Image.asset(Utils.getImgPath("rank_third.png"))),
            if ((entity.rank ?? 0) > 3)
              Container(
                  width: 36,
                  alignment: Alignment.center,
                  child: Text("${entity.rank ?? "-"}",
                      style: Styles.normalText(fontSize: 13))),
            ClipRRect(
              borderRadius: BorderRadius.circular(1),
              child: CachedNetworkImage(
                  width: 24,
                  height: 24,
                  fit: BoxFit.fitWidth,
                  placeholder: (context, url) => Styles.placeholderIcon(),
                  errorWidget: (context, url, error) =>
                      Image.asset(Utils.getImgPath("team_logo.png")),
                  imageUrl: entity.logo ?? ""),
            ).paddingOnly(right: 8),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 120),
              child: Text(entity.nameChs ?? "-",
                  style: const TextStyle(
                      fontSize: 13, color: Colours.text_color),
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ),
            const Spacer(),
            Container(
                width: 54,
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (entity.rankChange != 0 && entity.rankChange != null)
                      Image.asset(Utils.getImgPath((entity.rankChange ?? 0) > 0
                          ? "up_arrow_red.png"
                          : "down_arrow_green.png")),
                    Text("${entity.rankChange?.abs() ?? "-"}",
                        style: Styles.normalText(fontSize: 13).copyWith(
                            color: (entity.rankChange ?? 0) != 0
                                ? (entity.rankChange ?? 0) > 0
                                    ? Colours.main
                                    : Colours.green
                                : Colours.text_color)),
                  ],
                )),
            // Container(
            //     width: 54,
            //     alignment: Alignment.center,
            //     child: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         if(entity.scoreChange != 0 && entity.scoreChange != null)
            //           Image.asset(Utils.getImgPath((entity.scoreChange ?? 0) > 0?"up_arrow_red.png":"down_arrow_green.png")),
            //         Text(
            //             "${entity.scoreChange?.abs() ?? "-"}",
            //             style: Styles.normalText(fontSize: 13).copyWith(color: (entity.scoreChange ?? 0) != 0?(entity.scoreChange ?? 0) > 0?Colours.main:Colours.green:Colours.text_color)),
            //       ],
            //     )),
            Container(
                width: 90,
                alignment: Alignment.center,
                child: Text("${entity.score ?? "-"}",
                    style: Styles.normalText(fontSize: 13)))
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
