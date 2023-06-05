class ExpertIdeaEntity {
  String? expertId;
  String? info;
  String? logo;
  String? name;
  String? renew;
  int? subs;
  int? subsCnt;
  double? subsDay;
  String? subsEndTime;
  double? subsMonth;
  double? subsWeek;
  String? tags;
  int? total;
  int? valid;

  ExpertIdeaEntity(
      {this.expertId,
      this.info,
      this.logo,
      this.name,
      this.renew,
      this.subs,
      this.subsCnt,
      this.subsDay,
      this.subsEndTime,
      this.subsMonth,
      this.subsWeek,
      this.tags,
      this.total,
      this.valid});

  ExpertIdeaEntity.fromJson(Map<String, dynamic> json) {
    expertId = json['expertId'];
    info = json['info'];
    logo = json['logo'];
    name = json['name'];
    renew = json['renew'];
    subs = json['subs'];
    subsCnt = json['subsCnt'];
    subsDay = json['subsDay'];
    subsEndTime = json['subsEndTime'];
    subsMonth = json['subsMonth'];
    subsWeek = json['subsWeek'];
    tags = json['tags'];
    total = json['total'];
    valid = json['valid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expertId'] = this.expertId;
    data['info'] = this.info;
    data['logo'] = this.logo;
    data['name'] = this.name;
    data['renew'] = this.renew;
    data['subs'] = this.subs;
    data['subsCnt'] = this.subsCnt;
    data['subsDay'] = this.subsDay;
    data['subsEndTime'] = this.subsEndTime;
    data['subsMonth'] = this.subsMonth;
    data['subsWeek'] = this.subsWeek;
    data['tags'] = this.tags;
    data['total'] = this.total;
    data['valid'] = this.valid;
    return data;
  }
}

class ExpertColumnPageItems {
  List<ExpertIdeaEntity> items;
  int total;
  int page;
  int pageSize;

  ExpertColumnPageItems(this.items, this.total, this.page, this.pageSize);
}

/*
{
			"expertId": "",
			"info": "",
			"logo": "",
			"name": "",
			"renew": "",
			"subs": 0,
			"subsCnt": 0,
			"subsDay": 0,
			"subsEndTime": "",
			"subsMonth": 0,
			"subsWeek": 0,
			"tags": "",
			"total": 0,
			"valid": 0
		}
*/