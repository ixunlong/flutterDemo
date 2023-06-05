import 'package:sports/model/team/my_team_focus_entity.dart';

class FocusTeamListEntity {
  int? focusCnt;
  int? leagueId;
  String? leagueName;
  List<MyTeamFocusEntity>? teamList;

  FocusTeamListEntity(
      {this.focusCnt, this.leagueId, this.leagueName, this.teamList});

  FocusTeamListEntity.fromJson(Map<String, dynamic> json) {
    focusCnt = json['focusCnt'];
    leagueId = json['leagueId'];
    leagueName = json['leagueName'];
    if (json['teamList'] != null) {
      teamList = <MyTeamFocusEntity>[];
      json['teamList'].forEach((v) {
        teamList!.add(new MyTeamFocusEntity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['focusCnt'] = this.focusCnt;
    data['leagueId'] = this.leagueId;
    data['leagueName'] = this.leagueName;
    if (this.teamList != null) {
      data['teamList'] = this.teamList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
