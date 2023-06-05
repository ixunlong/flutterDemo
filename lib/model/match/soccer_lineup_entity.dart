import 'match_event_entity.dart';

class SoccerLineupEntity with LastLineup{
  String? guestArray;
  List<LineupPlayer>? guestBackup;
  List<LineupPlayer>? guestLineup;
  List<SuspendPlayer>? guestSuspend;
  List<MatchEventEntity>? guestEvents;
  String? homeArray;
  List<LineupPlayer>? homeBackup;
  List<LineupPlayer>? homeLineup;
  List<SuspendPlayer>? homeSuspend;
  List<MatchEventEntity>? homeEvents;
  int? matchId;
  int? source;
  int? guestAverageAge;
  String? guestCoachName;
  String? guestSumWorth;
  int? homeAverageAge;
  String? homeCoachName;
  int? homeQxbMatchId;
  String? homeSumWorth;
  String? homeLastMatcher;
  int? homeLastMatcherScore;
  int? homeLastScore;
  String? homeUmpire;
  int? guestQxbMatchId;
  String? guestLastMatcher;
  int? guestLastMatcherScore;
  int? guestLastScore;
  String? guestUmpire;
  String? locationCn;
  String? temp;
  String? weatherCn;

  SoccerLineupEntity({
        this.guestArray,
        this.guestAverageAge,
        this.guestCoachName,
        this.guestSumWorth,
        this.guestEvents,
        this.homeArray,
        this.homeAverageAge,
        this.homeCoachName,
        this.homeLineup,
        this.homeSumWorth,
        this.homeEvents,
        this.matchId,
        this.source,
        this.temp,
        this.homeQxbMatchId,
        this.homeLastMatcher,
        this.homeLastMatcherScore,
        this.homeLastScore,
        this.homeUmpire,
        this.guestQxbMatchId,
        this.guestLastMatcher,
        this.guestLastMatcherScore,
        this.guestLastScore,
        this.guestUmpire,
        this.locationCn,
        this.weatherCn
      });

  SoccerLineupEntity.fromJson(Map<String, dynamic> json) {
    guestArray = json['guestArray'];
    if (json['guestBackup'] != null) {
      guestBackup = <LineupPlayer>[];
      json['guestBackup'].forEach((v) {
        guestBackup!.add(new LineupPlayer.fromJson(v));
      });
    }
    if (json['guestLineup'] != null) {
      guestLineup = <LineupPlayer>[];
      json['guestLineup'].forEach((v) {
        guestLineup!.add(new LineupPlayer.fromJson(v));
      });
    }
    if (json['guestSuspend'] != null) {
      guestSuspend = <SuspendPlayer>[];
      json['guestSuspend'].forEach((v) {
        guestSuspend!.add(new SuspendPlayer.fromJson(v));
      });
    }
    if (json['guestEvents'] != null) {
      guestEvents = <MatchEventEntity>[];
      json['guestEvents'].forEach((v) {
        guestEvents!.add(new MatchEventEntity.fromJson(v));
      });
    }
    homeArray = json['homeArray'];
    if (json['homeBackup'] != null) {
      homeBackup = <LineupPlayer>[];
      json['homeBackup'].forEach((v) {
        homeBackup!.add(new LineupPlayer.fromJson(v));
      });
    }
    if (json['homeLineup'] != null) {
      homeLineup = <LineupPlayer>[];
      json['homeLineup'].forEach((v) {
        homeLineup!.add(new LineupPlayer.fromJson(v));
      });
    }
    if (json['homeSuspend'] != null) {
      homeSuspend = <SuspendPlayer>[];
      json['homeSuspend'].forEach((v) {
        homeSuspend!.add(new SuspendPlayer.fromJson(v));
      });
    }
    if (json['homeEvents'] != null) {
      homeEvents = <MatchEventEntity>[];
      json['homeEvents'].forEach((v) {
        homeEvents!.add(new MatchEventEntity.fromJson(v));
      });
    }
    matchId = json['matchId'];
    source = json['source'];
    guestAverageAge = json['guestAverageAge'];
    guestCoachName = json['guestCoachName'];
    guestSumWorth = json['guestSumWorth'];
    homeAverageAge = json['homeAverageAge'];
    homeCoachName = json['homeCoachName'];
    homeSumWorth = json['homeSumWorth'];
    homeQxbMatchId = json['homeQxbMatchId'];
    homeLastMatcher = json['homeLastMatcher'];
    homeLastMatcherScore = json['homeLastMatcherScore'];
    homeLastScore = json['homeLastScore'];
    homeUmpire = json['homeUmpire'];
    guestQxbMatchId = json['guestQxbMatchId'];
    guestLastMatcher = json['guestLastMatcher'];
    guestLastMatcherScore = json['guestLastMatcherScore'];
    guestLastScore = json['guestLastScore'];
    guestUmpire = json['guestUmpire'];
    locationCn = json['locationCn'];
    temp = json['temp'];
    weatherCn = json['weatherCn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['guestArray'] = guestArray;
    if (guestBackup != null) {
      data['guestBackup'] = guestBackup!.map((v) => v.toJson()).toList();
    }
    if (guestLineup != null) {
      data['guestLineup'] = guestLineup!.map((v) => v.toJson()).toList();
    }
    if (guestSuspend != null) {
      data['guestSuspend'] = guestSuspend!.map((v) => v.toJson()).toList();
    }
    if (guestEvents != null) {
      data['guestEvents'] = guestEvents!.map((v) => v.toJson()).toList();
    }
    data['homeArray'] = homeArray;
    if (homeBackup != null) {
      data['homeBackup'] = homeBackup!.map((v) => v.toJson()).toList();
    }
    if (homeLineup != null) {
      data['homeLineup'] = homeLineup!.map((v) => v.toJson()).toList();
    }
    if (homeSuspend != null) {
      data['homeSuspend'] = homeSuspend!.map((v) => v.toJson()).toList();
    }
    if (homeEvents != null) {
      data['homeEvents'] = homeEvents!.map((v) => v.toJson()).toList();
    }
    data['matchId'] = matchId;
    data['source'] = source;
    data['guestAverageAge'] = guestAverageAge;
    data['guestCoachName'] = guestCoachName;
    data['guestSumWorth'] = guestSumWorth;
    data['homeAverageAge'] = homeAverageAge;
    data['homeCoachName'] = homeCoachName;
    data['homeSumWorth'] = homeSumWorth;
    data['homeQxbMatchId'] = homeQxbMatchId;
    data['homeLastMatcher'] = homeLastMatcher;
    data['homeLastMatcherScore'] = homeLastMatcherScore;
    data['homeLastScore'] = homeLastScore;
    data['homeUmpire'] = homeUmpire;
    data['guestQxbMatchId'] = guestQxbMatchId;
    data['guestLastMatcher'] = guestLastMatcher;
    data['guestLastMatcherScore'] = guestLastMatcherScore;
    data['guestLastScore'] = guestLastScore;
    data['guestUmpire'] = guestUmpire;
    data['locationCn'] = locationCn;
    data['temp'] = temp;
    data['weatherCn'] = weatherCn;
    return data;
  }
}

class LineupPlayer {
  int? insideIndex;
  int? kind;
  String? currentScore;
  String? kindName;
  String? nameCn;
  String? nameEn;
  String? number;
  String? rating;
  String? playerId;
  String? position;
  String? positionName;

