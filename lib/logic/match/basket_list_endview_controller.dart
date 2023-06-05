import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/match/basket_list_end_controller.dart';
import 'package:sports/logic/match/basket_match_filter_controller.dart';
import 'package:sports/logic/match/match_page_controller.dart';
import 'package:sports/model/match/basket_list_entity.dart';
import 'package:sports/model/match/match_entity.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/util/date_utils_extension.dart';
import 'package:sports/util/utils.dart';

class BasketListEndViewController extends GetxController
    implements MatchListProvider {
  BasketListEndViewController(this.date);

  List<BasketListEntity> originalData = [];
  DateTime date;
  List<BasketListEntity> matchList = [];

  final EasyRefreshController refreshController = EasyRefreshController();
  final filter =
      Get.find<BasketMatchFilterController>(tag: Constant.matchFilterTagResult);
  @override
  QuickFilter quickFilter = QuickFilter.all;
  @override
  bool firstLoad = true;
  int hideMatch = 0;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getMatch();
  }

  @override
  updateView() {
    update();
  }

  @override
  Future getMatch() async {
    List<BasketListEntity>? result = await Api.getBasketMatchResultList(
        DateUtilsExtension.formatDateTime(date, 'yyyy-MM-dd'));
    if (result != null) {
      originalData = result;
      // matchList = result;
      if (firstLoad) {
        filter.initLeague(MatchType.end);
        quickFilter = filter.quickFilter;
      }
      filterMatch(filter.getHideLeagueIdList());
      firstLoad = false;
    }

    update();
    // Future.delayed(
    //     Duration(seconds: 1), Get.find<NavigationController>().stopVGA);
  }

  void filterMatch(List<int> hideLeagueId) {
    List<BasketListEntity> matchListTemp = [];
    final c = Get.find<BasketListEndController>();
    QuickFilter quickFilter = c.quickFilter;
    for (var match in originalData) {
      if (quickFilter == QuickFilter.guandian && match.planCnt == 0) {
        hideMatch++;
        continue;
      } else if (quickFilter == QuickFilter.qingbao &&
          match.intelligence == 0) {
        hideMatch++;
        continue;
      }
      if (!hideLeagueId.contains(match.leagueId)) {
        if (filter.leagueType == LeagueType.jc && match.jcNo.valuable == true) {
          matchListTemp.add(match);
        } else if (filter.leagueType == LeagueType.all ||
            filter.leagueType == LeagueType.rm) {
          matchListTemp.add(match);
        }
      }
    }
    matchList = matchListTemp;
    if (quickFilter == QuickFilter.yiji ||
        quickFilter == QuickFilter.jingcai ||
        quickFilter == QuickFilter.all) {
      c.hideMatch = filter.hideMatch;
    } else {
      c.hideMatch = hideMatch;
    }
    c.onShowBottom();
  }

  void resetPage() {
    matchList = originalData;
    update();
  }

  @override
  Future doRefresh() async {
    refreshController.callRefresh();
    update();
  }

  @override
  String getTicketName(MatchEntity match) {
    // TODO: implement getTicketName
    throw UnimplementedError();
  }

  @override
  onSelectMatchType(QuickFilter index) {
    // TODO: implement onSelectMatchType
    throw UnimplementedError();
  }

  // @override
  // bool stopRefresh() {
  //   var time = refreshController.controlFinishRefresh;
  //   update();
  //   return time;
  // }
}
