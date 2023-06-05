class DataTransferEntity {
  List<Periods>? periods;
  List<Teams>? teams;
  List<Transfers>? transfers;

  DataTransferEntity({this.periods, this.teams, this.transfers});

  DataTransferEntity.fromJson(Map<String, dynamic> json) {
    if (json['periods'] != null) {
      periods = <Periods>[];
      json['periods'].forEach((v) {
        periods!.add(new Periods.fromJson(v));
      });
    }
    if (json['teams'] != null) {
      teams = <Teams>[];
      json['teams'].forEach((v) {
        teams!.add(new Teams.fromJson(v));
      });
    }
    if (json['transfers'] != null) {
      transfers = <Transfers>[];
      json['transfers'].forEach((v) {
        transfers!.add(new Transfers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.periods != null) {
      data['periods'] = this.periods!.map((v) => v.toJson()).toList();
    }
    if (this.teams != null) {
      data['teams'] = this.teams!.map((v) => v.toJson()).toList();
    }
    if (this.transfers != null) {
      data['transfers'] = this.transfers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Periods {
  int? key;
  String? value;

  Periods({this.key, this.value});

  Periods.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }
}

class Teams {
  int? leagueId;
  String? nameChs;
  int? teamQxbId;
  int? teamId;
  int? rank;
  String? season;

  Teams(
      {this.leagueId,
      this.nameChs,
      this.teamQxbId,
      this.teamId,
      this.rank,
      this.season});

  Teams.fromJson(Map<String, dynamic> json) {
    leagueId = json['leagueId'];
    nameChs = json['nameChs'];
    teamQxbId = json['teamQxbId'];
    teamId = json['teamId'];
    rank = json['rank'];
    season = json['season'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leagueId'] = this.leagueId;
    data['nameChs'] = this.nameChs;
    data['teamQxbId'] = this.teamQxbId;
    data['teamId'] = this.teamId;
    data['rank'] = this.rank;
    data['season'] = this.season;
    return data;
  }
}

class Transfers {
  int? playerId;
  String? transferPeriod;
  String? transferTime;
  String? endTime;
  String? fromTeamCn;
  int? fromTeamId;
  String? toTeamCn;
  int? toTeamId;
  String? transferTypeCn;
  String? money;
  String? birthday;
  int? age;
  String? countryCn;
  String? height;
  String? weight;
  String? nameChs;
  String? nameEn;
  String? photo;
  String? positionCn;

  Transfers(
      {this.playerId,
      this.transferPeriod,
      this.transferTime,
      this.endTime,
      this.fromTeamCn,
      this.fromTeamId,
      this.toTeamCn,
      this.toTeamId,
      this.transferTypeCn,
      this.money,
      this.birthday,
      this.age,
      this.countryCn,
      this.height,
      this.weight,
      this.nameChs,
      this.nameEn,
      this.photo,
      this.positionCn});

  Transfers.fromJson(Map<String, dynamic> json) {
    playerId = json['playerId'];
    transferPeriod = json['transferPeriod'];
    transferTime = json['transferTime'];
    endTime = json['endTime'];
    fromTeamCn = json['fromTeamCn'];
    fromTeamId = json['fromTeamId'];
    toTeamCn = json['toTeamCn'];
    toTeamId = json['toTeamId'];
    transferTypeCn = json['transferTypeCn'];
    money = json['money'];
    birthday = json['birthday'];
    age = json['age'];
    countryCn = json['countryCn'];
    height = json['height'];
    weight = json['weight'];
    nameChs = json['nameChs'];
    nameEn = json['nameEn'];
    photo = json['photo'];
    positionCn = json['positionCn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['playerId'] = this.playerId;
    data['transferPeriod'] = this.transferPeriod;
    data['transferTime'] = this.transferTime;
    data['endTime'] = this.endTime;
    data['fromTeamCn'] = this.fromTeamCn;
    data['fromTeamId'] = this.fromTeamId;
    data['toTeamCn'] = this.toTeamCn;
    data['toTeamId'] = this.toTeamId;
    data['transferTypeCn'] = this.transferTypeCn;
    data['money'] = this.money;
    data['birthday'] = this.birthday;
    data['age'] = this.age;
    data['countryCn'] = this.countryCn;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['nameChs'] = this.nameChs;
    data['nameEn'] = this.nameEn;
    data['photo'] = this.photo;
    data['positionCn'] = this.positionCn;
    return data;
  }
}
