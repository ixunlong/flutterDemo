class ExpertIdeaListEntity {
  ExpertIdeaListRows? daily;
  List<ExpertIdeaListRows>? rows;
  ExpertIdeaListRows? sum;
  int? total;

  ExpertIdeaListEntity({this.daily, this.rows, this.sum, this.total});

  ExpertIdeaListEntity.fromJson(Map<String, dynamic> json) {
    daily = json['daily'] != null
        ? ExpertIdeaListRows.fromJson(json['daily'])
        : null;
    if (json['rows'] != null) {
      rows = <ExpertIdeaListRows>[];
      for (var v in (json['rows'] as List)) {
        rows?.add(ExpertIdeaListRows.fromJson(v));
      }
    }
    sum = json['sum'] != null ? ExpertIdeaListRows.fromJson(json['sum']) : null;
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    final daily = this.daily;
    if (daily != null) {
      data['daily'] = daily.toJson();
    }
    final rows = this.rows;
    if (rows != null) {
      data['rows'] = rows.map((v) => v.toJson()).toList();
    }
    final sum = this.sum;
    if (sum != null) {
      data['sum'] = sum.toJson();
    }
    data['total'] = total;
    return data;
  }
}

class ExpertIdeaListRows {
  String? endTime;
  String? expertId;
  int? id;
  String? img;
  int? imgType;
  String? publishTime;
  String? summary;
  String? title;
  int? uv;

  ExpertIdeaListRows(
      {this.endTime,
      this.expertId,
      this.id,
      this.img,
      this.imgType,
      this.publishTime,
      this.summary,
      this.title,
      this.uv});

  ExpertIdeaListRows.fromJson(Map<String, dynamic> json) {
    endTime = json['endTime'];
    expertId = json['expertId'];
    id = json['id'];
    img = json['img'];
    imgType = json['imgType'];
    publishTime = json['publishTime'];
    summary = json['summary'];
    title = json['title'];
    uv = json['uv'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['endTime'] = endTime;
    data['expertId'] = expertId;
    data['id'] = id;
    data['img'] = img;
    data['imgType'] = imgType;
    data['publishTime'] = publishTime;
    data['summary'] = summary;
    data['title'] = title;
    data['uv'] = uv;
    return data;
  }
}

class ExpertIdeaPageItems {
  List<ExpertIdeaListRows>? items;
  int total;
  int page;
  int pageSize;

  ExpertIdeaPageItems(this.items, this.total, this.page, this.pageSize);
}

/*
{
		"daily": {
			"endTime": "",
			"expertId": "",
			"id": 0,
			"img": "",
			"imgType": 0,
			"publishTime": "",
			"summary": "",
			"title": "",
			"uv": 0
		},
		"rows": [
			{
				"endTime": "",
				"expertId": "",
				"id": 0,
				"img": "",
				"imgType": 0,
				"publishTime": "",
				"summary": "",
				"title": "",
				"uv": 0
			}
		],
		"sum": {
			"endTime": "",
			"expertId": "",
			"id": 0,
			"img": "",
			"imgType": 0,
			"publishTime": "",
			"summary": "",
			"title": "",
			"uv": 0
		},
		"total": 0
}
*/