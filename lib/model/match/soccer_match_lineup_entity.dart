class SoccerMatchLineupEntity {
  String? guestArray;
  List<SoccerMatchLineupPlayer>? guestBackup;
  List<SoccerMatchLineupPlayer>? guestLineup;
  String? homeArray;
  List<SoccerMatchLineupPlayer>? homeBackup;
  List<SoccerMatchLineupPlayer>? homeLineup;
  int? matchId;
  int? source;

  SoccerMatchLineupEntity(
      {this.guestArray,
      this.guestBackup,
      this.guestLineup,
      this.homeArray,
      this.homeBackup,
      this.homeLineup,
      this.matchId,
      this.source});

  SoccerMatchLineupEntity.fromJson(Map<String, dynamic> json) {
    guestArray = json['guestArray'];
    if (json['guestBackup'] != null) {
      guestBackup = <SoccerMatchLineupPlayer>[];
      json['guestBackup'].forEach((v) {
        guestBackup!.add(new SoccerMatchLineupPlayer.fromJson(v));
      });
    }
    if (json['guestLineup'] != null) {
      guestLineup = <SoccerMatchLineupPlayer>[];
      json['guestLineup'].forEach((v) {
        guestLineup!.add(new SoccerMatchLineupPlayer.fromJson(v));
      });
    }
    homeArray = json['homeArray'];
    if (json['homeBackup'] != null) {
      homeBackup = <SoccerMatchLineupPlayer>[];
      json['homeBackup'].forEach((v) {
        homeBackup!.add(new SoccerMatchLineupPlayer.fromJson(v));
      });
    }
    if (json['homeLineup'] != null) {
      homeLineup = <SoccerMatchLineupPlayer>[];
      json['homeLineup'].forEach((v) {
        homeLineup!.add(new SoccerMatchLineupPlayer.fromJson(v));
      });
    }
    matchId = json['matchId'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['guestArray'] = this.guestArray;
    if (this.guestBackup != null) {
      data['guestBackup'] = this.guestBackup!.map((v) => v.toJson()).toList();
    }
    if (this.guestLineup != null) {
      data['guestLineup'] = this.guestLineup!.map((v) => v.toJson()).toList();
    }
    data['homeArray'] = this.homeArray;
    if (this.homeBackup != null) {
      data['homeBackup'] = this.homeBackup!.map((v) => v.toJson()).toList();
    }
    if (this.homeLineup != null) {
      data['homeLineup'] = this.homeLineup!.map((v) => v.toJson()).toList();
    }
    data['matchId'] = this.matchId;
    data['source'] = this.source;
    return data;
  }
}

class SoccerMatchLineupPlayer {
  int? id;
  int? kind;
  int? matchId;
  String? nameCn;
  String? nameEn;
  String? number;
  String? playerId;
  String? position;
  int? source;

  SoccerMatchLineupPlayer(
      {this.id,
      this.kind,
      this.matchId,
      this.nameCn,
      this.nameEn,
      this.number,
      this.playerId,
      this.position,
      this.source});

  SoccerMatchLineupPlayer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kind = json['kind'];
    matchId = json['matchId'];
    nameCn = json['nameCn'];
    nameEn = json['nameEn'];
    number = json['number'];
    playerId = json['playerId'];
    position = json['position'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['kind'] = this.kind;
    data['matchId'] = this.matchId;
    data['nameCn'] = this.nameCn;
    data['nameEn'] = this.nameEn;
    data['number'] = this.number;
    data['playerId'] = this.playerId;
    data['position'] = this.position;
    data['source'] = this.source;
    return data;
  }
}
