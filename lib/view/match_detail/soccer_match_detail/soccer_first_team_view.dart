import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/match/soccer_match_lineup_controller.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';

class SoccerFirstTeamView extends StatefulWidget {
  const SoccerFirstTeamView({super.key});

  @override
  State<SoccerFirstTeamView> createState() => _SoccerFirstTeamViewState();
}

class _SoccerFirstTeamViewState extends State<SoccerFirstTeamView> {
  List<double> homeX = [];
  List<double> homeY = [];
  List<double> guestX = [];
  final _soccerFieldHeight = (Get.width - 20) / 686 * 1330;
  final lineupController = Get.find<SoccerMatchLineupController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SoccerMatchLineupController>(
      builder: (_) {
        return Container(
          color: Colours.green00985F,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              lineupController.data?.weatherCn == null || lineupController.data?.locationCn == null ||
                  lineupController.data?.weatherCn == '' || lineupController.data?.locationCn == ''?
              Container(height: 7)
              :Padding(
                padding: const EdgeInsets.only(top: 18.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("${lineupController.data?.temp}  ${lineupController.data?.weatherCn}",
                        style: const TextStyle(fontSize: 11, color: Colours.white)
                    ),
                    Row(
                      children: [
                        Image.asset(width: 12, height: 12, Utils.getImgPath("icon_qiuchang.png")),
                        Container(width: 3),
                        Text(lineupController.data?.locationCn ?? "",
                            style: const TextStyle(fontSize: 11, color: Colours.white,fontWeight: FontWeight.w300)
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 24,top: 17),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Image.asset(
                      Utils.getImgPath('soccer_playground.png'),
                      height: _soccerFieldHeight,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                    Positioned(
                      top: 5,
                      left: 13,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          lineupController.data?.isLastLineup == false?Container():Row(
                            children: [
                              CachedNetworkImage(
                                  height: 18,
                                  width: 18,
                                  fit: BoxFit.fitHeight,
                                  placeholder: (context, url) => Styles.placeholderIcon(),
                                  errorWidget: (context, url, error,) => Image.asset(Utils.getImgPath("team_logo.png")),
                                  imageUrl: lineupController.detail.info?.baseInfo?.homeLogo ?? ""),
                              Container(width: 5),
                              Text(lineupController.detail.info?.baseInfo?.homeName ?? "",style: Styles.normalText(fontSize: 10).copyWith(color: Colours.white))
                            ],
                          ),
                          lineupController.data?.homeCoachName == null
                            || lineupController.data?.homeCoachName == ''?Container()
                            : Text("教练：${lineupController.data!.homeCoachName?.trim()}",
                            style: const TextStyle(fontSize: 10, color: Colours.white,fontWeight: FontWeight.w300)),
                        ],
                      )
                    ),
                    Positioned(
                      top: 5,
                      right: 13,
                      child: lineupController.data?.isLastLineup == false?Container():
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(lineupController.lastMatchScore(true),style: Styles.normalSubText(fontSize: 11).copyWith(color: Colours.greyEE)),
                          lineupController.data?.homeUmpire == null
                            || lineupController.data?.homeUmpire == ''?Container()
                            : Text("主裁判：${lineupController.data!.homeUmpire?.trim()}",
                              style: Styles.normalSubText(fontSize: 10).copyWith(color: Colours.greyEE)),
                        ],
                      )
                    ),
                    Positioned(
                      bottom: 5,
                      left: 13,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          lineupController.data?.isLastLineup == false?Container():Row(
                            children: [
                              CachedNetworkImage(
                                height: 18,
                                width: 18,
                                fit: BoxFit.fitHeight,
                                placeholder: (context, url) => Styles.placeholderIcon(),
                                errorWidget: (context, url, error,) => Image.asset(Utils.getImgPath("team_logo.png")),
                                imageUrl: lineupController.detail.info?.baseInfo?.guestLogo ?? ""),
                              Container(width: 5),
                              Text(lineupController.detail.info?.baseInfo?.guestName ?? "",style: Styles.normalText(fontSize: 10).copyWith(color: Colours.white))
                            ],
                          ),
                          lineupController.data?.guestCoachName == null
                            || lineupController.data?.guestCoachName == ''?Container()
                            : Text("教练：${lineupController.data!.guestCoachName?.trim()}",
                            style: const TextStyle(fontSize: 10, color: Colours.white)),
                        ],
                      )
                    ),
                    Positioned(
                      bottom: 5,
                      right: 13,
                      child: lineupController.data?.isLastLineup == false?Container():
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(lineupController.lastMatchScore(false),style: Styles.normalSubText(fontSize: 11).copyWith(color: Colours.greyEE)),
                          lineupController.data?.guestUmpire == null
                              || lineupController.data?.guestUmpire == ''?Container()
                              : Text("主裁判：${lineupController.data!.guestUmpire?.trim()}",
                              style: Styles.normalSubText(fontSize: 10).copyWith(color: Colours.greyEE)),
                        ],
                      )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Container(width: 13),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("阵型 ${lineupController.toArray("home")}",
                                style: const TextStyle(fontSize: 10, color: Colours.white,fontWeight: FontWeight.w300)),
                            const SizedBox(height: 12),
                            Text("阵型 ${lineupController.toArray("guest")}",
                                style:
                                    const TextStyle(fontSize: 10, color: Colours.white,fontWeight: FontWeight.w300))
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(lineupController.ageAndWorth(true),style: const TextStyle(fontSize: 10, color: Colours.white,fontWeight: FontWeight.w300)),
                          const SizedBox(height: 12),
                          Text(lineupController.ageAndWorth(false),style: const TextStyle(fontSize: 10, color: Colours.white,fontWeight: FontWeight.w300))
                        ],
                      ),
                      Container(width: 13)
                    ]),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: lineupController.data?.homeArray?.length == 5?_soccerFieldHeight/2 + 5:_soccerFieldHeight/2,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 17,bottom: 20,left: 5,right: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: getHomeLineup(),
                        ),
                      ),
                    ),
                    Positioned(
                      top: lineupController.data?.homeArray?.length == 5?_soccerFieldHeight/2:_soccerFieldHeight/2,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20,bottom: 20,left: 5,right: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: getGuestLineup(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //Container(height: 14)
            ],
          ),
        );
      }
    );
  }

  Widget _player(bool isHome, int index) {
    final player = isHome?lineupController.data!.homeLineup![index]:lineupController.data!.guestLineup![index];
    return GestureDetector(
      onTap: () {
        if(lineupController.data?.isLastLineup == true){
          Get.toNamed(Routes.soccerDataDialog,
              arguments: <int>[
                isHome?(lineupController.data?.homeQxbMatchId ?? 0)
                  :(lineupController.data?.guestQxbMatchId ?? 0),
                int.parse(player.playerId ?? "0")
              ]);
        }else {
          Get.toNamed(Routes.soccerDataDialog,
              arguments: <int>[
                lineupController.data?.matchId ?? 0,
                int.parse(player.playerId ?? "0")
              ]);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 26,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1, color: Colours.white),
                    color: isHome?Colours.homeColorRed:Colours.guestColorBlue,
                  ),
                  width: 26,
                  height: 26,
                  child: Center(
                    child: Text(
                      '${player.number}',
                      style: const TextStyle(fontSize: 13,color: Colours.white),
                    ),
                  ),
                ),
                ///红黄牌
                lineupController.playerEvents?[player.playerId]?[2].length !=0
                    && lineupController.playerEvents != null && lineupController.playerEvents?[player.playerId] != null?
                Positioned(
                    top: 0,
                    left: 13,
                    child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 0.5, color: Colours.white),
                        ),
                        child: Image.asset(
                            width: 10,
                            height: 10,
                            Utils.getImgPath(
                                lineupController.icon[
                                lineupController.title.indexOf(lineupController.playerEvents?[player.playerId]?[2].trim())
                                ]))
                    )
                ):Container(),
                ///失点
                lineupController.playerEvents?[player.playerId]?[4].length != 0
                    && lineupController.playerEvents != null && lineupController.playerEvents?[player.playerId] != null?
                Positioned(
                    top: 0,
                    right: 13,
                    child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 0.5, color: Colours.white),
                        ),
                        child: Image.asset(
                            width: 10,
                            height: 10,
                            Utils.getImgPath(
                                lineupController.icon[
                                lineupController.title.indexOf(lineupController.playerEvents?[player.playerId]?[4].trim())
                                ]))
                    )
                ):Container(),
                ///进球点球乌龙
                lineupController.playerEvents?[player.playerId]?[3].length !=0
                    && lineupController.playerEvents != null && lineupController.playerEvents?[player.playerId] != null?
                Positioned(
                    bottom: 0,
                    left: 13,
                    child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 0.5, color: Colours.white),
                        ),
                        child: Image.asset(
                            width: 10,
                            height: 10,
                            Utils.getImgPath(
                                lineupController.icon[
                                lineupController.title.indexOf(lineupController.playerEvents?[player.playerId]?[3].trim())
                                ]))
                    )
                ):Container(),
                ///上下场
                lineupController.playerEvents?[player.playerId]?[0].length !=0
                    && lineupController.playerEvents != null && lineupController.playerEvents?[player.playerId] != null?
                Positioned(
                    bottom: 0,
                    right: 13,
                    child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 0.5, color: Colours.white),
                        ),
                        child: Image.asset(
                            width: 10,
                            height: 10,
                            Utils.getImgPath(
                                lineupController.icon[
                                lineupController.title.indexOf(lineupController.playerEvents?[player.playerId]?[0].trim())
                                ]))
                    )
                ):Container(),
                ///上下场时间
                lineupController.playerEvents?[player.playerId]?[1].length != 0
                    && lineupController.playerEvents != null && lineupController.playerEvents?[player.playerId] != null?
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Text(
                      "${lineupController.playerEvents?[player.playerId]?[1].trim()}'" ?? "",
                      style: const TextStyle(color: Colours.white, fontSize: 8),
                    )
                ):Container()
              ],
            ),
          ),
          Container(height: 3),
          Text(
            (player.nameCn ?? player.nameEn) ?? '',
            style: const TextStyle(color: Colours.white, fontSize: 9),
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          Container(height: 1),
          (player.rating == null || player.rating == '' || player.rating == '0.00')
          ?Container()
          :Container(
            width: 22,
            height: 14,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.black54),
            child: Text(
              player.rating!,style: const TextStyle(color: Colors.white,fontSize: 8),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> getHomeLineup(){
    final List lineup = lineupController.data?.homeArray == null?[]:lineupController.data!.homeArray!.split('');
    List<Widget> listChildren = [];
    List<Widget> listParent = [];
    int sum = 0;
    listParent.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: _player(true, 0))
          ],
        )
    );
    for (int i = 0; i < lineup.length; i++) {
      i>0?sum += int.parse(lineup[i-1]):sum = sum;
      for (int j = 0; j < int.parse(lineup[i]); j++) {
        int tag = sum+j+1;
        listChildren.add(
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: _player(true, tag))
        );
      }
      listParent.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: listChildren,
          )
      );
      listChildren = [];
    }
    return listParent;
  }


  List<Widget> getGuestLineup(){
    final lineup = lineupController.data?.homeArray == null?[]:lineupController.data!.guestArray!.split('');
    List<Widget> listChildren = [];
    List<Widget> listParent = [];
    int sum1 = 0;
    for (int i = lineup.length-1; i >= 0; i--) {
      i < lineup.length-1?sum1 += int.parse(lineup[i+1]):sum1 = sum1;
      for (int j = 0; j < int.parse(lineup[i]); j++) {
        listChildren.add(
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                alignment: Alignment.center,
                child: _player(false, lineupController.data!.guestLineup!.length - 1 - (sum1+j))))
        );
      }
      if(listChildren.length == 1){
        listParent.add(
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: listChildren,
            )
        );
      }else{
        listParent.add(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: listChildren,
            )
        );
      }
      listChildren = [];
    }
    listParent.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: _player(false, 0))
          ],
        )
    );
    return listParent;
  }
}
