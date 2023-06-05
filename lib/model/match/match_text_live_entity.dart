class MatchLiveTextEntity {
  String? content;
  int? guestScore;
  int? homeScore;
  int? kind;
  String? kindName;
  int? liveId;
  int? matchId;
  String? processTime;
  int? source;
  bool isAnimated = false;

  MatchLiveTextEntity(
      {this.content,
      this.guestScore,
      this.homeScore,
      this.kind,
      this.kindName,
      this.liveId,
      this.matchId,
      this.processTime,
      this.source});

  MatchLiveTextEntity.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    guestScore = json['guestScore'];
    homeScore = json['homeScore'];
    kind = json['kind'];
    kindName = json['kindName'];
    liveId = json['liveId'];
    matchId = json['matchId'];
    processTime = json['processTime'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['guestScore'] = this.guestScore;
    data['homeScore'] = this.homeScore;
    data['kind'] = this.kind;
    data['kindName'] = this.kindName;
    data['liveId'] = this.liveId;
    data['matchId'] = this.matchId;
    data['processTime'] = this.processTime;
    data['source'] = this.source;
    return data;
  }
}

extension MatchLiveTextEntityEx1 on MatchLiveTextEntity {
  DateTime? get time => DateTime.tryParse(processTime ?? "");
}
