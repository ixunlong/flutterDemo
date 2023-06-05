class OddsCompanyEntity {
  int? id;
  String? name;
  int? d;

  OddsCompanyEntity({this.id, this.name, this.d});

  OddsCompanyEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    d = json['d'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['d'] = this.d;
    return data;
  }
}
