import 'package:package_info_plus/package_info_plus.dart';
import 'package:sports/http/api.dart';
import 'package:sports/util/utils.dart';

class AppUpdateEntity {
  String? apkUrl;
  int? force;
  String? latestVersion;
  int? needUpdate;
  String? updateDesc;
  String? version;
  bool? ignore;

  AppUpdateEntity(
      {this.apkUrl,
      this.force,
      this.latestVersion,
      this.needUpdate,
      this.updateDesc,
      this.version,
      this.ignore});

  AppUpdateEntity.fromJson(Map<String, dynamic> json) {
    apkUrl = json['apkUrl'];
    force = json['force'];
    latestVersion = json['latestVersion'];
    needUpdate = json['needUpdate'];
    updateDesc = json['updateDesc'];
    version = json['version'];
    ignore = json['ignore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['apkUrl'] = this.apkUrl;
    data['force'] = this.force;
    data['latestVersion'] = this.latestVersion;
    data['needUpdate'] = this.needUpdate;
    data['updateDesc'] = this.updateDesc;
    data['version'] = this.version;
    data['ignore'] = this.ignore;
    return data;
  }
}

extension AppUpdateEntityEx1 on AppUpdateEntity {
  bool get getForce => (force ?? 0) > 0;
  bool get getNeedUpdate => (needUpdate ?? 0) > 0;
  bool get getIgnore => ignore ?? false;

  // static Future<AppUpdateEntity?> requestUpdateInfo() async {
  //   final info = await PackageInfo.fromPlatform();
  //   return await Utils.tryOrNullf(() async {
  //     final r = await Api.checkUpdate(info.version);
  //     return AppUpdateEntity.fromJson(r.data['d']);
  //   });
  // }
}
