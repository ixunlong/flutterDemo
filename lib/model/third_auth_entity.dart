class ThirdAuthEntity {
  String? createTime;
  int? id;
  String? logo;
  String? name;
  String? openId;
  int? type;
  String? updateTime;
  String? userId;

  ThirdAuthEntity(
      {this.createTime,
      this.id,
      this.logo,
      this.name,
      this.openId,
      this.type,
      this.updateTime,
      this.userId});

  ThirdAuthEntity.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    id = json['id'];
    logo = json['logo'];
    name = json['name'];
    openId = json['openId'];
    type = json['type'];
    updateTime = json['updateTime'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['id'] = this.id;
    data['logo'] = this.logo;
    data['name'] = this.name;
    data['openId'] = this.openId;
    data['type'] = this.type;
    data['updateTime'] = this.updateTime;
    data['userId'] = this.userId;
    return data;
  }
}
