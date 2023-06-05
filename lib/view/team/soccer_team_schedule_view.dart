import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/team/team_schedule_controller.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/widgets/loading_check_widget.dart';
import 'package:sports/widgets/no_data_widget.dart';

import '../../model/team/team_schedule_entity.dart';
import '../../res/routes.dart';
import '../../res/styles.dart';
import '../../util/utils.dart';

class SoccerTeamScheduleView extends StatefulWidget {
  const SoccerTeamScheduleView({super.key, required this.teamId});
  final int teamId;

  @override
  State<SoccerTeamScheduleView> createState() => _SoccerTeamScheduleViewState();
}

class _SoccerTeamScheduleViewState extends State<SoccerTeamScheduleView>
    with AutomaticKeepAliveClientMixin {
  late final TeamScheduleController controller =
      Get.put(TeamScheduleController(), tag: widget.teamId.toString());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TeamScheduleController>(
        initState: (state) async {
          await controller.requestYears(widget.teamId);
          await controller.requestData(widget.teamId);
          controller.isLoading = false;
          Future.delayed(const Duration(milliseconds: 500)).then((value) => controller.initObserver());
        },
        tag: widget.teamId.toString(),
        builder: (controller) {
          return LoadingCheckWidget<int>(
            isLoading: controller.isLoading,
            loading: Container(),
            data: controller.years.length,
            child: controller.isLoading
                ? Container()
                : Container(
                    color: Colours.greyF7,
                    child: Column(
                      children: [
                        _pageChoice(),
                        Expanded(
                            child: LoadingCheckWidget<int>(
                          isLoading: controller.isLoading,
                          data: controller.matchGroup?.length,
                          loading: Container(),
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: controller
                                        .years[controller.yearIndex].count ==
                                    0
                                ? const NoDataWidget()
                                : ListView(
                                    // controller: controller.scrollController,
                                    physics: const ClampingScrollPhysics(),
                                    children: List.generate(
                                        controller.matchGroup?.length ?? 0,
                                        (index) => _listItem(index).paddingOnly(bottom: (controller.matchGroup?.length == index +1)?50:0))),
                          ),
                        )),
                      ],
                    ),
                  ),
          );
        });
  }

  Widget _pageChoice() {
    return Container(
      height: 34,
      color: Colours.white,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 12, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
              await controller.showDatePicker();
              await controller.requestData(widget.teamId);
              await Future.delayed(const Duration(microseconds: 500)).then(
                  (value) => controller.observerController.jumpTo(
                      index: controller.years[controller.yearIndex].year
                                  .toString() ==
                              DateTime.now().formatedString('yyyy')
                          ? controller.data?.matchGroup?.indexWhere((element) =>
                                  element.title ==
                                  DateTime.now().formatedString('yyyy-MM')) ??
                              0
                          : (controller.data?.matchGroup?.length ?? 1) - 1));
            },
            child: Container(
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
                    Text("${controller.years[controller.yearIndex].year ?? ''}",
                        strutStyle: Styles.centerStyle(fontSize: 12),
                        style: const TextStyle(
                            fontSize: 12, color: Colours.text_color)),
                    const SizedBox(width: 2),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Image.asset(Utils.getImgPath('down_arrow.png')),
                    )
                  ]),
            ),
          ),
          Container(width: 5),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                    controller.data?.leagueArray?.length ?? 0,
                    (childIndex) => Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () async {
                              controller.getType(childIndex);
                            },
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
                                  controller.data?.leagueArray?[childIndex]
                                          .leagueName ??
                                      "",
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

  Widget _listItem(itemIndex) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 12, right: 12),
      decoration: BoxDecoration(
          color: Colours.white, borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: Get.width,
                height: 38,
                alignment: Alignment.center,
                child: Text(
                    "${(controller.matchGroup?[itemIndex].title ?? "").split('-').join('年')}月",
                    style: Styles.mediumText(fontSize: 13))),
            Column(
              children: List.generate(
                  controller.matchGroup?[itemIndex].matchArray?.length ?? 0,
                  (index) => _childItem(
                      controller.matchGroup?[itemIndex].matchArray?[index])),
            )
          ],
        ),
      ),
    );
  }

  Widget _childItem(MatchArray? entity) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.soccerMatchDetail,
          arguments: entity?.qxbMatchId),
      child: Stack(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 16),
                SizedBox(
                  width: 72,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateTime.parse(entity?.matchTime ?? '')
                          .formatedString("MM-dd HH:mm") ?? "-",
                        style: Styles.normalSubText(fontSize: 11)),
                      Text(
                        (entity?.leagueName!=null && entity?.leagueName!=''
                          ?"${entity!.leagueName}\u2000":"") +
                        (entity?.groupCn != null && entity?.groupCn!=''
                          ?entity!.groupCn!:""),
                        style: Styles.normalSubText(fontSize: 11),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
                Container(width: 7),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(entity?.homeName ?? "-",
                        style: Styles.normalText(fontSize: 13),
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Container(
                    alignment: Alignment.centerRight,
                    width: 21,
                    height: 21,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: CachedNetworkImage(
                        placeholder: (context, url) => Styles.placeholderIcon(),
                        errorWidget: (context, url, error) =>
                            Image.asset(Utils.getImgPath("team_logo.png")),
                        imageUrl: entity?.homeLogo ?? ""),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(controller.formScore(1, entity),
                          style: Styles.mediumText(fontSize: 15)),
                      controller.formScore(2, entity) == ""
                          ? Container()
                          : Text(controller.formScore(2, entity),
                              style: Styles.normalSubText(fontSize: 10))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Container(
                    width: 21,
                    height: 21,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            Styles.placeholderIcon(),
                        errorWidget: (context, url, error) =>
                            Image.asset(Utils.getImgPath("team_logo.png")),
                        imageUrl: entity?.guestLogo ?? ''),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(entity?.guestName ?? '-',
                        style: Styles.normalText(fontSize: 13),
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start),
                  ),
                ),
                Container(width: 10)
              ],
            ),
          ),
          if(entity?.isWin!=null)
          Positioned(
              right: 0,top: 0,
              child: Container(
                  height: 14,width: 14,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(2),topRight: Radius.circular(2)),
                      color: [Colours.green,Colours.main,Colours.grey_color1][entity!.isWin!]
                  ),
                  child: Text(["负","胜","平"][entity.isWin!],style: TextStyle(fontSize: 10,color: Colors.white))
              ))
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
