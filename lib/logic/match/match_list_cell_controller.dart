import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/match/soccer_match_filter_controller.dart';

import '../../http/api.dart';
import '../../model/match/match_entity.dart';
import '../../res/constant.dart';
import '../../util/user.dart';

class MatchListCellController extends GetxController {
  MatchListCellController({this.match});
  final int? match;

  bool _isFollow = false;
  List<DateTime>? _dateList;
  bool _isStarAnimate = false;

  get dateList => _dateList;
  get isFollow => _isFollow;
  get isStarAnimate => _isStarAnimate;

  @override
  void onInit() {
    getFollow();
    super.onInit();
  }

  Future getFollow() async {
    _isFollow = User.isFollow(match!);
    update();
  }

  Future focus() async {
    _isStarAnimate = true;
    if (_isFollow) {
      await User.unFollow(match!);
    } else {
      await User.follow(match!);
    }
    _isFollow = User.isFollow(match!);
    update();
  }
}
