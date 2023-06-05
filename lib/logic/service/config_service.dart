import 'dart:developer';

import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/http/request_interceptor.dart';
import 'package:sports/model/config_entity.dart';
import 'package:sports/model/odds_company_entity.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/util/user.dart';

class ConfigService extends GetxService {
  late SoccerConfig soccerConfig;
  late BasketConfig basketConfig;
  late PushConfig pushConfig;
  int configTime = 0;
  String userId = '';
  int userType = 1; //0 userId, 1 uuid

  bool tipEnable = true;

  List<String> soccerOddsType = ['欧指', '亚指', '进球数'];
  List<String> basketOddsType = ['胜负', '让分胜负', '大小分'];
  List<OddsCompanyEntity> oddsCompany = [];
  // List<String> oddsCompany = ['澳门', '皇冠', '易胜博', '韦德', '立博', 'Bet365'];
  List<String> sounds = ['哨子', '口哨', '鼓声', '号角', '胜利'];
  List soccerSound = ['shaozi', 'koushao', 'gusheng', 'haojiao', 'shengli'];
  Future<ConfigService> init() async {
    return this;
  }

  @override
  void onReady() async {
    getCompany();

    super.onReady();
  }

  getCompany() async {
    try {
      List<OddsCompanyEntity>? company = await Api.getOddsCompany();
      oddsCompany = company ?? [];
    } catch (e) {}
  }

  loadConfig() async {
    if (oddsCompany.isEmpty) {
      await getCompany();
    }
    if (User.auth != null) {
      userType = 0;
      userId = User.auth!.userId ?? '';
    }
    if (configTime == 0) {
      soccerConfig = SpUtils.soccerConfig ?? SoccerConfig();
      basketConfig = SpUtils.basketConfig ?? BasketConfig();
      pushConfig = SpUtils.pushConfig ?? PushConfig();
      configTime = SpUtils.configTime ?? 0;
    }

    if (User.auth != null) {
      List<ConfigEntity>? config = await Api.getConfigList([]);
      if (config != null) {
        Map<int, String> json = {};
        int updateTime = 0;
        for (var element in config) {
          json[element.type!] = element.config!;
          if (element.time! > updateTime) {
            updateTime = element.time!;
          }
        }
        if (updateTime > configTime) {
          soccerConfig = SoccerConfig.fromJson(json);
          basketConfig = BasketConfig.fromJson(json);
          pushConfig = PushConfig.fromJson(json);
          configTime = updateTime;
        } else if (updateTime < configTime || updateTime == 0) {
          updateAll();
        }
      }
    }
  }

  saveConfig() {
    try {
      SpUtils.soccerConfig = soccerConfig;
      SpUtils.basketConfig = basketConfig;
      SpUtils.pushConfig = pushConfig;
      SpUtils.configTime = configTime;
    } catch (e) {
      log('$e');
    }
  }

  //同步本地配置到服务器
  updateAll() {
    Map<int, String> json = soccerConfig.toJson();
    json.addAll(basketConfig.toJson());
    json.addAll(pushConfig.toJson());
    List<ConfigEntity> list = [];
    for (var element in json.keys) {
      // String value = '';
      // if (json[element] is int) {
      //   value = json[element].toString();
      // } else if (json[element] is List) {
      //   value = (json[element] as List).join(',');
      // }
      list.add(
          ConfigEntity(config: json[element], type: element, typeName: ''));
    }
    Api.setConfigList(list, userId, userType);
  }

  update(int id, dynamic data) {
    if (userId.isEmpty) {
      userId = HeaderDeviceInfo.uuid;
    }
    String config = '';
    if (data is List) {
      config = data.join(',');
    } else if (data is int) {
      config = data.toString();
    }
    ConfigEntity entity = ConfigEntity(type: id, config: config, typeName: '');
    if (data is ConfigEntity) {
      entity = data;
    }
    configTime = DateTime.now().millisecondsSinceEpoch;
    log('${DateTime.now().millisecondsSinceEpoch}');
    Api.setConfigList([entity], userId, userType);
  }

  logout() {
    userId = HeaderDeviceInfo.uuid;
    userType = 1;
  }
}

