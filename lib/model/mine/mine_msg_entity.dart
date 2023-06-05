class MineMsgEntity {
  String? button;
  String? content;
  int? id;
  String? publishTime;
  int? read;
  String? title;
  String? url;

  MineMsgEntity(
      {this.button,
      this.content,
      this.id,
      this.publishTime,
      this.read,
      this.title,
      this.url});

  MineMsgEntity.fromJson(Map<String, dynamic> json) {
    button = json['button'];
    content = json['content'];
    id = json['id'];
    publishTime = json['publishTime'];
    read = json['read'];
    title = json['title'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['button'] = this.button;
    data['content'] = this.content;
    data['id'] = this.id;
    data['publishTime'] = this.publishTime;
    data['read'] = this.read;
    data['title'] = this.title;
    data['url'] = this.url;
    return data;
  }
}