class NewsCommentEntity {
  String? addr;
  String? comment;
  int? commentNum;
  String? createTime;
  String? fromComment;
  String? fromName;
  int? id;
  int? isLike;
  int? isUser;
  int? likeNum;
  int? originId;
  String? special;
  String? userLogo;
  String? userName;
  int? verifyStatus;

  bool isDeleted = false;

  NewsCommentEntity(
      {this.addr,
      this.comment,
      this.commentNum,
      this.createTime,
      this.fromComment,
      this.id,
      this.isLike,
      this.isUser,
      this.likeNum,
      this.originId,
      this.special,
      this.userLogo,
      this.userName,
      this.fromName,
      this.verifyStatus});

  NewsCommentEntity.fromJson(Map<String, dynamic> json) {
    addr = json['addr'];
    comment = json['comment'];
    commentNum = json['commentNum'];
    createTime = json['createTime'];
    fromComment = json['fromComment'];
    id = json['id'];
    isLike = json['isLike'];
    isUser = json['isUser'];
    likeNum = json['likeNum'];
    originId = json['originId'];
    special = json['special'];
    userLogo = json['userLogo'];
    userName = json['userName'];
    fromName = json['fromName'];
    verifyStatus = json['verifyStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addr'] = this.addr;
    data['comment'] = this.comment;
    data['commentNum'] = this.commentNum;
    data['createTime'] = this.createTime;
    data['fromComment'] = this.fromComment;
    data['id'] = this.id;
    data['isLike'] = this.isLike;
    data['isUser'] = this.isUser;
    data['likeNum'] = this.likeNum;
    data['originId'] = this.originId;
    data['special'] = this.special;
    data['userLogo'] = this.userLogo;
    data['userName'] = this.userName;
    data['fromName'] = this.fromName;
    data['verifyStatus'] = this.verifyStatus;
    return data;
  }
}