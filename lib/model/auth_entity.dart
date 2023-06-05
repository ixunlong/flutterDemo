class AuthEntity {
  String? userId;
  String? phone;
  String? token;
  String? accessCode;
  //用户类型 0游客 1普通 2专家
  int? type;

  AuthEntity({this.userId, this.phone, this.token, this.accessCode});

  AuthEntity.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    phone = json['phone'];
    token = json['token'];
    accessCode = json['accessCode'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['userId'] = userId;
    data['phone'] = phone;
    data['token'] = token;
    data['accessCode'] = accessCode;
    data['type'] = type;
    return data;
  }
}
