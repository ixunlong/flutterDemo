class CoinDetailEntity {
  String? createTime;
  String? description;
  String? goldAfter;
  String? goldChange;
  String? goldId;
  String? memo;
  String? payType;
  String? status;
  String? title;

  CoinDetailEntity(
      {this.createTime,
      this.description,
      this.goldAfter,
      this.goldChange,
      this.goldId,
      this.memo,
      this.payType,
      this.status,
      this.title});

  CoinDetailEntity.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    description = json['description'];
    goldAfter = json['goldAfter'];
    goldChange = json['goldChange'];
    goldId = json['goldId'];
    memo = json['memo'];
    payType = json['payType'];
    status = json['status'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['description'] = this.description;
    data['goldAfter'] = this.goldAfter;
    data['goldChange'] = this.goldChange;
    data['goldId'] = this.goldId;
    data['memo'] = this.memo;
    data['payType'] = this.payType;
    data['status'] = this.status;
    data['title'] = this.title;
    return data;
  }
}
