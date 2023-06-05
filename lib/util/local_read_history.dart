import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:sports/model/home/home_news_entity.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/util/utils.dart';

class ReadInfo {
  ReadInfo(this.id, this.time);
  final String id;
  List<String> time;

  toJson() {
    return {"id": id, "time": time.join(",")};
  }

  static ReadInfo? fromJson(Map<String, dynamic> json) {
    try {
      return ReadInfo(json['id'] ?? "", json['time']?.split(",") ?? []);
    } catch (err) {
      log("read info from json err ${err}");
    }
  }
}

typedef ReadMap = Map<String, ReadInfo?>;

class LocalReadHistory {
  static Map<String, ReadMap?> _readInfos = {};

  static load() {
    if (_readInfos.isEmpty) {
      _loadInfos();
    }
  }

  static save() {
    _saveInfos();
  }

  static _loadInfos() {
    final map = SpUtils.getJson(SpUtils.localReadHistoryKey) ?? {};
    _readInfos = map.map((key, value) {
      if (value is! Map<String, dynamic>) {
        return MapEntry(key, {});
      } else {
        return MapEntry(key, value.map((key, value) {
          return MapEntry(key, ReadInfo.fromJson(value));
        }));
      }
    });
    // for (var element in map.entries) {
    //   final value = element.value;
    //   if (value is! Map<String, dynamic>) {
    //     continue;
    //   }
    //   final map = value as Map<String, dynamic>;
    //   for (var e in map.entries) {
    //     final info = ReadInfo.fromJson(e.value);
    //     // log("info = ${info?.toJson()}");
    //   }
    // }
  }

  static _saveInfos() {
    final now = DateTime.now();
    _readInfos.removeWhere((key, value) => value == null);
    _readInfos.values.forEach((element) {
      element?.removeWhere((key, value) {
        if (value == null || value.time.isEmpty) {
          return true;
        }
        final time = _dateFormater.parse(value.time.first);
        return now.difference(time).inDays > 7;
      });
    });
    final json = _readInfos.map((key, value) => MapEntry(
        key, value?.map((key, value) => MapEntry(key, value?.toJson()))));
    final b = SpUtils.setJson(SpUtils.localReadHistoryKey, json);
    // log("save local read history $b ${json}");
  }

  static const _newsKey = "news";
  static final _dateFormater = DateFormat("yyyy-MM-dd HH:mm:ss");

  static readNews(String id) {
    if (id.isEmpty || id == "${null}") {
      return;
    }
    ReadMap map = _readInfos[_newsKey] ??
        () {
          ReadMap map = {};
          _readInfos[_newsKey] = map;
          return map;
        }.call();
    ReadInfo info = map[id] ??
        () {
          ReadInfo info = ReadInfo(id, []);
          map[id] = info;
          return info;
        }.call();
    info.time.insert(0, _dateFormater.format(DateTime.now()));
  }

  static bool hasReadedNews(String id) {
    return _readInfos[_newsKey]?[id] != null;
  }

  static List<int> readedNews() {
    return (_readInfos[_newsKey]?.keys ?? []).map((e) => int.tryParse(e)).toList().filter((item) => item != null).cast();
  }

  static readArticle() {}

  static bool hasReadArticle() {
    return false;
  }

  static _read(String key,String id) {
    if (id.isEmpty || id == "${null}") {
      return;
    }
    ReadMap map = _readInfos[key] ??
        () {
          ReadMap map = {};
          _readInfos[key] = map;
          return map;
        }.call();
    ReadInfo info = map[id] ??
        () {
          ReadInfo info = ReadInfo(id, []);
          map[id] = info;
          return info;
        }.call();
    info.time.insert(0, _dateFormater.format(DateTime.now()));
  }

  static bool _hasReaded(String key,String id) {
    return _readInfos[key]?[id] != null;
  }

  static const _planKey = "plan";
  static readPlan(String id) {
    _read(_planKey, id);
  }

  static bool hasReadedPlan(String id) {
    return _hasReaded(_planKey, id);
  }

}
