import 'package:azlistview/azlistview.dart';
import 'package:get/get.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/match/match_all_controller.dart';
import 'package:sports/logic/match/match_begin_controller.dart';
import 'package:sports/logic/match/match_list_cell_controller.dart';
import 'package:sports/logic/match/match_page_controller.dart';
import 'package:sports/logic/match/match_result_controller.dart';
import 'package:sports/logic/match/match_result_list_controller.dart';
import 'package:sports/logic/match/match_schedule_controller.dart';
import 'package:sports/logic/match/match_schedule_list_controller.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/logic/service/match_service.dart';
import 'package:sports/model/data/league_list_entity.dart';
import 'package:sports/model/match/match_entity.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/view/match/match_filter_page.dart';

import 'match_interest_controller.dart';

enum MatchType { focus, all, begin, schedule, end }

enum LeagueType { all, jz, dc, ssc }

class SoccerMatchFilterController extends GetxController {
  SoccerMatchFilterController();
  //全部数据源
  List<IndexLeagueEntity> indexLeagueEntity = [];
  //全部
  List<LeagueEntity> leagueList = [];
  List<int> hideLeagueId = [];
  List<int> allLeagueId = [];
  //竞足
  List<LeagueEntity> jzLeagueList = [];
  List<int> jzLeagueId = [];
  List<int> jzHideLeagueId = [];
  //单场
  List<LeagueEntity> dcLeagueList = [];
  List<int> dcLeagueId = [];
  List<int> dcHideLeagueId = [];
  //十四场
  List<LeagueEntity> sscLeagueList = [];
  List<int> sscLeagueId = [];
  List<int> sscHideLeagueId = [];
  LeagueListEntity? oneLevelData;
  var hideMatch = 0;
  var type = MatchType.all;
  var leagueType = LeagueType.all;
  //比赛频道右下角需要显示的类型 0全部1一级2竞足
  QuickFilter quickFilter = QuickFilter.all;

  @override
  void onInit() {
    super.onInit();
    oneLevelData = Get.find<MatchService>().oneLevelData;
  }

  void initLeague(MatchType type) {
    this.type = type;
    if ((type == MatchType.schedule ||
            type == MatchType.end ||
            type == MatchType.begin) &&
        Get.find<ConfigService>().soccerConfig.soccerInAppAlert7 == 1) {
      quickFilter = Get.find<MatchAllController>().quickFilter;
      if (quickFilter == QuickFilter.jingcai) {
        leagueType = LeagueType.jz;
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
      getAllLeague();
      updateLeague();
    }
  }

  void clear() {
    // leagueType = LeagueType.all;
    hideLeagueId = [];
    allLeagueId = [];
    jzHideLeagueId = [];
    dcHideLeagueId = [];
    sscHideLeagueId = [];
    hideMatch = 0;
  }

  void getAllLeague() {
    // type = matchType;
    allLeagueId = [];
    jzLeagueId = [];
    dcLeagueId = [];
    sscLeagueId = [];
    // int hideMatchTemp = 0;
    List<LeagueEntity> leagueList = [];
    List<MatchEntity> data = [];
    if (type == MatchType.all) {
      data = Get.find<MatchAllController>().originalData;
    } else if (type == MatchType.begin) {
      data = Get.find<MatchBeginController>().originalData;
    } else if (type == MatchType.schedule) {
      final index = Get.find<MatchScheduleController>().index;
      data = Get.find<MatchScheduleListController>(tag: '$index').originalData;
    } else if (type == MatchType.end) {
      final index = Get.find<MatchResultController>().index;
      data = Get.find<MatchResultListController>(tag: '$index').originalData;
    } else if (type == MatchType.focus) {
      data = Get.find<MatchInterestController>().originalData;
    }

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
      if (!allLeagueId.contains(match.leagueId)) {
        allLeagueId.add(match.leagueId!);
      }
      if (match.jcMatchNo != null && !jzLeagueId.contains(match.leagueId)) {
        jzLeagueId.add(match.leagueId!);
      }
      if (match.dcMatchNo != null && !dcLeagueId.contains(match.leagueId)) {
        dcLeagueId.add(match.leagueId!);
      }
      if (match.sfcMatchNo != null && !sscLeagueId.contains(match.leagueId)) {
        sscLeagueId.add(match.leagueId!);
      }
    }
    handleList(leagueList);
  }

