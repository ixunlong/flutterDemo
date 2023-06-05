import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/data/basketball/bb_data_player_controller.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/data/data_left_list.dart';
import 'package:sports/widgets/no_data_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BbDataPlayerPage extends StatefulWidget {
  BbDataPlayerPage(this.leagueId, {super.key, required this.tag});

  int leagueId;
  final String tag;

  @override
  State<BbDataPlayerPage> createState() => _BbDataPlayerPageState();
}

class _BbDataPlayerPageState extends State<BbDataPlayerPage>
    with AutomaticKeepAliveClientMixin {
  late BbDataPlayerController controller;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<BbDataPlayerController>(
      tag: widget.tag,
      initState: (state) {
        controller = Get.put(
            BbDataPlayerController(widget.leagueId, widget.tag),
            tag: widget.tag);
      },
      didUpdateWidget: (oldWidget, state) {
        if (controller.visible) {
          controller = Get.put(
              BbDataPlayerController(widget.leagueId, widget.tag),
              tag: widget.tag);
          controller.getStruct();
        }
      },
      builder: (_) {
        return VisibilityDetector(
          key: Key(widget.tag),
          onVisibilityChanged: (VisibilityInfo info) {
            controller.visible = !info.visibleBounds.isEmpty;
          },
          child: controller.struct == null
              ? Container()
              : (controller.struct!.isEmpty
                  ? NoDataWidget()
                  : Row(
                      children: [
                        DataLeftList(
                            controller.struct!.map((e) => e.value!).toList(),
                            controller.structIndex, ((p0) {
                          // Utils.onEvent('zqsjpd_qyb',
                          //     params: {'zqsjpd_qyb': controller.struct![p0]});
                          controller.onSelectStruct(p0);
                        })),
                        right(),
                      ],
                    )),
        );
      },
    );
  }

  // Widget left() {}

  Widget right() {
    // String typeString = '';
    // if (controller.dataType == 0) {
    //   typeString = '全部';
    // } else if (controller.dataType == 1) {
    //   typeString = '主场';
    // } else if (controller.dataType == 2) {
    //   typeString = '客场';
    // }
    double itemWidth = 42;
    return Expanded(
        child: Padding(
      padding: EdgeInsets.only(left: 4, right: 4),
      child: controller.header == null
          ? Container()
          : Column(
              children: [
                SizedBox(
                  height: 38,
                  child: Row(
                    children: [
                      SizedBox(
                          width: 34,
                          child: Text(
                            '球员',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colours.grey_color, fontSize: 13),
                          )),
                      Spacer(),
                      ...controller.header!
                          .map((e) => SizedBox(
                                width: e == '球队' ? 60 : itemWidth,
                                child: Text(
                                  e,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colours.grey_color, fontSize: 13),
                                ),
                              ))
                          .toList(),
                    ],
                  ),
                ),
                Expanded(
                    child: EasyRefresh(
                  onRefresh: () async {
                    controller.getPlayer(needLoading: false);
                  },
                  controller: EasyRefreshController(),
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                      itemBuilder: (context, index) => player(index),
                      itemCount: controller.getPlayerData().length,
                    ),
                  ),
                ))
              ],
            ),
    ));
  }

  Widget player(int index) {
    final data = controller.getPlayerData()[index];
    double itemWidth = 42;
    String rankImage = '';
    if (index == 0) {
      rankImage = 'rank_first.png';
    } else if (index == 1) {
      rankImage = 'rank_second.png';
    } else if (index == 2) {
      rankImage = 'rank_third.png';
    }
    return Container(
      height: 50,
      child: Row(children: [
        SizedBox(
            width: 34,
            child: Text(
              data.index ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colours.text_color1),
            )),
        CachedNetworkImage(
          height: 32,
          width: 24,
          fit: BoxFit.cover,
          imageUrl: data.playerLogo!,
          placeholder: (context, url) => Styles.placeholderIcon(),
          errorWidget: (context, url, error) => Image.asset(
            Utils.getImgPath('basket_team_logo.png'),
            height: 32,
            width: 24,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                data.playerName ?? '',
                // textAlign: TextAlign.center,
                style:
                    const TextStyle(color: Colours.text_color1, fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Text(
                '${data.playerPoints}分 ${data.playerRebounds}板 ${data.playerAssists}助',
                style: const TextStyle(color: Colours.grey66, fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
        ...List.generate(
            data.values!.length,
            (index) => SizedBox(
                  width: controller.header![index] == '球队' ? 60 : itemWidth,
                  child: Text(
                    data.values![index],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colours.text_color1, fontSize: 13),
                  ),
                )),
        // ...data.values!
        //     .map((e) => SizedBox(
        //           width: itemWidth,
        //           child: Text(
        //             e,
        //             textAlign: TextAlign.center,
        //             style: TextStyle(color: Colours.text_color1, fontSize: 13),
        //           ),
        //         ))
        //     .toList(),
      ]),
    );
  }

  // Widget _selectButton(String title) {
  //   return GestureDetector(
  //     onTap: () async {
  //       final result = await Get.bottomSheet(CupertinoPickerWidget(
  //         ['全部', '主场', '客场'],
  //         title: '选择主客场',
  //         initialIndex: controller.dataType,
  //       ));
  //       if (result != null) {
  //         controller.onSelectType(result);
  //       }
  //     },
  //     child: Container(
  //       width: 50,
  //       height: 20,
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.all(Radius.circular(10)),
  //           color: Colours.greyF5F7FA),
  //       child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
  //         Text(
  //           title,
  //           style: const TextStyle(
  //               fontSize: 12,
  //               color: Colours.grey_color,
  //               fontWeight: FontWeight.w400),
  //         ),
  //         SizedBox(width: 4),
  //         Image.asset(Utils.getImgPath('down_arrow.png'))
  //       ]),
  //     ),
  //   );
  // }

  @override
  bool get wantKeepAlive => true;
}
