import 'dart:async';

import 'package:dio/dio.dart';
import 'package:sports/http/dio_utils.dart';
import 'package:sports/model/mine/mine_interact_entity.dart';
import 'package:sports/model/mine/mine_msg_entity.dart';

typedef FResponse = Future<Response<dynamic>>;

class MineApi {

  static FResponse _getMineMsg({int page = 1,int pageSize = 20}) => DioUtils.post("/info/info-user-letter-do/list",params: {
    'page':page,'pageSize':pageSize, 'data': {}
  });

  static FResponse _readMineMsg(int id,{bool all = false}) => DioUtils.post("/info/info-user-letter-do/add",params: {
    'id':all ? -1 : id
  });

  static FResponse _getMineInteract({int page = 1,int size = 20}) => DioUtils.post("/info/info-user-interaction-do/list",params: {
    'page':page,'pageSize':size, 'data': {}
  });

  static FResponse _readMineInteract(int id,{bool all = false}) => DioUtils.post("/info/info-user-interaction-do/add",params: {
    'id':all ? -1 : id
  });

  static Future<List<MineMsgEntity>?> getMsg({int page = 1,int size = 20}) async {
    try {
      final r = await _getMineMsg(page: page,pageSize: size);
      List rows = r.data['d']['rows'];
      return rows.map((e) => MineMsgEntity.fromJson(e)).toList();
    } catch (err) {}
    return null;
  }

  static Future<bool?> readMsg(int id,{bool all = false}) async {
    try {
      final r = await _readMineMsg(id,all: all);
      return r.data['c'] == 200;
    } catch (e) {}
    return null;
  }

  static Future<List<MineInteractEntity>?> getInteract({int page = 1, int size = 20}) async {
    try {
      final r = await _getMineInteract(page: page,size: size);
      List rows = r.data['d']['rows'];
      return rows.map((e) => MineInteractEntity.fromJson(e)).toList();
    } catch (err) {}
    return null;
  }

  static Future<bool?> readInteract(int id,{bool all = false}) async {
    try {
      final r = await _readMineInteract(id,all: all);
      return r.data['c'] == 200;
    } catch (e) {}
    return null;
  }

  static Future<int?> getMsgUnreadCount() async {
    try {
      final r = await DioUtils.post("/info/info-user-letter-do/readCount");
      return r.data['d'] as int;
    } catch (e) { }
    return null;
  }

  static Future<int?> getInterUnreadCount() async {
    try {
      final r = await DioUtils.post("/info/info-user-interaction-do/readCount");
      return r.data['d'] as int;
    } catch (e) { }
    return null;
  }

}