class UserInfoEntity {
  String? avatar;
  double? get gold => qiuGold;
  String? id;
  String? name;
  int? payPwdLimit;
  String? phone;
  int? type;
  double? qiuGold;
  int? avatarUpdateDays;
  String? cardId;
  String? realName;

  UserInfoEntity(
      {this.avatar,
      this.id,
      this.name,
      this.payPwdLimit,
      this.phone,
      this.type,
      this.qiuGold,
      this.avatarUpdateDays,
      this.cardId,
      this.realName});

  UserInfoEntity.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    id = json['id'];
    name = json['name'];
    payPwdLimit = json['payPwdLimit'];
    phone = json['phone'];
    type = json['type'];
    qiuGold = json['qiuGold'];
    avatarUpdateDays = json['avatarUpdateDays'];
    cardId = json['cardId'];
    realName = json['realName'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar'] = this.avatar;
    data['gold'] = this.gold;
    data['id'] = this.id;
    data['name'] = this.name;
    data['payPwdLimit'] = this.payPwdLimit;
    data['phone'] = this.phone;
    data['type'] = this.type;
    data['qiuGold'] = this.qiuGold;
    data['avatarUpdateDays'] = this.avatarUpdateDays;
    data['cardId'] = cardId;
    data['realName'] = realName;
    return data;
  }
}
