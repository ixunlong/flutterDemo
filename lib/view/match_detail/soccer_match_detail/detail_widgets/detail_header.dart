import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/match/match_info_entity.dart';
import 'package:sports/model/match/match_video_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/select_bottomsheet.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DetailHeaderWidget extends StatelessWidget {
  DetailHeaderWidget(
      {super.key,
      this.info,
      this.liveAnimation = false,
      this.animatelivePress});

  MatchInfoEntity? info;
  // List<MatchVideoEntity>? videoList;
  FutureOr Function()? animatelivePress;

  bool liveAnimation;

  @override
  Widget build(BuildContext context) {
    return _header();
  }

  Widget _header() {
    var details = <String>[];
    if (info?.halfScoreRate != null) {
      if (info?.state == MatchState.notStart) {
      } else {
        details.add("半场${info?.halfScoreRate}");
      }
    }
    if (info?.otScoreRate != null) {
      details.add("加时${info?.otScoreRate}");
    }
    if (info?.pkScoreRate != null) {
      details.add("点球${info?.pkScoreRate}");
    }
    final detailTexts = <Widget>[];
    for (var i = 0; i < details.length; i += 1) {
      if (i + 1 < details.length && i != 0) {
        detailTexts.add(Text(
          "${details[i]} ${details[i + 1]}",
        ));
        i += 1;
      } else {
        detailTexts.add(Text(details[i]));
      }
    }
    final content = Container(
        height: 140,
        color: info?.topColor ?? Colours.red_color,
        child: Row(
          children: [
            Expanded(
                child: _teamCol(
                    info?.baseInfo?.homeLogo ?? "",
                    info?.baseInfo?.homeNameAll ?? "",
                    info?.baseInfo?.homeRanking,
                    info?.baseInfo?.homeId ?? 0)),
            Column(
              children: [
                const SizedBox(height: 20),
                (info?.state == MatchState.notStart)
                    ? Container(height: 15)
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: info == null
                                ? Colors.transparent
                                : info!.topStatusBgColor),
                        child: info?.state == MatchState.inMatch
                            ? info?.runningTime != null
                                ? Wrap(
                                    children: [
                                      Text(
                                          info?.runningTime
                                                  ?.replaceAll("'", "") ??
                                              "",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13)),
                                      const Text("'",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13))
                                          .animate(
                                              onPlay: (controller) =>
                                                  controller.repeat())
                                          .fade(duration: 1000.ms)
                                    ],
                                  )
                                : Text(info?.baseInfo?.statusName ?? "",
                                    style: const TextStyle(fontSize: 13))
                            : Text(info?.baseInfo?.statusName ?? "",
                                style: const TextStyle(fontSize: 13)),
                      ),
                const SizedBox(height: 6),
                Text(info?.centerTitle ?? "",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Container(
                  child: DefaultTextStyle(
                    style: const TextStyle(fontSize: 12, height: 1.5),
                    maxLines: 1,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: detailTexts),
                  ),
                ),
                const Spacer(),
                if (info?.baseInfo?.video == 1)
                  SizedBox(
                    height: 20,
                    child: OutlinedButton(
                        onPressed: () async {
                          Utils.onEvent('bsxq_dhzb');
                          Api.getVideoList(info?.baseInfo?.id ?? 0, 1)
                              .then((value) async {
                            if (value != null && value.isNotEmpty) {
                              final index = await Get.bottomSheet(
                                  SelectBottomSheet(
                                      value.map((e) => e.name ?? '').toList(),
                                      top: '请选择直播来源'));
                              if (index != null) {
                                launchUrlString(value[index].url ?? '',
                                    mode: LaunchMode.externalApplication);
                              }
                            }
                          });
                          // final index = await Get.bottomSheet(SelectBottomSheet(
                          //     videoList!.map((e) => e.name ?? '').toList(),
                          //     top: '请选择直播来源'));
                          // if (index != null) {
                          //   launchUrlString(videoList![index].url ?? '',
                          //       mode: LaunchMode.externalApplication);

                          // }
                        },
                        style: OutlinedButton.styleFrom(
                            backgroundColor: info?.topStatusBgColor,
                            foregroundColor: Colors.white,
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 12),
                            side: BorderSide.none,
                            padding: EdgeInsets.zero,
                            minimumSize: Size(78, 20),
                            maximumSize: Size(78, 20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                                Utils.getImgPath("video_live_play.png")),
                            SizedBox(width: 5),
                            Text("视频直播")
                          ],
                        )),
                  ),
                SizedBox(height: 15)
              ],
            ).sized(width: 128),
            Expanded(
                child: _teamCol(
                    info?.baseInfo?.guestLogo ?? "",
                    info?.baseInfo?.guestNameAll ?? "",
                    info?.baseInfo?.guestRanking,
                    info?.baseInfo?.guestId ?? 0)),
          ],
        ));
    return DefaultTextStyle(
        style: const TextStyle(color: Colors.white, fontSize: 14),
        child: content);
  }

  _teamCol(String logo, String name, String? rank, int id) {
    return GestureDetector(
      // onTap: () {
      //   Utils.onEvent('bspd_djdcbs', params: {"bspd_djdcbs": 1});
      //   Get.toNamed(Routes.soccerTeamDetail, arguments: id);
      // },
      child: Column(
        children: [
          const SizedBox(height: 25),
          logo.length == 0 && info == null
              ? Styles.placeholderIcon(width: 54, height: 54)
              : CachedNetworkImage(
                  imageUrl: logo,
                  width: 50,
                  height: 50,
                  placeholder: (context, url) => Styles.placeholderIcon(),
                  errorWidget: (context, url, error) => Image.asset(
                    Utils.getImgPath("team_logo.png"),
                    fit: BoxFit.fill,
                  ),
                ),
          const SizedBox(height: 5),
          Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(rank?.isEmpty ?? true ? "" : "[${rank ?? ""}]",
              style: const TextStyle(fontSize: 11))
        ],
      ),
    );
  }
}