  LineupPlayer(
      {this.insideIndex,
      this.kind,
      this.currentScore,
      this.kindName,
      this.nameCn,
      this.nameEn,
      this.number,
      this.rating,
      this.playerId,
      this.position,
      this.positionName});

  LineupPlayer.fromJson(Map<String, dynamic> json) {
    insideIndex = json['insideIndex'];
    kind = json['kind'];
    currentScore = json['currentScore'];
    kindName = json['kindName'];
    nameCn = json['nameCn'];
    nameEn = json['nameEn'];
    number = json['number'];
    rating = json['rating'];
    playerId = json['playerId'];
    position = json['position'];
    positionName = json['positionName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['insideIndex'] = insideIndex;
    data['kind'] = kind;
    data['currentScore'] = currentScore;
    data['kindName'] = kindName;
    data['nameCn'] = nameCn;
    data['nameEn'] = nameEn;
    data['number'] = number;
    data['rating'] = rating;
    data['playerId'] = playerId;
    data['position'] = position;
    data['positionName'] = positionName;
    return data;
  }
}

class SuspendPlayer {
  int? kind;
  String? kindName;
  int? matchId;
  String? nameChs;
  String? number;
  String? photo;
  int? playerId;
  int? playerQxbId;
  String? reason;
  String? position;
  int? source;
  int? teamId;

  SuspendPlayer(
      {this.kind,
      this.kindName,
      this.matchId,
      this.nameChs,
      this.number,
      this.photo,
      this.playerId,
      this.playerQxbId,
      this.reason,
      this.position,
      this.source,
      this.teamId});

  SuspendPlayer.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    kindName = json['kindName'];
    matchId = json['matchId'];
    nameChs = json['nameChs'];
    number = json['number'];
    photo = json['photo'];
    playerId = json['playerId'];
    playerQxbId = json['playerQxbId'];
    reason = json['reason'];
    position = json['position'];
    source = json['source'];
    teamId = json['teamId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kind'] = kind;
    data['kindName'] = kindName;
    data['matchId'] = matchId;
    data['nameChs'] = nameChs;
    data['number'] = number;
    data['photo'] = photo;
    data['playerId'] = playerId;
    data['playerQxbId'] = playerQxbId;
    data['reason'] = reason;
    data['position'] = position;
    data['source'] = source;
    data['teamId'] = teamId;
    return data;
  }
}

mixin LastLineup {
  bool isLastLineup = false;
  bool isEmpty = false;
}
