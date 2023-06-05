class BbDataPlayerEntity {
  String? index;
  String? playerAssists;
  String? playerLogo;
  String? playerName;
  String? playerPosition;
  String? playerRebounds;
  String? playerPoints;
  List<String>? values;

  BbDataPlayerEntity(
      {this.index,
      this.playerAssists,
      this.playerLogo,
      this.playerName,
      this.playerPosition,
      this.playerRebounds,
      this.playerPoints,
      this.values});

  BbDataPlayerEntity.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    playerAssists = json['playerAssists'];
    playerLogo = json['playerLogo'];
    playerName = json['playerName'];
    playerPosition = json['playerPosition'];
    playerRebounds = json['playerRebounds'];
    playerPoints = json['playerPoints'];
    values = json['values'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index'] = this.index;
    data['playerAssists'] = this.playerAssists;
    data['playerLogo'] = this.playerLogo;
    data['playerName'] = this.playerName;
    data['playerPosition'] = this.playerPosition;
    data['playerRebounds'] = this.playerRebounds;
    data['playerPoints'] = this.playerPoints;
    data['values'] = this.values;
    return data;
  }
}
