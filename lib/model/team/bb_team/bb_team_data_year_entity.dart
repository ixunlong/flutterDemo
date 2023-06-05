class BbTeamDataYearEntity {
  String? seasonYear;
  int? seasonId;
  List<LeagueInfo>? leagueInfo;

  BbTeamDataYearEntity({this.seasonYear, this.leagueInfo});

  BbTeamDataYearEntity.fromJson(Map<String, dynamic> json) {
    seasonYear = json['seasonYear'];
    seasonId = json['seasonId'];
    if (json['leagueInfo'] != null) {
      leagueInfo = <LeagueInfo>[];
      json['leagueInfo'].forEach((v) {
        leagueInfo!.add(new LeagueInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seasonYear'] = this.seasonYear;
    data['seasonId'] = this.seasonId;
    if (this.leagueInfo != null) {
      data['leagueInfo'] = this.leagueInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeagueInfo {
  int? leagueId;
  String? leagueName;
  List<Scope>? scope;

  LeagueInfo({this.leagueId, this.leagueName, this.scope});

  LeagueInfo.fromJson(Map<String, dynamic> json) {
    leagueId = json['leagueId'];
    leagueName = json['leagueName'];
    if (json['scope'] != null) {
      scope = <Scope>[];
      json['scope'].forEach((v) {
        scope!.add(new Scope.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leagueId'] = this.leagueId;
    data['leagueName'] = this.leagueName;
    if (this.scope != null) {
      data['scope'] = this.scope!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Scope {
  int? scopeId;
  String? scopeName;
  int? stageId;
  String? stageName;

  Scope({this.scopeId, this.scopeName, this.stageId, this.stageName});

  Scope.fromJson(Map<String, dynamic> json) {
    scopeId = json['scopeId'];
    scopeName = json['scopeName'];
    stageId = json['stageId'];
    stageName = json['stageName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scopeId'] = this.scopeId;
    data['scopeName'] = this.scopeName;
    data['stageId'] = this.stageId;
    data['stageName'] = this.stageName;
    return data;
  }
}
