import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sports/logic/home/navigation_controller.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/model/ws/event_data_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/sound_utils.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/util/web_socket_connection.dart';
import 'package:sports/view/home/video/video_player.dart';
import 'package:sports/view/match/match_page.dart';
import 'package:sports/view/match_detail/basketball_match_detail/bb_detail_page.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';



class _GetNotifyConfig {

  static bool isInMatchList() {
    if (Get.currentRoute == "/navigation") {
      final c = Get.find<NavigationController>();
      if(c.pageList.indexWhere((element) => element is MatchPage) == c.pageController.page) {
        return true;
      }
    }
    return false;
  } 

  static isBasketbool(WsEventEntity event) {
    final t = event.eventType ?? -1;
    return t ~/ 100 == 81;
  }

  static isSoccer(WsEventEntity event) {
    final t = event.eventType ?? 0;
    return t ~/ 100 == 82;
  }

  static bool doNotify(WsEventEntity event) {
    try {
      final entity = event.data;
      if (entity == null) { return false; }
      
      final s = Get.find<ConfigService>();
      if (!s.tipEnable) { return false; }

      switch (event.eventType) {
        case 8101: 
          //篮球进球
          //是否只提醒关注的
          if ( s.basketConfig.basketInAppAlert1 == 0 && !User.basketballFocuses.isFocus(entity.matchQxbId ?? -1)) { return false; }
          //是否只在比赛列表中提醒
          if (s.basketConfig.basketInAppAlert3 == 0 && !isInMatchList()) { return false; }
          //是否需要弹窗提示
          if(!s.basketConfig.basketInAppAlert2.contains(0)) { return false; }
          //播放声音
          if (s.basketConfig.basketInAppAlert2.contains(1)) { SoundUtils.playBasketGoal(); }
          //震动
          if (s.basketConfig.basketInAppAlert2.contains(2)) { Vibration.vibrate(); }
          return true;
        case 8201: 
          //足球进球
          //是否只提醒关注的
          if ( s.soccerConfig.soccerInAppAlert1 == 0 && !User.isFollow(entity.matchQxbId ?? -1)) { return false; }
          //是否只在比赛列表中提醒
          if (s.soccerConfig.soccerInAppAlert6 == 0 && !isInMatchList()) { return false; }
          //是否需要弹窗提示
          if(!s.soccerConfig.soccerInAppAlert2.contains(0)) { return false; }
          //播放声音
          if (s.soccerConfig.soccerInAppAlert2.contains(1)) { SoundUtils.playSoccerGoal(entity.highLight == 0); }
          //震动
          if (s.soccerConfig.soccerInAppAlert2.contains(2)) { Vibration.vibrate(); }
          return true;
        case 8202: 
          //足球红牌
          //是否只提醒关注的
          if ( s.soccerConfig.soccerInAppAlert1 == 0 && !User.isFollow(entity.matchQxbId ?? -1)) { return false; }
          //是否只在比赛列表中提醒
          if (s.soccerConfig.soccerInAppAlert6 == 0 && !isInMatchList()) { return false; }
          //是否需要弹窗提示
          if(!s.soccerConfig.soccerInAppAlert5.contains(0)) { return false; }
          //播放声音
          if (s.soccerConfig.soccerInAppAlert5.contains(1)) { SoundUtils.playRedCard(); }
          //震动
          if (s.soccerConfig.soccerInAppAlert5.contains(2)) { Vibration.vibrate(); }
          return true;
      }
    } catch (err) {
      return false;
    }
    return true;
  }

  static const evIcons = {
    8101:"match_event_basketball.png",
    8201:"match_event_soccer.png",
    8202:"match_ev_soccer_red.png"
  };

  static const evRorate = {
    8101:true,
    8201:true,
    8202:false
  };

}


class AppTipWidget extends StatefulWidget {
  const AppTipWidget({super.key});

  @override
  State<AppTipWidget> createState() => _AppTipWidgetState();
}

class _AppTipWidgetState extends State<AppTipWidget> {

  late Timer t;

  final _listKey = GlobalKey<AnimatedListState>();

  int count = 0;
  StreamSubscription? _sub;

