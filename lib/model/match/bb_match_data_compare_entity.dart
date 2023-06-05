import 'package:sports/model/match/basket_match_data_team_entity.dart';
import 'package:sports/model/match/basket_match_data_temavg_entity.dart';

class BbMatchDataCompareEntity {
  BasketMatchDataTeamEntity? appTeamSimple;
  BasketMatchDataTeamAvgEntity? appBbMatchAvgData;

  BbMatchDataCompareEntity({this.appTeamSimple, this.appBbMatchAvgData});

  BbMatchDataCompareEntity.fromJson(Map<String, dynamic> json) {
    appTeamSimple = json['appTeamSimple'] != null
        ? new BasketMatchDataTeamEntity.fromJson(json['appTeamSimple'])
        : null;
    appBbMatchAvgData = json['appBbMatchAvgData'] != null
        ? new BasketMatchDataTeamAvgEntity.fromJson(json['appBbMatchAvgData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appTeamSimple != null) {
      data['appTeamSimple'] = this.appTeamSimple!.toJson();
    }
    if (this.appBbMatchAvgData != null) {
      data['appBbMatchAvgData'] = this.appBbMatchAvgData!.toJson();
    }
    return data;
  }
}
