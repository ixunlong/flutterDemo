class MineInteractEntity {
  String? eventContent;
  String? eventTime;
  String? eventUserId;
  String? eventUserLogo;
  String? eventUserName;
  int? id;
  String? originContent;
  int? originId;
  String? href;
  int? read;
  String? typeContent;

  MineInteractEntity(
      {this.eventContent,
      this.eventTime,
      this.eventUserId,
      this.eventUserLogo,
      this.eventUserName,
      this.id,
      this.originContent,
      this.originId,
      this.read,
      this.typeContent,
      this.href});

  MineInteractEntity.fromJson(Map<String, dynamic> json) {
    eventContent = json['eventContent'];
    eventTime = json['eventTime'];
    eventUserId = json['eventUserId'];
    eventUserLogo = json['eventUserLogo'];
    eventUserName = json['eventUserName'];
    id = json['id'];
    originContent = json['originContent'];
    originId = json['originId'];
    read = json['read'];
    typeContent = json['typeContent'];
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventContent'] = this.eventContent;
    data['eventTime'] = this.eventTime;
    data['eventUserId'] = this.eventUserId;
    data['eventUserLogo'] = this.eventUserLogo;
    data['eventUserName'] = this.eventUserName;
    data['id'] = this.id;
    data['originContent'] = this.originContent;
    data['originId'] = this.originId;
    data['read'] = this.read;
    data['typeContent'] = this.typeContent;
    data['href'] = href;
    return data;
  }
}