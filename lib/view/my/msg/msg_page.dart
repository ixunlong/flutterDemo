import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:sports/http/apis/mine_api.dart';
import 'package:sports/model/mine/mine_interact_entity.dart';
import 'package:sports/model/mine/mine_msg_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/no_data_widget.dart';

class MsgPage extends StatefulWidget {
  const MsgPage({super.key});

  @override
  State<MsgPage> createState() => _MsgPageState();
}

class _MsgPageState extends State<MsgPage> with SingleTickerProviderStateMixin {

  late final tabController = TabController(length: 2, vsync: this,initialIndex: idx);

  List<MineMsgEntity> msgs = [];
  int msgPage = 1;
  bool msgEnd = false;

  List<MineInteractEntity> interacts = [];
  int interPage = 1;
  bool interEnd = false;

  String getCountString(int c) {
    if (c > 0 && c <= 99) { return "$c"; }

    if (c > 99) { return "99+"; }

    return "";
  } 
  int _msgCount = 0;
  String get msgCount => getCountString(_msgCount);
  int _interCount = 0;
  String get interCount => getCountString(_interCount);
  int idx = 0;

  getUnreadCounts({bool msg = true,bool inter = true}) async {
    final v = await Future.wait([
      msg ? MineApi.getMsgUnreadCount() : Future(() => null),
      inter ? MineApi.getInterUnreadCount() : Future(() => null)]
    );

    if (msg) { _msgCount = v[0] ?? 0; }

    if (inter) { _interCount = v[1] ?? 0; }
    
    update();
  }

  getMsgs() async {
    final page = msgPage;
    final l = await MineApi.getMsg(page: page);
    if (page != msgPage) { return; }
    if (l != null) {
      msgs.addAll(l);
      msgPage += 1;
    }
    msgEnd = (l?.length ?? 1) == 0;
    update();
  }

  getInteracts() async {
    final page = interPage;
    final l = await MineApi.getInteract(page: page);
    if (page != interPage) { return; }
    if (l != null) {
      interacts.addAll(l);
      interPage += 1;
    }
    interEnd = (l?.length ?? 1) == 0;
    update();
  }

  readAllMsg() {
    for (MineMsgEntity msg in msgs) {
      msg.read = 1;
    }
    MineApi.readMsg(0,all: true);
    _msgCount = 0;
    update();
  }

  readAllInter() {
    for (MineInteractEntity element in interacts) {
      element.read = 1;
    }
    MineApi.readInteract(0,all: true);
    _interCount = 0;
    update();
  }

  readMsg(MineMsgEntity msg) {
    MineApi.readMsg(msg.id!).then((value) {
      if (value ?? false) {
        log("read msg success");
        msg.read = 1;
        getUnreadCounts(inter: false);
        update();
      }
    });
  }

  readInteract(MineInteractEntity inter) {
    MineApi.readInteract(inter.id!).then((value) {
      if (value ?? false) {
        inter.read = 1;
        getUnreadCounts(msg: false);
        update();
      }
    });
  }

  readAllCurrent() {
    if (idx == 0) { readAllMsg(); }
    if (idx == 1) { readAllInter(); }
  }

  @override
  void initState() {
    getMsgs();
    getInteracts();
    getUnreadCounts();
    super.initState();
    tabController.addListener(() {
      log("tab listener = ${tabController.index}");
      if (tabController.index != idx) {
        
        readAllCurrent();

        idx = tabController.index;
      }
    });
  }

  @override
  void dispose() {
    readAllCurrent();
    tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: Styles.appBar(
        title: Styles.defaultTabBar(
          fontSize: 16,
          controller: tabController,
          tabs: [
            const Text("系统通知").marginSymmetric(horizontal: 4).badge(msgCount),
            const Text("互动").marginSymmetric(horizontal: 4).badge(interCount)
          ])
          .sized(width: 180,height: 44)
      ),
      backgroundColor: Colours.scaffoldBg,
      body: ExtendedTabBarView(
        controller: tabController,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: _msgContainer(),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: _interContainer(),
          ),
        ],
      ),
    );
  }

  Widget _msgContainer() {
    return EasyRefresh(
      onLoad: msgEnd ? null : () async {
        await getMsgs();
      },
      child: msgs.isEmpty ? const NoDataWidget(tip: "暂无系统通知") : ListView.builder(
        itemCount: msgs.length,
        itemBuilder: (context, index) {
          final msg = msgs[index];
          return _cell1(msg).tap(() { 
            readMsg(msg);
          }).marginOnly(bottom: 10); 
      }));
  }

  Widget _interContainer() {
    return EasyRefresh(
      onLoad: interEnd ? null : () async {
        await getInteracts();
      },
      child: interacts.isEmpty ? const NoDataWidget(tip: "暂无互动消息") : ListView.builder(
        itemCount: interacts.length,
        itemBuilder: (context, index) {
          final inter = interacts[index];
          return _cell2(inter).tap(() { 
            readInteract(inter);
            Utils.doRoute(inter.href ?? "");
          }).marginOnly(bottom: 10);
        },
      ));
  }

  Widget haveRead(int r,Widget child) {
    return Stack(
      children: [
        child,
        if (r == 0)
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colours.main
            ),
          ))
      ],
    );
  }

  Widget _cell1(MineMsgEntity e) {
    
    final c = Container(
      // height: 121,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(e.title ?? "",maxLines: 1,style: TextStyle(fontSize: 16,color: Colours.text_color1,fontWeight: FontWeight.w600),),
          const SizedBox(height: 8,),
          Text.rich(TextSpan(
            style: TextStyle(fontSize: 15,color: Colours.grey99),
            children: [
            TextSpan(text: e.content ?? ""),
            TextSpan(text: " ${e.button ?? ''}",style: TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()..onTap =() => Utils.doRoute(e.url ?? ""))
          ]),maxLines: 99,overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8,),
          Text(e.publishTime ?? "",style: TextStyle(fontSize: 12,color: Colours.grey99),)
        ],
      ),
    );
    return haveRead(e.read ?? 0, c);
  }

  Widget _cell2(MineInteractEntity e) {
    final c = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: e.eventUserLogo ?? "",
              errorWidget: (context, url, error) => Styles.placeholderIcon(),
              placeholder: (context, url) => Styles.placeholderIcon()
            )
          ).marginOnly(right: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              Text.rich(TextSpan(
                style: TextStyle(fontSize: 15),
                children: [
                TextSpan(text: e.eventUserName ?? "",style: TextStyle(color: Colours.text_color1,fontWeight: FontWeight.w600)),
                TextSpan(text: " ${e.typeContent}",style: TextStyle(color: Colours.grey66)), 
              ])),
              if ((e.eventContent ?? "").trim().isNotEmpty)
              Text(e.eventContent ?? "",maxLines: 2,style: TextStyle(fontSize: 14,color: Colours.text_color1),).marginSymmetric(vertical: 4),
              Text(e.eventTime ?? "",style: TextStyle(color: Colours.grey99,fontSize: 12),)
            ],).marginSymmetric(horizontal: 5),
          ),
          Container(
            clipBehavior: Clip.hardEdge,
            width: 46,
            height: 46,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colours.greyF5F5F5,
              borderRadius: BorderRadius.circular(2)
            ),
            child: Text(e.originContent ?? "",style: const TextStyle(fontSize: 10,color: Colours.grey99,height: 1.3),overflow: TextOverflow.ellipsis,maxLines: 3),
          )
        ],
      ),
    );
    return haveRead(e.read ?? 0, c);
  }
}