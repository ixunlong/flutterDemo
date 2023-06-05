class ExpertFocusEntity {
  List<Contents>? contents;
  int? total;

  ExpertFocusEntity({this.contents, this.total});

  ExpertFocusEntity.fromJson(Map<String, dynamic> json) {
    if (json['rows'] != null) {
      contents = <Contents>[];
      json['rows'].forEach((v) {
        contents!.add(new Contents.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.contents != null) {
      data['rows'] = this.contents!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class Contents {
  int? focus;
  String? id;
  String? logo;
  String? name;
  int? type;

  Contents({this.focus, this.id, this.logo, this.name, this.type});

  Contents.fromJson(Map<String, dynamic> json) {
    focus = json['focus'];
    id = json['id'];
    logo = json['logo'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['focus'] = this.focus;
    data['id'] = this.id;
    data['logo'] = this.logo;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
}