import 'dart:math';

class HotMatchEntity {
  String? color;
  int? guestId;
  String? guestLogo;
  String? guestName;
  String? guestRanking;
  String? guestScore;
  int? homeId;
  String? homeLogo;
  String? homeName;
  String? homeRanking;
  String? homeScore;
  int? id;
  int? leagueId;
  String? leagueName;
  String? matchNo;
  String? matchTime;
  String? status;
  String? matchDate;

  HotMatchEntity(
      {this.color,
      this.guestId,
      this.guestLogo,
      this.guestName,
      this.guestRanking,
      this.guestScore,
      this.homeId,
      this.homeLogo,
      this.homeName,
      this.homeRanking,
      this.homeScore,
      this.id,
      this.leagueId,
      this.leagueName,
      this.matchNo,
      this.matchTime,
      this.status,
      this.matchDate});

  HotMatchEntity.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    guestId = json['guestId'];
    guestLogo = json['guestLogo'];
    guestName = json['guestName'];
    guestRanking = json['guestRanking'];
    guestScore = json['guestScore'];
    homeId = json['homeId'];
    homeLogo = json['homeLogo'];
    homeName = json['homeName'];
    homeRanking = json['homeRanking'];
    homeScore = json['homeScore'];
    id = json['id'];
    leagueId = json['leagueId'];
    leagueName = json['leagueName'];
    matchNo = json['matchNo'];
    matchTime = json['matchTime'];
    status = json['status'];
    matchDate = json['matchDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['color'] = this.color;
    data['guestId'] = this.guestId;
    data['guestLogo'] = this.guestLogo;
    data['guestName'] = this.guestName;
    data['guestRanking'] = this.guestRanking;
    data['guestScore'] = this.guestScore;
    data['homeId'] = this.homeId;
    data['homeLogo'] = this.homeLogo;
    data['homeName'] = this.homeName;
    data['homeRanking'] = this.homeRanking;
    data['homeScore'] = this.homeScore;
    data['id'] = this.id;
    data['leagueId'] = this.leagueId;
    data['leagueName'] = this.leagueName;
    data['matchNo'] = this.matchNo;
    data['matchTime'] = this.matchTime;
    data['status'] = this.status;
    data['matchDate'] = matchDate;
    return data;
  }
}


extension HotMatchEntityEx1 on HotMatchEntity {
  DateTime? get getMatchDate => DateTime.tryParse(matchDate ?? "");
}