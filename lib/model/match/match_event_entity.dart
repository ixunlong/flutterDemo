class MatchEventEntity {
  String? allScore;
  String? eventTime;
  String? halfScore;
  int? isHome;
  int? kind;
  String? kindName;
  int? matchId;
  String? overTime;
  String? playerCh;
  String? playerId;
  String? playerId2;
  int? source;

  MatchEventEntity(
      {this.allScore,
        this.eventTime,
        this.halfScore,
        this.isHome,
        this.kind,
        this.kindName,
        this.matchId,
        this.overTime,
        this.playerCh,
        this.playerId,
        this.playerId2,
        this.source});

  MatchEventEntity.fromJson(Map<String, dynamic> json) {
    allScore = json['allScore'];
    eventTime = json['eventTime'];
    halfScore = json['halfScore'];
    isHome = json['isHome'];
    kind = json['kind'];
    kindName = json['kindName'];
    matchId = json['matchId'];
    overTime = json['overTime'];
    playerCh = json['playerCh'];
    playerId = json['playerId'];
    playerId2 = json['playerId2'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['allScore'] = this.allScore;
    data['eventTime'] = this.eventTime;
    data['halfScore'] = this.halfScore;
    data['isHome'] = this.isHome;
    data['kind'] = this.kind;
    data['kindName'] = this.kindName;
    data['matchId'] = this.matchId;
    data['overTime'] = this.overTime;
    data['playerCh'] = this.playerCh;
    data['playerId'] = this.playerId;
    data['playerId2'] = this.playerId2;
    data['source'] = this.source;
    return data;
  }
}


const eventsKind = {
  1: "进球",
  2: "红牌",
  3: "黄牌",
  4: "越位",
  5: "比赛结束",
  6: "控球率",
  7: "点球",
  8: "乌龙",
  9: "两黄变红",
  10: "开球",
  11: "换人",
  12: "任意球",
  13: "射失点球",
  14: "VAR",
  15: "头球",
  16: "守门员出击",
  17: "丟球",
  18: "抢断",
  19: "阻截",
  20: "传球",
  21: "助攻",
  22: "铲球",
  23: "过人",
  24: "进攻",
  25: "解围",
  26: "拦截",
  27: "防守",
  28: "反击",
  29: "界外球",
  30: "球门球",
  31: "出界",
  32: "传球",
  33: "成功率",
  34: "成功抢断",
  35: "进球取消",
  36: "取消点球",
  37: "犯规造成点球",
  38: "扑出点球",
  39: "救球受伤",
  40: "受伤回归",
  41: "射门",
  42: "射门不中",
  43: "中柱",
  44: "射门被挡",
  45: "射正",
  46: "犯规",
  47: "球权",
  48: "比赛开始",
  49: "角球",
  50: "其他",
  51: "腰斩",
  52: "中断",
  53: "半场结束"
};
