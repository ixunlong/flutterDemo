class DataPlayerEntity {
  String? index;
  String? playerLogo;
  String? playerName;
  String? playerPosition;
  String? teamName;
  List<String>? values;

  DataPlayerEntity(
      {this.index,
      this.playerLogo,
      this.playerName,
      this.playerPosition,
      this.teamName,
      this.values});

  DataPlayerEntity.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    playerLogo = json['playerLogo'];
    playerName = json['playerName'];
    playerPosition = json['playerPosition'];
    teamName = json['teamName'];
    values = json['values'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index'] = this.index;
    data['playerLogo'] = this.playerLogo;
    data['playerName'] = this.playerName;
    data['playerPosition'] = this.playerPosition;
    data['teamName'] = this.teamName;
    data['values'] = this.values;
    return data;
  }
}
