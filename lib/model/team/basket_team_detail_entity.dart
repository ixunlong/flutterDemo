import 'package:sports/model/team/team_detail_entity.dart';

class BasketTeamDetailEntity {
  String? coachName;
  String? conferenceName;
  String? country;
  List<HonorView>? honorView;
  int? leagueId;
  String? logo;
  String? matchResult;
  String? nameEnShort;
  String? nameZhShort;
  int? national;
  String? rank;
  int? sourceTeamId;
  String? totalWorth;
  String? venueName;

  BasketTeamDetailEntity(
      {this.coachName,
        this.conferenceName,
        this.country,
        this.honorView,
        this.leagueId,
        this.logo,
        this.matchResult,
        this.nameEnShort,
        this.nameZhShort,
        this.national,
        this.rank,
        this.sourceTeamId,
        this.totalWorth,
        this.venueName});

  BasketTeamDetailEntity.fromJson(Map<String, dynamic> json) {
    coachName = json['coachName'];
    conferenceName = json['conferenceName'];
    country = json['country'];
    if (json['honorView'] != null) {
      honorView = <HonorView>[];
      json['honorView'].forEach((v) {
        honorView!.add(new HonorView.fromJson(v));
      });
    }
    leagueId = json['leagueId'];
    logo = json['logo'];
    matchResult = json['matchResult'];
    nameEnShort = json['nameEnShort'];
    nameZhShort = json['nameZhShort'];
    national = json['national'];
    rank = json['rank'];
    sourceTeamId = json['sourceTeamId'];
    totalWorth = json['totalWorth'];
    venueName = json['venueName'];
    national = json['national'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coachName'] = this.coachName;
    data['conferenceName'] = this.conferenceName;
    data['country'] = this.country;
    if (this.honorView != null) {
      data['honorView'] = this.honorView!.map((v) => v.toJson()).toList();
    }
    data['leagueId'] = this.leagueId;
    data['logo'] = this.logo;
    data['matchResult'] = this.matchResult;
    data['nameEnShort'] = this.nameEnShort;
    data['nameZhShort'] = this.nameZhShort;
    data['national'] = this.national;
    data['rank'] = this.rank;
    data['sourceTeamId'] = this.sourceTeamId;
    data['totalWorth'] = this.totalWorth;
    data['venueName'] = this.venueName;
    data['national'] = this.national;
    return data;
  }
}

class HonorView {
  String? leagueId;
  String? leagueName;
  List<String>? season;
  int? size;

  HonorView({this.leagueId, this.leagueName, this.season, this.size});

  HonorView.fromJson(Map<String, dynamic> json) {
    leagueId = json['leagueId'];
    leagueName = json['leagueName'];
    season = json['season'].cast<String>();
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leagueId'] = this.leagueId;
    data['leagueName'] = this.leagueName;
    data['season'] = this.season;
    data['size'] = this.size;
    return data;
  }
}