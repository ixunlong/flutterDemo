class HomeNewsEntity {
  String? content;
  int? hot;
  int? id;
  int? imgStyle;
  String? imgs;
  String? publicTime;
  String? publicerName;
  String? disclaimer;
  String? media;
  String? summary;
  String? title;
  String? pv;
  String? logo;
  List<HomeNewsEntity>? list;
  int? top;
  String? info;
  String? video;
  int? commentNum;
  int? likeNum;
  int? isLike;
  int? isRead;
  String? h5url;
  int? classId;

  HomeNewsEntity(
      {this.content,
      this.hot,
      this.id,
      this.imgStyle,
      this.imgs,
      this.disclaimer,
      this.media,
      this.publicTime,
      this.publicerName,
      this.summary,
      this.title,
      this.pv,
      this.logo,
      this.list,
      this.info,
      this.top,
      this.video,
      this.commentNum,
      this.likeNum,
      this.isLike,
      this.isRead,
      this.h5url});

  HomeNewsEntity.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    hot = json['hot'];
    disclaimer = json['disclaimer'];
    media = json['media'];
    id = json['id'];
    imgStyle = json['imgStyle'];
    imgs = json['imgs'];
    publicTime = json['publicTime'];
    publicerName = json['publicerName'];
    summary = json['summary'];
    title = json['title'];
    pv = json["pv"];
    logo = json["logo"];
    top = json['top'];
    info = json['info'];
    video = json['video'];
    commentNum = json['commentNum'];
    likeNum = json['likeNum'];
    isLike = json['isLike'];
    isRead = json['isRead'];
    h5url = json['h5url'];
    if (json['list'] != null) {
      list = <HomeNewsEntity>[];
      json['list'].forEach((v) {
        list!.add(HomeNewsEntity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['hot'] = this.hot;
    data['id'] = this.id;
    data['disclaimer'] = this.disclaimer;
    data['media'] = this.media;
    data['imgStyle'] = this.imgStyle;
    data['imgs'] = this.imgs;
    data['publicTime'] = this.publicTime;
    data['publicerName'] = this.publicerName;
    data['summary'] = this.summary;
    data['title'] = this.title;
    data['pv'] = this.pv;
    data['logo'] = this.logo;
    data['top'] = top;
    data['info'] = info;
    data['commentNum'] = commentNum;
    data['likeNum'] = likeNum;
    data['isLike'] = isLike;
    data['isRead'] = isRead;
    data['h5url'] = h5url;
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
