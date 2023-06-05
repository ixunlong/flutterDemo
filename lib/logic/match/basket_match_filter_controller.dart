import 'package:azlistview/azlistview.dart';
import 'package:get/get.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:sports/logic/match/basket_list_all_controller.dart';
import 'package:sports/logic/match/basket_list_begin_controller.dart';
import 'package:sports/logic/match/basket_list_end_controller.dart';
import 'package:sports/logic/match/basket_list_endview_controller.dart';
import 'package:sports/logic/match/basket_list_focus_controller.dart';
import 'package:sports/logic/match/basket_list_schedule_controller.dart';
import 'package:sports/logic/match/basket_list_scheduleview_controller.dart';
import 'package:sports/logic/match/match_page_controller.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/logic/service/match_service.dart';
import 'package:sports/model/data/league_list_entity.dart';
import 'package:sports/model/match/basket_list_entity.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/util/utils.dart';

import 'match_interest_controller.dart';

enum MatchType { focus, all, begin, schedule, end }

enum LeagueType { all, rm, jc }

class BasketMatchFilterController extends GetxController {
  //全部数据源
  List<IndexLeagueEntity> indexLeagueEntity = [];
  //全部
  List<LeagueEntity> leagueList = [];
  List<int> hideLeagueId = [];
  List<int> allLeagueId = [];
  //热门
  List<LeagueEntity> rmLeagueList = [];
  List<int> rmLeagueId = [];
  List<int> rmHideLeagueId = [];
  //竞彩
  List<LeagueEntity> jcLeagueList = [];
  List<int> jcLeagueId = [];
  List<int> jcHideLeagueId = [];

  LeagueListEntity? oneLevelData;
  var hideMatch = 0;
  var type = MatchType.all;
  var leagueType = LeagueType.all;
  //比赛频道右下角需要显示的类型 0全部1一级2竞足
  QuickFilter quickFilter = QuickFilter.all;

  @override
  void onInit() {
    super.onInit();
    oneLevelData = Get.find<MatchService>().basketOneLevelData;
  }

  void initLeague(MatchType type) {
    this.type = type;
    if ((type == MatchType.schedule ||
            type == MatchType.end ||
            type == MatchType.begin) &&
        Get.find<ConfigService>().basketConfig.basketInAppAlert4 == 1) {
      quickFilter = Get.find<BasketListAllController>().quickFilter;
      if (quickFilter == QuickFilter.jingcai) {
        leagueType = LeagueType.jc;
      }
    }
    if (allLeagueId.isEmpty) {
      getAllLeague();
      loadLocalData();
      if (quickFilter == QuickFilter.yiji) {
        selectOneLevel();
      } else {
        updateLeague();
      }

      // if (matchType == MatchType.all) {}
    } else {
      updateLeague();
    }
  }

  void clear() {
    // leagueType = LeagueType.all;
    hideLeagueId = [];
    allLeagueId = [];
    rmHideLeagueId = [];
    jcHideLeagueId = [];
    hideMatch = 0;
  }

  void getAllLeague() {
    // type = matchType;
    allLeagueId = [];
    rmLeagueId = [];
    jcLeagueId = [];
    // int hideMatchTemp = 0;
    List<LeagueEntity> leagueList = [];
    List<BasketListEntity> data = [];
    if (type == MatchType.all) {
      data = Get.find<BasketListAllController>().originalData;
    } else if (type == MatchType.begin) {
      data = Get.find<BasketListBeginController>().originalData;
    } else if (type == MatchType.schedule) {
      final index = Get.find<BasketListScheduleController>().index;
      data = Get.find<BasketListScheduleViewController>(tag: '$index')
          .originalData;
    } else if (type == MatchType.end) {
      final index = Get.find<BasketListEndController>().index;
      data = Get.find<BasketListEndViewController>(tag: '$index').originalData;
    } else if (type == MatchType.focus) {
      data = Get.find<BasketListFocusController>().originalData;
    }
    List hotLeagueId = [];
    if (Get.find<MatchService>().basketOneLevelData?.hotList != null) {
      Get.find<MatchService>()
          .basketOneLevelData
          ?.hotList!
          .map((e) => e.leagueId)
          .toList();
    }
    List allHotLeagueId =
        oneLevelData!.hotList!.map((e) => e.leagueId).toList();
    for (var match in data) {
      if (match.leagueId == null) {
        continue;
      }
      List<LeagueEntity> hasLeague = leagueList
          .where((element) => element.leagueId == match.leagueId)
          .toList();
      if (hasLeague.isEmpty) {
        final league = LeagueEntity(
            leagueId: match.leagueId, leagueName: match.leagueName);
        // ..isSelected = !hideLeagueId.contains(match.leagueId);
        league.matchNum = 1;
        leagueList.add(league);
      } else {
        hasLeague.first.matchNum = hasLeague.first.matchNum! + 1;
      }
      // if (!leagueList.any((element) => element.leagueId == match.leagueId)) {

      // }
      if (!allLeagueId.contains(match.leagueId)) {
        allLeagueId.add(match.leagueId!);
      }
      if (allHotLeagueId.contains(match.leagueId)) {
        rmLeagueId.add(match.leagueId!);
      }
      if (match.jcNo.valuable && !jcLeagueId.contains(match.leagueId)) {
        jcLeagueId.add(match.leagueId!);
      }
    }
    handleList(leagueList);
  }

