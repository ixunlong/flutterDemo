import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/data/league_channel_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:get/get.dart';
import 'package:sports/util/tip_resources.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import '../../res/styles.dart';
import 'channel_filter/select_item_widget.dart';

class DataChannelFilterPage extends StatefulWidget {
  const DataChannelFilterPage({super.key});

  @override
  State<DataChannelFilterPage> createState() => _DataChannelFilterPageState();
}

class _DataChannelFilterPageState extends State<DataChannelFilterPage> {
  bool editable = false;

  // List<ChannelItem> selectedChannels = List.generate(6, (index) => ChannelItem("$index",index));
  // List<ChannelGroup> channelGroups = List.generate(10, (index) {
  //   final len = math.Random().nextInt(10) + 10;
  //   return ChannelGroup("group $index", List.generate(len, (idx) => ChannelItem("$index - $idx", 10000 * (index + 1) + idx)));
  // });
  final topScrollController = ScrollController();
  final scrollController = ScrollController();
  final leftScrollController = ScrollController();
  late final contentController =
      ListObserverController(controller: scrollController);

  List<LeagueChannelEntity> myChannels = [];
  Map<int, LeagueChannelEntity> myChannelsMap = {};
  List<LeagueChannelAreaEntity> areas = [];
  LeagueChannelAreaEntity? area;
  String selectCountry = "";

  updateChannelsMap() => myChannelsMap = myChannels
      .asMap()
      .map((key, value) => MapEntry(value.leagueId ?? 0, value));

  requestMyChannels() async {
    final channels = await Api.myLeagueChannels();
    log("get my league channels ${channels?.map((e) => e.leagueId)}");
    if (channels == null) {
      return;
    }
    myChannels = channels;
    updateChannelsMap();
    update();
  }

  requestChannelsAll() async {
    final areas = await Api.leagueChannelsAll();
    if (areas == null) {
      return;
    }
    this.areas = areas;
    area = areas
        .firstWhereOrNull((element) => element.area == (area?.area ?? "欧洲"));
    if (area == null && areas.isNotEmpty) {
      area = areas.first;
    }
    if (area != null &&
        (area?.list?.isNotEmpty ?? false) &&
        selectCountry.isEmpty) {
      selectCountry = area?.list?.first.country ?? "";
    }
    update();
  }

