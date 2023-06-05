class ExpertTopEntity {
  String? expertId;
  String? expertLogo;
  String? expertName;
  String? mn;
  String? redKeepHigh;

  ExpertTopEntity(
      {this.expertId,
        this.expertLogo,
        this.expertName,
        this.mn,
        this.redKeepHigh});

  ExpertTopEntity.fromJson(Map<String, dynamic> json) {
    expertId = json['expertId'];
    expertLogo = json['expertLogo'];
    expertName = json['expertName'];
    mn = json['mn'];
    redKeepHigh = json['redKeepHigh'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expertId'] = this.expertId;
    data['expertLogo'] = this.expertLogo;
    data['expertName'] = this.expertName;
    data['mn'] = this.mn;
    data['redKeepHigh'] = this.redKeepHigh;
    return data;
  }
}