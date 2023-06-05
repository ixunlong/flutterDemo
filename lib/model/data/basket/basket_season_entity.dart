class BasketSeasonEntity {
  int? seasonId;
  String? seasonYear;

  BasketSeasonEntity({this.seasonId, this.seasonYear});

  BasketSeasonEntity.fromJson(Map<String, dynamic> json) {
    seasonId = json['seasonId'];
    seasonYear = json['seasonYear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seasonId'] = this.seasonId;
    data['seasonYear'] = this.seasonYear;
    return data;
  }
}