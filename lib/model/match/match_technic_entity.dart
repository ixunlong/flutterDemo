import 'dart:developer';
import 'dart:ui';

import 'package:hexcolor/hexcolor.dart';

class MatchTechEntity {
  int? source;
  int? matchId;
  String? homeColor;
  String? guestColor;
  List<TechnicDetail1>? technicDetail;
  List<TechnicDetail>? topDetail;

  MatchTechEntity(
      {this.source,
      this.matchId,
      this.homeColor,
      this.guestColor,
      this.technicDetail,
      this.topDetail});

  MatchTechEntity.fromJson(Map<String, dynamic> json) {
    source = json['source'];
    matchId = json['matchId'];
    homeColor = json['homeColor'];
    guestColor = json['guestColor'];
    if (json['technicDetail'] != null) {
      technicDetail = <TechnicDetail1>[];
      json['technicDetail'].forEach((v) {
        technicDetail!.add(new TechnicDetail1.fromJson(v));
      });
    }
    if (json['topDetail'] != null) {
      topDetail = <TechnicDetail>[];
      json['topDetail'].forEach((v) {
        topDetail!.add(new TechnicDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['source'] = this.source;
    data['matchId'] = this.matchId;
    data['homeColor'] = this.homeColor;
    data['guestColor'] = this.guestColor;
    if (this.technicDetail != null) {
      data['technicDetail'] =
          this.technicDetail!.map((v) => v.toJson()).toList();
    }
    if (this.topDetail != null) {
      data['topDetail'] = this.topDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TechnicDetail1 {
  String? title;
  List<TechnicDetail>? technicDetail;

  TechnicDetail1({this.title, this.technicDetail});

  TechnicDetail1.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['technicDetail'] != null) {
      technicDetail = <TechnicDetail>[];
      json['technicDetail'].forEach((v) {
        technicDetail!.add(new TechnicDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.technicDetail != null) {
      data['technicDetail'] =
          this.technicDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TechnicDetail {
  String? homeData;
  String? guestData;
  String? technicCn;
  int? kind;

  TechnicDetail({this.homeData, this.guestData, this.technicCn, this.kind});

  TechnicDetail.fromJson(Map<String, dynamic> json) {
    homeData = json['homeData'];
    guestData = json['guestData'];
    technicCn = json['technicCn'];
    kind = json['kind'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['homeData'] = this.homeData;
    data['guestData'] = this.guestData;
    data['technicCn'] = this.technicCn;
    data['kind'] = this.kind;
    return data;
  }
}

extension MatchTechEntityEx1 on MatchTechEntity {
  Color? get getHomeColor => homeColor == null ? null : HexColor(homeColor!);
  Color? get getGuestColor => guestColor == null ? null : HexColor(guestColor!);
}

extension TechnicDetail1Ex1 on TechnicDetail1 {
  bool get isNoData {
    if (technicDetail == null) {
      return true;
    }
    bool isNoData = true;
    for (var element in technicDetail!) {
      if (element.isHasData) {
        log("element has data ${element.toJson()}");
        isNoData = false;
        break;
      }
    }
    return isNoData;
  }

  bool get isHasdata => !isNoData;
}

extension TechnicDetailEx1 on TechnicDetail {
  bool get isPercent =>
      (homeData?.contains("%") ?? false) && (guestData?.contains("%") ?? false);
  int? get homeInt => int.tryParse(homeData?.replaceAll("%", "") ?? "");
  int? get guestInt => int.tryParse(guestData?.replaceAll("%", "") ?? "");
  bool get isNoData => !isHasData;
  bool get isHasData => ((homeInt ?? 0) > 0) || ((guestInt ?? 0) > 0);
}
