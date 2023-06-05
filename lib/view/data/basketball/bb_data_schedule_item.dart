import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/res/routes.dart';

import '../../../model/data/basket/basket_schedule_entity.dart';
import '../../../res/colours.dart';
import '../../../res/styles.dart';
import '../../../util/utils.dart';

class BbDataScheduleItem extends StatelessWidget {
  const BbDataScheduleItem({Key? key, required this.data}) : super(key: key);

  final BasketScheduleEntity? data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(height: 16),
        Text(data!.kindName!,
          style: Styles.mediumText(fontSize: 13)),
        Container(height: 16),
        Column(
          children: List.generate(
            data?.scheduleList?.length ?? 0,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BbDataScheduleSingleItem(
                scheduleList: data!.scheduleList![index]),
            ))),
      ],
    );
  }
}

class BbDataScheduleSingleItem extends StatelessWidget {
  const BbDataScheduleSingleItem(
      {Key? key, required this.scheduleList, this.color = Colours.white})
      : super(key: key);

  final ScheduleList? scheduleList;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
          // Utils.onEvent("sjpd_sc_djdcbs");
          Get.toNamed(Routes.basketMatchDetail, arguments: scheduleList?.id);
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
              child: Text((scheduleList?.matchTime ?? '').length > 11?DateTime.tryParse(scheduleList?.matchTime ?? "")!.formatedString("MM-dd HH:mm"):(scheduleList?.matchTime ?? ""),
                style: const TextStyle(fontSize: 12, color: Colours.grey66))),
            Flexible(
              flex: 5,
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(scheduleList?.awayName ?? '',
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
                      imageUrl: scheduleList?.awayLogo ?? ''),
                )),
            Container(
              width: 54,
              alignment: Alignment.center,
              child: scheduleList?.statusId == 10
                ? scheduleList?.homeScore == null ? Container()
                  : Text('${scheduleList?.awayScore}-${scheduleList?.homeScore}',
                    style: Styles.mediumText(fontSize: 12))
                : Text(formScore(),
                    style: TextStyle(
                        fontSize: 15,
                        color: color == Colours.transparent
                            ? Colours.grey99
                            : Colours.text_color1))),
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
                      imageUrl: scheduleList?.homeLogo ?? ''),
                )),
            Flexible(
                flex: 5,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(scheduleList?.homeName ?? '',
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

  String formScore(){
    switch(scheduleList?.statusId){
      // case 10:
      //   if(scheduleList?.awayScore != null && scheduleList?.homeScore != null) {
      //     return "${scheduleList?.awayScore!}-${scheduleList?.homeScore!}";
      //   }else{
      //     return "vs";
      //   }
      case 12:
        return "取消";
      case 11:
        return "中断";
      case 14:
        return "腰斩";
      case 13:
        return "延期";
      case 15:
        return "待定";
      default:
        return "vs";

    }
  }

}
