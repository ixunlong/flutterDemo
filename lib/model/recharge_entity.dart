class RechargeEntity {
  double? gold;
  String? id;
  double? payAmt;
  String? productId;
  String? description;

  RechargeEntity({this.gold, this.id, this.payAmt, this.productId});

  RechargeEntity.fromJson(Map<String, dynamic> json) {
    gold = json['gold'];
    id = json['id'];
    payAmt = json['payAmt'];
    productId = json['productId'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gold'] = this.gold;
    data['id'] = this.id;
    data['payAmt'] = this.payAmt;
    data['productId'] = this.productId;
    data['description'] = this.description;
    return data;
  }
}