  updateMyChannels() async {
    final r = await Api.updateLeagueChannel(myChannels);
    log("update league channels $r");
    if (!r) {
      await Api.updateLeagueChannel(myChannels);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestMyChannels();
    requestChannelsAll();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  clickEdit() async {
    if (User.isLogin) {
      editable = !editable;
      if (!editable) {
        updateMyChannels();
      }
      update();
    } else {
      await User.needLogin(() => null);
      requestMyChannels();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(Utils.getImgPath("bottomsheet_close.png"),
                width: 24, height: 24)
            .tap(
          () {
            Get.back();
          },
        ),
        actions: [
          Center(
            child: Text(
              editable ? "完成" : "编辑",
              style: TextStyle(
                  color: editable ? Colours.main_color : Colours.text_color1,
                  fontWeight: FontWeight.w500),
            ).paddingSymmetric(horizontal: 16, vertical: 5).tap(
              () {
                if (editable) {
                  Utils.onEvent('sjpd_pdbj_pdbj',
                      params: {'sjpd_pdbj_pdbj': '2'});
                } else {
                  Utils.onEvent('sjpd_pdbj_pdbj',
                      params: {'sjpd_pdbj_pdbj': '1'});
                }
                clickEdit();
              },
            ),
          ),
          // TextButton(
          //   onPressed: () {
          //     clickEdit();
          //   },
          //   style: TextButton.styleFrom(
          //     foregroundColor: Colors.black
          //   ),
          //   child: Text(editable ? "完成" : "编辑"),
          // )
        ],
      ),
      body: Container(
        // height: Get.height - MediaQuery.of(context).padding.top - 100,
        color: const Color(0xFFF5F5F5),
        child: Column(
          children: [
            // _topRow(),
            _selectedChannels(),
            const SizedBox(height: 10),
            _areaBar(),
            Expanded(
                child: Row(
              children: [_leftList(), Expanded(child: _contentList())],
            ))
          ],
        ),
      ),
    );
  }

  final _gkey = GlobalKey();

  Widget _topRow() {
    return Container(
      color: Colors.white,
      height: 44,
      child: Row(
        children: [
          SizedBox(
            width: 16,
          ),
          Image.asset(Utils.getImgPath("bottomsheet_close.png"),
                  width: 24, height: 24)
              .tap(
            () {
              Get.back();
            },
          ),
          Spacer(),
          TextButton(
            onPressed: () {
              clickEdit();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            child: Text(editable ? "完成" : "编辑"),
          )
        ],
      ),
    );
  }

  Widget _selectedChannels() {
    final itemwidth = 36 + 18;
    final ratio = itemwidth / 75;
    final space = (Get.width - 32) - (36 + 18) * 5;
    final children = myChannels
        .map((e) => SelectItemWidget(
            key: ValueKey(e.leagueId),
            imgUrl: e.leagueLogo ?? "",
            name: e.leagueName ?? "",
            selected: editable ? true : null,
            longPress: editable
                ? null
                : () {
                    editable = true;
                    update();
                  },
            selectFn: () {
              log("click item");
              if (!editable) {
                Get.back<int?>(result: e.leagueId);
                return;
              }
              if (myChannels.length == 1) {
                ToastUtils.show("我的频道至少保留一个赛事");
                return;
              }
              myChannels.remove(e);
              myChannelsMap.remove(e.leagueId);
              update();
            }))
        .toList();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 200,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "我的频道",
                style: TextStyle(fontSize: 16, color: Colours.text_color1),
              ),
              Spacer(),
              if (!editable)
                Text(
                  "点击进入赛事，长按编辑，拖拽排序",
                  style: TextStyle(color: Colours.grey99, fontSize: 12),
                )
            ],
          ).marginSymmetric(horizontal: 0),
          SizedBox(
            height: 16,
          ),
          Expanded(
            child: children.isEmpty
                ? Container()
                : DraggableGridViewBuilder(
                    shrinkWrap: false,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        childAspectRatio: ratio,
                        crossAxisSpacing: space / 4),
                    children: children
                        .map((e) =>
                            DraggableGridItem(child: e, isDraggable: true))
                        .toList(),
                    dragCompletion: (list, beforeIndex, afterIndex) {
                      final item = myChannels.removeAt(beforeIndex);
                      myChannels.insert(afterIndex, item);
                    },
                  ),
            // child: ReorderableBuilder(
            //   // enableLongPress: true,
            //   enableDraggable: editable,
            //   automaticScrollExtent: 160,
            //   scrollController: topScrollController,
            //   dragChildBoxDecoration: BoxDecoration(),
            //   children: myChannels.map((e) => SelectItemWidget(
            //     key: ValueKey(e.leagueId),
            //     imgUrl: e.leagueLogo ?? "", name: e.leagueName ?? "",selected: editable ? true : null,
            //     longPress: editable ? null : () {
            //       editable = true;
            //       update();
            //     },
            //     selectFn: () {
            //       log("click item");
            //       if (!editable) {
            //         Get.back<int?>(result: e.leagueId);
            //         return;
            //       }
            //       if (myChannels.length == 1) {
            //         ToastUtils.show("我的频道至少保留一个赛事");
            //         return;
            //       }
            //       myChannels.remove(e);
            //       myChannelsMap.remove(e.leagueId);
            //       update();
            //     })).toList(),
            // // scrollController: _scontroller,
            // onReorder: (p0) {
            //   for (OrderUpdateEntity re in p0) {
            //     final item = myChannels.removeAt(re.oldIndex);
            //     myChannels.insert(re.newIndex, item);
            //   }
            // },
            // builder: (children){
            //   return GridView(
            //     key: _gkey,
            //     controller: topScrollController,
            //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //         crossAxisCount: 5,
            //         crossAxisSpacing: space / 4,
            //         childAspectRatio: ratio
            //       ),
            //     children: children
            //   );
            // })
          ),
        ],
      ),
    );
  }

  Widget _areaBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 44,
      child: ListView(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        children: [
          ...areas.map(
            (e) {
              return Container(
                margin: EdgeInsets.only(right: 10),
                alignment: Alignment.center,
                child: Container(
                  width: 60,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: e.area == area?.area
                              ? Colours.main_color
                              : Colours.grey666666),
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    "${e.area}",
                    style: TextStyle(
                        fontSize: 14,
                        color: e.area == area?.area
                            ? Colours.main_color
                            : Colours.grey666666),
                  ),
                ).tap(() {
                  area = e;
                  if (e.list?.isNotEmpty ?? false) {
                    selectCountry = e.list?.first.country ?? "";
                  }
                  update();
                }),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _leftList() {
    return Container(
      width: 80,
      color: Color(0xFFF5F7FA),
      child: ListView(
        controller: leftScrollController,
        children: [
          ...(area?.list ?? []).map((LeagueChannelCountryEntity e) {
            final selected = selectCountry == e.country;
            return Container(
              color: selected ? Colors.white : null,
              height: 44,
              child: Row(
                children: [
                  Container(
                    width: 3,
                    color: selected ? Colours.main_color : null,
                  ),
                  Expanded(
                      child: Text(
                    e.country ?? "",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13,
                        color: selected
                            ? Colours.main_color
                            : Colours.text_color1),
                  )),
                  SizedBox(width: 3)
                ],
              ),
            ).tap(() {
              // final key = _contentKeys[index] as GlobalKey;
              // final box = key.currentContext?.findRenderObject() as RenderBox;
              // final off = box.localToGlobal(Offset(0,0));
              // _contentScrollController.animateTo(index * 230, duration: Duration(milliseconds: 200), curve: Curves.linear);

              final index = area?.list?.indexOf(e) ?? -1;
              log("click left list $index");
              if (index < 0 || index >= (area?.list?.length ?? 0)) {
                return;
              }
              // selectGroupTitle = e.title;
              selectCountry = e.country ?? "";
              contentController.jumpTo(index: index);
              update();
            });
          }).toList()
        ],
      ),
    );
  }

  Widget _contentList() {
    final contentWidth = (Get.width - 80 - 16);
    final itemWidth = 36 + 18;
    final ratio = itemWidth / 75;
    final space = contentWidth - itemWidth * 4;
    log("content width = $contentWidth itemwidth = $itemWidth");
    return Container(
        padding: EdgeInsets.all(8),
        color: Colors.white,
        child: ListViewObserver(
          controller: contentController,
          onObserve: (p0) {
            final countries = area?.list;
            final index = p0.firstChild?.index;
            if (countries != null &&
                index != null &&
                countries.length > index) {
              selectCountry = countries[index].country ?? "";
              final offset = index * 44.0;
              if (leftScrollController.offset > offset) {
                leftScrollController.animateTo(offset,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.linear);
              } else if (leftScrollController.offset + 300 < offset) {
                leftScrollController.animateTo(offset - 300,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.linear);
              }
              update();
            }
          },
          child: ListView.builder(
              controller: scrollController,
              itemCount: area?.list?.length ?? 0,
              itemBuilder: (context, index) {
                final LeagueChannelCountryEntity country =
                    (area?.list?[index])!;
                final list = (country.list ?? []).filter(
                    (item) => myChannelsMap[item.leagueId ?? 0] == null);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 38,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          country.country ?? "",
                          style: TextStyle(
                              fontSize: 13,
                              color: Colours.text_color1,
                              fontWeight: FontWeight.w600),
                        )),
                    if (list.isEmpty)
                      Container(
                        height: 75,
                        alignment: Alignment.center,
                        child: Text(
                          "已全部添加到我的频道",
                          style: TextStyle(
                              color: Colours.text_color1, fontSize: 12),
                        ),
                      ),
                    if (list.isNotEmpty)
                      GridView.builder(
                        itemCount: list.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: space / 3,
                            childAspectRatio: ratio),
                        itemBuilder: (context, index) {
                          final channel = list[index];
                          return SelectItemWidget(
                              imgUrl: channel.leagueLogo ?? "",
                              name: channel.leagueName ?? "",
                              selected: false,
                              longPress: editable
                                  ? null
                                  : () {
                                      editable = true;
                                      update();
                                    },
                              selectFn: () {
                                // if (!editable) { return; }
                                myChannels.add(channel);
                                myChannelsMap[channel.leagueId ?? 0] = channel;
                                if (!editable) {
                                  updateMyChannels();
                                }
                                update();
                              });
                        },
                      ).marginOnly(bottom: 10)
                  ],
                );
              }),
        ));
  }
}
