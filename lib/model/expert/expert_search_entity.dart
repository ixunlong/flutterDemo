class ExpertSearchEntity {
  String? id;
  int? isFocus;
  String? logo;
  String? name;

  ExpertSearchEntity({this.id, this.isFocus, this.logo, this.name});

  ExpertSearchEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isFocus = json['isFocus'];
    logo = json['logo'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isFocus'] = this.isFocus;
    data['logo'] = this.logo;
    data['name'] = this.name;
    return data;
  }
}