  //点击tabbar或底部按钮
  void updateLeague() {
    // leagueType = type;
    int hideMatchTemp = 0;
    List<LeagueEntity> leagueListTemp = [];
    List<BasketListEntity> data = [];
    if (type == MatchType.all) {
      data = Get.find<BasketListAllController>().originalData;
    } else if (type == MatchType.begin) {
      data = Get.find<BasketListBeginController>().originalData;
    } else if (type == MatchType.schedule) {
      final index = Get.find<BasketListScheduleController>().index;
      data = Get.find<BasketListScheduleViewController>(tag: '$index')
          .originalData;
    } else if (type == MatchType.end) {
      final index = Get.find<BasketListEndController>().index;
      data = Get.find<BasketListEndViewController>(tag: '$index').originalData;
    } else if (type == MatchType.focus) {
      data = Get.find<BasketListFocusController>().originalData;
    }

    for (var match in data) {
      if (match.leagueId != null) {
        final league = LeagueEntity(
            leagueId: match.leagueId, leagueName: match.leagueName);

        if (leagueType == LeagueType.all) {
          if (hideLeagueId.contains(league.leagueId)) {
            league.isSelected = false;
            hideMatchTemp++;
          } else {
            league.isSelected = true;
          }
          List<LeagueEntity> hasLeague = leagueListTemp
              .where((element) => element.leagueId == match.leagueId)
              .toList();
          if (hasLeague.isEmpty) {
            league.matchNum = 1;
            leagueListTemp.add(league);
          } else {
            hasLeague.first.matchNum = hasLeague.first.matchNum! + 1;
          }
          // if (!leagueListTemp
          //     .any((element) => element.leagueId == match.leagueId)) {
          //   leagueListTemp.add(league);
          // }
        } else if (leagueType == LeagueType.jc) {
          if (jcLeagueId.contains(league.leagueId)) {
            if (jcHideLeagueId.contains(match.leagueId)) {
              league.isSelected = false;
              hideMatchTemp++;
            } else {
              league.isSelected = true;
              if (match.jcNo.valuable == false) {
                hideMatchTemp++;
              }
            }
            List<LeagueEntity> hasLeague = leagueListTemp
                .where((element) => element.leagueId == match.leagueId)
                .toList();
            if (match.jcNo.valuable == true) {
              if (hasLeague.isEmpty) {
                league.matchNum = 1;
                leagueListTemp.add(league);
              } else {
                hasLeague.first.matchNum = hasLeague.first.matchNum! + 1;
              }
            }
            // if (!leagueListTemp
            //     .any((element) => element.leagueId == match.leagueId)) {
            //   leagueListTemp.add(league);
            // }
          } else {
            hideMatchTemp++;
          }
        } else if (leagueType == LeagueType.rm) {
          if (rmLeagueId.contains(league.leagueId)) {
            if (rmHideLeagueId.contains(match.leagueId)) {
              league.isSelected = false;
              hideMatchTemp++;
            } else {
              league.isSelected = true;
            }
            List<LeagueEntity> hasLeague = leagueListTemp
                .where((element) => element.leagueId == match.leagueId)
                .toList();
            if (hasLeague.isEmpty) {
              league.matchNum = 1;
              leagueListTemp.add(league);
            } else {
              hasLeague.first.matchNum = hasLeague.first.matchNum! + 1;
            }
            // if (!leagueListTemp
            //     .any((element) => element.leagueId == match.leagueId)) {
            //   leagueListTemp.add(league);
            // }
          } else {
            hideMatchTemp++;
          }
        }
      }
    }
    hideMatch = hideMatchTemp;
    if (leagueType == LeagueType.all) {
      leagueList = leagueListTemp;
      handleList(leagueListTemp);
    } else {
      if (leagueType == LeagueType.jc) {
        jcLeagueList = leagueListTemp;
      } else if (leagueType == LeagueType.rm) {
        rmLeagueList = leagueListTemp;
      }
      // hideMatch = hideMatchTemp;
      update();
    }
  }