  bool showing = false;
  List<WsEvent> events = [];
  WsEventEntity? event;
  late final s = Get.find<ConfigService>();
  bool showSetting = !SpUtils.notifySetted;

  showEvent(WsEventEntity event) {
    if (_GetNotifyConfig.isBasketbool(event)) {
    } else if (_GetNotifyConfig.isSoccer(event)) {
    } else { return ; }

    showSetting = !SpUtils.notifySetted;
    this.event = event;
    showing = true;
    update();
    final s = (event.holdTime ?? 0) == 0 ? 5 : event.holdTime!;
    Future.delayed(Duration(seconds: s)).then((value) => dismiss());
  }

  next() {
    if (event != null) { return; }
    if (events.isEmpty) { return; }
    try {
      final e = events.removeAt(0);
      final evEntity = WsEventEntity.fromJson(e);
      if(_GetNotifyConfig.doNotify(evEntity)) {
        showEvent(evEntity);
      } else {
        next();    
      }
    } catch (err) { 
      next();
    }
  }

  dismiss() {
    if (event == null) { return; }
    showing = false;
    update();
    Future.delayed(300.ms).then((value) {
      event = null;
      update();
      next();
    });
  }

  @override
  void initState() {
    super.initState();
    
    _sub = WsConnection.all.listen((WsEvent event) { 
      events.add(event);
      next();
    });
  }

  @override
  void dispose() {
    t.cancel();
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return event != null ? Positioned(
      bottom: padding.bottom + 56,left: 0,right: 0,
      // height: 100,
      child: _content()
    ) : Container();
  }

