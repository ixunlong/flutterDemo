import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sports/model/match/match_info_entity.dart';
import 'package:sports/model/match/match_technic_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/match_detail/soccer_match_detail/match_nodata_widget.dart';

class StatisticsWidget extends StatelessWidget {
  const StatisticsWidget({super.key, this.tech, this.info});

  final MatchTechEntity? tech;
  final MatchInfoEntity? info;

  bool isTechEmpty() {
    if (tech?.technicDetail?.isEmpty ?? true) {
      return true;
    }
    var isEmpty = true;
    outloop:
    for (var i = 0; i < tech!.technicDetail!.length; i++) {
      final details = tech!.technicDetail![i];

      for (var j = 0; j < (details.technicDetail?.length ?? 0); j++) {
        final detail = details.technicDetail![j];
        // detail.homeData?.isEmpty
        final hd = int.tryParse(detail.homeData?.replaceAll("%", "") ?? "");
        final gd = int.tryParse(detail.guestData?.replaceAll("%", "") ?? "");
        if (hd != null && gd != null) {
          isEmpty = false;
          break outloop;
        }
      }
    }
    return isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    if (info?.state == MatchState.notStart) {
      return MatchNodataWidget(info: info);
    } else if (isTechEmpty()) {
      return MatchNodataWidget(info: info);
    }
    final List<Widget> l = [SizedBox(height: 20)];
    final len = tech?.technicDetail?.length ?? 0;
    for (var i = 0; i < len; i++) {
      final json = tech!.technicDetail![i];
      if (json.isNoData) {
        continue;
      }
      l.add(_cardBox(Column(
        children: [
          _cardTitle(json.title ?? ""),
          ...json.technicDetail?.filter((item) => item.isHasData).map((e1) => _middleTitleInt(
                  e1.technicCn ?? "", e1.homeData ?? "", e1.guestData ?? "")) ??
              []
        ],
      )));
      if (i != len - 1) {
        l.add(SizedBox(height: 10));
      }
    }

    return Column(children: l);
  }

  Widget _cardBox(Widget child) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        decoration: BoxDecoration(color: Colors.white),
        child: child);
  }

  Widget _cardTitle(String title) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(height: 10),
          Text("$title",
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xff292d32),
                  fontWeight: FontWeight.w500)),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _middleTitleInt(String title, String text_l, String text_r) {
    int l = int.tryParse(text_l.replaceAll("%", "")) ?? 0;
    int r = int.tryParse(text_r.replaceAll("%", "")) ?? 0;
    final m = (l == r);
    final il = l > r;
    final total = (l + r) == 0 ? 1 : (l + r);
    final lcolor = (m || il) ? Colours.homeColorRed : Colours.greyD7;
    final rcolor = (m || !il) ? Colours.guestColorBlue : Colours.greyD7;
    final lv = l / total;
    final rv = r / total;
    final bg = Colours.greyEE;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      height: 30,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Container(
                    alignment: Alignment.centerLeft,
                    width: 30,
                    child: Text(text_l,
                        style: TextStyle(fontSize: 10, color: Colors.black))),
                SizedBox(height: 2),
                Transform.rotate(
                  angle: math.pi,
                  child: LinearProgressIndicator(
                          value: lv, backgroundColor: bg, color: lcolor)
                      .rounded(2),
                ),
                SizedBox(height: 10)
              ])),
          Text(title,
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 11))
              .sized(width: 80),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Container(
                    alignment: Alignment.centerRight,
                    width: 30,
                    child: Text(text_r,
                        style: TextStyle(fontSize: 10, color: Colors.black))),
                SizedBox(height: 2),
                LinearProgressIndicator(
                        value: rv, backgroundColor: bg, color: rcolor)
                    .rounded(2),
                SizedBox(height: 10)
              ]))
        ],
      ),
    );
  }
}
