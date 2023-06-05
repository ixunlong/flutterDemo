import 'package:sports/model/data/data_points_entity.dart';
import 'package:sports/model/data/data_schedule_entity.dart';

class DataCupPointsEntity {
  String? introduce;
  List<MatchList>? matchList;

  DataCupPointsEntity({this.introduce, this.matchList});

  DataCupPointsEntity.fromJson(Map<String, dynamic> json) {
    introduce = json['introduce'];
    if (json['list'] != null) {
      matchList = <MatchList>[];
      json['list'].forEach((v) { matchList!.add(new MatchList.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['introduce'] = this.introduce;
    if (this.matchList != null) {
      data['list'] = this.matchList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MatchList {
  List<PointsList>? pointsList;
  int? maxMatchTime;
  String? name;
  Road? road;

  MatchList({this.pointsList, this.maxMatchTime, this.name, this.road});

  MatchList.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      pointsList = <PointsList>[];
      json['list'].forEach((v) { pointsList!.add(new PointsList.fromJson(v)); });
    }
    maxMatchTime = json['maxMatchTime'];
    name = json['name'];
    road = json['road'] != null ? new Road.fromJson(json['road']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pointsList != null) {
      data['list'] = this.pointsList!.map((v) => v.toJson()).toList();
    }
    data['maxMatchTime'] = this.maxMatchTime;
    data['name'] = this.name;
    if (this.road != null) {
      data['road'] = this.road!.toJson();
    }
    return data;
  }
}

class PointsList {
  String? name;
  List<GroupList>? groupList;
  Points? standingList;

  PointsList({this.name, this.groupList, this.standingList});

  PointsList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['scheduleList'] != null) {
      groupList = <GroupList>[];
      json['scheduleList'].forEach((v) { groupList!.add(new GroupList.fromJson(v)); });
    }
    standingList = json['standingList'] != null ? new Points.fromJson(json['standingList']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.groupList != null) {
      data['scheduleList'] = this.groupList!.map((v) => v.toJson()).toList();
    }
    if (this.standingList != null) {
      data['standingList'] = this.standingList!.toJson();
    }
    return data;
  }
}

class GroupList {
  String? name;
  List<TeamList>? teamList;
  int? sort;
  int? winTeamId;

  GroupList({this.name, this.teamList, this.sort,this.winTeamId});

  GroupList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['scheduleList'] != null) {
      teamList = <TeamList>[];
      json['scheduleList'].forEach((v) { teamList!.add(new TeamList.fromJson(v)); });
    }
    sort = json['sort'];
    winTeamId = json['winTeamId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.teamList != null) {
      data['scheduleList'] = this.teamList!.map((v) => v.toJson()).toList();
    }
    data['sort'] = this.sort;
    data['winTeamId'] = this.winTeamId;
    return data;
  }
}

class Road {
  List<GroupList>? roadVs;
  List<GroupList>? roadVs16;
  List<GroupList>? roadVs4;
  List<GroupList>? roadVs8;

  Road({this.roadVs, this.roadVs16, this.roadVs4, this.roadVs8});

  Road.fromJson(Map<String, dynamic> json) {
    if (json['roadVs'] != null) {
      roadVs = <GroupList>[];
      json['roadVs'].forEach((v) { roadVs!.add(new GroupList.fromJson(v)); });
    }
    if (json['roadVs16'] != null) {
      roadVs16 = <GroupList>[];
      json['roadVs16'].forEach((v) { roadVs16!.add(new GroupList.fromJson(v)); });
    }
    if (json['roadVs4'] != null) {
      roadVs4 = <GroupList>[];
      json['roadVs4'].forEach((v) { roadVs4!.add(new GroupList.fromJson(v)); });
    }
    if (json['roadVs8'] != null) {
      roadVs8 = <GroupList>[];
      json['roadVs8'].forEach((v) { roadVs8!.add(new GroupList.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.roadVs != null) {
      data['roadVs'] = this.roadVs!.map((v) => v.toJson()).toList();
    }
    if (this.roadVs16 != null) {
      data['roadVs16'] = this.roadVs16!.map((v) => v.toJson()).toList();
    }
    if (this.roadVs4 != null) {
      data['roadVs4'] = this.roadVs4!.map((v) => v.toJson()).toList();
    }
    if (this.roadVs8 != null) {
      data['roadVs8'] = this.roadVs8!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}