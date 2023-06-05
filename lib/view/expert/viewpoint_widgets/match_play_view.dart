import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sports/model/expert/plan_Info_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:get/get.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/utils.dart';

const _grey99 = Color(0xff999999);
const _grey66 = Color(0xff666666);
const _textBlack = Color(0xff292d32);

const _notReady = Color(0xFFB58D76);
const _bingo = Color(0xFFF53F3F);
const _unBingo = Color(0xFF999999);
const _zou = Color(0xFF2766D6);
const _cancel = Color(0xFF666666);

extension PlanPlayContentItemEx1 on PlanPlayContentItemEntity {
  bool get selected => (s == 1 || s == 2);
}

class MatchPlayView extends StatelessWidget {
  MatchPlayView({super.key,this.planInfo,this.match});

  PlanInfoEntity? planInfo;

  PlanMatchBriesEntity? match;

  bool getResult = false;
  List<PlanItemShowEntity> get shows => planInfo?.itemShow?.filter((item) => item.matchId == match?.matchId) ?? [];
  
  // late PlanItemShowEntity? itemShow = () {
  //   if (planInfo?.itemShow?.isEmpty ?? true) { return null; }
  //   for (PlanItemShowEntity element in planInfo?.itemShow ?? []) {
  //     if(element.matchId == match?.matchId) {
  //       return element;
  //     }
  //   }
  // }.call();  

  String? get matchScore {
    if (match?.sportsId == 2) {
      if (match?.homeScore == null || match?.guestScore == null) {
        return "vs";
      }
      return "${match?.guestScore} : ${match?.homeScore}";
    }
    if(match?.homeScore90 == null || match?.guestScore90 == null) {
      return "vs";
    }
    if (!(match?.isMatchStart ?? false)) { return "vs"; }
    if (planInfo?.planStatus == 3) { return "vs"; }
    
    return "${match?.homeScore90} : ${match?.guestScore90}";
  }

  @override
  Widget build(BuildContext context) {

    // TYPE_0(0, "未开"),
    // TYPE_1(1, "中"),
    // TYPE_2(2, "未中"),
    // TYPE_3(3, "取消"),
    // TYPE_4(4, "走"),
    String? hzhpng;

    getResult = true;
    
    final status = () {
      if (shows.isNotEmpty) {
        return shows.first.status ?? 0;
      }
      return planInfo?.planStatus ?? 0;
    }.call();
    if (status == 1) {
      hzhpng = "expert_hong.png";
    } else if (status == 2) {
      hzhpng = "expert_hei.png";
    } else if (status == 3) {
      hzhpng = "result_quxiao.png";
      getResult = false;
    }else if (status == 4) {
      hzhpng = "expert_zou.png";
    } else {
      getResult = false;
    }
    final leftRanking = match?.sportsId == 2 ? match?.guestRanking : match?.homeRanking;
    final leftName = match?.sportsId == 2 ? match?.guestName : match?.homeName;
    final rightRanking = match?.sportsId == 2 ? match?.homeRanking : match?.guestRanking;
    final rightName = match?.sportsId == 2 ? match?.homeName : match?.guestName; 
    final leftTeam = Expanded(
      child: Text.rich(TextSpan(children: [
        if (leftRanking?.isNotEmpty ?? false)
        TextSpan(text: "[${leftRanking}] ",style: const TextStyle(fontSize: 12,color: _grey99)),
        TextSpan(text: leftName ?? "",style: const TextStyle(fontSize: 16,color: _textBlack))
      ]),maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.right,));
    final rightTeam = Expanded(
      child: Text.rich(TextSpan(children: [
        TextSpan(text: rightName ?? "",style: const TextStyle(fontSize: 16,color: _textBlack)),
        if (rightRanking?.isNotEmpty ?? false)
        TextSpan(text: " [${rightRanking}]",style: const TextStyle(fontSize: 12,color: _grey99))
      ]),maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.left,
      ));

    final container = Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
            color: Colours.greyF7, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            // if (itemShow?.playTypeName?.isNotEmpty ?? false)
            // Text(itemShow?.playTypeName ?? "",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),).marginOnly(bottom: 10),
            DefaultTextStyle(
                style: TextStyle(color: Colours.grey_color, fontSize: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(match?.sportsId==2?"[篮]\u2000":"[足]\u2000"),
                    Text("${match?.leagueName} ${match?.rounds ?? ""} ${match?.matchTimeDate?.formatedString("MM/dd HH:mm") ?? ""}"),
                    if ((match?.weatherCn?.trim().length ?? 0) > 0)
                    const Spacer(),
                    if ((match?.weatherCn?.trim().length ?? 0) > 0)
                    Text(match?.weatherCn ?? "")
                  ],
                )),
            const SizedBox(height: 10),
            const Divider(height: 0.5),
            const SizedBox(height: 10),
            Row(
              children: [
                leftTeam,
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  alignment: Alignment.center,
                  // width: 60,
                  child: Text(matchScore ?? "vs",maxLines: 1, style: TextStyle(color: _textBlack)),
                ),
                rightTeam,
              ],
            ).tap(() { 
              if (match?.sportsId == 1) {
                Get.toNamed(Routes.soccerMatchDetail,arguments: match?.matchId);
              }
              if (match?.sportsId == 2) {
                Get.toNamed(Routes.basketMatchDetail,arguments: match?.matchId);
              }
            }),
            SizedBox(height: 10),
            _playContent(),
            SizedBox(height: 10),
            // Text("含比分推荐", style: TextStyle(fontSize: 12, color: _grey66))
          ],
        ),
      ),
    );
    return Stack(children: [
      container,
      Positioned(
        top: 32,
        right: 32,
        child: hzhpng == null ? Container() : Image.asset(Utils.getImgPath(hzhpng)))
    ]);
  }

