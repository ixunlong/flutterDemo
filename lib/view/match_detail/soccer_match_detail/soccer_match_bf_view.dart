import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/match/match_odds_ok_entity.dart';
import 'package:sports/res/colours.dart';

class SoccerMatchBfView extends StatefulWidget {
  const SoccerMatchBfView({super.key});

  @override
  State<SoccerMatchBfView> createState() => _SoccerMatchBfViewState();
}

class _SoccerMatchBfViewState extends State<SoccerMatchBfView> {
  MatchOddsOkEntity? data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      MatchOddsOkEntity? result = await Api.getOddsOk(0);
      setState(() {
        data = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Container(height: 10, color: Colours.scaffoldBg),
      tradingWidget(),
      Container(height: 10, color: Colours.scaffoldBg),
      largeTradingWidget(),
    ]);
  }

  tradingWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 13),
      color: Colours.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          '交易数据',
          style: TextStyle(
              fontSize: 16,
              color: Colours.text_color1,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 14),
        chartWidget(0),
        SizedBox(height: 20),
        tradingTable(),
        Divider(color: Colours.greyEE),
        SizedBox(height: 14),
        Text(
          '本场比赛必发交易规模超千万，谨防比赛过于热门',
          style: TextStyle(fontSize: 12, color: Colours.text_color1),
        )
      ]),
    );
  }

  chartWidget(int type) {
    double total = 0;
    double home = 0;
    double guest = 0;
    double flat = 0;
    String homePer = '';
    String guestPer = '';
    String flatPer = '';
    if (type == 0) {
      home = (data?.homeCount ?? 0).toDouble();
      guest = (data?.guestCount ?? 0).toDouble();
      flat = (data?.flatCount ?? 0).toDouble();
      homePer = data?.cutHomeCount ?? '';
      guestPer = data?.cutGuestCount ?? '';
      flatPer = data?.cutFlatCount ?? '';
    } else {
      home = (data?.maxHomeCount ?? 0).toDouble();
      guest = (data?.maxGuestCount ?? 0).toDouble();
      flat = (data?.maxFlatCount ?? 0).toDouble();
      homePer = data?.cutMaxHomeCount ?? '';
      guestPer = data?.cutMaxGuestCount ?? '';
      flatPer = data?.cutMaxFlatCount ?? '';
    }
    total = (home + guest + flat).toDouble();
    return Container(
      color: Colours.greyF5F7FA,
      height: 161,
      child: Row(children: [
        Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                    startDegreeOffset: 180,
                    sectionsSpace: 4,
                    centerSpaceRadius: 50,
                    sections: [
                      chartSection(home, Colours.main_color),
                      chartSection(guest, Colours.green),
                      chartSection(flat, Colours.guestColorBlue)
                    ]),
              ),
            ),
            Positioned(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '交易量',
                  style: TextStyle(fontSize: 12, color: Colours.grey_color1),
                ),
                Text(
                  total.toString(),
                  style: TextStyle(fontSize: 16, color: Colours.text_color1),
                ),
                Text(
                  '港元',
                  style: TextStyle(fontSize: 12, color: Colours.grey_color1),
                )
              ],
            ))
          ],
        ),
        Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 12),
            Row(
              children: [
                Container(
                  color: Colours.main_color,
                  width: 8,
                  height: 8,
                ),
                SizedBox(width: 4),
                Text('胜',
                    style: TextStyle(fontSize: 10, color: Colours.grey_color1)),
                SizedBox(width: 10),
                Container(
                  color: Colours.guestColorBlue,
                  width: 8,
                  height: 8,
                ),
                SizedBox(width: 4),
                Text('平',
                    style: TextStyle(fontSize: 10, color: Colours.grey_color1)),
                SizedBox(width: 10),
                Container(
                  color: Colours.green,
                  width: 8,
                  height: 8,
                ),
                SizedBox(width: 4),
                Text('负',
                    style: TextStyle(fontSize: 10, color: Colours.grey_color1))
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Text(
                  homePer,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colours.main_color,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                    width: 100,
                    child: Text(
                      home.toString(),
                      textAlign: TextAlign.end,
                      style: TextStyle(color: Colours.text_color1),
                    ))
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  flatPer,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colours.guestColorBlue,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                    width: 100,
                    child: Text(
                      flat.toString(),
                      textAlign: TextAlign.end,
                      style: TextStyle(color: Colours.text_color1),
                    ))
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  guestPer,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colours.green,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                    width: 100,
                    child: Text(
                      guest.toString(),
                      textAlign: TextAlign.end,
                      style: TextStyle(color: Colours.text_color1),
                    ))
              ],
            )
          ],
        ),
        SizedBox(width: 24),
      ]),
    );
  }

  tradingTable() {
    List title = ['选项', '成交价', '交易量', '机构盈亏', '冷热指数'];
    return Table(
      columnWidths: {
        0: const FlexColumnWidth(0.6),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
            decoration: const BoxDecoration(color: Colours.greyF5F7FA),
            children: List.generate(title.length, (index) {
              return TableCell(
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Text(title[index],
                          style: const TextStyle(
                              fontSize: 12, color: Colours.text_color1),
                          textAlign: TextAlign.center)));
            })),
        ...List.generate(3, (index) {
          String item1 = '';
          String item2 = '';
          String item3 = '';
          String item4 = '';
          String item5 = '';
          var color = Colours.main;
          if (index == 0) {
            item1 = '胜';
            item2 = '${data?.homePrice}';
            item3 = '${data?.homeCount}';
            if (data!.homeProfit! > 0) {
              item4 = '+${data?.homeProfit}';
            } else {
              color = Colours.green;
              item4 = '${data?.homeProfit}';
            }
            item5 = '${data?.homeCold}';
          } else if (index == 1) {
            item1 = '平';
            item2 = '${data?.flatPrice}';
            item3 = '${data?.flatCount}';
            if (data!.flatProfit! > 0) {
              item4 = '+${data?.flatProfit}';
            } else {
              color = Colours.green;
              item4 = '${data?.flatProfit}';
            }
            // item4 = '${data?.flatProfit}';
            item5 = '${data?.flatCold}';
          } else {
            item1 = '负';
            item2 = '${data?.guestPrice}';
            item3 = '${data?.guestCount}';
            if (data!.guestProfit! > 0) {
              item4 = '+${data?.guestProfit}';
            } else {
              color = Colours.green;
              item4 = '${data?.guestProfit}';
            }
            // item4 = '${data?.guestProfit}';
            item5 = '${data?.guestCold}';
          }
          final row = [item1, item2, item3, item4, item5];
          return TableRow(
              children: List.generate(
                  5,
                  (index1) => TableCell(
                          child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          row[index1],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              color: index1 == 3 ? color : Colours.text_color1),
                        ),
                      ))));
        }),
      ],
    );
  }

  largeTradingWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 13),
      color: Colours.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          '大额交易',
          style: TextStyle(
              fontSize: 16,
              color: Colours.text_color1,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 14),
        chartWidget(1),
        SizedBox(height: 12),
        Text(
          '近10笔大额交易明细',
          style: TextStyle(
              fontSize: 16,
              color: Colours.text_color1,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 12),
        largeTradingTable(),
        // SizedBox(height: 50),
      ]),
    );
  }

  largeTradingTable() {
    List title = ['时间', '选项', '成交价', '交易量', '买卖'];
    return Table(
      columnWidths: {
        0: const FixedColumnWidth(85),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
            decoration: const BoxDecoration(color: Colours.greyF5F7FA),
            children: List.generate(title.length, (index) {
              return TableCell(
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Text(title[index],
                          style: const TextStyle(
                              fontSize: 12, color: Colours.text_color1),
                          textAlign: TextAlign.center)));
            })),
        ...List.generate(data!.details!.length, (index) {
          Details detail = data!.details![index];
          String item1 = detail.matchTime ?? '-';
          String item2 = detail.choices ?? '-';
          String item3 = detail.price == null ? '-' : detail.price.toString();
          String item4 =
              detail.countNum == null ? '-' : detail.countNum.toString();
          String item5 = detail.type ?? '-';
          Color color = Colours.text_color1;
          final row = [item1, item2, item3, item4, item5];
          if (item2 == '胜') {
            color = Colours.main;
          } else {
            color = Colours.green;
          }
          return TableRow(
              decoration: BoxDecoration(
                  color: index % 2 == 0 ? Colours.white : Colours.greyF5F7FA),
              children: List.generate(
                  5,
                  (index1) => TableCell(
                          child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          row[index1],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              color: index1 == 0
                                  ? Colours.grey_color1
                                  : ((index1 == 3 || index1 == 4)
                                      ? color
                                      : Colours.text_color1)),
                        ),
                      ))));
        }),
      ],
    );
  }

  PieChartSectionData chartSection(double value, Color color) {
    return PieChartSectionData(
      showTitle: false,
      color: color,
      value: value,
      radius: 6,
    );
  }

  // List<PieChartSectionData> pieSection() {
  //   return List.generate(3, (i) {
  //     // final isTouched = i == touchedIndex;
  //     final fontSize = 16.0;
  //     final radius = 6.0;
  //     switch (i) {
  //       case 0:
  //         return PieChartSectionData(
  //           showTitle: false,
  //           color: Colours.main_color,
  //           value: 40,
  //           radius: radius,
  //         );
  //       case 1:
  //         return PieChartSectionData(
  //           showTitle: false,
  //           color: Colours.green,
  //           value: 30,
  //           radius: radius,
  //         );
  //       case 2:
  //         return PieChartSectionData(
  //           showTitle: false,
  //           color: Colours.guestColorBlue,
  //           value: 15,
  //           radius: radius,
  //         );

  //       default:
  //         throw Error();
  //     }
  //   });
  // }
}
