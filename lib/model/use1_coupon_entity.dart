class Use1CouponEntity {
  int? autoSelect;
  int? canUse;
  String? condition;
  String? createTime;
  String? endTime;
  double? gold;
  int? id;
  String? name;
  String? reason;
  String? remark;
  int? sign;
  String? startTime;
  String? typeLower;
  String? typeUpper;
  String? userId;

  Use1CouponEntity(
      {this.autoSelect,
      this.canUse,
      this.condition,
      this.createTime,
      this.endTime,
      this.gold,
      this.id,
      this.name,
      this.reason,
      this.remark,
      this.sign,
      this.startTime,
      this.typeLower,
      this.typeUpper,
      this.userId});

  Use1CouponEntity.fromJson(Map<String, dynamic> json) {
    autoSelect = json['autoSelect'];
    canUse = json['canUse'];
    condition = json['condition'];
    createTime = json['createTime'];
    endTime = json['endTime'];
    gold = json['gold']?.toDouble();
    id = json['id'];
    name = json['name'];
    reason = json['reason'];
    remark = json['remark'];
    sign = json['sign'];
    startTime = json['startTime'];
    typeLower = json['typeLower'];
    typeUpper = json['typeUpper'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['autoSelect'] = this.autoSelect;
    data['canUse'] = this.canUse;
    data['condition'] = this.condition;
    data['createTime'] = this.createTime;
    data['endTime'] = this.endTime;
    data['gold'] = this.gold;
    data['id'] = this.id;
    data['name'] = this.name;
    data['reason'] = this.reason;
    data['remark'] = this.remark;
    data['sign'] = this.sign;
    data['startTime'] = this.startTime;
    data['typeLower'] = this.typeLower;
    data['typeUpper'] = this.typeUpper;
    data['userId'] = this.userId;
    return data;
  }
}