  handleList(List<LeagueEntity> list) {
    // List<LeagueEntity> list = data.level1List!;
    List<LeagueEntity> hotLeague = [];
    indexLeagueEntity = [];
    for (int i = 0, length = list.length; i < length; i++) {
      if (oneLevelData!.hotList!
          .any((element) => element.leagueId == list[i].leagueId)) {
        //热门比赛
        hotLeague.add(list[i]);
      } else {
        String pinyin = PinyinHelper.getPinyinE(list[i].leagueName!);
        String tag = pinyin.substring(0, 1).toUpperCase();
        bool hasTag = false;
        for (var match in indexLeagueEntity) {
          if (match.tagIndex == tag) {
            match.leagues.add(list[i]);
            hasTag = true;
            continue;
          }
        }
        if (!hasTag) {
          indexLeagueEntity.add(IndexLeagueEntity([list[i]], tag));
        }
      }
    }

    SuspensionUtil.sortListBySuspensionTag(indexLeagueEntity);
    if (hotLeague.isNotEmpty) {
      indexLeagueEntity.insert(0, IndexLeagueEntity(hotLeague, '★'));
    }
    SuspensionUtil.setShowSuspensionStatus(indexLeagueEntity);
    update();
  }

  void selectLeague(LeagueEntity league) {
    league.isSelected = !league.isSelected;
    if (leagueType == LeagueType.all) {
      if (!league.isSelected && !hideLeagueId.contains(league.leagueId)) {
        hideLeagueId.add(league.leagueId!);
      } else {
        hideLeagueId.remove(league.leagueId);
      }
    } else if (leagueType == LeagueType.jc) {
      if (!league.isSelected && !jcHideLeagueId.contains(league.leagueId)) {
        jcHideLeagueId.add(league.leagueId!);
      } else {
        jcHideLeagueId.remove(league.leagueId);
      }
    } else if (leagueType == LeagueType.rm) {
      if (!league.isSelected && !rmHideLeagueId.contains(league.leagueId)) {
        rmHideLeagueId.add(league.leagueId!);
      } else {
        rmHideLeagueId.remove(league.leagueId);
      }
    }

    updateLeague();
  }

  List<LeagueEntity> getLeague(LeagueType type) {
    List<LeagueEntity> list = [];
    if (type == LeagueType.jc) {
      list = jcLeagueList;
    } else if (type == LeagueType.rm) {
      list = rmLeagueList;
    }
    return list;
  }

  void onSelectLeagueType(LeagueType type) {
    leagueType = type;
    // setMatchListType(type == LeagueType.jz ? 2 : 0);
    quickFilter =
        (leagueType == LeagueType.jc ? QuickFilter.jingcai : QuickFilter.all);
    updateLeague();
  }

  void selectOneLevel() {
    if (oneLevelData == null) {
      return;
    }
    List<int> hideLeagueIdTemp = [];
    if (leagueType == LeagueType.all) {
      for (var leagueId in allLeagueId) {
        if (!oneLevelData!.level1List!
            .any((element) => element.leagueId == leagueId)) {
          hideLeagueIdTemp.add(leagueId);
        }
      }
      hideLeagueId = hideLeagueIdTemp;
    } else if (leagueType == LeagueType.jc) {
      for (var leagueId in jcLeagueId) {
        if (!oneLevelData!.level1List!
            .any((element) => element.leagueId == leagueId)) {
          hideLeagueIdTemp.add(leagueId);
        }
      }
      jcHideLeagueId = hideLeagueIdTemp;
    } else if (leagueType == LeagueType.rm) {
      for (var leagueId in rmLeagueId) {
        if (!oneLevelData!.level1List!
            .any((element) => element.leagueId == leagueId)) {
          hideLeagueIdTemp.add(leagueId);
        }
      }
      rmHideLeagueId = hideLeagueIdTemp;
    }
    quickFilter =
        (leagueType == LeagueType.jc ? QuickFilter.jingcai : QuickFilter.yiji);
    updateLeague();
  }

  void selectAll() {
    if (leagueType == LeagueType.all) {
      hideLeagueId = [];
    } else if (leagueType == LeagueType.jc) {
      jcHideLeagueId = [];
    } else if (leagueType == LeagueType.rm) {
      rmHideLeagueId = [];
    }
    // hideMatch.value =
    quickFilter =
        (leagueType == LeagueType.jc ? QuickFilter.jingcai : QuickFilter.all);
    updateLeague();
  }

