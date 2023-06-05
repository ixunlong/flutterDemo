
import 'package:sports/util/sp_utils.dart';

class LeagueChannelAreaEntity {
  String? area;
  List<LeagueChannelCountryEntity>? list;

  LeagueChannelAreaEntity.fromJson(Json json) {
    area = json['area'];
    final l1 = json['list'];
    if (l1 != null && l1 is List) {
      list = l1.map((e) => LeagueChannelCountryEntity.fromJson(e)).toList();
    }
  }
}

class LeagueChannelCountryEntity {
  String? country;
  List<LeagueChannelEntity>? list;

  LeagueChannelCountryEntity.fromJson(Json json) {
    country = json['country'];
    final l1 = json['list'];
    if (l1 != null && l1 is List) {
      list = l1.map((e) => LeagueChannelEntity.fromJson(e)).toList();
    }
  }
}

class LeagueChannelEntity {
  String? area;
  String? country;
  String? endTime;
  int? hot;
  int? leagueId;
  String? leagueLogo;
  String? leagueName;
  int? level;
  String? nameChs;
  String? nameEn;
  double? progress;
  String? rule;
  List<String>? seasonList;
  String? seasons;
  int? sourceLeagueId;
  String? startTime;
  int? transfer;
  int? type;
  int? weight;

  LeagueChannelEntity(
      {this.area,
        this.country,
        this.endTime,
        this.hot,
        this.leagueId,
        this.leagueLogo,
        this.leagueName,
        this.level,
        this.nameChs,
        this.nameEn,
        this.progress,
        this.rule,
        this.seasonList,
        this.seasons,
        this.sourceLeagueId,
        this.startTime,
        this.transfer,
        this.type,
        this.weight});

  LeagueChannelEntity.fromJson(Map<String, dynamic> json) {
    area = json['area'];
    country = json['country'];
    endTime = json['endTime'];
    hot = json['hot'];
    leagueId = json['leagueId'];
    leagueLogo = json['leagueLogo'];
    leagueName = json['leagueName'];
    level = json['level'];
    nameChs = json['nameChs'];
    nameEn = json['nameEn'];
    progress = json['progress'];
    rule = json['rule'];
    seasonList = json['seasonList']?.cast<String>();
    seasons = json['seasons'];
    sourceLeagueId = json['sourceLeagueId'];
    startTime = json['startTime'];
    transfer = json['transfer'];
    type = json['type'];
    weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['area'] = this.area;
    data['country'] = this.country;
    data['endTime'] = this.endTime;
    data['hot'] = this.hot;
    data['leagueId'] = this.leagueId;
    data['leagueLogo'] = this.leagueLogo;
    data['leagueName'] = this.leagueName;
    data['level'] = this.level;
    data['nameChs'] = this.nameChs;
    data['nameEn'] = this.nameEn;
    data['progress'] = this.progress;
    data['rule'] = this.rule;
    data['seasonList'] = this.seasonList;
    data['seasons'] = this.seasons;
    data['sourceLeagueId'] = this.sourceLeagueId;
    data['startTime'] = this.startTime;
    data['transfer'] = this.transfer;
    data['type'] = this.type;
    data['weight'] = this.weight;
    return data;
  }
}