class LeagueListEntity {
  List<LeagueEntity>? hotList;
  List<LeagueEntity>? level1List;

  LeagueListEntity({this.hotList, this.level1List});

  LeagueListEntity.fromJson(Map<String, dynamic> json) {
    if (json['hotList'] != null) {
      hotList = <LeagueEntity>[];
      json['hotList'].forEach((v) {
        hotList!.add(new LeagueEntity.fromJson(v));
      });
    }
    if (json['level1List'] != null) {
      level1List = <LeagueEntity>[];
      json['level1List'].forEach((v) {
        level1List!.add(new LeagueEntity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hotList != null) {
      data['hotList'] = this.hotList!.map((v) => v.toJson()).toList();
    }
    if (this.level1List != null) {
      data['level1List'] = this.level1List!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeagueEntity with LeagueSelected {
  int? leagueId;
  String? leagueName;
  int? hot;
  // bool? isSelected;

  LeagueEntity({this.leagueId, this.leagueName, this.hot});

  LeagueEntity.fromJson(Map<String, dynamic> json) {
    leagueId = json['leagueId'];
    leagueName = json['leagueName'];
    hot = json['hot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leagueId'] = this.leagueId;
    data['leagueName'] = this.leagueName;
    data['hot'] = this.hot;
    return data;
  }
}

mixin LeagueSelected {
  bool isSelected = true;
  int? matchNum;
}
