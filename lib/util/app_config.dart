import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:yaml/yaml.dart';

class AppConfig {
  static AppConfig? _config;

  static AppConfig get config => _config!;

  static configfromfile() async {
    final content = await rootBundle.loadString("assets/files/config.yaml");
    YamlMap json = loadYaml(content)['config'];
    _config = AppConfig.fromJson(json.cast());
  }

  static Future<AppConfig> readfromfile() async {
    if (_config == null) {
      await configfromfile();
    }
    return _config!;
  }

  String? channel;
  late bool isDebug;

  AppConfig.fromJson(Json json) {
    channel = json['channel'];
    isDebug = json['isDebug'] ?? false;
  }
}
