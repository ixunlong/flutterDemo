import 'dart:developer';

import 'package:intl/intl.dart';
import 'expert_views_entity.dart';

class PlanInfoEntity {
  int? activityId;
  String? activityName;
	String? beginTime;
	String? expertId;
	String? expertLogo;
	String? expertName;
	String? firstTag;
  int? sportsId;
	List<PlanItemShowEntity>? itemShow;
	List<PlanMatchBriesEntity>? matchBries;
	String? payCnt;
	String? planContent;
	int? planId;
	String? planIsOrder;
	String? planIssueNo;
	String? planPublicTime;
	int? planStatus;
	String? planSummary;
	String? planTitle;
	String? price;
	String? priceReal;
	List<Rows>? pushPlan;
	String? secondTag;
  int? isFocus;
  int? pv;
  int? isCanPay;
  int? isCanRead;
  String? footerContent;
  int? isShowFooter;
  String? feeContent;
  int? feeContentCnt;
  String? freeContent;

	PlanInfoEntity({this.activityId, this.activityName, this.beginTime, this.expertId, this.expertLogo, this.expertName, this.firstTag, this.sportsId, this.itemShow, this.matchBries, this.payCnt, this.planContent, this.planId, this.planIsOrder, this.planIssueNo, this.planPublicTime, this.planStatus, this.planSummary, this.planTitle, this.price, this.priceReal, this.pushPlan, this.secondTag,this.feeContent,this.feeContentCnt,this.freeContent});

	PlanInfoEntity.fromJson(Map<String, dynamic> json) {
    // log('plan info entity $json');
    activityId = json['activityId'];
    activityName = json['activityName'];
		beginTime = json['beginTime'];
		expertId = json['expertId'];
		expertLogo = json['expertLogo'];
		expertName = json['expertName'];
		firstTag = json['firstTag'];
    sportsId = json['sportsId'];
		if (json['itemShow'] != null) {
			itemShow = <PlanItemShowEntity>[];
			json['itemShow'].forEach((v) {
        if (v == null){ return; }
         itemShow!.add(new PlanItemShowEntity.fromJson(v));
      });
		}
		if (json['matchBries'] != null) {
			matchBries = <PlanMatchBriesEntity>[];
			json['matchBries'].forEach((v) {
        if (v == null) { return; }
        matchBries!.add(new PlanMatchBriesEntity.fromJson(v));
      });
		}
		payCnt = json['payCnt'];
		planContent = json['planContent'];
		planId = json['planId'];
		planIsOrder = json['planIsOrder'];
		planIssueNo = json['planIssueNo'];
		planPublicTime = json['planPublicTime'];
		planStatus = json['planStatus'];
		planSummary = json['planSummary'];
		planTitle = json['planTitle'];
		price = json['price'];
		priceReal = json['priceReal'];
    // if (json['pushPlan'] != null) {
    //   pushPlan = [];
    //   (json['pushPlan'] as List).forEach((element) { pushPlan!.add(Rows.fromJson(element)); });
    // }
		pushPlan = json['pushPlan'] != null ? (json['pushPlan'] as List).map((e) => Rows.fromJson(e)).toList() : null;
		secondTag = json['secondTag'];
    pv = json['pv'];
    isFocus = json['isFocus'];
    isCanPay = json['isCanPay'];
    isCanRead = json['isCanRead'];
    footerContent = json['footerContent'];
    isShowFooter = json['isShowFooter'];
    feeContent = json['feeContent'];
    feeContentCnt = json['feeContentCnt'];
    freeContent = json['freeContent'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activityId'] = this.activityId;
    data['activityName'] = this.activityName;
		data['beginTime'] = this.beginTime;
		data['expertId'] = this.expertId;
		data['expertLogo'] = this.expertLogo;
		data['expertName'] = this.expertName;
		data['firstTag'] = this.firstTag;
    data['sportsId'] = this.sportsId;
		if (this.itemShow != null) {
      data['itemShow'] = this.itemShow!.map((v) => v.toJson()).toList();
    }
		if (this.matchBries != null) {
      data['matchBries'] = this.matchBries!.map((v) => v.toJson()).toList();
    }
		data['payCnt'] = this.payCnt;
		data['planContent'] = this.planContent;
		data['planId'] = this.planId;
		data['planIsOrder'] = this.planIsOrder;
		data['planIssueNo'] = this.planIssueNo;
		data['planPublicTime'] = this.planPublicTime;
		data['planStatus'] = this.planStatus;
		data['planSummary'] = this.planSummary;
		data['planTitle'] = this.planTitle;
		data['price'] = this.price;
		data['priceReal'] = this.priceReal;
		if (this.pushPlan != null) {
      data['pushPlan'] = this.pushPlan!.map((e) => e.toJson()).toList();
    }
		data['secondTag'] = this.secondTag;
    data['pv'] = pv;
    data['isFocus'] = isFocus;
    data['isCanPay'] = isCanPay;
    data['isCanRead'] = isCanRead;
    data['footerContent'] = footerContent;
    data['isShowFooter'] = isShowFooter;
    data['feeContent'] = feeContent;
    data['feeContentCnt'] = feeContentCnt;
    data['freeContent'] = freeContent;
		return data;
	}
}

class PlanMatchBriesEntity {
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
  int? matchId;
  String? matchTime;
  String? rounds;
  int? status;
  String? weatherCn;
  String? locationCn;