  Widget _content() {
    List<Color> gradientColors = [Color(0xFFE56934).withOpacity(0.95),Color(0xFFF08557).withOpacity(0.95)];
    if (event?.isSoccer ?? false) {
      gradientColors = [Color(0xFFF53F3F).withOpacity(0.95),Color(0xFFFF7070).withOpacity(0.95)];
    }
    final content = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors,begin: Alignment.centerRight,end: Alignment.centerLeft),
        borderRadius: BorderRadius.circular(8)
      ),
      margin: const EdgeInsets.symmetric(horizontal: 24,vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
      child: Column(
        children: [
          _infoContent(),
          if (showSetting)
          _settingView()
        ],
      ),
    );
    return showing ? 
        content.animate(key: ValueKey("s ${event?.data?.matchQxbId}"))
        .move(begin: const Offset(200, 0),end: Offset.zero,duration: 200.ms).fadeIn(delay: 100.ms, duration: 100.ms,begin: 0,end: 1)
      : content.animate(key: ValueKey("e ${event?.data?.matchQxbId}"))
        .move(begin: Offset.zero,end: const Offset(200, 0),duration: 200.ms).fadeOut(delay: 100.ms,duration: 100.ms,begin: 1,end: 0);
  }

  Widget _settingView() {
    final e = this.event;
    if (e == null) { return Container(); }
    int f = 0;
    if (_GetNotifyConfig.isSoccer(e)) {
      f = s.soccerConfig.soccerInAppAlert1;
      log("${s.soccerConfig.soccerInAppAlert1}");
    } else {
      f = s.basketConfig.basketInAppAlert1;
      log("${s.basketConfig.basketInAppAlert1}");
    }

    return Container(
      padding: const EdgeInsets.only(top: 11),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white,fontSize: 12),
        child: Row(
          children: [
            const Text("提醒范围"),
            const SizedBox(width: 8,),
            _roundBtn("关注", f == 0).tap(() {
              if (_GetNotifyConfig.isSoccer(e)) { 
                s.soccerConfig.soccerInAppAlert1 = 0;
                s.update(ConfigType.soccerInAppAlert1, 0); 
              }  else { 
                s.basketConfig.basketInAppAlert1 = 0;
                s.update(ConfigType.basketInAppAlert1, 0); 
              }
              update();
              SpUtils.notifySetted = true;
            }),
            const SizedBox(width: 5,),
            _roundBtn("全部", f == 1).tap(() {
              if (_GetNotifyConfig.isSoccer(e)) { 
                s.soccerConfig.soccerInAppAlert1 = 1;
                s.update(ConfigType.soccerInAppAlert1, 1); 
              }  else { 
                s.basketConfig.basketInAppAlert1 = 1;
                s.update(ConfigType.basketInAppAlert1, 1); 
              }
              update();
              SpUtils.notifySetted = true;
            }),
            const Spacer(),
            _iconBtn("设置", Utils.getImgPath("config.png")).tap(() {
              if (_GetNotifyConfig.isSoccer(e)) { 
                Get.toNamed(Routes.soccerConfig);
              }  else { 
                Get.toNamed(Routes.basketballConfig);
              }
              SpUtils.notifySetted = true;
            })
          ],
        ),
      ),
    );
  }
  
  Widget _iconBtn(String title,String icon) {
    return Row(
      children: [
        Image.asset(icon,width: 16,height: 16).marginOnly(right: 5),
        Text(title)
      ],
    );
  }

  Widget _roundBtn(String title,bool selected) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: selected ? Border.all(color: Colors.white,width: 0.5) : null,
        borderRadius: BorderRadius.circular(10),
        color: Color(0x1A000000)
      ),
      alignment: Alignment.center,
      width: 32,
      height: 16,
      child: Center(
        child: Text(title,style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w400)),
      ),
    );
  }

  Widget _infoContent() {
    EventDataEntity? entity;
    try {
      entity = event?.data;
    } catch (err) {}
    
    final image = _GetNotifyConfig.evIcons[event?.eventType ?? 0] ?? "match_event_soccer.png";
    final rotate = _GetNotifyConfig.evRorate[event?.eventType ?? 0] ?? false;
    Animate icon = Image.asset(Utils.getImgPath(image),width: 44,height: 44).animate(key: ValueKey("a ${event?.data?.matchQxbId}"));
    if (rotate) {
      icon = icon.rotate( duration: 2000.ms,begin: math.pi,end: 0 );
    }
    icon = icon.move(duration: 2000.ms, begin: const Offset(-10, 0),end: Offset.zero);
    final topEmpty = (entity?.topTeamName ?? "").isEmpty && (entity?.topTeamScore ?? '').isEmpty;
    final bottomEmpty = (entity?.footTeamName ?? '').isEmpty && (entity?.footTeamScore ?? '').isEmpty;
    final midSpace = !topEmpty && !bottomEmpty;
    return Container(
      height: 47,
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 8,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!topEmpty)
                  _teamInfo(entity?.topTeamName ?? "", entity?.topTeamScore ?? '',alert: entity?.highLight == 0),
                  if (midSpace)
                  const SizedBox(height: 5,),
                  if (!bottomEmpty)
                  _teamInfo(entity?.footTeamName ?? '', entity?.footTeamScore ?? '',alert: entity?.highLight == 1)
                ],
              ),
            ),
            // Spacer(),
            Container(width: 0.5,color: Colors.white.withOpacity(0.50),margin: const EdgeInsets.symmetric(horizontal: 16),),
            SizedBox(
              width: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(entity?.firstTag ?? '',style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 5),
                  Text(entity?.secTag ?? '',style: const TextStyle(fontSize: 14))
                ],
            )),
          ],
        ),
      ),
    ).tap(() {
      final id = event?.data?.matchQxbId;
      final e = event;
      if (id == null || e == null) { return ;}
      if (_GetNotifyConfig.isBasketbool(e)) {
        if (Get.currentRoute == Routes.basketMatchDetail) { return; }
        Get.toNamed(Routes.basketMatchDetail,arguments: id);
        dismiss();
      } else if (_GetNotifyConfig.isSoccer(e)) {
        if (Get.currentRoute == Routes.soccerMatchDetail) { return; }
        Get.toNamed(Routes.soccerMatchDetail,arguments: id);
        dismiss();
      }
    });
  }

  Widget _teamInfo(String team,String scoreValue,{bool alert = false}) {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: alert ? 16 : 14,
        color: alert ? Colors.white : Colors.white.withOpacity(0.8),
        fontWeight: alert ? FontWeight.w500 : FontWeight.w400), 
      child: Row(
        children: [
          Expanded(child: Text(team,maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.left,)),
          Text(scoreValue,maxLines: 1,overflow: TextOverflow.ellipsis)
        ],
      )
    );
  }

}