class ImageUploadResultEntity {
  String? createTime;
  String? creater;
  int? id;
  String? name;
  String? path;
  String? type;
  String? url;

  ImageUploadResultEntity(
      {this.createTime,
      this.creater,
      this.id,
      this.name,
      this.path,
      this.type,
      this.url});

  ImageUploadResultEntity.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    creater = json['creater'];
    id = json['id'];
    name = json['name'];
    path = json['path'];
    type = json['type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['creater'] = this.creater;
    data['id'] = this.id;
    data['name'] = this.name;
    data['path'] = this.path;
    data['type'] = this.type;
    data['url'] = this.url;
    return data;
  }
}
