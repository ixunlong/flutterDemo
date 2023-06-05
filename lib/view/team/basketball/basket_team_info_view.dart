import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:sports/logic/team/basketball/basket_team_detail_controller.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/custom_icons.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/no_data_widget.dart';

class BasketTeamInfoView extends StatefulWidget {
  const BasketTeamInfoView({super.key});

  @override
  State<BasketTeamInfoView> createState() => _BasketTeamInfoViewState();
}

class _BasketTeamInfoViewState extends State<BasketTeamInfoView> {
  int teamId = Get.arguments;
  late BasketTeamDetailController detailC;
  List<bool> dataList = List.generate(20, (index) => false).toList();

  @override
  void initState() {
    super.initState();
    detailC = Get.find<BasketTeamDetailController>(tag: teamId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colours.scaffoldBg,
      padding: EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: GetBuilder<BasketTeamDetailController>(
          tag: teamId.toString(),
          initState: (_) {},
          builder: (_) {
            bool teamEmpty = detailC.data?.country.valuable != true &&
                detailC.data?.venueName.valuable != true &&
                detailC.data?.coachName.valuable != true &&
                detailC.data?.conferenceName.valuable != true;
            return detailC.data == null
                ? Container()
                : ((teamEmpty && detailC.data?.honorView == null)
                    ? NoDataWidget()
                    : ListView(
                        children: [
                          SizedBox(height: 10),
                          if (!teamEmpty) ...[
                            teamData(),
                            SizedBox(height: 10),
                          ],
                          if (detailC.data?.honorView.hasValue == true) ...[
                            teamHonor(),
                            SizedBox(height: 10),
                          ],
                          SizedBox(height: 50),
                        ],
                      ));
          },
        ),
      ),
    );
  }

  teamData() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colours.white,
      ),
      child: Column(
        children: [
          if (detailC.data?.country.valuable == true) ...[
            teamDataRow('所在地区', detailC.data?.country ?? ''),
            SizedBox(height: 8),
          ],
          if (detailC.data?.venueName.valuable == true) ...[
            teamDataRow('球队主场', '${detailC.data?.venueName}'),
            SizedBox(height: 8),
          ],
          if (detailC.data?.coachName.valuable == true) ...[
            teamDataRow('主教练', detailC.data?.coachName ?? ''),
            SizedBox(height: 8),
          ],
          if (detailC.data?.conferenceName.valuable == true) ...[
            teamDataRow('赛区', detailC.data?.conferenceName ?? ''),
            SizedBox(height: 8),
          ]
        ],
      ),
    );
  }

  teamDataRow(String title, String content) {
    return Row(
      children: [
        Text(title, style: TextStyle(color: Colours.grey_color, fontSize: 14)),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            content,
            style: TextStyle(color: Colours.text_color1, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  teamHonor() {
    final width = (Get.width - 32 - 16 - 60 - 20) / 3;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 8, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colours.white,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          '球队荣誉',
          style: TextStyle(
              fontSize: 16,
              color: Colours.text_color1,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        ...detailC.data!.honorView!.map((e) {
          return Column(
            children: [
              ExpandablePanel(
                header: Row(
                  children: [
                    Image.asset(
                      Utils.getImgPath('gold_cup.png'),
                      width: 16,
                    ),
                    SizedBox(
                      width: 4,
                      height: 40,
                    ),
                    Text(
                      '${e.leagueName ?? ''} ${e.size.toString()}次',
                      style: TextStyle(
                          color: Colours.text_color1,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                theme: ExpandableThemeData(
                    iconSize: 12,
                    iconPadding:
                        EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                    // useInkWell: false,
                    // crossFadePoint: 0.2,
                    collapseIcon: CustomIcons.arrow_up,
                    expandIcon: CustomIcons.arrow_down,
                    hasIcon: e.size! > 3,
                    tapHeaderToExpand: e.size! > 3),
                collapsed: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                        e.size! > 3 ? 3 : e.size!,
                        (index) => Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Colours.greyF5F7FA,
                            ),
                            height: 24,
                            width: width,
                            child: Text(
                              e.season![index],
                              style: TextStyle(
                                  color: Colours.grey_color, fontSize: 12),
                            )))),
                expanded: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                        e.size!,
                        (index) => Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Colours.greyF5F7FA,
                            ),
                            height: 24,
                            width: width,
                            child: Text(
                              e.season![index],
                              style: TextStyle(
                                  color: Colours.grey_color, fontSize: 12),
                            )))),
              ),
              SizedBox(height: 8)
            ],
          );
        }).toList(),
      ]),
    );
  }
}
