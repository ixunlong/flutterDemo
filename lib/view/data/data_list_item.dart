import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sports/res/routes.dart';

import '../../model/data/data_points_entity.dart';
import '../../res/colours.dart';
import '../../res/styles.dart';
import '../../util/utils.dart';
import '../../widgets/common_dialog.dart';

class DataListItem extends StatelessWidget {
  const DataListItem(
      {Key? key,
      required this.team,
      required this.index,
      required this.qualify})
      : super(key: key);

  final TeamStanding? team;
  final int index;
  final Qualifying? qualify;

  @override
  Widget build(BuildContext context) {
    String rankImage = '';
    if (index == 0) {
      rankImage = 'rank_first.png';
    } else if (index == 1) {
      rankImage = 'rank_second.png';
    } else if (index == 2) {
      rankImage = 'rank_third.png';
    }
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        // onTap: () =>
        //     Get.toNamed(Routes.soccerTeamDetail, arguments: team?.teamId),
        child: Stack(
          children: [
            Container(
              color: index >= ((qualify?.beginRank ?? 0) - 1) &&
                      index <= ((qualify?.endRank ?? -1) - 1)
                  ? HexColor(qualify?.color ?? ("#FFFFFF"))
                  : null,
              height: 50,
              padding: const EdgeInsets.only(left: 0, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                        width: 36,
                        alignment: Alignment.center,
                        child: index < 3
                            ? Image.asset(
                                Utils.getImgPath(rankImage),
                                width: 20,
                                height: 20,
                              )
                            : Text("${team?.rank ?? "-"}",
                                style: Styles.normalText(fontSize: 13))),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(1),
                        child: CachedNetworkImage(
                            width: 24,
                            height: 24,
                            placeholder: (context, url) =>
                                Styles.placeholderIcon(),
                            errorWidget: (context, url, error) =>
                                Image.asset(Utils.getImgPath("team_logo.png")),
                            imageUrl: team?.teamLogo ?? ""),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    fit: FlexFit.tight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(team?.teamName ?? "",
                            style: const TextStyle(
                                fontSize: 13, color: Colours.text_color),
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  Flexible(flex: 8, child: _itemTeam()),
                ],
              ),
            ),
            Positioned(
                top: 0,
                bottom: 0,
                right: 8,
                child: team?.deductionExplainCn != null &&
                        team?.deductionExplainCn != ""
                    ? GestureDetector(
                        onTap: () => Get.dialog(CommonDialog.hint("扣分说明",
                            content: team?.deductionExplainCn ?? "",
                            confirmText: "我知道了")),
                        child: Image.asset(
                            width: 12,
                            height: 12,
                            Utils.getImgPath("question_mark.png")),
                      )
                    : Container()),
            Align(
              // 替换Positioned小部件
              alignment: Alignment.center, // 让标签居中
              child: index == (qualify?.beginRank ?? 0) - 1
                  ? Container(
                      color: qualify?.tagColor != null &&
                              qualify?.tagColor != "#ffffff"
                          ? HexColor(qualify?.tagColor ?? ("#000000"))
                          : null,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(qualify?.leagueName ?? "",
                          style: const TextStyle(
                              fontSize: 10, color: Colours.white)),
                    )
                  : Container(),
            ),
          ],
        ));
  }

  Widget _itemTeam() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            width: 28,
            alignment: Alignment.center,
            child: Text(team?.totalCount.toString() ?? "0",
                style: Styles.normalText(fontSize: 13))),
        Container(
            width: 60,
            alignment: Alignment.center,
            child: Text(
                "${team?.winCount ?? 0}/${team?.drawCount ?? 0}/${team?.loseCount ?? 0}",
                style: Styles.normalText(fontSize: 13))),
        Container(
            width: 45,
            alignment: Alignment.center,
            child: Text("${team?.getScore ?? 0}/${team?.loseScore ?? 0}",
                style: Styles.normalText(fontSize: 13))),
        Container(
            width: 28,
            alignment: Alignment.center,
            child: Text(team?.goalDifference.toString() ?? "0",
                style: Styles.normalText(fontSize: 13))),
        Container(
            width: 28,
            alignment: Alignment.center,
            child: Text(team?.integral.toString() ?? "0",
                style: Styles.normalText(fontSize: 13))),
      ],
    );
  }
}

class DataListHeader extends StatelessWidget {
  const DataListHeader({Key? key, required this.headType}) : super(key: key);

  final String headType;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 5,
          fit: FlexFit.tight,
          child: Text(headType,
                  style: Styles.normalSubText(fontSize: 13)
                      .copyWith(color: Colours.grey666666))
              .paddingOnly(left: 16),
        ),
        Flexible(
          flex: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 28,
                  alignment: Alignment.center,
                  child: Text("赛", style: Styles.normalSubText(fontSize: 13))),
              Container(
                  width: 60,
                  alignment: Alignment.center,
                  child:
                      Text("胜/平/负", style: Styles.normalSubText(fontSize: 13))),
              Container(
                  width: 45,
                  alignment: Alignment.center,
                  child:
                      Text("进/失", style: Styles.normalSubText(fontSize: 13))),
              Container(
                  width: 28,
                  alignment: Alignment.center,
                  child: Text("净", style: Styles.normalSubText(fontSize: 13))),
              Container(
                  width: 28,
                  alignment: Alignment.center,
                  child: Text("积分", style: Styles.normalSubText(fontSize: 13))),
            ],
          ),
        )
      ],
    );
  }
}
