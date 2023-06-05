class SoccerDataEntity {
  int? accuratePass;
  int? aerialWon;
  String? age;
  String? assist;
  String? birthday;
  int? clearanceWon;
  int? clearances;
  List<CountArray>? countArray;
  String? countryCn;
  int? crossNum;
  int? crossWon;
  List<String>? defendArray;
  List<String>? disciplineArray;
  int? dispossessed;
  List<String>? doorArray;
  int? dribblesWon;
  int? errorLeadToGoal;
  int? fouls;
  String? goals;
  String? goalsPenalty;
  String? height;
  int? interception;
  bool? isBest;
  bool? isFirstTeam;
  int? keyPass;
  String? logo;
  int? longBall;
  int? longBallWon;
  String? nameChs;
  String? number;
  List<String>? offensiveArray;
  int? offsides;
  int? offsidesProvoked;
  List<String>? otherArray;
  List<String>? passArray;
  double? passRate;
  String? penaltyGoals;
  int? penaltySave;
  String? photo;
  String? playingTime;
  String? positionCn;
  String? rating;
  int? red;
  int? secondYellow;
  int? shotOnPost;
  int? shots;
  int? shotsBlocked;
  int? shotsTarget;
  int? tackles;
  int? throughBall;
  int? throughBallWon;
  int? totalPass;
  int? touches;
  int? turnover;
  int? wasFouled;
  String? weight;
  int? yellow;

  SoccerDataEntity(
      {this.accuratePass,
        this.aerialWon,
        this.age,
        this.assist,
        this.birthday,
        this.clearanceWon,
        this.clearances,
        this.countArray,
        this.countryCn,
        this.crossNum,
        this.crossWon,
        this.defendArray,
        this.disciplineArray,
        this.dispossessed,
        this.doorArray,
        this.dribblesWon,
        this.errorLeadToGoal,
        this.fouls,
        this.goals,
        this.goalsPenalty,
        this.height,
        this.interception,
        this.isBest,
        this.isFirstTeam,
        this.keyPass,
        this.logo,
        this.longBall,
        this.longBallWon,
        this.nameChs,
        this.number,
        this.offensiveArray,
        this.offsides,
        this.offsidesProvoked,
        this.otherArray,
        this.passArray,
        this.passRate,
        this.penaltyGoals,
        this.penaltySave,
        this.photo,
        this.playingTime,
        this.positionCn,
        this.rating,
        this.red,
        this.secondYellow,
        this.shotOnPost,
        this.shots,
        this.shotsBlocked,
        this.shotsTarget,
        this.tackles,
        this.throughBall,
        this.throughBallWon,
        this.totalPass,
        this.touches,
        this.turnover,
        this.wasFouled,
        this.weight,
        this.yellow});

  SoccerDataEntity.fromJson(Map<String, dynamic> json) {
    accuratePass = json['accuratePass'];
    aerialWon = json['aerialWon'];
    age = json['age'];
    assist = json['assist'];
    birthday = json['birthday'];
    clearanceWon = json['clearanceWon'];
    clearances = json['clearances'];
    if (json['countArray'] != null) {
      countArray = <CountArray>[];
      json['countArray'].forEach((v) {
        countArray!.add(new CountArray.fromJson(v));
      });
    }
    countryCn = json['countryCn'];
    crossNum = json['crossNum'];
    crossWon = json['crossWon'];
    defendArray = json['defendArray'].cast<String>();
    disciplineArray = json['disciplineArray'].cast<String>();
    dispossessed = json['dispossessed'];
    doorArray = json['doorArray'].cast<String>();
    dribblesWon = json['dribblesWon'];
    errorLeadToGoal = json['errorLeadToGoal'];
    fouls = json['fouls'];
    goals = json['goals'];
    goalsPenalty = json['goalsPenalty'];
    height = json['height'];
    interception = json['interception'];
    isBest = json['isBest'];
    isFirstTeam = json['isFirstTeam'];
    keyPass = json['keyPass'];
    logo = json['logo'];
    longBall = json['longBall'];
    longBallWon = json['longBallWon'];
    nameChs = json['nameChs'];
    number = json['number'];
    offensiveArray = json['offensiveArray'].cast<String>();
    offsides = json['offsides'];
    offsidesProvoked = json['offsidesProvoked'];
    otherArray = json['otherArray'].cast<String>();
    passArray = json['passArray'].cast<String>();
    passRate = json['passRate'];
    penaltyGoals = json['penaltyGoals'];
    penaltySave = json['penaltySave'];
    photo = json['photo'];
    playingTime = json['playingTime'];
    positionCn = json['positionCn'];
    rating = json['rating'];
    red = json['red'];
    secondYellow = json['secondYellow'];
    shotOnPost = json['shotOnPost'];
    shots = json['shots'];
    shotsBlocked = json['shotsBlocked'];
    shotsTarget = json['shotsTarget'];
    tackles = json['tackles'];
    throughBall = json['throughBall'];
    throughBallWon = json['throughBallWon'];
    totalPass = json['totalPass'];
    touches = json['touches'];
    turnover = json['turnover'];
    wasFouled = json['wasFouled'];
    weight = json['weight'];
    yellow = json['yellow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accuratePass'] = this.accuratePass;
    data['aerialWon'] = this.aerialWon;
    data['age'] = this.age;
    data['assist'] = this.assist;
    data['birthday'] = this.birthday;
    data['clearanceWon'] = this.clearanceWon;
    data['clearances'] = this.clearances;
    if (this.countArray != null) {
      data['countArray'] = this.countArray!.map((v) => v.toJson()).toList();
    }
    data['countryCn'] = this.countryCn;
    data['crossNum'] = this.crossNum;
    data['crossWon'] = this.crossWon;
    data['defendArray'] = this.defendArray;
    data['disciplineArray'] = this.disciplineArray;
    data['dispossessed'] = this.dispossessed;
    data['doorArray'] = this.doorArray;
    data['dribblesWon'] = this.dribblesWon;
    data['errorLeadToGoal'] = this.errorLeadToGoal;
    data['fouls'] = this.fouls;
    data['goals'] = this.goals;
    data['goalsPenalty'] = this.goalsPenalty;
    data['height'] = this.height;
    data['interception'] = this.interception;
    data['isBest'] = this.isBest;
    data['isFirstTeam'] = this.isFirstTeam;
    data['keyPass'] = this.keyPass;
    data['logo'] = this.logo;
    data['longBall'] = this.longBall;
    data['longBallWon'] = this.longBallWon;
    data['nameChs'] = this.nameChs;
    data['number'] = this.number;
    data['offensiveArray'] = this.offensiveArray;
    data['offsides'] = this.offsides;
    data['offsidesProvoked'] = this.offsidesProvoked;
    data['otherArray'] = this.otherArray;
    data['passArray'] = this.passArray;
    data['passRate'] = this.passRate;
    data['penaltyGoals'] = this.penaltyGoals;
    data['penaltySave'] = this.penaltySave;
    data['photo'] = this.photo;
    data['playingTime'] = this.playingTime;
    data['positionCn'] = this.positionCn;
    data['rating'] = this.rating;
    data['red'] = this.red;
    data['secondYellow'] = this.secondYellow;
    data['shotOnPost'] = this.shotOnPost;
    data['shots'] = this.shots;
    data['shotsBlocked'] = this.shotsBlocked;
    data['shotsTarget'] = this.shotsTarget;
    data['tackles'] = this.tackles;
    data['throughBall'] = this.throughBall;
    data['throughBallWon'] = this.throughBallWon;
    data['totalPass'] = this.totalPass;
    data['touches'] = this.touches;
    data['turnover'] = this.turnover;
    data['wasFouled'] = this.wasFouled;
    data['weight'] = this.weight;
    data['yellow'] = this.yellow;
    return data;
  }
}

class CountArray {
  String? info;
  int? type;

  CountArray({this.info, this.type});

  CountArray.fromJson(Map<String, dynamic> json) {
    info = json['info'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['info'] = this.info;
    data['type'] = this.type;
    return data;
  }
}