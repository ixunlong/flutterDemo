class MyTeamFocusEntity {
  int? focus;
  int? id;
  int? leagueId;
  String? leagueName;
  String? logo;
  String? nameChsShort;
  int? type;

  MyTeamFocusEntity(
      {this.focus,
      this.id,
      this.leagueId,
      this.leagueName,
      this.logo,
      this.nameChsShort,
      this.type});

  MyTeamFocusEntity.fromJson(Map<String, dynamic> json) {
    focus = json['focus'];
    id = json['id'];
    leagueId = json['leagueId'];
    leagueName = json['leagueName'];
    logo = json['logo'];
    nameChsShort = json['nameChsShort'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['focus'] = this.focus;
    data['id'] = this.id;
    data['leagueId'] = this.leagueId;
    data['leagueName'] = this.leagueName;
    data['logo'] = this.logo;
    data['nameChsShort'] = this.nameChsShort;
    data['type'] = this.type;
    return data;
  }
}
