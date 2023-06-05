class OrderEntity {
  String? createTime;
  String? description;
  double? gold;
  String? id;
  int? itemId;
  String? otherId;
  double? payAmt;
  String? payId;
  int? payType;
  int? status;
  String? tag;
  String? title;
  String? userId;

  OrderEntity(
      {this.createTime,
      this.description,
      this.gold,
      this.id,
      this.itemId,
      this.otherId,
      this.payAmt,
      this.payId,
      this.payType,
      this.status,
      this.tag,
      this.title,
      this.userId});

  OrderEntity.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    description = json['description'];
    gold = json['gold'];
    id = json['id'];
    itemId = json['itemId'];
    otherId = json['otherId'];
    payAmt = json['payAmt'];
    payId = json['payId'];
    payType = json['payType'];
    status = json['status'];
    tag = json['tag'];
    title = json['title'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['description'] = this.description;
    data['gold'] = this.gold;
    data['id'] = this.id;
    data['itemId'] = this.itemId;
    data['otherId'] = this.otherId;
    data['payAmt'] = this.payAmt;
    data['payId'] = this.payId;
    data['payType'] = this.payType;
    data['status'] = this.status;
    data['tag'] = this.tag;
    data['title'] = this.title;
    data['userId'] = this.userId;
    return data;
  }
}
