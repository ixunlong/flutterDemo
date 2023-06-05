// TYPE_0(0, "未开"),
// TYPE_1(1, "中"),
// TYPE_2(2, "未中"),
// TYPE_3(3, "取消"),
// TYPE_4(4, "走"),

// 1001,"足球全场胜平负"
// 1002,"足球全场让球胜平负"
// 1003,"足球全场比分"
// 1004,"足球全场总进球数" 总进球
// 1005,"足球半全场" 半全场
// 1006,"足球让球/亚盘" 让球
// 1007,"足球全场进球数大小球" 大小球

class ExpertViewsEntity {
  List<Rows>? rows;
  int? total;

  ExpertViewsEntity({this.rows, this.total});

  ExpertViewsEntity.fromJson(Map<String, dynamic> json) {
    if (json['rows'] != null) {
      rows = <Rows>[];
      json['rows'].forEach((v) {
        rows!.add(new Rows.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class Rows {
  int? activityId;
  String? activityName;
  String? expertBackRatio;
  String? expertBackRatioN;
  String? expertId;
  String? expertInfo;
  String? expertLogo;
  String? expertName;
  String? expertWinRatio;
  String? expertWinRatioN;
  String? firstTag;
  List<MatchBries>? matchBries;
  int? planId;
  String? planIssueNo;
  String? planPublicTime;
  int? planStatus;
  String? planSummary;
  String? planTitle;
  String? playType;
  String? playTypeName;
  String? price;
  String? priceCoupon;
  String? priceReal;
  int? sportsId;
  int? pv;
  String? secondTag;

  Rows(
      {this.activityId,
        this.activityName,
        this.expertBackRatio,
        this.expertBackRatioN,
        this.expertId,
        this.expertInfo,
        this.expertLogo,
        this.expertName,
        this.expertWinRatio,
        this.expertWinRatioN,
        this.firstTag,
        this.matchBries,
        this.planId,
        this.planIssueNo,
        this.planPublicTime,
        this.planStatus,
        this.planSummary,
        this.planTitle,
        this.playType,
        this.playTypeName,
        this.price,
        this.priceCoupon,
        this.priceReal,
        this.sportsId,
        this.pv,
        this.secondTag});

  Rows.fromJson(Map<String, dynamic> json) {
    activityId = json['activityId'];
    activityName = json['activityName'];
    expertBackRatio = json['expertBackRatio'];
    expertBackRatioN = json['expertBackRatioN'];
    expertId = json['expertId'];
    expertInfo = json['expertInfo'];
    expertLogo = json['expertLogo'];
    expertName = json['expertName'];
    expertWinRatio = json['expertWinRatio'];
    expertWinRatioN = json['expertWinRatioN'];
    firstTag = json['firstTag'];
    if (json['matchBries'] != null) {
      matchBries = <MatchBries>[];
      json['matchBries'].forEach((v) {
        matchBries!.add(new MatchBries.fromJson(v));
      });
    }
    planId = json['planId'];
    planIssueNo = json['planIssueNo'];
    planPublicTime = json['planPublicTime'];
    planStatus = json['planStatus'];
    planSummary = json['planSummary'];
    planTitle = json['planTitle'];
    playType = json['playType'];
    playTypeName = json['playTypeName'];
    price = json['price'];
    priceCoupon = json['priceCoupon'];
    priceReal = json['priceReal'];
    sportsId = json['sportsId'];
    pv = json['pv'];
    secondTag = json['secondTag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activityId'] = this.activityId;
    data['activityName'] = this.activityName;
    data['expertBackRatio'] = this.expertBackRatio;
    data['expertBackRatioN'] = this.expertBackRatioN;
    data['expertId'] = this.expertId;
    data['expertInfo'] = this.expertInfo;
    data['expertLogo'] = this.expertLogo;
    data['expertName'] = this.expertName;
    data['expertWinRatio'] = this.expertWinRatio;
    data['expertWinRatioN'] = this.expertWinRatioN;
    data['firstTag'] = this.firstTag;
    if (this.matchBries != null) {
      data['matchBries'] = this.matchBries!.map((v) => v.toJson()).toList();
    }
    data['planId'] = this.planId;
    data['planIssueNo'] = this.planIssueNo;
    data['planPublicTime'] = this.planPublicTime;
    data['planStatus'] = this.planStatus;
    data['planSummary'] = this.planSummary;
    data['planTitle'] = this.planTitle;
    data['playType'] = this.playType;
    data['playTypeName'] = this.playTypeName;
    data['price'] = this.price;
    data['priceCoupon'] = this.priceCoupon;
    data['priceReal'] = this.priceReal;
    data['sportsId'] = this.sportsId;
    data['pv'] = this.pv;
    data['secondTag'] = this.secondTag;
    return data;
  }
}

class MatchBries {
  int? guestId;
  String? guestLogo;
  String? guestName;
  String? guestRanking;
  int? guestScore;
  int? guestScore90;
  int? guestScoreHalf;
  int? homeId;
  String? homeLogo;
  String? homeName;
  String? homeRanking;
  int? homeScore;
  int? homeScore90;
  int? homeScoreHalf;
  int? leagueId;
  String? leagueName;
  String? locationCn;
  int? matchId;
  String? matchTime;
  String? rounds;
  int? sportsId;
  int? status;
  String? weatherCn;

  MatchBries(
      {this.guestId,
        this.guestLogo,
        this.guestName,
        this.guestRanking,
        this.guestScore,
        this.guestScore90,
        this.guestScoreHalf,
        this.homeId,
        this.homeLogo,
        this.homeName,
        this.homeRanking,
        this.homeScore,
        this.homeScore90,
        this.homeScoreHalf,
        this.leagueId,
        this.leagueName,
        this.locationCn,
        this.matchId,
        this.matchTime,
        this.rounds,
        this.sportsId,
        this.status,
        this.weatherCn});

  MatchBries.fromJson(Map<String, dynamic> json) {
    guestId = json['guestId'];
    guestLogo = json['guestLogo'];
    guestName = json['guestName'];
    guestRanking = json['guestRanking'];
    guestScore = json['guestScore'];
    guestScore90 = json['guestScore90'];
    guestScoreHalf = json['guestScoreHalf'];
    homeId = json['homeId'];
    homeLogo = json['homeLogo'];
    homeName = json['homeName'];
    homeRanking = json['homeRanking'];
    homeScore = json['homeScore'];
    homeScore90 = json['homeScore90'];
    homeScoreHalf = json['homeScoreHalf'];
    leagueId = json['leagueId'];
    leagueName = json['leagueName'];
    locationCn = json['locationCn'];
    matchId = json['matchId'];
    matchTime = json['matchTime'];
    rounds = json['rounds'];
    sportsId = json['sportsId'];
    status = json['status'];
    weatherCn = json['weatherCn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['guestId'] = this.guestId;
    data['guestLogo'] = this.guestLogo;
    data['guestName'] = this.guestName;
    data['guestRanking'] = this.guestRanking;
    data['guestScore'] = this.guestScore;
    data['guestScore90'] = this.guestScore90;
    data['guestScoreHalf'] = this.guestScoreHalf;
    data['homeId'] = this.homeId;
    data['homeLogo'] = this.homeLogo;
    data['homeName'] = this.homeName;
    data['homeRanking'] = this.homeRanking;
    data['homeScore'] = this.homeScore;
    data['homeScore90'] = this.homeScore90;
    data['homeScoreHalf'] = this.homeScoreHalf;
    data['leagueId'] = this.leagueId;
    data['leagueName'] = this.leagueName;
    data['locationCn'] = this.locationCn;
    data['matchId'] = this.matchId;
    data['matchTime'] = this.matchTime;
    data['rounds'] = this.rounds;
    data['sportsId'] = this.sportsId;
    data['status'] = this.status;
    data['weatherCn'] = this.weatherCn;
    return data;
  }
}