  int? sportsId;

  PlanMatchBriesEntity(
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
      this.matchId,
      this.matchTime,
      this.rounds,
      this.status,
      this.weatherCn,
      this.locationCn,
      this.sportsId});

  PlanMatchBriesEntity.fromJson(Map<String, dynamic> json) {
    guestId = json['guestId'];
    guestLogo = json['guestLogo'];
    guestName = json['guestName'];
    guestRanking = json['guestRanking'];
    guestScore90 = json['guestScore90'];
    guestScoreHalf = json['guestScoreHalf'];
    homeId = json['homeId'];
    homeLogo = json['homeLogo'];
    homeName = json['homeName'];
    homeRanking = json['homeRanking'];
    homeScore90 = json['homeScore90'];
    homeScoreHalf = json['homeScoreHalf'];
    leagueId = json['leagueId'];
    leagueName = json['leagueName'];
    matchId = json['matchId'];
    matchTime = json['matchTime'];
    rounds = json['rounds'];
    status = json['status'];
    weatherCn = json['weatherCn'];
    locationCn = json['locationCn'];
    sportsId = json['sportsId'];
    homeScore = json['homeScore'];
    guestScore = json['guestScore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['guestId'] = this.guestId;
    data['guestLogo'] = this.guestLogo;
    data['guestName'] = this.guestName;
    data['guestRanking'] = this.guestRanking;
    data['guestScore90'] = this.guestScore90;
    data['guestScoreHalf'] = this.guestScoreHalf;
    data['homeId'] = this.homeId;
    data['homeLogo'] = this.homeLogo;
    data['homeName'] = this.homeName;
    data['homeRanking'] = this.homeRanking;
    data['homeScore90'] = this.homeScore90;
    data['homeScoreHalf'] = this.homeScoreHalf;
    data['leagueId'] = this.leagueId;
    data['leagueName'] = this.leagueName;
    data['matchId'] = this.matchId;
    data['matchTime'] = this.matchTime;
    data['rounds'] = this.rounds;
    data['status'] = this.status;
    data['weatherCn'] = this.weatherCn;
    data['locationCn'] = this.locationCn;
    data['sportsId'] = this.sportsId;
    data['homeScore'] = this.homeScore;
    data['guestScore'] = this.guestScore;
    return data;
  }
}

class PlanPushPlanEntity {
  String? expertBackRatio;
  String? expertId;
  String? expertInfo;
  String? expertLogo;
  String? expertName;
  String? firstTag;
  List<PlanMatchBriesEntity>? matchBries;
  int? planId;
  String? planIssueNo;
  String? planPublicTime;
  int? planStatus;
  String? planSummary;
  String? planTitle;
  String? secondTag;

