class ExpertApplyEntity {
  String? createTime;
  String? idCard;
  String? idCard1;
  String? idCard2;
  String? info;
  String? logo;
  String? name;
  String? otherPhoto;
  String? realName;
  int? type;
  //0申请中 1通过 2拒绝
  int? status;
  String? userId;
  String? wechat;

  ExpertApplyEntity(
      {this.createTime,
      this.idCard,
      this.idCard1,
      this.idCard2,
      this.info,
      this.logo,
      this.name,
      this.otherPhoto,
      this.realName,
      this.type,
      this.status,
      this.userId,
      this.wechat});

  ExpertApplyEntity.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    idCard = json['idCard'];
    idCard1 = json['idCard1'];
    idCard2 = json['idCard2'];
    info = json['info'];
    logo = json['logo'];
    name = json['name'];
    otherPhoto = json['otherPhoto'];
    realName = json['realName'];
    type = json['type'];
    status = json['status'];
    userId = json['userId'];
    wechat = json['wechat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['idCard'] = this.idCard;
    data['idCard1'] = this.idCard1;
    data['idCard2'] = this.idCard2;
    data['info'] = this.info;
    data['logo'] = this.logo;
    data['name'] = this.name;
    data['otherPhoto'] = this.otherPhoto;
    data['realName'] = this.realName;
    data['type'] = this.type;
    data['status'] = this.status;
    data['userId'] = this.userId;
    data['wechat'] = this.wechat;
    return data;
  }
}
