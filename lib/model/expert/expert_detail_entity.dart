class ExpertDetailEntity {
  Record? bbDetail;
  Record? fbDetail;
  String? focus;
  String? id;
  String? info;
  String? isFocus;
  int? isShowBb;
  int? isShowFb;
  String? logo;
  String? name;
  int? type;

  ExpertDetailEntity(
      {this.bbDetail,
        this.fbDetail,
        this.focus,
        this.id,
        this.info,
        this.isFocus,
        this.isShowBb,
        this.isShowFb,
        this.logo,
        this.name,
        this.type});

  ExpertDetailEntity.fromJson(Map<String, dynamic> json) {
    bbDetail = json['bbDetail'] != null
        ? new Record.fromJson(json['bbDetail'])
        : null;
    fbDetail = json['fbDetail'] != null
        ? new Record.fromJson(json['fbDetail'])
        : null;
    focus = json['focus'];
    id = json['id'];
    info = json['info'];
    isFocus = json['isFocus'];
    isShowBb = json['isShowBb'];
    isShowFb = json['isShowFb'];
    logo = json['logo'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bbDetail != null) {
      data['bbDetail'] = this.bbDetail!.toJson();
    }
    if (this.fbDetail != null) {
      data['fbDetail'] = this.fbDetail!.toJson();
    }
    data['focus'] = this.focus;
    data['id'] = this.id;
    data['info'] = this.info;
    data['isFocus'] = this.isFocus;
    data['isShowBb'] = this.isShowBb;
    data['isShowFb'] = this.isShowFb;
    data['logo'] = this.logo;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
}

class Record {
  List<Achievement>? achievement;
  String? backRatio;
  String? backRatioM;
  String? redKeep;
  String? redKeepHigh;
  String? valueN;
  String? winRatio;
  String? winRatioM;

  Record(
      {this.achievement,
        this.backRatio,
        this.backRatioM,
        this.redKeep,
        this.redKeepHigh,
        this.valueN,
        this.winRatio,
        this.winRatioM});

  Record.fromJson(Map<String, dynamic> json) {
    if (json['achievement'] != null) {
      achievement = <Achievement>[];
      json['achievement'].forEach((v) {
        achievement!.add(new Achievement.fromJson(v));
      });
    }
    backRatio = json['backRatio'];
    backRatioM = json['backRatioM'];
    redKeep = json['redKeep'];
    redKeepHigh = json['redKeepHigh'];
    valueN = json['valueN'];
    winRatio = json['winRatio'];
    winRatioM = json['winRatioM'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.achievement != null) {
      data['achievement'] = this.achievement!.map((v) => v.toJson()).toList();
    }
    data['backRatio'] = this.backRatio;
    data['backRatioM'] = this.backRatioM;
    data['redKeep'] = this.redKeep;
    data['redKeepHigh'] = this.redKeepHigh;
    data['valueN'] = this.valueN;
    data['winRatio'] = this.winRatio;
    data['winRatioM'] = this.winRatioM;
    return data;
  }
}

class Achievement {
  int? planId;
  int? status;

  Achievement({this.planId, this.status});

  Achievement.fromJson(Map<String, dynamic> json) {
    planId = json['planId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['planId'] = this.planId;
    data['status'] = this.status;
    return data;
  }
}