import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/http/apis/basketball.dart';
import 'package:sports/model/basketball/bb_match_detail_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/ladder_path.dart';
import 'package:sports/widgets/no_data_widget.dart';

class BbDetailOutsWidget extends StatefulWidget {
  const BbDetailOutsWidget({super.key,required this.id,this.haveTopData = false});

  final int id;
  final bool haveTopData;

  @override
  State<BbDetailOutsWidget> createState() => _BbDetailOutsWidgetState();
}

class _BbDetailOutsWidgetState extends State<BbDetailOutsWidget> {

  BbMatchDetailEntity? detail;
  int liveCount = 30;
  int periodNum = 0;
  List get lives => detail?.appMatchTlives?[periodNum - 1].data ?? [];
  bool get nomore => liveCount > lives.length;

  FutureOr getMatchDetail() async {
    final response = await BasketballApi.matchDetail(widget.id);
    try {
      detail = BbMatchDetailEntity.fromJson(response.data['d']);
      if ((detail?.appMatchTlives?.length ?? 0) > 0) {
        periodNum = detail?.appMatchTlives?.length ?? 0;
      }
      update();
    } catch (err) {
      log("篮球获取比赛详情出错");
      log("$err");
    }
  }

  @override
  void initState() {
    getMatchDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (detail == null) {
      return const NoDataWidget();
    }
    return EasyRefresh.builder(
      onRefresh: () async {
        liveCount = 30;
        await getMatchDetail();
      },
      onLoad: nomore ? null : () async {
        liveCount += 30;
        update();
      },
      childBuilder: (ctx,b) => SingleChildScrollView(
        clipBehavior: Clip.none,
        physics: b,
        child: Column(
          children: [
            Container(color: Colours.greyF5F5F5,height: 10),
            _liveTextBox(),
            _vSpace()
          ]
        )
      )
    );
  }

  Widget _vSpace() => const SizedBox(height: 10);

  Widget logo(String url,{double size = 24}) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration( shape: BoxShape.circle ),
      child: CachedNetworkImage(
        imageUrl: url,
        placeholder: (context, url) => Styles.placeholderIcon(),
        errorWidget: (context, url, error) => Image.asset(Utils.getImgPath('basket_team_logo.png'),width: size,height: size,)
      )  
    );
  }

  Widget _homeLogo({double size = 24}) => logo(detail?.homeTeamLogo ?? "",size: size);
  Widget _awayLogo({double size = 24}) => logo(detail?.awayTeamLogo ?? "",size: size);

  Widget _liveTextCell(DetailMatchLiveTextDataEntity e,String t,bool islast) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  e.teamType == 1 ? _homeLogo() : _awayLogo(),
                  if (!islast)
                  Expanded(child: Container(
                    width: 0.5,
                    color: Color(0xffd7d7d7),
                  ))
                ],
              ),
            ),
            const SizedBox(width: 6,),
            Expanded(
              child: Column(
                children: [
                  DefaultTextStyle(
                    style: TextStyle(fontSize: 12,color: Colours.grey99),
                    child: Row(children: [
                      Text(t + " ${e.time ?? ""}"),
                      const Spacer(),
                      Text(e.scores ?? "-")
                    ],).paddingSymmetric(vertical: 2),
                  ),
                  const SizedBox(height: 2,),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                    decoration: BoxDecoration(color: Color(0xFFF7F7F7),borderRadius: BorderRadius.circular(2)),
                    child: Text(e.data ?? "-",style: TextStyle(fontSize: 14,color: Colours.text_color1),),
                  ),
                  const SizedBox(height: 10)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _liveTextBox() {
    final lives1 = detail?.appMatchTlives;
    final count = lives1?.length ?? 0;
    if (lives1?.isEmpty ?? true) {
      log('lives empty ${detail?.appMatchTlives}');
      return const NoDataWidget(tip: "暂无直播数据").sized(height: 450);
    }
    final count2 = nomore ? lives.length : liveCount;
    final list = lives.sublist(0,count2);
    final t = lives1?[periodNum - 1].name ?? "";
    return Column(
      children: [
        Container(
          color: Colours.greyF5F5F5,
          child: Row(
            children: [
              ...List.generate(lives1?.length ?? 0, (index) {
                final p = index + 1;
                return Expanded(
                  child: ClipPath(
                    clipper: LadderPath(p > count / 2),
                    child: Container(
                      color: p == periodNum ? Colors.white : null,
                      height: 36,
                      alignment: Alignment.center,
                      child: Text(lives1?[index].name ?? "",style: TextStyle(fontSize: 14,color: p == periodNum ? Colours.main : Colours.grey66,fontWeight:  p == periodNum ? FontWeight.w500 : null),),
                    ),
                  ).tap(() {
                    periodNum = p;
                    liveCount = 30;
                    update();
                  }),
                );
              })
            ],
          ),
        ),
        list.isEmpty ? const NoDataWidget() :
        Container(
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 12),
              ...List.generate(list.length, (index) {
                bool islast = list.length == index + 1;
                return _liveTextCell(list[index],t,islast);
              }),
              if (list.isEmpty)
              const NoDataWidget(),
              const SizedBox(height: 100)
            ],
          ),
        ),
      ],
    );
  }
}