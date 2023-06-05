class BbInfoEntity {
  String? guestFavourable;
  String? guestInjury;
  String? guestUnFavourable;
  String? homeFavourable;
  String? homeInjury;
  String? homeUnFavourable;
  String? neutrality;

  BbInfoEntity(
      {this.guestFavourable,
        this.guestInjury,
        this.guestUnFavourable,
        this.homeFavourable,
        this.homeInjury,
        this.homeUnFavourable,
        this.neutrality});

  BbInfoEntity.fromJson(Map<String, dynamic> json) {
    guestFavourable = json['guestFavourable'];
    guestInjury = json['guestInjury'];
    guestUnFavourable = json['guestUnFavourable'];
    homeFavourable = json['homeFavourable'];
    homeInjury = json['homeInjury'];
    homeUnFavourable = json['homeUnFavourable'];
    neutrality = json['neutrality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['guestFavourable'] = this.guestFavourable;
    data['guestInjury'] = this.guestInjury;
    data['guestUnFavourable'] = this.guestUnFavourable;
    data['homeFavourable'] = this.homeFavourable;
    data['homeInjury'] = this.homeInjury;
    data['homeUnFavourable'] = this.homeUnFavourable;
    data['neutrality'] = this.neutrality;
    return data;
  }
}