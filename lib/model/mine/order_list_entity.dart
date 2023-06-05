class OrderListEntity {
  int? activityId;
  String? activityName;
  String? couponIds;
  String? couponInfo1;
  String? couponInfo2;
  String? createTime;
  String? expertId;
  String? expertLogo;
  String? expertName;
  double? gold;
  String? id;
  String? info;
  String? matchInfo;
  int? planId;
  String? planStatus;
  String? playInfo;
  List<PlayInfoList>? playInfoList;
  int? playType;
  double? price;
  int? sportsId;
  int? status;
  List<MatchList>? matchList;

  OrderListEntity(
      {this.activityId,
      this.activityName,
      this.couponIds,
      this.couponInfo1,
      this.couponInfo2,
      this.createTime,
      this.expertId,
      this.expertLogo,
      this.expertName,
      this.gold,
      this.id,
      this.info,
      this.matchInfo,
      this.planId,
      this.planStatus,
      this.playInfo,
      this.playInfoList,
      this.playType,
      this.price,
      this.sportsId,
      this.status,
      this.matchList});

  OrderListEntity.fromJson(Map<String, dynamic> json) {
    activityId = json['activityId'];
    activityName = json['activityName'];
    couponIds = json['couponIds'];
    couponInfo1 = json['couponInfo1'];
    couponInfo2 = json['couponInfo2'];
    createTime = json['createTime'];
    expertId = json['expertId'];
    expertLogo = json['expertLogo'];
    expertName = json['expertName'];
    gold = json['gold'];
    id = json['id'];
    info = json['info'];
    matchInfo = json['matchInfo'];
    planId = json['planId'];
    planStatus = json['planStatus'];
    playInfo = json['playInfo'];
    if (json['playInfoList'] != null) {
      playInfoList = <PlayInfoList>[];
      json['playInfoList'].forEach((v) {
        playInfoList!.add(new PlayInfoList.fromJson(v));
      });
    }
    playType = json['playType'];
    price = json['price'];
    sportsId = json['sportsId'];
    status = json['status'];
    if (json['matchList'] != null) {
      matchList = <MatchList>[];
      json['matchList'].forEach((v) {
        matchList!.add(new MatchList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activityId'] = this.activityId;
    data['activityName'] = this.activityName;
    data['couponIds'] = this.couponIds;
    data['couponInfo1'] = this.couponInfo1;
    data['couponInfo2'] = this.couponInfo2;
    data['createTime'] = this.createTime;
    data['expertId'] = this.expertId;
    data['expertLogo'] = this.expertLogo;
    data['expertName'] = this.expertName;
    data['gold'] = this.gold;
    data['id'] = this.id;
    data['info'] = this.info;
    data['matchInfo'] = this.matchInfo;
    data['planId'] = this.planId;
    data['planStatus'] = this.planStatus;
    data['playInfo'] = this.playInfo;
    if (this.playInfoList != null) {
      data['playInfoList'] = this.playInfoList!.map((v) => v.toJson()).toList();
    }
    data['playType'] = this.playType;
    data['price'] = this.price;
    data['sportsId'] = this.sportsId;
    data['status'] = this.status;
    if (this.matchList != null) {
      data['matchList'] = this.matchList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MatchList {
  int? matchId;
  String? matchInfo;
  List<PlayInfoList>? playInfoList;
  int? playType;
  String? playTypeName;

  MatchList(
      {this.matchId,
      this.matchInfo,
      this.playInfoList,
      this.playType,
      this.playTypeName});

  MatchList.fromJson(Map<String, dynamic> json) {
    matchId = json['matchId'];
    matchInfo = json['matchInfo'];
    if (json['playInfoList'] != null) {
      playInfoList = <PlayInfoList>[];
      json['playInfoList'].forEach((v) {
        playInfoList!.add(new PlayInfoList.fromJson(v));
      });
    }
    playType = json['playType'];
    playTypeName = json['playTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['matchId'] = this.matchId;
    data['matchInfo'] = this.matchInfo;
    if (this.playInfoList != null) {
      data['playInfoList'] = this.playInfoList!.map((v) => v.toJson()).toList();
    }
    data['playType'] = this.playType;
    data['playTypeName'] = this.playTypeName;
    return data;
  }
}

class PlayInfoList {
  String? code;
  String? name;
  int? win;

  PlayInfoList({this.code, this.name, this.win});

  PlayInfoList.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    win = json['win'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['win'] = this.win;
    return data;
  }
}
