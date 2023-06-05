import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/mine/coin_history_entity.dart';

class CoinHistoryController extends GetxController {
  List<DateTime>? dateList;
  List<List<CoinHistoryEntity>>? groupCoinList;
  int page = 1;
  int pageSize = 10;
  bool isLoading = true;
  List<CoinHistoryEntity>? list;

  CoinHistoryController();

  @override
  void onReady() {
    super.onReady();
    getData();
  }

  getData() async {
    page = 1;
    final data = await Api.goldHistoryList(page, pageSize);
    if (data != null) {
      list = data;
      handleData(list!);
    }
  }

  Future<List<CoinHistoryEntity>?> getMore() async {
    page++;
    final data = await Api.goldHistoryList(page, pageSize);
    if (data != null) {
      list!.addAll(data);
      handleData(list!);
      // update();
    }
    return data;
  }

  void handleData(List<CoinHistoryEntity> matchList) async {
    List<DateTime> dateListTemp = [];
    List<List<CoinHistoryEntity>> groupListTemp = [];
    List<CoinHistoryEntity> sameMonthCoinList = [];
    for (CoinHistoryEntity match in matchList) {
      final dateTime = DateTime.parse(match.createTime!).toLocal();
      if (dateListTemp.isEmpty) {
        dateListTemp.add(dateTime);
        sameMonthCoinList.add(match);
      } else if (DateUtils.isSameMonth(dateListTemp.last, dateTime)) {
        sameMonthCoinList.add(match);
      } else {
        groupListTemp.add(sameMonthCoinList);
        dateListTemp.add(dateTime);
        sameMonthCoinList = [match];
      }
    }
    //加上最后一个月比赛
    if (sameMonthCoinList.isNotEmpty) {
      groupListTemp.add(sameMonthCoinList);
    }

    dateList = dateListTemp;
    groupCoinList = groupListTemp;
    isLoading = false;
    update();
  }
}
