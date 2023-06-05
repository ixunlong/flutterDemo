class DataRankEntity {
  String? areaCn;
  String? areaEn;
  String? logo;
  String? nameChs;
  String? nameEn;
  int? rank;
  int? rankChange;
  String? rankMonth;
  int? score;
  int? scoreChange;
  int? teamId;
  int? teamQxbId;
  int? type;

  DataRankEntity(
      {this.areaCn,
        this.areaEn,
        this.logo,
        this.nameChs,
        this.nameEn,
        this.rank,
        this.rankChange,
        this.rankMonth,
        this.score,
        this.scoreChange,
        this.teamId,
        this.teamQxbId,
        this.type});

  DataRankEntity.fromJson(Map<String, dynamic> json) {
    areaCn = json['areaCn'];
    areaEn = json['areaEn'];
    logo = json['logo'];
    nameChs = json['nameChs'];
    nameEn = json['nameEn'];
    rank = json['rank'];
    rankChange = json['rankChange'];
    rankMonth = json['rankMonth'];
    score = json['score'];
    scoreChange = json['scoreChange'];
    teamId = json['teamId'];
    teamQxbId = json['teamQxbId'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['areaCn'] = this.areaCn;
    data['areaEn'] = this.areaEn;
    data['logo'] = this.logo;
    data['nameChs'] = this.nameChs;
    data['nameEn'] = this.nameEn;
    data['rank'] = this.rank;
    data['rankChange'] = this.rankChange;
    data['rankMonth'] = this.rankMonth;
    data['score'] = this.score;
    data['scoreChange'] = this.scoreChange;
    data['teamId'] = this.teamId;
    data['teamQxbId'] = this.teamQxbId;
    data['type'] = this.type;
    return data;
  }
}

class DataRankMonthEntity {
  String? rankMonth;

  DataRankMonthEntity({this.rankMonth});

  DataRankMonthEntity.fromJson(Map<String, dynamic> json) {
    rankMonth = json['rankMonth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rankMonth'] = this.rankMonth;
    return data;
  }
}

class DataBbRankEntity {
  String? logo;
  int? score;
  int? rankChange;
  int? teamQxbId;
  int? rank;
  int? regionId;
  String? nameChs;

  DataBbRankEntity(
      {this.logo,
        this.score,
        this.rankChange,
        this.teamQxbId,
        this.rank,
        this.regionId,
        this.nameChs});

  DataBbRankEntity.fromJson(Map<String, dynamic> json) {
    logo = json['logo'];
    score = json['points'].toInt();
    rankChange = json['positionChanged'];
    teamQxbId = json['qxbTeamId'];
    rank = json['ranking'];
    regionId = json['regionId'];
    nameChs = json['teamName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['logo'] = this.logo;
    data['points'] = this.score;
    data['positionChanged'] = this.rankChange;
    data['qxbTeamId'] = this.teamQxbId;
    data['ranking'] = this.rank;
    data['regionId'] = this.regionId;
    data['teamName'] = this.nameChs;
    return data;
  }
}

class DataBbRankMonthEntity {
  String? rankMonth;

  DataBbRankMonthEntity({this.rankMonth});

  DataBbRankMonthEntity.fromJson(Map<String, dynamic> json) {
    rankMonth = json['month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this.rankMonth;
    return data;
  }
}