// 1001,"足球全场胜平负"
// 1002,"足球全场让球胜平负"
// 1003,"足球全场比分"
// 1004,"足球全场总进球数"
// 1005,"足球半全场"
// 1006,"足球让球/亚盘"
// 1007,"足球全场进球数大小球"
// 1008,"足球双平玩法"
  Widget _playContent() {
    final shows = planInfo?.itemShow?.filter((item) => item.matchId == match?.matchId) ?? [];
    final List<Widget> children = [];
    
    Widget showWidget(PlanItemShowEntity show) {
      switch (show.playType) {
        case 1001: return _playContentSpf(show);
        case 1002: return _playContentRqspf(show);
        case 1004: return _playContentJqs(show);
        case 1005: return _playContentBqc(show);
        case 1006: return _playContentRq(show);
        case 1007: return _playContentDx(show);
        case 1008: return _playContentSp(show);
        case 2001: return _lqSf(show);
        case 2002: return _lqRqsf(show);
        case 2003: return _lqDx(show);
        default:
          return Container();
      }
    }

    for (var s in shows) {
      if (children.isNotEmpty) { children.add(const SizedBox(height: 10)); }
      children.add(showWidget(s)); 
    }
    return Column(children: children);
    // switch (itemShow?.playType) {
    //   case 1001: return _playContentSpf();
    //   case 1002: return _playContentRqspf();
    //   case 1004: return _playContentJqs();
    //   case 1005: return _playContentBqc();
    //   case 1006: return _playContentRq();
    //   case 1007: return _playContentDx();
    //   case 2001: return _lqSf();
    //   case 2002: return _lqRqsf();
    //   case 2003: return _lqDx();
    //   default:
    //     return Container();
    // }
  }

  Widget _playContentSp(PlanItemShowEntity show) {
    // final itemshows = planInfo?.itemShow?.filter((item) => item.matchId == match?.matchId) ?? [];
    final children = <Widget>[];
    // for (var show in itemshows) {
      var plays = show.sp ?? [];
      if ((planInfo?.isCanRead ?? 0) == 0 && plays.isNotEmpty) {
        plays = [plays.first];
      }
      for (PlanPlayContentEntity sp in plays) {
        Map<String,PlanPlayContentItemEntity> map = {};
        int snum = 0;
        bool haveResult = false;
        for (PlanPlayContentItemEntity l in sp.list ?? []) {
          // log("篮球让球胜负 ${l.toJson()}");
          map[l.i ?? ""] = l;
          if ((l.s ?? 0) > 0) {
            snum += 1;
          }
          if (l.r == 1) { haveResult = true; }
        }
        if (children.isNotEmpty) {
          children.add(const SizedBox(height: 6));
        }
        children.add(Row(
          children: [
            _matchInfoWhiteBox(Text((sp.line ?? "").isEmpty ? "0" : sp.line!)),
            const SizedBox(width: 8.5,),
            Expanded(
              child: _matchInfoWhiteBox(Row(
                children: [
                  _checkContent1(map['s'], snum, haveResult),
                  const VerticalDivider(width: 0.5),
                  _checkContent1(map['p'], snum, haveResult),
                  const VerticalDivider(width: 0.5),
                  _checkContent1(map['f'], snum, haveResult)
                ],
              ),width: double.infinity),
            ),
          ],
        ));
      }
    // }
    return Column(children: children);
  }
  
  Widget _playContentSpf(PlanItemShowEntity show) {
    final spf = show.spf;
    List<Widget> children = [];
    int snum = 0;
    bool haveResult = false;
    Map<String,PlanPlayContentItemEntity> eles = {};
    for (PlanPlayContentItemEntity element in spf?.list ?? []) {
      if (element.r == 1) { haveResult = true; }
      if(element.selected) {snum += 1;}
      eles[element.i ?? ""] = element;
    }
    for (var i in ["s","p","f"]) {
      PlanPlayContentItemEntity? element = eles[i];
      children.add(_checkContent1(element, snum, haveResult));
      if (i != "f") {
        children.add(const VerticalDivider(width: 1));
      }
    }
    return _matchInfoWhiteBox(Row(children: children),width: null);
  }
  
  Widget _playContentRqspf(PlanItemShowEntity show) {
    final lineLen = show.rqSpf?.length ?? 0;
    int snum = 0;
    bool haveResult = false;
    for (var i = 0; i < lineLen; i++) {
      final srqspf = show.rqSpf?[i];
      for (PlanPlayContentItemEntity element in srqspf?.list ?? []) {
        if (element.r == 1) { haveResult = true; }
        if (element.selected) {snum += 1;}
      }
    }

    List<Widget> colChildren = [];
    for (var i = 0; i < lineLen; i++) {
      final srqspf = show.rqSpf![i];
      List<Widget> rowChildren = [];
      Map<String,PlanPlayContentItemEntity> eles = {};
      for (PlanPlayContentItemEntity element in srqspf.list ?? []) {
        eles[element.i ?? ""] = element;
      }
      for (var j in ["s","p","f"]) {
        PlanPlayContentItemEntity? element = eles[j];
        rowChildren.add(_checkContent1(element, snum,haveResult));
        if (j != "f") {
          rowChildren.add(VerticalDivider(width: 1));
        }
      }
      colChildren.add(Row(
        children: [
          _matchInfoWhiteBox(Text(srqspf.line ?? "")),
          const SizedBox(width: 8.5),
          Expanded(child: _matchInfoWhiteBox(Row(
            children: rowChildren,
          ),width: null))
        ],
      ));
      if (i < lineLen - 1) {
        colChildren.add(SizedBox(height: 6));
      }
    }

    return Column(children: colChildren);
  }
  
  Widget _playContentJqs(PlanItemShowEntity show) {
    final jqs = show.jqs;
    int snum = 0;
    bool haveResult = false;
    PlanPlayContentItemEntity? t1;
    PlanPlayContentItemEntity? t2;
    PlanPlayContentItemEntity? t3;
    PlanPlayContentItemEntity? t4;
    PlanPlayContentItemEntity? t5;
    PlanPlayContentItemEntity? t6;
    PlanPlayContentItemEntity? t7;
    for (PlanPlayContentItemEntity ele in jqs?.list ?? []) {
      if (ele.r == 1) { haveResult = true; }
      if (ele.selected) { snum += 1; }
      switch (ele.i) {
        case "t1": t1 = ele; break;
        case "t2": t2 = ele; break;
        case "t3": t3 = ele; break;
        case "t4": t4 = ele; break;
        case "t5": t5 = ele; break;
        case "t6": t6 = ele; break;
        case "t7": t7 = ele; break;
      }
    }
    return Column(
      children: [
        _matchInfoWhiteBox(Row(
          children: [
            Expanded(child: Row(children: [
              _checkContent1(t1,snum,haveResult),
              VerticalDivider(width: 1),
              _checkContent1(t2,snum,haveResult),
            ],)),
            VerticalDivider(width: 1),
            Expanded(child: Row(
              children: [
              _checkContent1(t3,snum,haveResult),
              VerticalDivider(width: 1),
              _checkContent1(t4,snum,haveResult),
              ],
            ))
          ],
        ),width: null),
        SizedBox(height: 6),
        _matchInfoWhiteBox(Row(
          children: [
            Expanded(child: Row(children: [
              _checkContent1(t5,snum,haveResult),
              VerticalDivider(width: 1),
              _checkContent1(t6,snum,haveResult),
            ],)),
            // Expanded(child: )
            VerticalDivider(width: 1),
            _checkContent1(t7,snum,haveResult),
          ],
        ),width: null),
      ],
    );
  }

  Widget _playContentBqc(PlanItemShowEntity show) {
    final bqc = show.bqc;
    final List data = [
      ["胜",["ss","sp","sf"]],
      ["平",["ps","pp","pf"]],
      ["负",["fs","fp","ff"]],
    ];
    int snum = 0;
    bool haveResult = false;
    Map<String,PlanPlayContentItemEntity> map = {};
    for (PlanPlayContentItemEntity element in bqc?.list ?? []) {
      if (element.r == 1) { haveResult = true; }
      if (element.selected) { snum += 1; }
      map[element.i ?? ""] = element;
    }

    List<Widget> colChildren = [];

    for (var i = 0; i < data.length; i++) {
      final n = data[i][0];
      List tags = data[i][1];
      List items = tags.map((str)=>map[str]).toList();
      colChildren.add(Row(
        children: [
          // _matchInfoWhiteBox(Text(n)),
          // SizedBox(width: 8.5),
          Expanded(child: _matchInfoWhiteBox(Row(
            children: [
              _checkContent1(items[0], snum, haveResult),
              VerticalDivider(width: 1),
              _checkContent1(items[1], snum, haveResult),
              VerticalDivider(width: 1),
              _checkContent1(items[2], snum, haveResult),
            ],
          ),width: null))
        ],
      ));
      if ( i < 2) {colChildren.add(SizedBox(height: 6));}
    }

    return Column(children: colChildren);
  }

  Widget _playContentDx(PlanItemShowEntity show) {
    List<Widget> children = [];
    int line = 0;
    int totalLen = show.dx?.length ?? 0;
    for (var dx1 in show.dx ?? []) {
      PlanPlayContentItemEntity? d;
      PlanPlayContentItemEntity? x;
      int snum = 0;
      bool haveResult = false;
      for (PlanPlayContentItemEntity element in dx1.list ?? []) {
        if (element.r == 1) { haveResult = true; }
        switch(element.i) {
          case "d" : d = element;break;
          case "x" : x = element;break;
        }
        if (element.s == 1 || element.s == 2) {snum += 1;}
      }
      if (d == null || x == null) { continue; }
      final box = _matchInfoWhiteBox(
        Row(
          children: [
            _checkContent1(d,snum,haveResult),
            VerticalDivider(width: 0.5),
            _checkContent("进球数", "${dx1.line}",checked: (getResult && !haveResult)),
            VerticalDivider(width: 0.5),
            _checkContent1(x,snum,haveResult),
          ],
        ),
        width: double.infinity);
      children.add(box);
      if (line++ < totalLen - 1) {
        children.add(SizedBox(height: 6));
      }
    }
    return Column(children: children);
  }

  Widget _lqSf(PlanItemShowEntity show) {
    // final itemshows = planInfo?.itemShow?.filter((item) => item.matchId == match?.matchId) ?? [];
    final children = <Widget>[];
    // for (var show in itemshows) {
      for (PlanPlayContentEntity sf in show.lqSf == null ? [] : [show.lqSf!]) {
        Map<String,PlanPlayContentItemEntity> map = {};
        int snum = 0;
        bool haveResult = false;
        for (PlanPlayContentItemEntity l in sf.list ?? []) {
          // log("篮球让球胜负 ${l.toJson()}");
          map[l.i ?? ""] = l;
          if ((l.s ?? 0) > 0) {
            snum += 1;
          }
          if (l.r == 1) { haveResult = true; }
        }
        if (children.isNotEmpty) {
          children.add(const SizedBox(height: 10));
        }
        children.add(_matchInfoWhiteBox(Row(
          children: [
            _checkContent1(map['f'], snum, haveResult),
            const VerticalDivider(width: 0.5),
            _checkContent1(map['s'], snum, haveResult)
          ],
        ),width: double.infinity));
      }
    // }
    return Column(children: children);
  }

  Widget _lqRqsf(PlanItemShowEntity show) {
    
    final children = <Widget>[];
    
      for (PlanPlayContentEntity rqsf in show.lqRqSf ?? []) {
        Map<String,PlanPlayContentItemEntity> map = {};
        int snum = 0;
        bool haveResult = false;
        for (PlanPlayContentItemEntity l in rqsf.list ?? []) {
          // log("篮球让球胜负 ${l.toJson()}");
          map[l.i ?? ""] = l;
          if ((l.s ?? 0) > 0) {
            snum += 1;
          }
          if (l.r == 1) { haveResult = true; }
        }
        final line = rqsf.line ?? "";
        final zhu = "主${line.startsWith("-") ? line : "+$line"}";
        if (children.isNotEmpty) {
          children.add(const SizedBox(height: 10));
        }
        children.add(_matchInfoWhiteBox(Row(
          children: [
            _checkContent1(map['f'], snum, haveResult),
            const VerticalDivider(width: 0.5),
            _checkContent("让分", zhu),
            const VerticalDivider(width: 0.5),
            _checkContent1(map['s'], snum, haveResult)
          ],
        ),width: double.infinity));
      }
    
    return Column(children: children);
  }

  Widget _lqDx(PlanItemShowEntity show) {
    
    final children = <Widget>[];
    
      for (PlanPlayContentEntity dx in show.lqDx ?? []) {
        Map<String,PlanPlayContentItemEntity> map = {};
        int snum = 0;
        bool haveResult = false;
        for (PlanPlayContentItemEntity l in dx.list ?? []) {
          // log("篮球大小 ${l.toJson()}");
          map[l.i ?? ""] = l;
          if ((l.s ?? 0) > 0) {
            snum += 1;
          }
          if (l.r == 1) { haveResult = true; }
        }
        children.add(_matchInfoWhiteBox(Row(
          children: [
            _checkContent1(map['d'], snum, haveResult),
            const VerticalDivider(width: 0.5),
            _checkContent("总分", dx.line ?? ''),
            const VerticalDivider(width: 0.5),
            _checkContent1(map['x'], snum, haveResult)
          ],
        ),width: double.infinity));
      }
    
    return Column(children: children);
  }

  Widget _playContentRq(PlanItemShowEntity show) {
    final yp = show.yp;
    List<Widget> children = [];
    int line = 0;
    int lineMax = yp?.length ?? 0;
    for (PlanPlayContentEntity yp1 in yp ?? []) {
      PlanPlayContentItemEntity? s;
      PlanPlayContentItemEntity? f;
      int snum = 0;
      bool haveResult = false;
      for (PlanPlayContentItemEntity element in yp1.list ?? []) {
        if (element.r == 1) { haveResult = true; }
        switch(element.i) {
          case "s" : s = element;break;
          case "f" : f = element;break;
        }
        if (element.s == 1 || element.s == 2) {snum += 1;}
      }
      if (s == null || f == null) { continue; }

      String qiuLine = yp1.line ?? '';
      if (qiuLine.startsWith("-")) {
        qiuLine = "主$qiuLine";
      } else if (qiuLine.startsWith(RegExp("[\\d]"))) {
        qiuLine = "主+$qiuLine";
      } else if (qiuLine.startsWith("+")) {
        qiuLine = "主$qiuLine";
      }

      final box = _matchInfoWhiteBox(
          Row(
            children: [
              _checkContent1(s,snum,haveResult),
              VerticalDivider(width: 0.5),
              _checkContent("", qiuLine,checked: (getResult && !haveResult)),
              VerticalDivider(width: 0.5),
              _checkContent1(f,snum,haveResult),
            ],
          ),
          width: double.infinity);
      children.add(box);
      if (line++ < lineMax - 1) {
        children.add(SizedBox(height: 6));
      }
    }
    return Column( children: children);
  }

  Widget _checkContent1(PlanPlayContentItemEntity? item,int snum,bool haveResult) {
    int? type = item?.s;
    if (snum == 1 && type == 1) { type = 0;} 
    else if (type == 0) { type = null; }
    return _checkContent(item?.n ?? "", item?.o ?? "",type: type,checked: item?.r == 1,haveResult: haveResult);
  }

  Widget _checkContent(String text, String rate, {int? type, bool checked = false, bool haveResult = false, bool expanded = true}) {
    String lt = "荐";
    if (type == 1) {
      lt = "首";
    } else if (type == 2) {
      lt = "次";
    }
    bool half = text.isNotEmpty && rate.isNotEmpty;
    // var bgColor = (getResult && (type == 1 || type == 2 || type == 0)) ? Color(0xffeeeeee) : null;
    bool bingo = type != null && checked;

    Color? bgColor;
    if (type != null && (planInfo?.canRead ?? false)) {
      // TYPE_0(0, "未开"),
      // TYPE_1(1, "中"),
      // TYPE_2(2, "未中"),
      // TYPE_3(3, "取消"),
      // TYPE_4(4, "走"),
      if (planInfo?.planStatus == 0) {
        bgColor = _notReady;
      } else if (planInfo?.planStatus == 3) {
        bgColor = _cancel;
      } else if (planInfo?.planStatus == 4) {
        bgColor = _zou;
      } else if (bingo) {
        bgColor = _bingo;
      } else {
        bgColor = _unBingo;
      }
    }


    final s = Stack(
      children: [
        Positioned.fill(
            child: Container(
          color: bgColor ?? Colors.white,
          child: DefaultTextStyle(
            style: TextStyle(
                fontSize: 12, color: bgColor != null ? Colors.white : Color(0xFF292D32)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              if(text.isNotEmpty)
              Text(text), 
              if (rate.isNotEmpty)
              Text(rate)],
            ),
          ),
        )),
        if (type != null && ((planInfo?.canRead ?? false)))
          Positioned(
              left: 0,
              top: 0,
              width: 14,
              height: 14,
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: Color(0xFFFFB400),
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(4))),
                child: Text(
                  lt,
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                ),
              )),
        if (checked)
        Positioned.fill(child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(child: Container()),
            Expanded(child: Column(
              children: [
                Expanded(child: Center(child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        color: bingo ? Colors.white : Colours.main_color,
                        shape: BoxShape.circle),
                    child: Icon(
                      Icons.check,
                      size: 8,
                      color: bingo ? Colours.main_color : Colors.white,
                    )))),
                if (half)
                Expanded(child: Container())
              ],
            ))
          ],
        ))
      ],
    );
    return expanded ? Expanded(child: s) : s;
  }

  Widget _matchInfoWhiteBox(Widget child, {double? width = 38, double? height = 40}) {
    
    return DefaultTextStyle(
      style: const TextStyle(fontSize: 12,color: Colours.text_color),
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration( color: Colors.white, borderRadius: BorderRadius.circular(4) ),
        foregroundDecoration: BoxDecoration(
          border: Border.all(color: const Color(0xffeaeaea)),
          borderRadius: BorderRadius.circular(4)
        ),
        child: child,
      ),
    );
  }

}
