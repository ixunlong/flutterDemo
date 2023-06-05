// enum ConfigType {
//   pushAll,
//   pushNews, //新闻资讯
//   pushExpert, //关注专家提醒
//   pushInNight //夜间免打扰模式
// }

// extension ConfigName on ConfigType {
//   String name() {
//     return ConfigEntity.configName[index];
//   }
// }

class ConfigEntity {
  String? config;
  int? id;
  int? type;
  String? typeName;
  String? userId;
  int? time;

  ConfigEntity(
      {this.config, this.id, this.type, this.typeName, this.userId, this.time});

  ConfigEntity.fromJson(Map<String, dynamic> json) {
    config = json['config'];
    id = json['id'];
    type = json['type'];
    typeName = json['typeName'];
    userId = json['userId'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['config'] = config;
    data['id'] = id;
    data['type'] = type;
    data['typeName'] = typeName;
    data['userId'] = userId;
    data['time'] = time;
    return data;
  }
}
