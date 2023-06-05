import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/data/data_team_controller.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/data/data_left_list.dart';
import 'package:sports/widgets/no_data_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

class DataTeamPage extends StatefulWidget {
  DataTeamPage(this.leagueId, {super.key, required this.tag});

  int leagueId;
  final String tag;

  @override
  State<DataTeamPage> createState() => _DataTeamPageState();
}

class _DataTeamPageState extends State<DataTeamPage>
    with AutomaticKeepAliveClientMixin {
  late DataTeamController controller;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<DataTeamController>(
      tag: widget.tag,
      initState: (state) {
        controller = Get.put(DataTeamController(widget.leagueId, widget.tag),
            tag: widget.tag);
      },
      didUpdateWidget: (oldWidget, state) {
        if (controller.visible) {
          controller = Get.put(DataTeamController(widget.leagueId, widget.tag),
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
                          Utils.onEvent('zqsjpd_qdb', params: {
                            'zqsjpd_qdb': controller.struct![p0].value
                          });
                          controller.onSelectStruct(p0);
                        })),
                        right(),
                      ],
                    )),
        );
      },
    );
  }

  Widget right() {
    // return EasyRefresh.bui
    return Expanded(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: controller.header == null
          ? Container()
          : Column(
              children: [
                Container(
                  height: 38,
                  color: Colours.white,
                  child: Row(
                    children: [
                      SizedBox(
                          width: 34,
                          child: Text(
                            '球队',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colours.grey_color, fontSize: 13),
                          )),
                      Spacer(),
                      ...controller.header!
                          .map((e) => SizedBox(
                                width: 50,
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
                    controller.getTeam(needLoading: false);
                  },
                  controller: EasyRefreshController(),
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                      itemBuilder: (context, index) => player(index),
                      itemCount: controller.teamAll!.length,
                    ),
                  ),
                ))
              ],
            ),
    ));
  }

  Widget player(int index) {
    final data = controller.teamAll![index];
    String rankImage = '';
    if (index == 0) {
      rankImage = 'rank_first.png';
    } else if (index == 1) {
      rankImage = 'rank_second.png';
    } else if (index == 2) {
      rankImage = 'rank_third.png';
    }
    return GestureDetector(
      onTap: () {
        Utils.onEvent('sjpd_qdxq', params: {'sjpd_qdxq': '4'});
        Get.toNamed(Routes.soccerTeamDetail, arguments: data.qxbTeamId);
      },
      child: Container(
        height: 50,
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(children: [
          SizedBox(
              width: 34,
              child: Text(
                data.index ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colours.text_color1),
              )),
          CachedNetworkImage(
            height: 24,
            width: 24,
            fit: BoxFit.fitWidth,
            imageUrl: data.teamLogo!,
            placeholder: (context, url) => Styles.placeholderIcon(),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              data.teamName ?? '',
              // textAlign: TextAlign.center,
              style: TextStyle(color: Colours.text_color1, fontSize: 13),
            ),
          ),
          ...data.values!
              .map((e) => SizedBox(
                    width: 50,
                    child: Text(
                      e,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Colours.text_color1, fontSize: 13),
                    ),
                  ))
              .toList(),
        ]),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
