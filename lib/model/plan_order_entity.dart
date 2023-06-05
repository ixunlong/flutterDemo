class PlanOrderEntity {
  String? couponIds;
  String? createTime;
  String? expertId;
  int? gold;
  String? id;
  String? info;
  int? planId;
  int? price;
  int? status;
  String? userId;

  PlanOrderEntity(
      {this.couponIds,
      this.createTime,
      this.expertId,
      this.gold,
      this.id,
      this.info,
      this.planId,
      this.price,
      this.status,
      this.userId});

  PlanOrderEntity.fromJson(Map<String, dynamic> json) {
    couponIds = json['couponIds'];
    createTime = json['createTime'];
    expertId = json['expertId'];
    gold = json['gold'];
    id = json['id'];
    info = json['info'];
    planId = json['planId'];
    price = json['price'];
    status = json['status'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['couponIds'] = this.couponIds;
    data['createTime'] = this.createTime;
    data['expertId'] = this.expertId;
    data['gold'] = this.gold;
    data['id'] = this.id;
    data['info'] = this.info;
    data['planId'] = this.planId;
    data['price'] = this.price;
    data['status'] = this.status;
    data['userId'] = this.userId;
    return data;
  }
}