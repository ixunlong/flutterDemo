import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/util/user.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// enum WsState { noinit, connected, connecting, error, disconnected }

typedef WsEvent = Map<String,dynamic>;

class _WsHandle {
  _WsHandle(this.url, {required this.handler});

  static const retryMax = 3;
  int retry = 0;

  final String url;

  void Function(dynamic) handler;

  IOWebSocketChannel? _channel;
  bool connected = true;

  connect() {
    _channel = IOWebSocketChannel.connect(url,
      headers: {
        "uuid":SpUtils.appUuid,
        "version":"1.0"
      },pingInterval: const Duration(seconds: 30));
    connected = true;
    log("ws connect to $url");
    _channel?.stream.listen((event) {
      log("ws receive event ${event}");
      handler(event);
    }, onDone: () {
      if (!connected) {
        return;
      }
      if (retry++ < retryMax) {
        log("ws retry connect $retry");
        connect();
      } else {
        close();
      }
    });
  }

  send(String msg) {
    log("ws send masg _channel ${_channel} msg = ${msg}");
    _channel?.sink.add(msg);
  }

  void close() {
    log("websocket close $url");
    _channel?.sink.close();
    connected = false;
    _channel = null;
  }
}

enum WsMatchType { textLive, event }

class WsConnection {
  static _WsHandle? _handler;

  static get connected => _handler?.connected ?? false;

  static Map<int, StreamController> _livesMap = {};
  static Map<int, StreamController> _eventsMap = {};

  static Stream _makeStream(
      WsMatchType type, int id, Map<int, StreamController> map) {
    reconnect();
    if (map[id] != null) {
      return map[id]!.stream;
    }
    final controller = StreamController.broadcast(
      onCancel: () {
        log("stream controller on cancel");
        final msg = makeWsMessage(type, false, id);
        // _handler?.send(msg);
        map.remove(id)?.close();
      },
    );
    final sc = map.remove(id);
    if (sc == null) {
      final msg = makeWsMessage(type, true, id);
      // _handler?.send(msg);
      map[id] = controller;
    } else {
      sc.close().then((value) {
        // final msg = makeWsMessage(type, true, id);
        // _handler?.send(msg);
        map[id] = controller;
      });
    }
    return controller.stream;
  }

// {eventType:1,timestamp:10000000,params:{qxbMatchId:7103}} 绑定直播
// {eventType:2,timestamp:10000000,params:{id:7103}}  解绑直播
// {eventType:3,timestamp:10000000,params:{qxbMatchId:7103}} 绑定比赛事件
// {eventType:4,timestamp:10000000,params:{id:7103}} 解绑比赛事件

  static String makeWsMessage(WsMatchType type, bool sub, int id) {
    final params = sub ? {"qxbMatchId": id} : {"id": id};
    int tnum = 1;
    if (type == WsMatchType.textLive) {
      tnum = sub ? 1 : 2;
    } else if (type == WsMatchType.event) {
      tnum = sub ? 3 : 4;
    }
    return jsonEncode({
      "eventType": tnum,
      "timestamp": DateTime.now().millisecondsSinceEpoch ~/ 1000,
      "params": params
    });
  }

  static Stream liveStream(int id) =>
      _makeStream(WsMatchType.textLive, id, _livesMap);

  static Stream eventStream(int id) =>
      _makeStream(WsMatchType.event, id, _eventsMap);

  static StreamSubscription? _sub;

  static StreamController<WsEvent> _all = StreamController.broadcast();
  static Stream<WsEvent> get all => _all.stream;

  static init() async {
    _sub?.cancel;
    reconnect();
    _sub = Connectivity().onConnectivityChanged.listen((event) {
      reconnect();
    });
  }
  
  static get getUrl => () {
    final host = Uri.parse(SpUtils.baseUrl).host;
    final isProduction = host == 'api.qiuxiangbiao.com';
    return "ws://$host${isProduction ? '' : ':8001'}/websocket?userId=${User.auth?.userId ?? ""}";
  }.call();

  static needReconnect() {
    if (!connected) {
      return true;
    }
    if (getUrl != _handler?.url) {
      return true;
    }
    return false;
  }

  static _doReMsgChannel() {
    for (var id in _livesMap.keys) {
      final msg = makeWsMessage(WsMatchType.textLive, true, id);
      _handler?.send(msg);
    }
    for (var id in _eventsMap.keys) {
      final msg = makeWsMessage(WsMatchType.event, true, id);
      _handler?.send(msg);
    }
  }

  static reconnect({bool force = false}) {
    if (needReconnect()) {
    } else if (force) {
    } else { return; }
    
    final url = getUrl;
    _handler?.close();
    _handler = _WsHandle(url, handler: _doHandle)..connect();
    Future.delayed(const Duration(milliseconds: 100))
        .then((value) => _doReMsgChannel());
  }

  static void _doHandle(dynamic event) {
    try {
      final map = jsonDecode(event) as Map<String, dynamic>;
      // final type = map['eventType'] as int;
      _all.add(map);
    } catch (err) {}
  }
}