  PlanPushPlanEntity(
      {this.expertBackRatio,
      this.expertId,
      this.expertInfo,
      this.expertLogo,
      this.expertName,
      this.firstTag,
      this.matchBries,
      this.planId,
      this.planIssueNo,
      this.planPublicTime,
      this.planStatus,
      this.planSummary,
      this.planTitle,
      this.secondTag});

  PlanPushPlanEntity.fromJson(Map<String, dynamic> json) {
    expertBackRatio = json['expertBackRatio'];
    expertId = json['expertId'];
    expertInfo = json['expertInfo'];
    expertLogo = json['expertLogo'];
    expertName = json['expertName'];
    firstTag = json['firstTag'];
    if (json['matchBries'] != null) {
      matchBries = <PlanMatchBriesEntity>[];
      json['matchBries'].forEach((v) {
        matchBries!.add(new PlanMatchBriesEntity.fromJson(v));
      });
    }
    planId = json['planId'];
    planIssueNo = json['planIssueNo'];
    planPublicTime = json['planPublicTime'];
    planStatus = json['planStatus'];
    planSummary = json['planSummary'];
    planTitle = json['planTitle'];
    secondTag = json['secondTag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expertBackRatio'] = this.expertBackRatio;
    data['expertId'] = this.expertId;
    data['expertInfo'] = this.expertInfo;
    data['expertLogo'] = this.expertLogo;
    data['expertName'] = this.expertName;
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
    data['secondTag'] = this.secondTag;
    return data;
  }
}

class PlanPlayContentItemEntity {
  String? i;
  String? n;
  String? o;
  String? p;
  int? r;
  int? s;

  PlanPlayContentItemEntity({this.i, this.n, this.o, this.p, this.r, this.s});

  PlanPlayContentItemEntity.fromJson(Map<String, dynamic> json) {
    i = json['i'];
    n = json['n'];
    o = json['o'];
    p = json['p'];
    r = json['r'];
    s = json['s'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['i'] = this.i;
    data['n'] = this.n;
    data['o'] = this.o;
    data['p'] = this.p;
    data['r'] = this.r;
    data['s'] = this.s;
    return data;
  }
}

class PlanPlayContentEntity {
  String? line;
  List<PlanPlayContentItemEntity>? list;
  int? status;
  int? used;

  PlanPlayContentEntity({this.line, this.list, this.status, this.used});

  PlanPlayContentEntity.fromJson(Map<String, dynamic> json) {
    line = json['line'];
    if (json['list'] != null) {
      list = <PlanPlayContentItemEntity>[];
      json['list'].forEach((v) {
        list!.add(new PlanPlayContentItemEntity.fromJson(v));
      });
    }
    status = json['status'];
    used = json['used'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['line'] = this.line;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['used'] = this.used;
    return data;
  }
}

class PlanItemShowEntity {
	PlanPlayContentEntity? bf;
	PlanPlayContentEntity? bqc;
	List<PlanPlayContentEntity>? dx;
  List<PlanPlayContentEntity>? sp;
	PlanPlayContentEntity? jqs;
	int? matchId;
	int? playType;
	String? playTypeName;
	List<PlanPlayContentEntity>? rqSpf;
	PlanPlayContentEntity? spf;
	int? status;
	List<PlanPlayContentEntity>? yp;

  List<PlanPlayContentEntity>? lqDx;
  List<PlanPlayContentEntity>? lqRqSf;
  PlanPlayContentEntity? lqSf;

	PlanItemShowEntity({this.bf,
    this.bqc,
    this.dx,
    this.jqs,
    this.matchId,
    this.playType,
    this.playTypeName,
    this.rqSpf,
    this.spf,
    this.status,
    this.yp,
    this.lqDx,
    this.lqRqSf,
    this.lqSf,
    this.sp
  });

  List<PlanPlayContentEntity>? getContentFrom(dynamic l) {
    log("$l");
    if (l == null || l is! List) { return null;}
    return l.map((e) => PlanPlayContentEntity.fromJson(e)).toList();
  }

