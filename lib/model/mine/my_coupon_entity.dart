class MyCouponEntity {
  String? condition;
  String? createTime;
  String? endTime;
  int? id;
  String? maxLimit;
  String? name;
  String? remark;
  String? startTime;
  int? status;
  String? typeLower;
  String? typeUpper;
  String? useUrl;
  String? userId;

  MyCouponEntity(
      {this.condition,
      this.createTime,
      this.endTime,
      this.id,
      this.maxLimit,
      this.name,
      this.remark,
      this.startTime,
      this.status,
      this.typeLower,
      this.typeUpper,
      this.useUrl,
      this.userId});

  MyCouponEntity.fromJson(Map<String, dynamic> json) {
    condition = json['condition'];
    createTime = json['createTime'];
    endTime = json['endTime'];
    id = json['id'];
    maxLimit = json['maxLimit'];
    name = json['name'];
    remark = json['remark'];
    startTime = json['startTime'];
    status = json['status'];
    typeLower = json['typeLower'];
    typeUpper = json['typeUpper'];
    useUrl = json['useUrl'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['condition'] = this.condition;
    data['createTime'] = this.createTime;
    data['endTime'] = this.endTime;
    data['id'] = this.id;
    data['maxLimit'] = this.maxLimit;
    data['name'] = this.name;
    data['remark'] = this.remark;
    data['startTime'] = this.startTime;
    data['status'] = this.status;
    data['typeLower'] = this.typeLower;
    data['typeUpper'] = this.typeUpper;
    data['useUrl'] = this.useUrl;
    data['userId'] = this.userId;
    return data;
  }
}