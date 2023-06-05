import 'basket_schedule_entity.dart';

class BasketPointsEntity {
  String? introduce;
  List<MatchList>? matchList;

  BasketPointsEntity({this.introduce, this.matchList});

  BasketPointsEntity.fromJson(Map<String, dynamic> json) {
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
  String? name;
  Road? road;
  List<ScheduleList>? scheduleList;
  List<Points>? matchRank;
  List<Points>? areaRank;

  MatchList(
      {this.name,
        this.road,
        this.scheduleList,
        this.matchRank,
        this.areaRank});

  MatchList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    road = json['road'] != null ? new Road.fromJson(json['road']) : null;
    if (json['rankGroupList'] != null) {
      matchRank = <Points>[];
      json['rankGroupList'].forEach((v) { matchRank!.add(new Points.fromJson(v)); });
    }
    if (json['rankGroupList2'] != null) {
      areaRank = <Points>[];
      json['rankGroupList2'].forEach((v) { areaRank!.add(new Points.fromJson(v)); });
    }
    road = json['road'] != null ? new Road.fromJson(json['road']) : null;
    if (json['scheduleList'] != null) {
      scheduleList = <ScheduleList>[];
      json['scheduleList'].forEach((v) { scheduleList!.add(new ScheduleList.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.road != null) {
      data['road'] = this.road!.toJson();
    }
    if (this.scheduleList != null) {
      data['scheduleList'] = this.scheduleList!.map((v) => v.toJson()).toList();
    }
    if (this.matchRank != null) {
      data['rankGroupList'] = this.matchRank!.map((v) => v.toJson()).toList();
    }
    if (this.areaRank != null) {
      data['rankGroupList2'] = this.areaRank!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GroupList {
  int? sort;
  String? name;
  int? winTeamId;
  int? homeTeamId;
  int? awayTeamId;
  String? homeName;
  String? awayName;
  String? homeLogo;
  String? awayLogo;
  int? homeScore;
  int? awayScore;
  List<GroupMatchList>? matchList;

  GroupList(
      {this.sort,
        this.name,
        this.winTeamId,
        this.homeTeamId,
        this.awayTeamId,
        this.homeName,
        this.awayName,
        this.homeLogo,
        this.awayLogo,
        this.homeScore,
        this.awayScore,
        this.matchList});

  GroupList.fromJson(Map<String, dynamic> json) {
    sort = json['sort'];
    name = json['name'];
    winTeamId = json['winTeamId'];
    homeTeamId = json['homeTeamId'];
    awayTeamId = json['awayTeamId'];
    homeName = json['homeName'];
    awayName = json['awayName'];
    homeLogo = json['homeLogo'];
    awayLogo = json['awayLogo'];
    homeScore = json['homeScore'];
    awayScore = json['awayScore'];
    if (json['list'] != null) {
      matchList = <GroupMatchList>[];
      json['list'].forEach((v) {
        matchList!.add(new GroupMatchList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sort'] = this.sort;
    data['name'] = this.name;
    data['winTeamId'] = this.winTeamId;
    data['homeTeamId'] = this.homeTeamId;
    data['awayTeamId'] = this.awayTeamId;
    data['homeName'] = this.homeName;
    data['awayName'] = this.awayName;
    data['homeLogo'] = this.homeLogo;
    data['awayLogo'] = this.awayLogo;
    data['homeScore'] = this.homeScore;
    data['awayScore'] = this.awayScore;
    if (this.matchList != null) {
      data['list'] = this.matchList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GroupMatchList {
  int? id;
  String? matchTime;
  int? statusId;
  int? homeTeamId;
  int? awayTeamId;
  int? homeScore;
  int? awayScore;

  GroupMatchList(
      {this.id,
        this.matchTime,
        this.statusId,
        this.homeTeamId,
        this.awayTeamId,
        this.homeScore,
        this.awayScore});

  GroupMatchList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    matchTime = json['matchTime'];
    statusId = json['statusId'];
    homeTeamId = json['homeTeamId'];
    awayTeamId = json['awayTeamId'];
    homeScore = json['homeScore'];
    awayScore = json['awayScore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['matchTime'] = this.matchTime;
    data['statusId'] = this.statusId;
    data['homeTeamId'] = this.homeTeamId;
    data['awayTeamId'] = this.awayTeamId;
    data['homeScore'] = this.homeScore;
    data['awayScore'] = this.awayScore;
    return data;
  }
}

class Road {
  String? name;
  List<GroupList>? roadVs;
  List<GroupList>? roadVs16;
  List<GroupList>? roadVs4;
  List<GroupList>? roadVs8;

  Road({this.name, this.roadVs, this.roadVs16, this.roadVs4, this.roadVs8});

  Road.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['roadVs'] != null) {
      roadVs = <GroupList>[];
      json['roadVs'].forEach((v) {
        roadVs!.add(new GroupList.fromJson(v));
      });
    }
    if (json['roadVs16'] != null) {
      roadVs16 = <GroupList>[];
      json['roadVs16'].forEach((v) {
        roadVs16!.add(new GroupList.fromJson(v));
      });
    }
    if (json['roadVs4'] != null) {
      roadVs4 = <GroupList>[];
      json['roadVs4'].forEach((v) {
        roadVs4!.add(new GroupList.fromJson(v));
      });
    }
    if (json['roadVs8'] != null) {
      roadVs8 = <GroupList>[];
      json['roadVs8'].forEach((v) {
        roadVs8!.add(new GroupList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
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

class Points {
  String? groupName;
  List<Qualifying>? qualifying;
  List<TeamStanding>? teamStanding;

  Points(
      {this.groupName,
        this.qualifying,
        this.teamStanding});

  Points.fromJson(Map<String, dynamic> json) {
    groupName = json['name'];
    if (json['lineList'] != null) {
      qualifying = <Qualifying>[];
      json['lineList'].forEach((v) {
        qualifying!.add(new Qualifying.fromJson(v));
      });
    }
    if (json['rankList'] != null) {
      teamStanding = <TeamStanding>[];
      json['rankList'].forEach((v) {
        teamStanding!.add(new TeamStanding.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.groupName;
    if (this.qualifying != null) {
      data['lineList'] = this.qualifying!.map((v) => v.toJson()).toList();
    }
    if (this.teamStanding != null) {
      data['rankList'] = this.teamStanding!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Qualifying {
  int? beginRank;
  String? color;
  int? endRank;
  String? name;
  String? tagColor;

  Qualifying(
      {this.beginRank,
        this.color,
        this.endRank,
        this.name,
        this.tagColor});

  Qualifying.fromJson(Map<String, dynamic> json) {
    beginRank = json['begin'];
    color = json['color'];
    endRank = json['end'];
    name = json['name'];
    tagColor = json['tagColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['begin'] = this.beginRank;
    data['color'] = this.color;
    data['end'] = this.endRank;
    data['name'] = this.name;
    data['tagColor'] = this.tagColor;
    return data;
  }
}

class TeamStanding {
  int? conferenceId;
  String? gameBack;
  int? lost;
  String? name;
  int? position;
  String? streaks;
  int? teamId;
  String? teamLogo;
  String? teamName;
  int? won;
  double? wonRate;

  TeamStanding(
      {this.conferenceId,
        this.gameBack,
        this.lost,
        this.name,
        this.position,
        this.streaks,
        this.teamId,
        this.teamLogo,
        this.teamName,
        this.won,
        this.wonRate});

  TeamStanding.fromJson(Map<String, dynamic> json) {
    conferenceId = json['conferenceId'];
    gameBack = json['gameBack'];
    lost = json['lost'];
    name = json['name'];
    position = json['position'];
    streaks = json['streaks'];
    teamId = json['teamId'];
    teamLogo = json['teamLogo'];
    teamName = json['teamName'];
    won = json['won'];
    wonRate = json['wonRate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['conferenceId'] = this.conferenceId;
    data['gameBack'] = this.gameBack;
    data['lost'] = this.lost;
    data['name'] = this.name;
    data['position'] = this.position;
    data['streaks'] = this.streaks;
    data['teamId'] = this.teamId;
    data['teamLogo'] = this.teamLogo;
    data['teamName'] = this.teamName;
    data['won'] = this.won;
    data['wonRate'] = this.wonRate;
    return data;
  }
}