  //点击tabbar或底部按钮
  void updateLeague() {
    // leagueType = type;
    int hideMatchTemp = 0;
    List<LeagueEntity> leagueListTemp = [];
    List<MatchEntity> data = [];
    if (type == MatchType.all) {
      data = Get.find<MatchAllController>().originalData;
    } else if (type == MatchType.begin) {
      data = Get.find<MatchBeginController>().originalData;
    } else if (type == MatchType.schedule) {
      final index = Get.find<MatchScheduleController>().index;
      data = Get.find<MatchScheduleListController>(tag: '$index').originalData;
    } else if (type == MatchType.end) {
      final index = Get.find<MatchResultController>().index;
      data = Get.find<MatchResultListController>(tag: '$index').originalData;
    } else if (type == MatchType.focus) {
      data = Get.find<MatchInterestController>().originalData;
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
        } else if (leagueType == LeagueType.jz) {
          if (jzLeagueId.contains(league.leagueId)) {
            if (jzHideLeagueId.contains(match.leagueId)) {
              league.isSelected = false;
              hideMatchTemp++;
            } else {
              league.isSelected = true;
              if (match.jcMatchNo == null) {
                hideMatchTemp++;
              }
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
          } else {
            hideMatchTemp++;
          }
        } else if (leagueType == LeagueType.dc) {
          if (dcLeagueId.contains(league.leagueId)) {
            if (dcHideLeagueId.contains(match.leagueId)) {
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
          } else {
            hideMatchTemp++;
          }
        } else {
          if (sscLeagueId.contains(league.leagueId)) {
            if (sscHideLeagueId.contains(match.leagueId)) {
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
      if (leagueType == LeagueType.jz) {
        jzLeagueList = leagueListTemp;
      } else if (leagueType == LeagueType.dc) {
        dcLeagueList = leagueListTemp;
      } else if (leagueType == LeagueType.ssc) {
        sscLeagueList = leagueListTemp;
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
    } else if (leagueType == LeagueType.jz) {
      if (!league.isSelected && !jzHideLeagueId.contains(league.leagueId)) {
        jzHideLeagueId.add(league.leagueId!);
      } else {
        jzHideLeagueId.remove(league.leagueId);
      }
    } else if (leagueType == LeagueType.dc) {
      if (!league.isSelected && !dcHideLeagueId.contains(league.leagueId)) {
        dcHideLeagueId.add(league.leagueId!);
      } else {
        dcHideLeagueId.remove(league.leagueId);
      }
    } else {
      if (!league.isSelected && !sscHideLeagueId.contains(league.leagueId)) {
        sscHideLeagueId.add(league.leagueId!);
      } else {
        sscHideLeagueId.remove(league.leagueId);
      }
    }

    updateLeague();
  }

  List<LeagueEntity> getLeague(LeagueType type) {
    List<LeagueEntity> list = [];
    if (type == LeagueType.jz) {
      list = jzLeagueList;
    } else if (type == LeagueType.dc) {
      list = dcLeagueList;
    } else if (type == LeagueType.ssc) {
      list = sscLeagueList;
    }
    return list;
  }

  void onSelectLeagueType(LeagueType type) {
    leagueType = type;
    // setMatchListType(type == LeagueType.jz ? 2 : 0);
    quickFilter =
        (leagueType == LeagueType.jz ? QuickFilter.jingcai : QuickFilter.all);
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
    } else if (leagueType == LeagueType.jz) {
      for (var leagueId in jzLeagueId) {
        if (!oneLevelData!.level1List!
            .any((element) => element.leagueId == leagueId)) {
          hideLeagueIdTemp.add(leagueId);
        }
      }
      jzHideLeagueId = hideLeagueIdTemp;
    } else if (leagueType == LeagueType.dc) {
      for (var leagueId in dcLeagueId) {
        if (!oneLevelData!.level1List!
            .any((element) => element.leagueId == leagueId)) {
          hideLeagueIdTemp.add(leagueId);
        }
      }
      dcHideLeagueId = hideLeagueIdTemp;
    } else {
      for (var leagueId in sscLeagueId) {
        if (!oneLevelData!.level1List!
            .any((element) => element.leagueId == leagueId)) {
          hideLeagueIdTemp.add(leagueId);
        }
      }
      sscHideLeagueId = hideLeagueIdTemp;
    }
    quickFilter =
        (leagueType == LeagueType.jz ? QuickFilter.jingcai : QuickFilter.yiji);
    updateLeague();
  }

  void selectAll() {
    if (leagueType == LeagueType.all) {
      hideLeagueId = [];
    } else if (leagueType == LeagueType.jz) {
      jzHideLeagueId = [];
    } else if (leagueType == LeagueType.dc) {
      dcHideLeagueId = [];
    } else {
      sscHideLeagueId = [];
    }
    // hideMatch.value =
    quickFilter =
        (leagueType == LeagueType.jz ? QuickFilter.jingcai : QuickFilter.all);
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
    } else if (leagueType == LeagueType.jz) {
      for (var leagueId in jzLeagueId) {
        if (!jzHideLeagueId.contains(leagueId)) {
          hideLeagueIdTemp.add(leagueId);
        }
      }
      jzHideLeagueId = hideLeagueIdTemp;
    } else if (leagueType == LeagueType.dc) {
      for (var leagueId in dcLeagueId) {
        if (!dcHideLeagueId.contains(leagueId)) {
          hideLeagueIdTemp.add(leagueId);
        }
      }
      dcHideLeagueId = hideLeagueIdTemp;
    } else {
      for (var leagueId in sscLeagueId) {
        if (!sscHideLeagueId.contains(leagueId)) {
          hideLeagueIdTemp.add(leagueId);
        }
      }
      sscHideLeagueId = hideLeagueIdTemp;
    }
    quickFilter =
        (leagueType == LeagueType.jz ? QuickFilter.jingcai : QuickFilter.all);
    updateLeague();
  }

  void onConfirm() {
    List<int> hideLeagueIdList = getHideLeagueIdList();
    savaFilter();
    if (type == MatchType.all) {
      Get.find<MatchAllController>()
          .onSelectMatchType(quickFilter, fromFilterPage: true);
      Get.find<MatchAllController>().filterMatch(hideLeagueIdList);
    } else if (type == MatchType.begin) {
      Get.find<MatchBeginController>().quickFilter = quickFilter;
      Get.find<MatchBeginController>().filterMatch(hideLeagueIdList);
    } else if (type == MatchType.schedule) {
      final index = Get.find<MatchScheduleController>().index;
      Get.find<MatchScheduleController>()
          .onSelectMatchType(quickFilter, fromFilterPage: true);
      Get.find<MatchScheduleListController>(tag: '$index')
          .filterMatch(hideLeagueIdList);
    } else if (type == MatchType.end) {
      final index = Get.find<MatchResultController>().index;
      Get.find<MatchResultController>()
          .onSelectMatchType(quickFilter, fromFilterPage: true);
      Get.find<MatchResultListController>(tag: '$index')
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
    } else if (leagueType == LeagueType.jz) {
      // List<LeagueEntity> selectLeague =
      //     jzLeagueList.where((element) => element.isSelected == true).toList();
      // for (var e in selectLeague) {
      //   hideLeagueIdList.remove(e.leagueId);
      // }
      List<int> selectLeague = jzLeagueId
          .where((element) => !jzHideLeagueId.contains(element))
          .toList();
      for (var e in selectLeague) {
        hideLeagueIdList.remove(e);
      }
    } else if (leagueType == LeagueType.dc) {
      // List selectLeague =
      //     dcLeagueList.where((element) => element.isSelected == true).toList();
      // for (var e in selectLeague) {
      //   hideLeagueIdList.remove(e.leagueId);
      // }
      List<int> selectLeague = dcLeagueId
          .where((element) => !dcHideLeagueId.contains(element))
          .toList();
      for (var e in selectLeague) {
        hideLeagueIdList.remove(e);
      }
    } else {
      // List selectLeague =
      //     sscLeagueList.where((element) => element.isSelected == true).toList();
      // for (var e in selectLeague) {
      //   hideLeagueIdList.remove(e.leagueId);
      // }
      List<int> selectLeague = sscLeagueId
          .where((element) => !sscHideLeagueId.contains(element))
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
      } else if (leagueType == LeagueType.jz) {
        hideLeague = jzHideLeagueId;
      } else if (leagueType == LeagueType.dc) {
        hideLeague = dcHideLeagueId;
      } else {
        hideLeague = sscHideLeagueId;
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
        } else if (leagueType == LeagueType.jz) {
          jzHideLeagueId = hideLeague;
        } else if (leagueType == LeagueType.dc) {
          dcHideLeagueId = hideLeague;
        } else {
          sscHideLeagueId = hideLeague;
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
