import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/match/soccer_match_lineup_controller.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/utils.dart';

import '../../../res/styles.dart';

class SoccerSuspendView extends StatefulWidget {
  const SoccerSuspendView({super.key});

  @override
  State<SoccerSuspendView> createState() => _SoccerSuspendViewState();
}

class _SoccerSuspendViewState extends State<SoccerSuspendView> {
  final controller = Get.put(SoccerMatchLineupController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SoccerMatchLineupController>(builder: (_) {
      return ListView(padding: EdgeInsets.zero, children: [
        Container(
          padding: EdgeInsets.only(top: 10),
          color: Colours.greyF5F5F5,
        ),
        _suspend(),
        Container(
          height: 60,
          color: Colours.white,
        )
      ]);
    });
  }

  Widget _suspend() {
    return Container(
      color: Colours.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: const Text('伤病及禁赛球员',
              style: TextStyle(
                  fontSize: 16,
                  color: Colours.text_color,
                  fontWeight: FontWeight.w500)),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(child: _suspendList(isHome: true)),
            const SizedBox(width: 8),
            Flexible(child: _suspendList(isHome: false))
          ],
        ),
      ]),
    );
  }

  Widget _suspendList({required bool isHome}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                stops: const [0, 0.85],
                colors: isHome
                    ? [Colours.redFFDBDB, Colours.white]
                    : [Colours.blueE1ECFF, Colours.white]),
          ),
          child: Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                    width: 26,
                    height: 26,
                    placeholder: (context, url) => Styles.placeholderIcon(),
                    errorWidget: (
                      context,
                      url,
                      error,
                    ) =>
                        Image.asset(Utils.getImgPath("team_logo.png")),
                    imageUrl: isHome
                        ? controller.detail.info?.baseInfo?.homeLogo ?? ""
                        : controller.detail.info?.baseInfo?.guestLogo ?? ""),
              ),
              Container(width: 11),
              Text(
                  isHome
                      ? controller.detail.info?.baseInfo?.homeName ?? ""
                      : controller.detail.info?.baseInfo?.guestName ?? "",
                  style: Styles.mediumText(fontSize: 14))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: (isHome
                  ? (controller.nowData?[1]?.homeSuspend?.length == 0 ||
                      controller.nowData?[1]?.homeSuspend == null)
                  : (controller.nowData?[1]?.guestSuspend?.length == 0 ||
                      controller.nowData?[1]?.guestSuspend == null))
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Text('暂无数据',
                      style:
                          TextStyle(fontSize: 11, color: Colours.grey_color1)))
              : Column(
                  children: List.generate(
                      isHome == true
                          ? controller.nowData![1]!.homeSuspend!.length
                          : controller.nowData![1]!.guestSuspend!.length,
                      (index) => _suspendPlayer(isHome, index)),
                ),
        ),
      ],
    );
  }

  Widget _suspendPlayer(bool isHome, int index) {
    final player = isHome
        ? controller.nowData![1]!.homeSuspend![index]
        : controller.nowData![1]!.guestSuspend![index];
    var reasonImage = '';
    if (player.kind == 0 || player.kind == 1 || player.kind == 2) {
      reasonImage = 'icon_jinsai.png';
    } else if (player.kind != 99) {
      reasonImage = 'icon_shangbing.png';
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        ClipOval(
          child: Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            color: isHome ? Colours.homeColorRed : Colours.guestColorBlue,
            child: Text(
              player.number ?? '',
              style: const TextStyle(
                  color: Colours.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      (player.nameChs) ?? '',
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colours.text_color,
                          fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  if (reasonImage.isNotEmpty)
                    Image.asset(Utils.getImgPath(reasonImage))
                ],
              ),
              Text('${player.position ?? ''} ${player.reason ?? ''}',
                  style:
                      const TextStyle(fontSize: 11, color: Colours.grey_color1))
            ],
          ),
        )
      ]),
    );
  }
}
