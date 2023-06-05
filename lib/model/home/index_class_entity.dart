class IndexClassEntity {
  int? id;
  String? name;
  int? sort;
  int? status;

  IndexClassEntity({this.id, this.name, this.sort, this.status});

  IndexClassEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sort = json['sort'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['sort'] = this.sort;
    data['status'] = this.status;
    return data;
  }
}