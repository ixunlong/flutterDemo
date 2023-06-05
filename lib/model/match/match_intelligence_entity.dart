class MatchIntelligenceEntity {
  String? confident;
  String? guestAnalysis;
  String? guestFavourable;
  String? guestInjury;
  String? guestNews;
  String? guestScore;
  String? guestUnFavourable;
  String? homeAnalysis;
  String? homeFavourable;
  String? homeInjury;
  String? homeNews;
  String? homeScore;
  String? homeUnFavourable;
  String? neutrality;
  String? injuryAnalysis;
  String? matchData;
  String? matchForecast;
  int? matchId;
  int? source;
  int? stars;
  String? title;
  String? vsInfo;

  MatchIntelligenceEntity(
      {this.confident,
        this.guestAnalysis,
        this.guestFavourable,
        this.guestInjury,
        this.guestNews,
        this.guestScore,
        this.guestUnFavourable,
        this.homeAnalysis,
        this.homeFavourable,
        this.homeInjury,
        this.homeNews,
        this.homeScore,
        this.homeUnFavourable,
        this.injuryAnalysis,
        this.matchData,
        this.matchForecast,
        this.matchId,
        this.source,
        this.stars,
        this.title,
        this.vsInfo,
        this.neutrality});

  MatchIntelligenceEntity.fromJson(Map<String, dynamic> json) {
    confident = json['confident'];
    guestAnalysis = json['guestAnalysis'];
    guestFavourable = json['guestFavourable'];
    guestInjury = json['guestInjury'];
    guestNews = json['guestNews'];
    guestScore = json['guestScore'];
    guestUnFavourable = json['guestUnFavourable'];
    homeAnalysis = json['homeAnalysis'];
    homeFavourable = json['homeFavourable'];
    homeInjury = json['homeInjury'];
    homeNews = json['homeNews'];
    homeScore = json['homeScore'];
    homeUnFavourable = json['homeUnFavourable'];
    injuryAnalysis = json['injuryAnalysis'];
    matchData = json['matchData'];
    matchForecast = json['matchForecast'];
    matchId = json['matchId'];
    source = json['source'];
    stars = json['stars'];
    title = json['title'];
    vsInfo = json['vsInfo'];
    neutrality = json['neutrality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['confident'] = this.confident;
    data['guestAnalysis'] = this.guestAnalysis;
    data['guestFavourable'] = this.guestFavourable;
    data['guestInjury'] = this.guestInjury;
    data['guestNews'] = this.guestNews;
    data['guestScore'] = this.guestScore;
    data['guestUnFavourable'] = this.guestUnFavourable;
    data['homeAnalysis'] = this.homeAnalysis;
    data['homeFavourable'] = this.homeFavourable;
    data['homeInjury'] = this.homeInjury;
    data['homeNews'] = this.homeNews;
    data['homeScore'] = this.homeScore;
    data['homeUnFavourable'] = this.homeUnFavourable;
    data['injuryAnalysis'] = this.injuryAnalysis;
    data['matchData'] = this.matchData;
    data['matchForecast'] = this.matchForecast;
    data['matchId'] = this.matchId;
    data['source'] = this.source;
    data['stars'] = this.stars;
    data['title'] = this.title;
    data['vsInfo'] = this.vsInfo;
    data['neutrality'] = this.neutrality;
    return data;
  }
}