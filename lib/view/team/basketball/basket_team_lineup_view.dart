import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/team/basketball/bb_team_lineup_controller.dart';
import 'package:sports/model/team/bb_team/bb_team_player_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/cupertino_picker_widget.dart';
import 'package:sports/widgets/no_data_widget.dart';

class BasketTeamLineupView extends StatefulWidget {
  const BasketTeamLineupView({super.key});

  @override
  State<BasketTeamLineupView> createState() => _BasketTeamLineupViewState();
}

class _BasketTeamLineupViewState extends State<BasketTeamLineupView> {
  BbTeamLineupController controller =
      Get.put(BbTeamLineupController(), tag: '${Get.arguments}');
  List<String> tableTitle = [
    '球员',
    '得分',
    '篮板',
    '助攻',
    '抢断',
    '盖帽',
    '投篮%',
    '三分%',
    '罚球%'
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BbTeamLineupController>(
      tag: '${Get.arguments}',
      builder: (_) {
        return Container(
          color: Colours.greyF7,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: controller.yearData == null
                ? Container()
                : (controller.yearData!.isEmpty
                    ? NoDataWidget()
                    : Column(
                        children: [
                          if (controller.nation == 1) _pageChoice(),
                          Expanded(
                            child: ListView(
                              children: [
                                // SizedBox(height: 10),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colours.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 12),
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('球员数据',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16)),
                                        SizedBox(height: 16),
                                        filterWidget(),
                                        SizedBox(height: 10),
                                        lineup(),
                                      ]),
                                ),
                                SizedBox(height: 50)
                              ],
                            ),
                          ),
                        ],
                      )),
          ),
        );
      },
    );
  }

  Widget _pageChoice() {
    return Container(
      color: Colours.white,
      padding: const EdgeInsets.only(left: 12, right: 8, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: selectYear,
            child: Container(
              height: 24,
              width: 58,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 6, right: 2),
              decoration: BoxDecoration(
                  color: Colours.greyF5F7FA,
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        Utils.parseYear(controller
                                .yearData![controller.yearIndex].seasonYear ??
                            ''),
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
                    controller
                        .yearData![controller.yearIndex].leagueInfo!.length,
                    (childIndex) => Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () async {
                              controller.changeLeague(childIndex);
                            },
                            child: Container(
                              height: 24,
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: controller.leagueIndex == childIndex
                                      ? Colours.redFFECEE
                                      : Colours.white),
                              child: Text(
                                  controller.yearData![controller.yearIndex]
                                          .leagueInfo![childIndex].leagueName ??
                                      "",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          controller.leagueIndex == childIndex
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

  filterWidget() {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                  controller
                      .yearData![controller.yearIndex]
                      .leagueInfo![controller.leagueIndex]
                      .scope!
                      .length, (index) {
                return GestureDetector(
                  onTap: () {
                    controller.changeScope(index);
                  },
                  child: Container(
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          color: controller.scopeIndex == index
                              ? Colours.main_color
                              : Colours.greyF5F5F5),
                      // width: 52,
                      child: Text(
                        (controller
                                    .yearData![controller.yearIndex]
                                    .leagueInfo![controller.leagueIndex]
                                    .scope![index]
                                    .scopeName ??
                                '') +
                            (controller
                                    .yearData![controller.yearIndex]
                                    .leagueInfo![controller.leagueIndex]
                                    .scope![index]
                                    .stageName ??
                                ''),
                        style: TextStyle(
                            color: controller.scopeIndex == index
                                ? Colours.white
                                : Colours.grey_color,
                            fontSize: 12),
                      )),
                );
              }),
            ),
          ),
        ),
        if (controller.nation == 0) ...[
          SizedBox(width: 10),
          SizedBox(
              height: 22,
              width: 61,
              child: _selectButton(
                  Utils.parseYear(
                      controller.yearData![controller.yearIndex].seasonYear ??
                          ''),
                  selectYear))
        ],
      ],
    );
  }

  Widget lineup() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        defaultColumnWidth: const FixedColumnWidth(40),
        columnWidths: const {
          0: FixedColumnWidth(141),
          6: FixedColumnWidth(52),
          7: FixedColumnWidth(52),
          8: FixedColumnWidth(52),
        },
        children: [
          TableRow(
              children: List.generate(tableTitle.length, (index) {
            TextAlign align = TextAlign.center;
            if (index == 0) {
              align = TextAlign.left;
            }
            return TableCell(
                child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text(tableTitle[index],
                  style: const TextStyle(fontSize: 12, color: Colours.grey66),
                  textAlign: align),
            ));
          })),
          ...List.generate(controller.list!.length, (index) {
            BbTeamPlayerEntity player = controller.list![index];
            return TableRow(
                children: List.generate(9, (index1) {
              Widget widget;
              if (index1 == 0) {
                widget = Padding(
                  padding: EdgeInsets.symmetric(vertical: 9),
                  child: Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: player.logo ?? '',
                        width: 24,
                        height: 32,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Styles.placeholderIcon(),
                        errorWidget: (context, url, error) => Image.asset(
                          Utils.getImgPath('basket_team_logo.png'),
                          height: 32,
                          width: 24,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              player.nameZhShort ?? '',
                              style: TextStyle(
                                  fontSize: 13, color: Colours.text_color1),
                            ),
                            SizedBox(height: 2),
                            Text(
                                '${player.shirtNumber}号 ${Utils.basketPositionCn(player.position)}',
                                style: TextStyle(
                                    fontSize: 11, color: Colours.grey66))
                          ],
                        ),
                      )
                    ],
                  ),
                );
              } else {
                String text = '';
                if (index1 == 1) {
                  text = '${player.points ?? '-'}';
                } else if (index1 == 2) {
                  text = '${player.rebounds ?? '-'}';
                } else if (index1 == 3) {
                  text = '${player.assists ?? '-'}';
                } else if (index1 == 4) {
                  text = '${player.steals ?? '-'}';
                } else if (index1 == 5) {
                  text = '${player.blocks ?? '-'}';
                } else if (index1 == 6) {
                  text = player.fieldGoalsAccuracy ?? '-';
                } else if (index1 == 7) {
                  text = player.threePointsAccuracy ?? '-';
                } else if (index1 == 8) {
                  text = player.freeThrowsAccuracy ?? '-';
                }
                widget = Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colours.text_color1),
                );
              }
              return TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: widget);
            })

                // controller.vsList!.map((e) {
                //   return TableCell(child: Text(e));
                // }).toList());
                );
          })
        ],
      ),
    );
  }

  Widget _selectButton(String title, Function f) {
    return TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          side: MaterialStateProperty.all<BorderSide>(
            BorderSide(width: 0.5, color: Colours.grey_color),
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        onPressed: () => f(),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 12,
                color: Colours.grey_color,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(width: 4),
          Image.asset(Utils.getImgPath('down_arrow.png'))
        ]));
  }

  void selectYear() async {
    final yearList = controller.yearData!
        .map((e) => Utils.parseYear(e.seasonYear!))
        .toList();
    final result = await Get.bottomSheet(CupertinoPickerWidget(
      yearList,
      title: '选择年份',
      initialIndex: controller.yearIndex,
    ));
    if (result != null) {
      controller.changeYear(result);
    }
  }
}
