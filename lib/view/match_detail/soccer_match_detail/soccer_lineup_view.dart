import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/match/soccer_match_lineup_controller.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/match_detail/soccer_match_detail/soccer_first_team_view.dart';
import 'package:sports/widgets/no_data_widget.dart';

import '../../../res/routes.dart';
import '../../../res/styles.dart';

class SoccerLineupView extends StatefulWidget {
  const SoccerLineupView({super.key});

  @override
  State<SoccerLineupView> createState() => _SoccerLineupViewState();
}

class _SoccerLineupViewState extends State<SoccerLineupView>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.put(SoccerMatchLineupController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SoccerMatchLineupController>(builder: (_) {
      return ListView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
          children: [
        Container(
          padding: const EdgeInsets.only(top: 10),
          color: Colours.greyF5F5F5,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                color: Colours.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('首发阵容',style: Styles.mediumText(fontSize: 16)),
                            Container(width: 4),
                            Text("点击球员查看个人统计",
                                style: Styles.normalSubText(fontSize: 12)
                                    .copyWith(color: Colours.grey_color1)),
                          ],
                        ),
                        Container(
                          // constraints: const BoxConstraints(maxWidth: 53,maxHeight: 23),
                          decoration: BoxDecoration(
                            // color: Colours.redFFF2F2,
                            borderRadius: BorderRadius.circular(15)
                          ),
                          child: Container(
                            height: 22,
                            decoration: BoxDecoration(
                              color: Colours.redFFF2F2,
                              borderRadius: BorderRadius.circular(15)
                            ),
                            child: ToggleButtons(
                              splashColor: Colours.transparent,
                              borderRadius: BorderRadius.circular(15),
                              constraints: const BoxConstraints(minWidth: 54,minHeight:22),
                              onPressed: (index) => controller.lineupChoice(index),
                              isSelected: controller.isSelected,
                              borderColor: Colours.main,
                              color: Colours.redFFF2F2,
                              selectedBorderColor: Colours.main,
                              fillColor: Colours.main,
                              children: [
                                Text("上场",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: controller.isSelected[0]
                                      ? Colours.white
                                      : Colours.main)),
                                Text("本场",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: controller.isSelected[1]
                                        ? Colours.white
                                        : Colours.main)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ((controller.data?.guestLineup == null ||
              controller.data?.homeLineup == null ||
              controller.data?.homeLineup?.length == 0 ||
              controller.data?.guestLineup?.length == 0))?
              Container(width: Get.width, height: 600, color: Colours.white,
                child: NoDataWidget(
                  needPic: false,
                  tip: "暂无${controller.isSelected[0]?"上场":"本场"}首发阵容"
                ))
              :controller.data?.homeLineup?.length != 11 ||
                controller.data?.guestLineup?.length != 11
              ? Container()
              : Column(
                children: [
                const SoccerFirstTeamView(),
                _iconWidget(),
                const SizedBox(height: 10),
                _backup(),
                controller.data?.homeSuspend == null && controller.data?.guestSuspend == null
                    ?Container():Padding(padding: const EdgeInsets.only(top: 10),child: _suspend()),
                Container(
                  height: 60,
                  color: Colours.white,
                )
                ],
              )
            ],
          ),
        ),
      ]);
    });
  }

  Widget _iconWidget() {
    return Container(
      height: 80,
      color: Colours.white,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              5,
              (index) => Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(Utils.getImgPath(controller.icon[index])),
                  const SizedBox(width: 5),
                  Text(controller.title[index],
                    style: TextStyle(fontSize: 12, height: 1))
                ],
              ))),
          Container(height: 10),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                4,
                (index) => Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(Utils.getImgPath(controller.icon[5+index])),
                    const SizedBox(width: 5),
                    Text(controller.title[5 + index],
                        style: TextStyle(fontSize: 12, height: 1))
                  ],
                ))),
        ],
      ),
    );
  }

  Widget _backup() {
    return Container(
      color: Colours.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text('替补席',
              style: TextStyle(
                  fontSize: 16,
                  color: Colours.text_color,
                  fontWeight: FontWeight.w500)),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: _backupList(isHome: true)
            ),
            Container(width: 16),
            Flexible(
              child: _backupList(isHome: false),
              ),
          ],
        ),
      ]),
    );
  }

  Widget _backupList({required bool isHome}){
    return Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                stops: const [0,0.85],
                colors: isHome?[Colours.redFFDBDB,Colours.white]
                  :[Colours.blueE1ECFF,Colours.white]),
            ),
            child: Row(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    width: 26,
                    height: 26,
                    placeholder: (context, url) => Styles.placeholderIcon(),
                    errorWidget: (context, url, error,) => Image.asset(Utils.getImgPath("team_logo.png")),
                    imageUrl: isHome?
                    controller.detail.info?.baseInfo?.homeLogo ?? ""
                    :controller.detail.info?.baseInfo?.guestLogo ?? ""),
                ),
                Container(width: 11),
                Text(isHome?controller.detail.info?.baseInfo?.homeName ?? "":controller.detail.info?.baseInfo?.guestName ?? "",style: Styles.mediumText(fontSize: 14))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: List.generate(
                isHome?controller.data?.homeBackup?.length ?? 0
                  :controller.data?.guestBackup?.length ?? 0,
                (index) => _backupPlayerWidget(isHome, index)),
            ),
          )
        ]
    );
  }
  Widget _backupPlayerWidget(bool isHome, int index) {
    final player = isHome
        ? controller.data!.homeBackup![index]
        : controller.data!.guestBackup![index];
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if(controller.playerEvents?[player.playerId] == null){
          ToastUtils.showDismiss("该球员本场未上场，暂无技术统计");
        }else{
          if(controller.data?.isLastLineup == true){
            Get.toNamed(Routes.soccerDataDialog,
                arguments: <int>[
                  isHome?(controller.data?.homeQxbMatchId ?? 0)
                    :(controller.data?.guestQxbMatchId ?? 0),
                  int.parse(player.playerId ?? "0")
                ]);
          }else {
            Get.toNamed(Routes.soccerDataDialog,
                arguments: <int>[
                  controller.data?.matchId ?? 0,
                  int.parse(player.playerId ?? "0")
                ]);
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 14,top: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: ClipOval(
              child: Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                color: isHome ? Colours.homeColorRed : Colours.guestColorBlue,
                child: Text(
                  player.number ?? '',
                  style: const TextStyle(
                      color: Colours.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (player.nameCn ?? player.nameEn) ?? '',
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Colours.text_color,
                      fontWeight: FontWeight.w500),
                ),
                Text(player.positionName ?? '',
                  style: const TextStyle(
                    fontSize: 11, height: 1.4, color: Colours.grey_color1))
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: controller.playerEvents == null ||
              controller.playerEvents?[player.playerId] == null
            ? Container(width: 40)
            : Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ///上下场
                        controller.playerEvents?[player.playerId]?[0].length != 0
                            ? Image.asset(Utils.getImgPath(controller.icon[
                                controller.title.indexOf(controller
                                    .playerEvents?[player.playerId]?[0])]))
                            : Container(),
                        controller.playerEvents?[player.playerId]?[1].length != 0
                            ? Padding(
                                padding: const EdgeInsets.only(left: 2),
                                child: Text(
                                  "${controller.playerEvents?[player.playerId]?[1]}'",
                                  style: Styles.normalSubText(fontSize: 11
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3, right: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ///红黄牌
                        controller.playerEvents?[player.playerId]?[2].length != 0
                            ? Image.asset(Utils.getImgPath(controller.icon[
                                controller.title.indexOf(controller
                                    .playerEvents?[player.playerId]?[2]
                                    .trim())]))
                            : Container(),

                        ///进球点球乌龙
                        controller.playerEvents?[player.playerId]?[3].length != 0
                            ? Image.asset(Utils.getImgPath(controller.icon[
                                controller.title.indexOf(controller
                                    .playerEvents?[player.playerId]?[3]
                                    .trim())]))
                            : Container(),

                        ///失点
                        controller.playerEvents?[player.playerId]?[4].length != 0
                            ? Image.asset(Utils.getImgPath(controller.icon[
                                controller.title.indexOf(controller
                                    .playerEvents?[player.playerId]?[4]
                                    .trim())]))
                            : Container(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _suspend() {
    return Container(
      color: Colours.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text('伤病及禁赛球员',
              style: TextStyle(
                  fontSize: 16,
                  color: Colours.text_color,
                  fontWeight: FontWeight.w500)),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: _suspendList(isHome: true)
            ),
            const SizedBox(width: 8),
            Flexible(
              child: _suspendList(isHome: false)
            )
          ],
        ),
      ]),
    );
  }

  Widget _suspendList({required bool isHome}){
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                stops: const [0,0.85],
                colors: isHome?[Colours.redFFDBDB,Colours.white]
                    :[Colours.blueE1ECFF,Colours.white]),
          ),
          child: Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                    width: 26,
                    height: 26,
                    placeholder: (context, url) => Styles.placeholderIcon(),
                    errorWidget: (context, url, error,) => Image.asset(Utils.getImgPath("team_logo.png")),
                    imageUrl: isHome?
                    controller.detail.info?.baseInfo?.homeLogo ?? ""
                        :controller.detail.info?.baseInfo?.guestLogo ?? ""),
              ),
              Container(width: 11),
              Text(isHome?
              controller.detail.info?.baseInfo?.homeName ?? ""
              :controller.detail.info?.baseInfo?.guestName ?? "",
              style: Styles.mediumText(fontSize: 14))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: (isHome?(controller.nowData?[1]?.homeSuspend?.length == 0 ||
            controller.nowData?[1]?.homeSuspend == null)
            :(controller.nowData?[1]?.guestSuspend?.length == 0 ||
            controller.nowData?[1]?.guestSuspend == null))
            ? Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Text('暂无数据',
              style: TextStyle(
                fontSize: 11, color: Colours.grey_color1)))
            : Column(
          children: List.generate(
            isHome == true?controller.nowData![1]!.homeSuspend!.length
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

  @override
  bool get wantKeepAlive => true;
}