//全局设置类
class PushConfig with Convert {
  int pushAll = 1;
  int pushNews = 1; //新闻资讯
  int pushExpert = 1; //关注专家提醒
  int pushInNight = 1; //夜间免打扰模式
  int bottomVibration = 1; //底部导航栏震动

  PushConfig();

  PushConfig.fromJson(Map<int, String> data) {
    Map<int, dynamic> json = convertJson(data);
    if (json[ConfigType.pushAll] != null) {
      pushAll = json[ConfigType.pushAll];
    }
    if (json[ConfigType.pushNews] != null) {
      pushNews = json[ConfigType.pushNews];
    }
    if (json[ConfigType.pushExpert] != null) {
      pushExpert = json[ConfigType.pushExpert];
    }
    if (json[ConfigType.pushInNight] != null) {
      pushInNight = json[ConfigType.pushInNight];
    }
    if (json[ConfigType.bottomVibration] != null) {
      bottomVibration = json[ConfigType.bottomVibration];
    }
  }

  Map<int, String> toJson() {
    final Map<int, dynamic> data = new Map<int, dynamic>();
    data[ConfigType.pushAll] = pushAll;
    data[ConfigType.pushNews] = pushNews;
    data[ConfigType.pushExpert] = pushExpert;
    data[ConfigType.pushInNight] = pushInNight;
    data[ConfigType.bottomVibration] = bottomVibration;
    Map<int, String> json = Map<int, String>();
    for (var key in data.keys) {
      if (data[key] is int) {
        json[key] = data[key].toString();
      } else if (data[key] is String) {
        json[key] = data[key];
      }
    }
    return json;
  }

  Map<String, dynamic> toStringJson() {
    Map<int, dynamic> data = toJson();
    Map<String, dynamic> json = {};
    for (var element in data.keys) {
      json[element.toString()] = data[element];
    }
    return json;
  }
}

class SoccerConfig with Convert {
  int soccerInAppAlert1 = 1; //提醒范围
  List soccerInAppAlert2 = [0]; //进球提示
  int soccerInAppAlert3 = 4; //主队进球声音
  int soccerInAppAlert4 = 3; //客队进球声音
  List soccerInAppAlert5 = [0]; //红牌提示
  int soccerInAppAlert6 = 1; //弹窗范围
  int soccerInAppAlert7 = 1; //共享筛选

  int pushSoccer1 = 1; //关注
  int pushSoccer2 = 1; //首发阵容
  int pushSoccer3 = 1; //开赛
  int pushSoccer4 = 1; //赛果
  int pushSoccer5 = 1; //进球
  int pushSoccer6 = 1; //红牌
  int pushSoccer7 = 0; //黄牌
  int pushSoccer8 = 0; //角球

  //列表数据
  int soccerList1 = 1; //指数
  int soccerList2 = 1; //球队排名
  int soccerList3 = 1; //彩种编号
  int soccerList4 = 1; //观点
  int soccerList5 = 1; //红黄牌
  int soccerList6 = 1; //角球
  List soccerList7 = [0, 1, 2]; //指数类型
  int soccerList8 = Get.find<ConfigService>().oddsCompany.isEmpty
      ? 1
      : Get.find<ConfigService>()
              .oddsCompany
              .firstWhere((element) => element.d == 1)
              .id ??
          1; //指数公司
  int soccerList9 = 1; //指数显示

  SoccerConfig();