  void selectReverse() {
    List<int> hideLeagueIdTemp = [];
    if (leagueType == LeagueType.all) {
      for (var leagueId in allLeagueId) {
        if (!hideLeagueId.contains(leagueId)) {
          hideLeagueIdTemp.add(leagueId);
        }
      }
      hideLeagueId = hideLeagueIdTemp;
    } else if (leagueType == LeagueType.jc) {
      for (var leagueId in jcLeagueId) {
        if (!jcHideLeagueId.contains(leagueId)) {
          hideLeagueIdTemp.add(leagueId);
        }
      }
      jcHideLeagueId = hideLeagueIdTemp;
    } else if (leagueType == LeagueType.rm) {
      for (var leagueId in rmLeagueId) {
        if (!rmHideLeagueId.contains(leagueId)) {
          hideLeagueIdTemp.add(leagueId);
        }
      }
      rmHideLeagueId = hideLeagueIdTemp;
    }
    quickFilter =
        (leagueType == LeagueType.jc ? QuickFilter.jingcai : QuickFilter.all);
    updateLeague();
  }

  void onConfirm() {
    List<int> hideLeagueIdList = getHideLeagueIdList();
    savaFilter();
    if (type == MatchType.all) {
      Get.find<BasketListAllController>()
          .onSelectMatchType(quickFilter, fromFilterPage: true);
      Get.find<BasketListAllController>().filterMatch(hideLeagueIdList);
    } else if (type == MatchType.begin) {
      Get.find<BasketListBeginController>().quickFilter = quickFilter;
      Get.find<BasketListBeginController>().filterMatch(hideLeagueIdList);
    } else if (type == MatchType.schedule) {
      final index = Get.find<BasketListScheduleController>().index;
      Get.find<BasketListScheduleController>()
          .onSelectMatchType(quickFilter, fromFilterPage: true);
      Get.find<BasketListScheduleViewController>(tag: '$index')
          .filterMatch(hideLeagueIdList);
    } else if (type == MatchType.end) {
      final index = Get.find<BasketListEndController>().index;
      Get.find<BasketListEndController>()
          .onSelectMatchType(quickFilter, fromFilterPage: true);
      Get.find<BasketListEndViewController>(tag: '$index')
          .filterMatch(hideLeagueIdList);
    } else if (type == MatchType.focus) {
      Get.find<MatchInterestController>().quickFilter = quickFilter;
      Get.find<MatchInterestController>().filterMatch(hideLeagueIdList);
    }
    Get.back();
  }

  List<int> getHideLeagueIdList() {
    List<int> hideLeagueIdList = List.from(allLeagueId);
    if (leagueType == LeagueType.all) {
      hideLeagueIdList = hideLeagueId;
    } else if (leagueType == LeagueType.jc) {
      List<int> selectLeague = jcLeagueId
          .where((element) => !jcHideLeagueId.contains(element))
          .toList();
      for (var e in selectLeague) {
        hideLeagueIdList.remove(e);
      }
    } else if (leagueType == LeagueType.rm) {
      List<int> selectLeague = rmLeagueId
          .where((element) => !rmHideLeagueId.contains(element))
          .toList();
      for (var e in selectLeague) {
        hideLeagueIdList.remove(e);
      }
    }
    return hideLeagueIdList;
  }

  //只保存全部频道
  void savaFilter() {
    if (type == MatchType.all) {
      List<int> hideLeague = [];
      if (leagueType == LeagueType.all) {
        hideLeague = hideLeagueId;
      } else if (leagueType == LeagueType.jc) {
        hideLeague = jcHideLeagueId;
      } else if (leagueType == LeagueType.rm) {
        hideLeague = rmHideLeagueId;
      }
      final json = {
        'hideLeagueId': hideLeague,
        // 'type': type.index,
        'leagueType': leagueType.index,
        'matchType': QuickFilter.values.indexOf(quickFilter)
      };
      SpUtils.matchAllFilterData = json;
    }
  }

  void loadLocalData() {
    if (type == MatchType.all) {
      final filterJson = SpUtils.matchAllFilterData;
      if (filterJson != null) {
        leagueType = LeagueType.values[filterJson['leagueType']];
        quickFilter = QuickFilter.values[filterJson['matchType']];
        final hideLeague = filterJson['hideLeagueId'].cast<int>();
        if (leagueType == LeagueType.all) {
          hideLeagueId = hideLeague;
        } else if (leagueType == LeagueType.jc) {
          jcHideLeagueId = hideLeague;
        } else if (leagueType == LeagueType.rm) {
          rmHideLeagueId = hideLeague;
        }
        updateLeague();
      }
    }
  }
}

class IndexLeagueEntity extends ISuspensionBean {
  List<LeagueEntity> leagues;
  String tagIndex;
  IndexLeagueEntity(this.leagues, this.tagIndex);
  @override
  String getSuspensionTag() {
    return tagIndex;
  }
}
