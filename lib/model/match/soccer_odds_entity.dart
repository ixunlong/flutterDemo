class SoccerOddsEntity {
  int? companyId;
  String? companyName;
  List<OddsData>? firstData;
  String? firstRate;
  List<OddsData>? lastData;
  String? lastRate;
  String? line;
  String? updateTime;

  SoccerOddsEntity(
      {this.companyId,
        this.companyName,
        this.firstData,
        this.firstRate,
        this.lastData,
        this.lastRate,
        this.line,
        this.updateTime});

  SoccerOddsEntity.fromJson(Map<String, dynamic> json) {
    companyId = json['companyId'];
    companyName = json['companyName'];
    if (json['firstData'] != null) {
      firstData = <OddsData>[];
      json['firstData'].forEach((v) {
        firstData!.add(new OddsData.fromJson(v));
      });
    }
    firstRate = json['firstRate'];
    if (json['lastData'] != null) {
      lastData = <OddsData>[];
      json['lastData'].forEach((v) {
        lastData!.add(new OddsData.fromJson(v));
      });
    }
    lastRate = json['lastRate'];
    line = json['line'];
    updateTime = json['updateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyId'] = this.companyId;
    data['companyName'] = this.companyName;
    if (this.firstData != null) {
      data['firstData'] = this.firstData!.map((v) => v.toJson()).toList();
    }
    data['firstRate'] = this.firstRate;
    if (this.lastData != null) {
      data['lastData'] = this.lastData!.map((v) => v.toJson()).toList();
    }
    data['lastRate'] = this.lastRate;
    data['line'] = this.line;
    data['updateTime'] = this.updateTime;
    return data;
  }
}

class OddsData {
  int? f;
  String? i;
  String? kl;
  String? n;
  String? o;
  String? p;
  String? pr;
  int? r;
  int? s;
  int? st;

  OddsData(
      {this.f,
        this.i,
        this.kl,
        this.n,
        this.o,
        this.p,
        this.pr,
        this.r,
        this.s,
        this.st});

  OddsData.fromJson(Map<String, dynamic> json) {
    f = json['f'];
    i = json['i'];
    kl = json['kl'];
    n = json['n'];
    o = json['o'];
    p = json['p'];
    pr = json['pr'];
    r = json['r'];
    s = json['s'];
    st = json['st'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['f'] = this.f;
    data['i'] = this.i;
    data['kl'] = this.kl;
    data['n'] = this.n;
    data['o'] = this.o;
    data['p'] = this.p;
    data['pr'] = this.pr;
    data['r'] = this.r;
    data['s'] = this.s;
    data['st'] = this.st;
    return data;
  }
}

class SoccerOddsDetailEntity {
  bool? beginFlag;
  String? closed;
  List<OddsData>? data;
  String? line;
  String? updateTime;

  SoccerOddsDetailEntity(
      {this.beginFlag, this.closed, this.data, this.line, this.updateTime});

  SoccerOddsDetailEntity.fromJson(Map<String, dynamic> json) {
    beginFlag = json['beginFlag'];
    closed = json['closed'];
    if (json['data'] != null) {
      data = <OddsData>[];
      json['data'].forEach((v) {
        data!.add(new OddsData.fromJson(v));
      });
    }
    line = json['line'];
    updateTime = json['updateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['beginFlag'] = this.beginFlag;
    data['closed'] = this.closed;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['line'] = this.line;
    data['updateTime'] = this.updateTime;
    return data;
  }
}

class SoccerOddsCompanyEntity {
  int? d;
  int? id;
  String? line;
  String? name;

  SoccerOddsCompanyEntity({this.d, this.id, this.line, this.name});

  SoccerOddsCompanyEntity.fromJson(Map<String, dynamic> json) {
    d = json['d'];
    id = json['id'];
    line = json['line'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['d'] = this.d;
    data['id'] = this.id;
    data['line'] = this.line;
    data['name'] = this.name;
    return data;
  }
}