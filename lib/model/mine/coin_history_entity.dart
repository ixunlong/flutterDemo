class CoinHistoryEntity {
  String? id;
  String? userId;
  int? type;
  String? otherId;
  int? goldSign;
  double? goldChange;
  double? goldAfter;
  int? status;
  String? memo;
  String? extInfo;
  String? createTime;

  CoinHistoryEntity(
      {this.id,
      this.userId,
      this.type,
      this.otherId,
      this.goldSign,
      this.goldChange,
      this.goldAfter,
      this.status,
      this.memo,
      this.extInfo,
      this.createTime});

  CoinHistoryEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    type = json['type'];
    otherId = json['otherId'];
    goldSign = json['goldSign'];
    goldChange = json['goldChange'];
    goldAfter = json['goldAfter'];
    status = json['status'];
    memo = json['memo'];
    extInfo = json['extInfo'];
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['type'] = this.type;
    data['otherId'] = this.otherId;
    data['goldSign'] = this.goldSign;
    data['goldChange'] = this.goldChange;
    data['goldAfter'] = this.goldAfter;
    data['status'] = this.status;
    data['memo'] = this.memo;
    data['extInfo'] = this.extInfo;
    data['createTime'] = this.createTime;
    return data;
  }
}
