import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:sports/logic/team/soccer_team_detail_controller.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/custom_icons.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/no_data_widget.dart';

class SoccerTeamInfoView extends StatefulWidget {
  const SoccerTeamInfoView({super.key});

  @override
  State<SoccerTeamInfoView> createState() => _SoccerTeamInfoViewState();
}

class _SoccerTeamInfoViewState extends State<SoccerTeamInfoView> {
  // final controller = Get.put(SoccerTeamInfoController());
  int teamId = Get.arguments;
  late SoccerTeamDetailController detailC;
  List<bool> dataList = List.generate(20, (index) => false).toList();

  @override
  void initState() {
    super.initState();
    detailC = Get.find<SoccerTeamDetailController>(tag: teamId.toString());
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
        child: GetBuilder<SoccerTeamDetailController>(
          tag: teamId.toString(),
          initState: (_) {},
          builder: (_) {
            bool teamEmpty = detailC.data?.foundingDate.valuable != true &&
                detailC.data?.countryCn.valuable != true &&
                detailC.data?.areaCn.valuable != true &&
                detailC.data?.gymCn.valuable != true &&
                detailC.data?.addrCn.valuable != true &&
                detailC.data?.website.valuable != true;
            return detailC.data == null
                ? Container()
                : ((teamEmpty &&
                        detailC.data?.honorView == null &&
                        detailC.data!.introduce.valuable != true)
                    ? NoDataWidget()
                    : ListView(
                        children: [
                          SizedBox(height: 10),
                          if (!teamEmpty) ...[
                            teamData(),
                            SizedBox(height: 10),
                          ],
                          if (detailC.data?.honorView != null) ...[
                            teamHonor(),
                            SizedBox(height: 10),
                          ],
                          if (detailC.data!.introduce.valuable) teamInfo(),
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
          if (detailC.data?.foundingDate.valuable == true) ...[
            teamDataRow('成立时间', detailC.data!.foundingDate ?? ''),
            SizedBox(height: 8),
          ],
          if (detailC.data?.countryCn.valuable == true ||
              detailC.data?.areaCn.valuable == true) ...[
            teamDataRow(
                '所在地区',
                detailC.data?.countryCn.valuable == true
                    ? '${detailC.data?.countryCn} '
                    : '' + '${detailC.data?.areaCn}'),
            SizedBox(height: 8),
          ],
          if (detailC.data?.gymCn.valuable == true) ...[
            teamDataRow(
                '球队主场',
                '${detailC.data?.gymCn}' +
                    (detailC.data?.capacity.valuable == true
                        ? '·可容纳${detailC.data?.capacity}人'
                        : '')),
            SizedBox(height: 8),
          ],
          if (detailC.data?.addrCn.valuable == true) ...[
            teamDataRow('球队地址', detailC.data?.addrCn ?? ''),
            SizedBox(height: 8),
          ],
          if (detailC.data?.website.valuable == true) ...[
            teamDataRow('球队网址', detailC.data?.website ?? ''),
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

  teamInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colours.white,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          '球队简介',
          style: TextStyle(
              fontSize: 16,
              color: Colours.text_color1,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        Html(
            data: getData(),
            // style: style,
            onLinkTap: (url, context, attributes, element) {
              // if (url != null) { Utils.doRoute(url); }
            },
            style: {
              "body": Style(letterSpacing: -0.5),
            }),
      ]),
    );
  }

  String getData() {
    var regCom = RegExp(r'<\/p>[.\n]<p>');
    var regC = RegExp(r"[\u4e00-\u9fa5]");
    var reg = RegExp(r"(?<=(<[^>]+>))(.*(?!(&\w*;)+))(?=(<[^>]+>))");
    String append = '';
    String? com = detailC.data?.introduce
        ?.split("<p>&nbsp;</p>")
        .join("<div style= 'height: 20;width: 200px;'>  </div>")
        .split(regCom)
        .join("</p><div style= 'height: 20;width: 200px;'>  </div><p>")
        .split("/><p>")
        .join("/><div style= 'height: 20;width: 200px;'>  </div><p>")
        .split("/><img")
        .join("/><div style= 'height: 20;width: 200px;'>  </div><img");
    com?.split("").forEach((element) {
      if (regC.hasMatch(element)) {
        append += "$element\u200A";
      } else {
        append += element;
      }
    });
    var newData = "";
    newData = """
    <!DOCTYPE html>
      <html>
        <body style="margin: 0 0 0 0"><div style="color: #FF444444;margin: 0;font-size: 14px; line-height: 1.3; letter-spacing: -1px; white-space: normal; text-align: justify;">$append</div></body>
      </html>
      <style>
      p{
        margin: 0;
      }
      </style>
    """;
    return newData;
  }
}
