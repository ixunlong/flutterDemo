import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/basketball/bb_detail_head_entity.dart';
import 'package:sports/model/basketball/bb_match_detail_entity.dart';
import 'package:sports/model/match/match_video_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/select_bottomsheet.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BbDetailHeadWidget extends StatefulWidget {
  const BbDetailHeadWidget({super.key, this.detail, this.id});

  final BbDetailHeadInfoEntity? detail;
  final int? id;
  // final List<MatchVideoEntity>? videoList;

  @override
  State<BbDetailHeadWidget> createState() => _BbDetailHeadWidgetState();
}

class _BbDetailHeadWidgetState extends State<BbDetailHeadWidget> {
  BbDetailHeadInfoEntity? get detail => widget.detail;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white),
      child: Container(
        color: Colours.main_color,
        height: 146,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _team(detail?.awayTeamName ?? "", detail?.awayPosition ?? "",
                detail?.awayTeamLogo ?? ""),
            _matchStatus(),
            _team(detail?.homeTeamName ?? "", detail?.homePosition ?? "",
                detail?.homeTeamLogo ?? "",
                isHome: true),
          ],
        ),
      ),
    );
  }

  Widget _team(String name, String rank, String icon, {bool isHome = false}) {
    String n = isHome ? '主' : '客';
    if (rank.isNotEmpty) {
      n = '$n/$rank';
    }
    return Expanded(
      child: GestureDetector(
        // onTap: () {
        //   final id = isHome ? detail?.homeTeamId : detail?.awayTeamId;
        //   Get.toNamed(Routes.basketTeamDetail, arguments: id);
        // },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon.length == 0 && detail == null
                ? Styles.placeholderIcon(width: 54, height: 54)
                : CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: icon,
                    placeholder: (context, url) => Styles.placeholderIcon(),
                    errorWidget: (context, url, error) => Image.asset(
                      Utils.getImgPath('basket_team_logo.png'),
                      width: 54,
                      height: 54,
                    ),
                  ).sized(width: 54, height: 54),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 3),
            Text("[$n]", style: const TextStyle(fontSize: 10), maxLines: 1)
          ],
        ),
      ),
    );
  }

  Widget _matchStatus() {
    if (detail?.statusId == 1 && detail?.matchDateTime != null) {
      final date = detail!.matchDateTime!;
      return Container(
        width: 140,
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: 15),
        child: Column(children: [
          SizedBox(height: 35),
          Text(detail?.timeDesc ?? "", style: const TextStyle(fontSize: 22)),
          Spacer(),
          if (detail?.video == 1) videoWidget()
          // ],
        ]),
      );
    }
    return Container(
      width: 140,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 5),
          if (detail?.statusId == 10)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  // width: 45,
                  // height: 21,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: const Color(0x6EFDFDFD),
                      borderRadius: BorderRadius.circular(2)),
                  alignment: Alignment.center,
                  child: const Text(
                    "完场",
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          if (detail?.statusId != 10)
            Text((detail?.statusMap[detail?.statusId] ?? "") +
                (detail?.getRemainingTime ?? "")),
          Text(
            "${detail?.awayScore ?? ""} - ${detail?.homeScore ?? ''}",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
          if (detail?.halfScore != null) Text(detail?.halfScore ?? ''),
          if (detail?.matchPursueScore != null && detail?.matchScore != null)
            Text("差 ${detail?.matchPursueScore}  总 ${detail?.matchScore}"),
          Spacer(),
          if (detail?.video == 1) videoWidget(),
        ].map((e) => e is Spacer ? e : e.marginOnly(bottom: 4)).toList(),
      ),
    );
  }

  Widget videoWidget() {
    return SizedBox(
      height: 20,
      child: OutlinedButton(
          onPressed: () async {
            Utils.onEvent('bsxq_dhzb');
            Api.getVideoList(widget.id ?? 0, 2).then((value) async {
              if (value != null && value.isNotEmpty) {
                final index = await Get.bottomSheet(SelectBottomSheet(
                    value.map((e) => e.name ?? '').toList(),
                    top: '请选择直播来源'));
                if (index != null) {
                  launchUrlString(value[index].url ?? '',
                      mode: LaunchMode.externalApplication);
                }
              }
            });
            // final index = await Get.bottomSheet(SelectBottomSheet(
            //     widget.videoList!.map((e) => e.name ?? '').toList(),
            //     top: '请选择直播来源'));
            // if (index != null) {
            //   launchUrlString(widget.videoList![index].url ?? '',
            //       mode: LaunchMode.externalApplication);
            // launchUrlString(urlString)
            // Get.toNamed(Routes.webview, arguments: {
            //   "url": videoList![index].url ?? ''
            // });
            // }
          },
          style: OutlinedButton.styleFrom(
              backgroundColor: Color(0x6EFDFDFD),
              foregroundColor: Colors.white,
              textStyle: TextStyle(color: Colors.white, fontSize: 12),
              side: BorderSide.none,
              padding: EdgeInsets.zero,
              minimumSize: Size(78, 20),
              maximumSize: Size(78, 20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(Utils.getImgPath("video_live_play.png")),
              SizedBox(width: 5),
              Text("视频直播")
            ],
          )),
    );
  }
}