  SoccerConfig.fromJson(Map<int, String> data) {
    Map<int, dynamic> json = convertJson(data);

    if (json[ConfigType.soccerInAppAlert1] != null) {
      soccerInAppAlert1 = json[ConfigType.soccerInAppAlert1];
    }
    if (json[ConfigType.soccerInAppAlert2] != null) {
      soccerInAppAlert2 = json[ConfigType.soccerInAppAlert2];
    }
    if (json[ConfigType.soccerInAppAlert3] != null) {
      soccerInAppAlert3 = json[ConfigType.soccerInAppAlert3];
    }
    if (json[ConfigType.soccerInAppAlert4] != null) {
      soccerInAppAlert4 = json[ConfigType.soccerInAppAlert4];
    }
    if (json[ConfigType.soccerInAppAlert5] != null) {
      soccerInAppAlert5 = json[ConfigType.soccerInAppAlert5];
    }
    if (json[ConfigType.soccerInAppAlert6] != null) {
      soccerInAppAlert6 = json[ConfigType.soccerInAppAlert6];
    }
    if (json[ConfigType.soccerInAppAlert7] != null) {
      soccerInAppAlert7 = json[ConfigType.soccerInAppAlert7];
    }
    if (json[ConfigType.pushSoccer1] != null) {
      pushSoccer1 = json[ConfigType.pushSoccer1];
    }
    if (json[ConfigType.pushSoccer2] != null) {
      pushSoccer2 = json[ConfigType.pushSoccer2];
    }
    if (json[ConfigType.pushSoccer3] != null) {
      pushSoccer3 = json[ConfigType.pushSoccer3];
    }
    if (json[ConfigType.pushSoccer4] != null) {
      pushSoccer4 = json[ConfigType.pushSoccer4];
    }
    if (json[ConfigType.pushSoccer5] != null) {
      pushSoccer5 = json[ConfigType.pushSoccer5];
    }
    if (json[ConfigType.pushSoccer6] != null) {
      pushSoccer6 = json[ConfigType.pushSoccer6];
    }
    if (json[ConfigType.pushSoccer7] != null) {
      pushSoccer7 = json[ConfigType.pushSoccer7];
    }
    if (json[ConfigType.pushSoccer8] != null) {
      pushSoccer8 = json[ConfigType.pushSoccer8];
    }
    if (json[ConfigType.soccerList1] != null) {
      soccerList1 = json[ConfigType.soccerList1];
    }
    if (json[ConfigType.soccerList2] != null) {
      soccerList2 = json[ConfigType.soccerList2];
    }
    if (json[ConfigType.soccerList3] != null) {
      soccerList3 = json[ConfigType.soccerList3];
    }
    if (json[ConfigType.soccerList4] != null) {
      soccerList4 = json[ConfigType.soccerList4];
    }
    if (json[ConfigType.soccerList5] != null) {
      soccerList5 = json[ConfigType.soccerList5];
    }
    if (json[ConfigType.soccerList6] != null) {
      soccerList6 = json[ConfigType.soccerList6];
    }
    if (json[ConfigType.soccerList7] != null) {
      soccerInAppAlert2 = json[ConfigType.soccerInAppAlert2];
      // String str = json[ConfigType.soccerList7];
      // if (str.isEmpty) {
      //   soccerList7 = [];
      // } else {
      //   soccerList7 = str.split(',').map((e) => int.parse(e)).toList();
      // }
    }
    if (json[ConfigType.soccerList8] != null) {
      soccerList8 = json[ConfigType.soccerList8];
    }
    if (json[ConfigType.soccerList9] != null) {
      soccerList9 = json[ConfigType.soccerList9];
    }
  }

  Map<int, String> toJson() {
    final Map<int, dynamic> data = new Map<int, dynamic>();
    data[ConfigType.soccerInAppAlert1] = soccerInAppAlert1;
    data[ConfigType.soccerInAppAlert2] = soccerInAppAlert2.join(',');
    data[ConfigType.soccerInAppAlert3] = soccerInAppAlert3;
    data[ConfigType.soccerInAppAlert4] = soccerInAppAlert4;
    data[ConfigType.soccerInAppAlert5] = soccerInAppAlert5.join(',');
    data[ConfigType.soccerInAppAlert6] = soccerInAppAlert6;
    data[ConfigType.soccerInAppAlert7] = soccerInAppAlert7;
    data[ConfigType.pushSoccer1] = pushSoccer1;
    data[ConfigType.pushSoccer2] = pushSoccer2;
    data[ConfigType.pushSoccer3] = pushSoccer3;
    data[ConfigType.pushSoccer4] = pushSoccer4;
    data[ConfigType.pushSoccer5] = pushSoccer5;
    data[ConfigType.pushSoccer6] = pushSoccer6;
    data[ConfigType.pushSoccer7] = pushSoccer7;
    data[ConfigType.pushSoccer8] = pushSoccer8;
    data[ConfigType.soccerList1] = soccerList1;
    data[ConfigType.soccerList2] = soccerList2;
    data[ConfigType.soccerList3] = soccerList3;
    data[ConfigType.soccerList4] = soccerList4;
    data[ConfigType.soccerList5] = soccerList5;
    data[ConfigType.soccerList6] = soccerList6;
    data[ConfigType.soccerList7] = soccerList7.join(',');
    data[ConfigType.soccerList8] = soccerList8;
    data[ConfigType.soccerList9] = soccerList9;
    Map<int, String> json = Map<int, String>();
    for (var key in data.keys) {
      if (data[key] is int) {
        json[key] = data[key].toString();
      } else if (data[key] is String) {
        json[key] = data[key];
      }
    }
    return json;
  }

