class TeamLineupEntity {
  List<Player>? player;
  String? title;

  TeamLineupEntity({this.player, this.title});

  TeamLineupEntity.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      player = <Player>[];
      json['list'].forEach((v) {
        player!.add(new Player.fromJson(v));
      });
    }
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.player != null) {
      data['list'] = this.player!.map((v) => v.toJson()).toList();
    }
    data['title'] = this.title;
    return data;
  }
}

class Player {
  String? age;
  String? countryCn;
  String? number;
  String? photo;
  String? place;
  String? playerCn;
  int? playerId;
  String? teamCn;
  int? type;
  String? value;

  Player(
      {this.age,
        this.countryCn,
        this.number,
        this.photo,
        this.place,
        this.playerCn,
        this.playerId,
        this.teamCn,
        this.type,
        this.value});

  Player.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    countryCn = json['countryCn'];
    number = json['number'];
    photo = json['photo'];
    place = json['place'];
    playerCn = json['playerCn'];
    playerId = json['playerId'];
    teamCn = json['teamCn'];
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['countryCn'] = this.countryCn;
    data['number'] = this.number;
    data['photo'] = this.photo;
    data['place'] = this.place;
    data['playerCn'] = this.playerCn;
    data['playerId'] = this.playerId;
    data['teamCn'] = this.teamCn;
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}