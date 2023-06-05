class DataTeamEntity {
  String? index;
  String? teamName;
  String? teamLogo;
  int? qxbTeamId;
  int? home;
  List<String>? values;

  DataTeamEntity(
      {this.index,
      this.teamName,
      this.teamLogo,
      this.home,
      this.values,
      this.qxbTeamId});

  DataTeamEntity.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    teamName = json['teamName'];
    teamLogo = json['teamLogo'];
    home = json['home'];
    qxbTeamId = json['qxbTeamId'];
    values = json['values'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index'] = this.index;
    data['teamName'] = this.teamName;
    data['teamLogo'] = this.teamLogo;
    data['home'] = this.home;
    data['values'] = this.values;
    data['qxbTeamId'] = this.qxbTeamId;
    return data;
  }
}