  Map<String, String> toStringJson() {
    Map<int, String> data = toJson();
    Map<String, String> json = {};
    for (var element in data.keys) {
      json[element.toString()] = data[element] ?? '';
    }
    return json;
  }

  String getPushConfigCount() {
    int count = 0;
    if (pushSoccer2 == 1) {
      count++;
    }
    if (pushSoccer3 == 1) {
      count++;
    }
    if (pushSoccer4 == 1) {
      count++;
    }
    if (pushSoccer5 == 1) {
      count++;
    }
    if (pushSoccer6 == 1) {
      count++;
    }
    if (pushSoccer7 == 1) {
      count++;
    }
    if (pushSoccer8 == 1) {
      count++;
    }
    return '$count/7';
  }
}

class BasketConfig with Convert {
  //篮球推送
  int pushBasket1 = 1; //关注
  int pushBasket2 = 1; //开赛
  int pushBasket3 = 1; //赛果

  //应用内提醒
  int basketInAppAlert1 = 1; //提醒范围
  List basketInAppAlert2 = [0]; //进球提示
  int basketInAppAlert3 = 1; //弹窗范围
  int basketInAppAlert4 = 1; //共享筛选

  //列表数据
  int basketList1 = 1; //指数
  int basketList2 = 1; //球队排名
  int basketList3 = 1; //彩种编号
  List basketList7 = [0, 1, 2]; //指数类型
  int basketList8 = Get.find<ConfigService>().oddsCompany.isEmpty
      ? 1
      : Get.find<ConfigService>()
              .oddsCompany
              .firstWhere((element) => element.d == 1)
              .id ??
          1; //指数公司
  int basketList9 = 1; //指数显示

  BasketConfig();

  BasketConfig.fromJson(Map<int, String> data) {
    Map<int, dynamic> json = convertJson(data);
    if (json[ConfigType.basketInAppAlert1] != null) {
      basketInAppAlert1 = json[ConfigType.basketInAppAlert1];
    }
    if (json[ConfigType.basketInAppAlert2] != null) {
      basketInAppAlert2 = json[ConfigType.basketInAppAlert2];
    }
    if (json[ConfigType.basketInAppAlert3] != null) {
      basketInAppAlert3 = json[ConfigType.basketInAppAlert3];
    }
    if (json[ConfigType.basketInAppAlert4] != null) {
      basketInAppAlert4 = json[ConfigType.basketInAppAlert4];
    }
    if (json[ConfigType.pushBasket1] != null) {
      pushBasket1 = json[ConfigType.pushBasket1];
    }
    if (json[ConfigType.pushBasket2] != null) {
      pushBasket2 = json[ConfigType.pushBasket2];
    }
    if (json[ConfigType.pushBasket3] != null) {
      pushBasket3 = json[ConfigType.pushBasket3];
    }
    if (json[ConfigType.basketList1] != null) {
      basketList1 = json[ConfigType.basketList1];
    }
    if (json[ConfigType.basketList2] != null) {
      basketList2 = json[ConfigType.basketList2];
    }
    if (json[ConfigType.basketList3] != null) {
      basketList3 = json[ConfigType.basketList3];
    }
    if (json[ConfigType.basketList7] != null) {
      basketList7 = json[ConfigType.basketList7];
    }
    if (json[ConfigType.basketList8] != null) {
      basketList8 = json[ConfigType.basketList8];
    }
    if (json[ConfigType.basketList9] != null) {
      basketList9 = json[ConfigType.basketList9];
    }
  }

