import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/home/navigation_controller.dart';
import 'package:sports/logic/match/match_page_controller.dart';
import 'package:sports/logic/match/match_result_controller.dart';
import 'package:sports/logic/match/soccer_match_filter_controller.dart';
import 'package:sports/model/match/match_entity.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/util/date_utils_extension.dart';

class MatchResultListController extends GetxController
    implements MatchListProvider {
  MatchResultListController(this.date);

  List<MatchEntity> originalData = [];
  DateTime date;
  List<MatchEntity> matchList = [];

  final EasyRefreshController refreshController = EasyRefreshController();
  final filter =
      Get.find<SoccerMatchFilterController>(tag: Constant.matchFilterTagResult);
  @override
  QuickFilter quickFilter = QuickFilter.all;
  @override
  bool firstLoad = true;
  int hideMatch = 0;

  @override
  void onReady() {
    super.onReady();
    getMatch();
  }

  @override
  updateView() {
    update();
  }

  @override
  Future getMatch() async {
    List<MatchEntity>? result = await Api.getMatchResultList(
        DateUtilsExtension.formatDateTime(date, 'yyyy-MM-dd'));
    if (result != null) {
      originalData = result;
      // matchList = result;
      if (firstLoad) {
        filter.initLeague(MatchType.end);
      }
      filterMatch(filter.getHideLeagueIdList());
      firstLoad = false;
    }

    update();
    // Future.delayed(
    //     Duration(seconds: 1), Get.find<NavigationController>().stopVGA);
  }

  void filterMatch(List<int> hideLeagueId) {
    List<MatchEntity> matchListTemp = [];
    final c = Get.find<MatchResultController>();
    QuickFilter quickFilter = c.quickFilter;
    hideMatch = 0;
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
        if (filter.leagueType == LeagueType.jz && match.jcMatchNo != null) {
          matchListTemp.add(match);
        } else if (filter.leagueType == LeagueType.dc &&
            match.dcMatchNo != null) {
          matchListTemp.add(match);
        } else if (filter.leagueType == LeagueType.ssc &&
            match.sfcMatchNo != null) {
          matchListTemp.add(match);
        } else if (filter.leagueType == LeagueType.all) {
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
    // update();
    // firstLoad = false;
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
    String name = '';
    if (filter.leagueType == LeagueType.jz) {
      name = match.jcMatchNo ?? '';
    } else if (filter.leagueType == LeagueType.dc) {
      name = match.dcMatchNo ?? '';
    } else if (filter.leagueType == LeagueType.ssc) {
      name = match.sfcMatchNo ?? '';
    } else {
      name = ((match.jcMatchNo ?? match.dcMatchNo) ?? match.sfcMatchNo) ?? '';
    }
    return name;
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