	PlanItemShowEntity.fromJson(Map<String, dynamic> json) {
		// bf = json['bf'] != null ? new PlanPlayContentEntity.fromJson(json['bf']) : null;
    bf = json['bf'] == null ? null : PlanPlayContentEntity.fromJson(json['bf']);
		bqc = json['bqc'] == null ? null : PlanPlayContentEntity.fromJson(json['bqc']);
		dx = getContentFrom(json['dx']);
		jqs = json['jqs'] == null ? null : PlanPlayContentEntity.fromJson(json['jqs']);
		matchId = json['matchId'];
		playType = json['playType'];
		playTypeName = json['playTypeName'];
		rqSpf = getContentFrom(json['rqSpf']);
		spf = json['spf'] == null ? null : PlanPlayContentEntity.fromJson(json['spf']);;
		status = json['status'];

    yp = getContentFrom(json['yp']);
    sp = getContentFrom(json['sp']);
		// yp = json['yp'] != null ? PlanPlayContentEntity.fromJson(json['yp']) : null;
    lqDx = getContentFrom(json['lqDx']);
    lqRqSf = getContentFrom(json['lqRqSf']);
    lqSf = json['lqSf'] == null ? null : PlanPlayContentEntity.fromJson(json['lqSf']);
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.bf != null) {
      data['bf'] = this.bf!.toJson();
    }
		if (this.bqc != null) {
      data['bqc'] = this.bqc!.toJson();
    }
		if (this.dx != null) {
      data['dx'] = this.dx!.map((e) => e.toJson());
    }
		if (this.jqs != null) {
      data['jqs'] = this.jqs!.toJson();
    }
		data['matchId'] = this.matchId;
		data['playType'] = this.playType;
		data['playTypeName'] = this.playTypeName;
		if (this.rqSpf != null) {
      data['rqSpf'] = this.rqSpf!.map((e) => e.toJson());
    }
		if (this.spf != null) {
      data['spf'] = this.spf!.toJson();
    }
		data['status'] = this.status;
		if (this.yp != null) {
      data['yp'] = this.yp!.map(((e) => e.toJson()));
    }
    if (this.sp != null) {
      data['sp'] = this.sp!.map((e) => e.toJson());
    }
    data['lqDx'] = lqDx?.map((e) => e.toJson());
    data['lqRqSf'] = lqRqSf?.map((e) => e.toJson());
    data['lqSf'] = lqSf?.toJson();
		return data;
	}
}

// PlanItemShowEntity status
// TYPE_0(0,"未开"),
// TYPE_1(1,"中"),
// TYPE_2(2,"未中"),
// TYPE_3(3,"取消");

final _df = DateFormat("yyyy-MM-dd HH:mm:ss");

extension PlanMatchBriesEntityEx1 on PlanMatchBriesEntity {
  DateTime? get matchTimeDate => DateTime.tryParse(matchTime ?? "")?.toLocal();
  bool get isMatchStart => ((matchTimeDate?.difference(DateTime.now()))?.inSeconds ?? 1) < 0;
}

extension PlanInfoEx1 on PlanInfoEntity {
  DateTime? get pubTime => DateTime.tryParse(planPublicTime ?? "")?.toLocal();
  PlanMatchBriesEntity? get match => (matchBries?.isEmpty ?? true) ? null : matchBries?.first;
  DateTime? get matchTime => DateTime.tryParse(beginTime ?? "")?.toLocal();
  // bool? get isMatchStart => (matchTime?.difference(DateTime.now()).inSeconds ?? 1) < 0;

  int get uvCount => int.tryParse(payCnt ?? "") ?? 0;

  bool get hasPayed => (int.tryParse(planIsOrder ?? "") ?? 0) > 0;
  // bool get getIsFree => (isFree ?? 0) > 0;
  bool get canRead => (isCanRead ?? 0) > 0;
  bool get canPay => (isCanPay ?? 0) > 0;
  bool get showFooter => (isShowFooter ?? 0) > 0;
}