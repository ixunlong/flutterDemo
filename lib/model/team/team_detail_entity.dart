class TeamDetailEntity {
  String? age;
  String? currentSeason;
  String? foundingDate;
  String? honor;
  List<HonorView>? honorView;
  String? introduce;
  int? isFocus;
  String? leagueName;
  String? logo;
  List<MatchResult>? matchResult;
  String? nameChs;
  String? nameChsShort;
  String? nameEn;
  String? national;
  String? price;
  String? rank;
  int? sourceTeamId;
  String? type;
  String? countryCn;
  String? areaCn;
  String? gymCn;
  String? capacity;
  String? website;
  String? addrCn;

  TeamDetailEntity(
      {this.age,
      this.currentSeason,
      this.foundingDate,
      this.honor,
      this.honorView,
      this.introduce,
      this.isFocus,
      this.leagueName,
      this.logo,
      this.matchResult,
      this.nameChs,
      this.nameChsShort,
      this.nameEn,
      this.national,
      this.price,
      this.rank,
      this.sourceTeamId,
      this.type,
      this.countryCn,
      this.areaCn,
      this.gymCn,
      this.capacity,
      this.website,
      this.addrCn});

  TeamDetailEntity.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    currentSeason = json['currentSeason'];
    foundingDate = json['foundingDate'];
    honor = json['honor'];
    if (json['honorView'] != null) {
      honorView = <HonorView>[];
      json['honorView'].forEach((v) {
        honorView!.add(new HonorView.fromJson(v));
      });
    }
    introduce = json['introduce'];
    isFocus = json['isFocus'];
    leagueName = json['leagueName'];
    logo = json['logo'];
    if (json['matchResult'] != null) {
      matchResult = <MatchResult>[];
      json['matchResult'].forEach((v) {
        matchResult!.add(new MatchResult.fromJson(v));
      });
    }
    nameChs = json['nameChs'];
    nameChsShort = json['nameChsShort'];
    nameEn = json['nameEn'];
    national = json['national'];
    price = json['price'];
    rank = json['rank'];
    sourceTeamId = json['sourceTeamId'];
    type = json['type'];
    countryCn = json['countryCn'];
    areaCn = json['areaCn'];
    gymCn = json['gymCn'];
    capacity = json['capacity'];
    website = json['website'];
    addrCn = json['addrCn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['currentSeason'] = this.currentSeason;
    data['foundingDate'] = this.foundingDate;
    data['honor'] = this.honor;
    if (this.honorView != null) {
      data['honorView'] = this.honorView!.map((v) => v.toJson()).toList();
    }
    data['introduce'] = this.introduce;
    data['isFocus'] = this.isFocus;
    data['leagueName'] = this.leagueName;
    data['logo'] = this.logo;
    if (this.matchResult != null) {
      data['matchResult'] = this.matchResult!.map((v) => v.toJson()).toList();
    }
    data['nameChs'] = this.nameChs;
    data['nameChsShort'] = this.nameChsShort;
    data['nameEn'] = this.nameEn;
    data['national'] = this.national;
    data['price'] = this.price;
    data['rank'] = this.rank;
    data['sourceTeamId'] = this.sourceTeamId;
    data['type'] = this.type;
    data['countryCn'] = this.countryCn;
    data['areaCn'] = this.areaCn;
    data['gymCn'] = this.gymCn;
    data['capacity'] = this.capacity;
    data['website'] = this.website;
    data['addrCn'] = this.addrCn;
    return data;
  }
}

class HonorView {
  String? leagueName;
  int? size;
  List<String>? season;

  HonorView({this.leagueName, this.season});

  HonorView.fromJson(Map<String, dynamic> json) {
    leagueName = json['leagueName'];
    season = json['season'].cast<String>();
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leagueName'] = this.leagueName;
    data['season'] = this.season;
    data['size'] = this.size;
    return data;
  }
}

class MatchResult {
  int? guestId;
  String? guestLogo;
  String? guestName;
  int? guestScore90;
  int? homeId;
  String? homeLogo;
  String? homeName;
  int? homeScore90;
  String? leagueName;
  String? matchTime;
  int? resultStatus;
  String? rounds;

  MatchResult(
      {this.guestId,
      this.guestLogo,
      this.guestName,
      this.guestScore90,
      this.homeId,
      this.homeLogo,
      this.homeName,
      this.homeScore90,
      this.leagueName,
      this.matchTime,
      this.resultStatus,
      this.rounds});

  MatchResult.fromJson(Map<String, dynamic> json) {
    guestId = json['guestId'];
    guestLogo = json['guestLogo'];
    guestName = json['guestName'];
    guestScore90 = json['guestScore90'];
    homeId = json['homeId'];
    homeLogo = json['homeLogo'];
    homeName = json['homeName'];
    homeScore90 = json['homeScore90'];
    leagueName = json['leagueName'];
    matchTime = json['matchTime'];
    resultStatus = json['resultStatus'];
    rounds = json['rounds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['guestId'] = this.guestId;
    data['guestLogo'] = this.guestLogo;
    data['guestName'] = this.guestName;
    data['guestScore90'] = this.guestScore90;
    data['homeId'] = this.homeId;
    data['homeLogo'] = this.homeLogo;
    data['homeName'] = this.homeName;
    data['homeScore90'] = this.homeScore90;
    data['leagueName'] = this.leagueName;
    data['matchTime'] = this.matchTime;
    data['resultStatus'] = this.resultStatus;
    data['rounds'] = this.rounds;
    return data;
  }
}
