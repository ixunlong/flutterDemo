class MatchOddsOkEntity {
  int? id;
  int? matchQxbId;
  String? homeName;
  String? guestName;
  String? matchTime;
  String? leagueName;
  double? homePrice;
  double? guestPrice;
  double? flatPrice;
  int? homeCount;
  int? guestCount;
  int? flatCount;
  String? cutHomeCount;
  String? cutGuestCount;
  String? cutFlatCount;
  int? homeProfit;
  int? guestProfit;
  int? flatProfit;
  int? homeCold;
  int? guestCold;
  int? flatCold;
  List<String>? pointData;
  int? maxHomeCount;
  int? maxGuestCount;
  int? maxFlatCount;
  String? cutMaxHomeCount;
  String? cutMaxGuestCount;
  String? cutMaxFlatCount;
  List<Details>? details;

  MatchOddsOkEntity(
      {this.id,
      this.matchQxbId,
      this.homeName,
      this.guestName,
      this.matchTime,
      this.leagueName,
      this.homePrice,
      this.guestPrice,
      this.flatPrice,
      this.homeCount,
      this.guestCount,
      this.flatCount,
      this.cutHomeCount,
      this.cutGuestCount,
      this.cutFlatCount,
      this.homeProfit,
      this.guestProfit,
      this.flatProfit,
      this.homeCold,
      this.guestCold,
      this.flatCold,
      this.pointData,
      this.maxHomeCount,
      this.maxGuestCount,
      this.maxFlatCount,
      this.cutMaxHomeCount,
      this.cutMaxGuestCount,
      this.cutMaxFlatCount,
      this.details});

  MatchOddsOkEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    matchQxbId = json['matchQxbId'];
    homeName = json['homeName'];
    guestName = json['guestName'];
    matchTime = json['matchTime'];
    leagueName = json['leagueName'];
    homePrice = json['homePrice'];
    guestPrice = json['guestPrice'];
    flatPrice = json['flatPrice'];
    homeCount = json['homeCount'];
    guestCount = json['guestCount'];
    flatCount = json['flatCount'];
    cutHomeCount = json['cutHomeCount'];
    cutGuestCount = json['cutGuestCount'];
    cutFlatCount = json['cutFlatCount'];
    homeProfit = json['homeProfit'];
    guestProfit = json['guestProfit'];
    flatProfit = json['flatProfit'];
    homeCold = json['homeCold'];
    guestCold = json['guestCold'];
    flatCold = json['flatCold'];
    pointData = json['pointData'].cast<String>();
    maxHomeCount = json['maxHomeCount'];
    maxGuestCount = json['maxGuestCount'];
    maxFlatCount = json['maxFlatCount'];
    cutMaxHomeCount = json['cutMaxHomeCount'];
    cutMaxGuestCount = json['cutMaxGuestCount'];
    cutMaxFlatCount = json['cutMaxFlatCount'];
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(new Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['matchQxbId'] = this.matchQxbId;
    data['homeName'] = this.homeName;
    data['guestName'] = this.guestName;
    data['matchTime'] = this.matchTime;
    data['leagueName'] = this.leagueName;
    data['homePrice'] = this.homePrice;
    data['guestPrice'] = this.guestPrice;
    data['flatPrice'] = this.flatPrice;
    data['homeCount'] = this.homeCount;
    data['guestCount'] = this.guestCount;
    data['flatCount'] = this.flatCount;
    data['cutHomeCount'] = this.cutHomeCount;
    data['cutGuestCount'] = this.cutGuestCount;
    data['cutFlatCount'] = this.cutFlatCount;
    data['homeProfit'] = this.homeProfit;
    data['guestProfit'] = this.guestProfit;
    data['flatProfit'] = this.flatProfit;
    data['homeCold'] = this.homeCold;
    data['guestCold'] = this.guestCold;
    data['flatCold'] = this.flatCold;
    data['pointData'] = this.pointData;
    data['maxHomeCount'] = this.maxHomeCount;
    data['maxGuestCount'] = this.maxGuestCount;
    data['maxFlatCount'] = this.maxFlatCount;
    data['cutMaxHomeCount'] = this.cutMaxHomeCount;
    data['cutMaxGuestCount'] = this.cutMaxGuestCount;
    data['cutMaxFlatCount'] = this.cutMaxFlatCount;
    if (this.details != null) {
      data['details'] = this.details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
  String? matchTime;
  double? price;
  int? countNum;
  String? choices;
  String? type;

  Details({this.matchTime, this.price, this.countNum, this.choices, this.type});

  Details.fromJson(Map<String, dynamic> json) {
    matchTime = json['matchTime'];
    price = json['price'];
    countNum = json['countNum'];
    choices = json['choices'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['matchTime'] = this.matchTime;
    data['price'] = this.price;
    data['countNum'] = this.countNum;
    data['choices'] = this.choices;
    data['type'] = this.type;
    return data;
  }
}
