import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/model/data/data_schedule_entity.dart';
import 'package:sports/res/routes.dart';

import '../../res/colours.dart';
import '../../res/styles.dart';
import '../../util/utils.dart';

class DataScheduleItem extends StatelessWidget {
  const DataScheduleItem({Key? key, required this.data}) : super(key: key);

  final DataScheduleEntity? data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(height: 16),
        Text(
            // RegExp(r"[0-9]").hasMatch(data!.round!)?
            // "第${data!.round!}轮":
            data!.round!,
            style: Styles.mediumText(fontSize: 13)),
        Container(height: 16),
        Column(
            children: List.generate(
                data?.teamList?.length ?? 0,
                (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DataScheduleSingleItem(
                          teamList: data!.teamList![index]),
                    ))),
      ],
    );
  }
}

class DataScheduleSingleItem extends StatelessWidget {
  const DataScheduleSingleItem(
      {Key? key, required this.teamList, this.color = Colours.white})
      : super(key: key);

  final TeamList? teamList;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (teamList?.matchId != null) {
          Utils.onEvent("sjpd_sc_djdcbs");
          Get.toNamed(Routes.soccerMatchDetail, arguments: teamList?.matchId);
        }
        ;
      },
      child: Container(
        height: 50,
        color: color,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                flex: 5,
                fit: FlexFit.tight,
                child: Text(
                    teamList?.matchTime != null
                        ? DateTime.parse(teamList?.matchTime ?? "")
                            .formatedString("MM-dd HH:mm")
                        : "",
                    style: TextStyle(fontSize: 12, color: Colours.grey66))),
            Flexible(
                flex: 5,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(teamList?.homeName ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      color: color == Colours.transparent
                        ? Colours.grey66
                        : Colours.text_color1),
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end),
                )),
            Flexible(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  width: 21,
                  height: 21,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: CachedNetworkImage(
                      fit: BoxFit.fitWidth,
                      placeholder: (context, url) => Styles.placeholderIcon(),
                      errorWidget: (context, url, error) =>
                          Image.asset(Utils.getImgPath("team_logo.png")),
                      imageUrl: teamList?.homeLogo ?? ''),
                )),
            Flexible(
                flex: 3,
                child: Container(
                    alignment: Alignment.center,
                    child: teamList?.status == 7
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              teamList?.homeScore90 == null
                                  ? Container()
                                  : Text(
                                      '${teamList?.homeScore90}-${teamList?.guestScore90}',
                                      style: Styles.mediumText(fontSize: 15)),
                              scoreMore()
                            ],
                          )
                        : Text(statusCheck(),
                            style: TextStyle(
                                fontSize: 15,
                                color: color == Colours.transparent
                                    ? Colours.grey99
                                    : Colours.text_color1)))),
            Flexible(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  width: 21,
                  height: 21,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: CachedNetworkImage(
                      fit: BoxFit.fitWidth,
                      errorWidget: (context, url, error) =>
                          Image.asset(Utils.getImgPath("team_logo.png")),
                      placeholder: (context, url) => Styles.placeholderIcon(),
                      imageUrl: teamList?.guestLogo ?? ''),
                )),
            Flexible(
                flex: 5,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(teamList?.guestName ?? '',
                      style: TextStyle(
                          fontSize: 13,
                          color: color == Colours.transparent
                              ? Colours.grey66
                              : Colours.text_color1),
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start),
                )),
          ],
        ),
      ),
    );
  }

  Widget scoreMore() {
    if (teamList?.homeScoreOt != null && teamList?.homeScorePk == null) {
      return Text('加时 ${teamList?.homeScoreOt}-${teamList?.guestScoreOt}',
          style: Styles.normalSubText(fontSize: 10));
    } else if (teamList?.homeScoreOt == null && teamList?.homeScorePk != null) {
      return Text('点球 ${teamList?.homeScorePk}-${teamList?.guestScorePk}',
          style: Styles.normalSubText(fontSize: 10));
    } else if (teamList?.homeScoreOt != null && teamList?.homeScorePk != null) {
      return Text('加｜点', style: Styles.normalSubText(fontSize: 10));
    } else {
      return Container();
    }
  }

  String statusCheck() {
    switch (teamList?.status) {
      case 8:
        return "取消";
      case 9:
        return "中断";
      case 10:
        return "腰斩";
      case 11:
        return "延期";
      case 12:
        return "待定";
      default:
        return "vs";
    }
  }
}
