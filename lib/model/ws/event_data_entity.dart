
import 'dart:developer';

class EventDataEntity {
  String? firstTag;
  String? footTeamName;
  String? footTeamScore;
  String? secTag;
  String? topTeamName;
  String? topTeamScore;
  int? highLight;
  int? matchQxbId;

  EventDataEntity(
      {this.firstTag,
      this.footTeamName,
      this.footTeamScore,
      this.secTag,
      this.topTeamName,
      this.topTeamScore,
      this.highLight,
      this.matchQxbId});

  EventDataEntity.fromJson(Map<String, dynamic> json) {
    firstTag = json['firstTag'];
    footTeamName = json['footTeamName'];
    footTeamScore = json['footTeamScore'];
    secTag = json['secTag'];
    topTeamName = json['topTeamName'];
    topTeamScore = json['topTeamScore'];
    highLight = json['highLight'];
    matchQxbId = json['matchQxbId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstTag'] = firstTag;
    data['footTeamName'] = footTeamName;
    data['footTeamScore'] = footTeamScore;
    data['secTag'] = secTag;
    data['topTeamName'] = topTeamName;
    data['topTeamScore'] = topTeamScore;
    data['highLight'] = highLight;
    data['matchQxbId'] = matchQxbId;
    return data;
  }
}

extension EventDataEntityEx1 on EventDataEntity {
  bool isComplete() {
    if (
      this.firstTag == null ||
      this.footTeamName == null ||
      this.footTeamScore == null ||
      this.secTag == null ||
      this.topTeamName == null ||
      this.topTeamScore == null) {
        return false;
      }
    return true;
  }
}

class WsEventEntity {
  int? eventType;
  List<Null>? scope;
  int? status;
  int? timestamp;
  int? holdTime;
  EventDataEntity? data;

  WsEventEntity({this.eventType, this.scope, this.status, this.timestamp,this.data,this.holdTime});

  WsEventEntity.fromJson(Map<String, dynamic> json) {
    eventType = json['eventType'];
    if (json['scope'] != null) {
      scope = <Null>[];
      json['scope'].forEach((v) {
        scope!.add(v);
      });
    }
    status = json['status'];
    timestamp = json['timestamp'];
    holdTime = json['holdTime'];
    if (json['data'] != null) {
      data = EventDataEntity.fromJson(json['data']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventType'] = this.eventType;
    if (this.scope != null) {
      data['scope'] = this.scope!.map((v) => v).toList();
    }
    data['status'] = this.status;
    data['timestamp'] = this.timestamp;
    data['holdTime'] = holdTime;
    data['data'] = this.data?.toJson();
    return data;
  }
}


extension WsEventEntityEx1 on WsEventEntity {
  bool get isBasketbool => (eventType ?? 0) ~/ 100 == 81;
  bool get isSoccer => (eventType ?? 0) ~/ 100 == 82;
}
