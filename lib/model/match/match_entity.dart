/// Status
/// TYPE_1(1, "未开赛"),
/// TYPE_2(2, "上半场"),
/// TYPE_3(3, "中场"),
/// TYPE_4(4, "下半场"),
/// TYPE_5(5, "加时"),
/// TYPE_6(6, "点球"),
/// TYPE_7(7, "完场"),
/// TYPE_8(8, "取消"),
/// TYPE_9(9, "中断"),
/// TYPE_10(10, "腰斩"),
/// TYPE_11(11, "延期"),
/// TYPE_12(12, "待定"),
/// TYPE_99(99, "未知"),

class MatchEntity with MatchFollow {
  int? id;
  int? anchors;
  String? color;
  String? dcMatchNo;
  int? guestCorner;
  String? guestLogo;
  String? guestName;
  String? guestRanking;
  int? guestRed;
  int? guestScore90;
  int? guestScoreHalf;
  int? guestScoreOt;
  int? guestScorePk;
  int? guestYellow;
  int? homeCorner;
  String? homeLogo;
  String? homeName;
  String? homeRanking;
  int? homeRed;
  int? homeScore90;
  int? homeScoreHalf;
  int? homeScoreOt;
  int? homeScorePk;
  int? homeYellow;
  int? intelligence;
  String? jcMatchNo;
  String? leagueName;
  String? leagueColor;
  int? leagueId;
  int? lineup;
  String? matchDate;
  String? matchTime;
  String? rounds;
  String? sfcMatchNo;
  String? show;
  String? status;
  int? fjLiveId;
  String? locationCn;
  int? neutrality;
  int? planCnt;
  List<OddsList>? oddsList;
  int? video;

  MatchEntity(
      {this.id,
      this.anchors,
      this.color,
      this.dcMatchNo,
      this.guestCorner,
      this.guestLogo,
      this.guestName,
      this.guestRanking,
      this.guestRed,
      this.guestScore90,
      this.guestScoreHalf,
      this.guestYellow,
      this.homeCorner,
      this.homeLogo,
      this.homeName,
      this.homeRanking,
      this.homeRed,
      this.homeScore90,
      this.homeScoreHalf,
      this.homeYellow,
      this.intelligence,
      this.jcMatchNo,
      this.leagueName,
      this.leagueColor,
      this.leagueId,
      this.lineup,
      this.matchDate,
      this.matchTime,
      this.rounds,
      this.sfcMatchNo,
      this.show,
      this.status,
      this.fjLiveId,
      this.locationCn,
      this.neutrality,
      this.oddsList,
      this.planCnt,
      this.video});

  MatchEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    anchors = json['anchors'];
    color = json['color'];
    dcMatchNo = json['dcMatchNo'];
    guestCorner = json['guestCorner'];
    guestLogo = json['guestLogo'];
    guestName = json['guestName'];
    guestRanking = json['guestRanking'];
    guestRed = json['guestRed'];
    guestScore90 = json['guestScore90'];
    guestScoreHalf = json['guestScoreHalf'];
    guestScoreOt = json['guestScoreOt'];
    guestScorePk = json['guestScorePk'];
    guestYellow = json['guestYellow'];
    homeCorner = json['homeCorner'];
    homeLogo = json['homeLogo'];
    homeName = json['homeName'];
    homeRanking = json['homeRanking'];
    homeRed = json['homeRed'];
    homeScore90 = json['homeScore90'];
    homeScoreHalf = json['homeScoreHalf'];
    homeScoreOt = json['homeScoreOt'];
    homeScorePk = json['homeScorePk'];
    homeYellow = json['homeYellow'];
    intelligence = json['intelligence'];
    jcMatchNo = json['jcMatchNo'];
    leagueName = json['leagueName'];
    leagueColor = json['leagueColor'];
    leagueId = json['leagueId'];
    lineup = json['lineup'];
    matchDate = json['matchDate'];
    matchTime = json['matchTime'];
    rounds = json['rounds'];
    sfcMatchNo = json['sfcMatchNo'];
    show = json['show'];
    status = json['status'];
    fjLiveId = json['fjLiveId'];
    locationCn = json['locationCn'];
    neutrality = json['neutrality'];
    planCnt = json['planCnt'];
    video = json['video'];
    if (json['oddsList'] != null) {
      oddsList = <OddsList>[];
      json['oddsList'].forEach((v) {
        oddsList!.add(new OddsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['anchors'] = this.anchors;
    data['color'] = this.color;
    data['dcMatchNo'] = this.dcMatchNo;
    data['guestCorner'] = this.guestCorner;
    data['guestLogo'] = this.guestLogo;
    data['guestName'] = this.guestName;
    data['guestRanking'] = this.guestRanking;
    data['guestRed'] = this.guestRed;
    data['guestScore90'] = this.guestScore90;
    data['guestScoreHalf'] = this.guestScoreHalf;
    data['guestScoreOt'] = this.guestScoreOt;
    data['guestScorePk'] = this.guestScorePk;
    data['guestYellow'] = this.guestYellow;
    data['homeCorner'] = this.homeCorner;
    data['homeLogo'] = this.homeLogo;
    data['homeName'] = this.homeName;
    data['homeRanking'] = this.homeRanking;
    data['homeRed'] = this.homeRed;
    data['homeScore90'] = this.homeScore90;
    data['homeScoreHalf'] = this.homeScoreHalf;
    data['homeScoreOt'] = this.homeScoreOt;
    data['homeScorePk'] = this.homeScorePk;
    data['homeYellow'] = this.homeYellow;
    data['intelligence'] = this.intelligence;
    data['jcMatchNo'] = this.jcMatchNo;
    data['leagueName'] = this.leagueName;
    data['leagueColor'] = this.leagueColor;
    data['leagueId'] = this.leagueId;
    data['lineup'] = this.lineup;
    data['matchDate'] = this.matchDate;
    data['matchTime'] = this.matchTime;
    data['rounds'] = this.rounds;
    data['sfcMatchNo'] = this.sfcMatchNo;
    data['show'] = this.show;
    data['status'] = this.status;
    data['fjLiveId'] = this.fjLiveId;
    data['locationCn'] = this.locationCn;
    data['neutrality'] = this.neutrality;
    data['planCnt'] = this.planCnt;
    data['video'] = this.video;
    if (this.oddsList != null) {
      data['oddsList'] = this.oddsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OddsList {
  int? p;
  int? c;
  String? cn;
  String? d;
  String? l;
  String? o1;
  String? o2;

  OddsList({this.p, this.c, this.cn, this.d, this.l, this.o1, this.o2});

  OddsList.fromJson(Map<String, dynamic> json) {
    p = json['p'];
    c = json['c'];
    cn = json['cn'];
    d = json['d'];
    l = json['l'];
    o1 = json['o1'];
    o2 = json['o2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['p'] = this.p;
    data['c'] = this.c;
    data['cn'] = this.cn;
    data['d'] = this.d;
    data['l'] = this.l;
    data['o1'] = this.o1;
    data['o2'] = this.o2;
    return data;
  }
}

mixin MatchFollow {
  bool isFollow = false;
  bool lastMatchInDay = false;
}