  Map<int, String> toJson() {
    final Map<int, dynamic> data = new Map<int, dynamic>();
    data[ConfigType.basketInAppAlert1] = basketInAppAlert1;
    data[ConfigType.basketInAppAlert2] = basketInAppAlert2.join(',');
    data[ConfigType.basketInAppAlert3] = basketInAppAlert3;
    data[ConfigType.basketInAppAlert4] = basketInAppAlert4;
    data[ConfigType.pushBasket1] = pushBasket1;
    data[ConfigType.pushBasket2] = pushBasket2;
    data[ConfigType.pushBasket3] = pushBasket3;
    data[ConfigType.basketList1] = basketList1;
    data[ConfigType.basketList2] = basketList2;
    data[ConfigType.basketList3] = basketList3;
    data[ConfigType.basketList7] = basketList7.join(',');
    data[ConfigType.basketList8] = basketList8;
    data[ConfigType.basketList9] = basketList9;
    Map<int, String> json = Map<int, String>();
    for (var key in data.keys) {
      if (data[key] is int) {
        json[key] = data[key].toString();
      } else if (data[key] is String) {
        json[key] = data[key];
      }
    }
    return json;
  }

  Map<String, dynamic> toStringJson() {
    Map<int, dynamic> data = toJson();
    Map<String, dynamic> json = {};
    for (var element in data.keys) {
      json[element.toString()] = data[element];
    }
    return json;
  }

  String getPushConfigCount() {
    int count = 0;
    if (pushBasket2 == 1) {
      count++;
    }
    if (pushBasket3 == 1) {
      count++;
    }
    return '$count/2';
  }
}

class ConfigType {
  static int pushAll = 0;
  static int pushNews = 1; //新闻资讯
  static int pushExpert = 2; //关注专家提醒
  static int pushInNight = 3; //夜间免打扰模式
  static int bottomVibration = 101; //底部导航栏震动

  //足球推送
  static int pushSoccer1 = 1001; //关注
  static int pushSoccer2 = 1002; //首发阵容
  static int pushSoccer3 = 1003; //开赛
  static int pushSoccer4 = 1004; //赛果
  static int pushSoccer5 = 1005; //进球
  static int pushSoccer6 = 1006; //红牌
  static int pushSoccer7 = 1007; //黄牌
  static int pushSoccer8 = 1008; //角球

  //应用内提醒
  static int soccerInAppAlert1 = 1101; //提醒范围
  static int soccerInAppAlert2 = 1102; //进球提示
  static int soccerInAppAlert3 = 1103; //主队进球声音
  static int soccerInAppAlert4 = 1104; //客队进球声音
  static int soccerInAppAlert5 = 1105; //红牌提示
  static int soccerInAppAlert6 = 1106; //弹窗范围
  static int soccerInAppAlert7 = 1107; //共享筛选

  //列表数据
  static int soccerList1 = 1201; //指数
  static int soccerList2 = 1202; //球队排名
  static int soccerList3 = 1203; //彩种编号
  static int soccerList4 = 1204; //观点
  static int soccerList5 = 1205; //红黄牌
  static int soccerList6 = 1206; //角球
  static int soccerList7 = 1207; //指数类型
  static int soccerList8 = 1208; //指数公司
  static int soccerList9 = 1209; //指数显示

  //篮球推送
  static int pushBasket1 = 2001; //关注
  static int pushBasket2 = 2002; //开赛
  static int pushBasket3 = 2003; //赛果

  //应用内提醒
  static int basketInAppAlert1 = 2101; //提醒范围
  static int basketInAppAlert2 = 2102; //进球提示
  static int basketInAppAlert3 = 2103; //弹窗范围
  static int basketInAppAlert4 = 2104; //共享筛选

  //列表数据
  static int basketList1 = 2201; //指数
  static int basketList2 = 2202; //球队排名
  static int basketList3 = 2203; //彩种编号
  static int basketList7 = 2207; //指数类型
  static int basketList8 = 2208; //指数公司
  static int basketList9 = 2209; //指数显示
}

mixin Convert {
  Map<int, dynamic> convertJson(Map<int, String> data) {
    Map<int, dynamic> json = {};
    for (var element in data.keys) {
      if (element == ConfigType.soccerInAppAlert2 ||
          element == ConfigType.soccerInAppAlert5 ||
          element == ConfigType.soccerList7 ||
          element == ConfigType.basketInAppAlert2 ||
          element == ConfigType.basketList7) {
        if (data[element]!.isEmpty) {
          json[element] = [];
        } else {
          json[element] =
              data[element]!.split(',').map((e) => int.parse(e)).toList();
        }
      } else {
        json[element] = int.parse(data[element]!);
      }
    }
    return json;
  }
}
