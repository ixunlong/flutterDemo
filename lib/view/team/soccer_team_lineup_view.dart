import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/team/team_lineup_controlller.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/widgets/loading_check_widget.dart';

import '../../logic/team/soccer_team_detail_controller.dart';
import '../../model/team/team_lineup_entity.dart';
import '../../res/styles.dart';
import '../../util/utils.dart';

class SoccerTeamLineupView extends StatefulWidget {
  const SoccerTeamLineupView({super.key, required this.teamId});
  final int teamId;

  @override
  State<SoccerTeamLineupView> createState() => _SoccerTeamLineupViewState();
}

class _SoccerTeamLineupViewState extends State<SoccerTeamLineupView> {
  late final TeamLineupController controller =
      Get.put(TeamLineupController(), tag: widget.teamId.toString());
  late final SoccerTeamDetailController team =
      Get.find<SoccerTeamDetailController>(tag: widget.teamId.toString());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TeamLineupController>(
        initState: (state) => controller.requestData(widget.teamId),
        tag: widget.teamId.toString(),
        builder: (controller) {
          return LoadingCheckWidget<bool>(
            isLoading: controller.isLoading,
            data:
                controller.data.every((element) => element.player?.length == 0),
            loading: Container(),
            child: Container(
              color: Colours.greyF7,
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                itemCount: controller.data.length,
                padding: const EdgeInsets.only(left: 12, right: 12),
                itemBuilder: (BuildContext context, int index) =>
                    _listItem(index).paddingOnly(bottom: controller.data.length == index+1?50:0)
              ),
            ),
          );
        });
  }

  Widget _listItem(itemIndex) {
    return controller.data[itemIndex].player == null ||
            controller.data[itemIndex].player?.length == 0
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colours.white),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 16, left: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                            fit: FlexFit.tight,
                            flex: 8,
                            child: Text(controller.data[itemIndex].title ?? "",
                                style: Styles.mediumText(fontSize: 16))),
                        Flexible(
                            fit: FlexFit.tight,
                            flex: 4,
                            child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                    controller.data[itemIndex].player?.any((element) => element.value != null && element.value != "") == true?
                                    itemIndex == 0? "身价(英镑)"
                                        : (team.data?.type == "1" ||
                                                team.data?.type == "2"
                                            ? "俱乐部/身价(英镑)"
                                            : "身价(英镑)"):"",
                                    style: Styles.normalSubText(fontSize: 12))))
                      ],
                    ),
                    Container(height: 8),
                    Flexible(
                      child: Column(
                        children: List.generate(
                            controller.data[itemIndex].player?.length ?? 0,
                            (index) => _childItem(
                                controller.data[itemIndex].player?[index],itemIndex)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  Widget _childItem(Player? player,itemIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CachedNetworkImage(
                  height: 32,
                  width: 24,
                  fit: BoxFit.cover,
                  imageUrl: player?.photo ?? "",
                  placeholder: (context, url) => Styles.placeholderIcon(),
                  errorWidget: (context, url, error) => Image.asset(
                    Utils.getImgPath('team_logo.png'),
                    height: 32,
                    width: 24,
                  ),
                ),
                Container(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: Text(player?.playerCn ?? "",
                            style: Styles.normalText(fontSize: 13))),
                    if((player?.number != null && player?.number != ""
                        ? "${player!.number}号\u2000"
                        : "") +
                        (player?.age != null && player?.age != ""
                            ? "${player!.age}岁\u2000"
                            : "") +
                        (player?.countryCn != null &&
                            player?.countryCn != "" &&
                            (team.data?.nameChs != player?.countryCn)
                            ? "${player?.countryCn}"
                            : "")!="") Text(
                        (player?.number != null && player?.number != ""
                                ? "${player!.number}号\u2000"
                                : "") +
                            (player?.age != null && player?.age != ""
                                ? "${player!.age}岁\u2000"
                                : "") +
                            (player?.countryCn != null &&
                                    player?.countryCn != "" &&
                                    (team.data?.nameChs != player?.countryCn)
                                ? "${player?.countryCn}"
                                : ""),
                        style: Styles.normalSubText(fontSize: 11))
                  ],
                )
              ],
            ),
          ),
          Flexible(
              flex: 4,
              fit: FlexFit.tight,
              child: controller.data[itemIndex].player?.any((element) => element.value != null && element.value != "") == true?
              (player?.teamCn == null || player?.teamCn == "") &&
                      (player?.value == null ||
                          player?.value == "" ||
                          double.parse(player?.value ?? "0") == 0)
                  ? Container(
                      alignment: Alignment.center,
                      child: Text("-", style: Styles.normalText(fontSize: 13)))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        player?.type == 1 || player?.type == 2
                            ? player?.place == "主教练"
                                ? Container()
                                : Text(player?.teamCn ?? "-",
                                    style: Styles.mediumText(fontSize: 11),
                                    textAlign: TextAlign.center)
                            : Container(),
                        Text(
                            player?.value != null &&
                                    player?.value != "" &&
                                    double.parse(player?.value ?? "0") > 0
                                ? "${player!.value}万"
                                : "-",
                            style: Styles.normalText(fontSize: 13)),
                      ],
                    ):Text(""))
        ],
      ),
    );
  }
}
