class MatchVideoEntity {
  int? id;
  int? type;
  int? matchId;
  String? name;
  String? url;
  int? sort;

  MatchVideoEntity(
      {this.id, this.type, this.matchId, this.name, this.url, this.sort});

  MatchVideoEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    matchId = json['matchId'];
    name = json['name'];
    url = json['url'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['matchId'] = this.matchId;
    data['name'] = this.name;
    data['url'] = this.url;
    data['sort'] = this.sort;
    return data;
  }
}
