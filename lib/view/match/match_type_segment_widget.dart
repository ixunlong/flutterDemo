import 'dart:async';

import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sports/logic/match/match_all_controller.dart';
import 'package:sports/logic/match/match_page_controller.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/utils.dart';

class MatchTypeWidget extends StatefulWidget {
  // ScrollController? scrollController;
  // MatchListProvider controller;
  //0 足球 1篮球
  int type;
  bool firstLoad;
  QuickFilter matchType;
  Function(QuickFilter index)? onTap;
  MatchTypeWidget(this.type, this.firstLoad, this.matchType,
      {super.key, this.onTap});

  @override
  State<MatchTypeWidget> createState() => _MatchTypeWidgetState();
}

class _MatchTypeWidgetState extends State<MatchTypeWidget> {
  //底部选择是否展开
  bool expandSelect = false;
  Timer? timer;
  bool hideSegment = true;

  // MatchListProvider controller = Get.find<MatchAllController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      PrimaryScrollController.of(context).addListener(() {
        if (expandSelect) {
          setState(() {
            hideSegment = true;
            expandSelect = false;
            timer?.cancel();
          });
        }
      });
    });
  }

  @override
  void dispose() {
    // widget.scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: Get.width,
          height: 34,
        ),
        segment(),
        if (!widget.firstLoad)
          Positioned(
            child: AnimatedOpacity(
                opacity: expandSelect ? 1 : 0,
                duration: Duration(milliseconds: 300),
                child: Visibility(
                  visible: !hideSegment,
                  child: MatchTypeSegmentWidget(
                    (index) {
                      if (timer != null) {
                        timer?.cancel();
                      }
                      Future.delayed(Duration(seconds: 1))
                          .then((value) => onExpand());

                      // hideSegment = false;
                      // startTimer();
                      if (widget.onTap != null) {
                        widget.onTap!(QuickFilter.values[index]);
                      }
                    },
                    QuickFilter.values.indexOf(widget.matchType),
                    widget.type,
                    key: Key(widget.matchType.toString()),
                  ),
                )),
          ),
      ],
    );
  }

  segment() {
    return AnimatedPositioned(
        // right: 8,
        right: expandSelect ? 100 : 8,
        duration: Duration(milliseconds: 300),
        child: AnimatedOpacity(
          opacity: expandSelect ? 0 : 1,
          onEnd: () {
            if (!expandSelect) {
              hideSegment = true;
            }
          },
          duration: Duration(milliseconds: 300),
          child: GestureDetector(
            onTap: () => onExpand(),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    color: Colours.main,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 4),
                          color: Colours.main.withOpacity(0.1),
                          blurRadius: 4)
                    ]),
                alignment: Alignment.center,
                width: 68,
                height: 34,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      Utils.getImgPath(getMatchTypeImage(widget.matchType)),
                      width: 16,
                    ),
                    SizedBox(width: 2),
                    Text(
                      widget.matchType.convertString(widget.type),
                      style: TextStyle(color: Colours.white, fontSize: 12),
                    )
                  ],
                )),
          ),
        ));
  }

  onExpand() {
    hideSegment = !hideSegment;
    expandSelect = !expandSelect;
    if (expandSelect) {
      startTimer();
    }
    update();
  }

  startTimer() {
    if (timer != null) {
      timer?.cancel();
    }
    timer = Timer.periodic(Duration(seconds: 4), (timer) {
      timer.cancel();
      onExpand();
    });
  }

  String getMatchTypeImage(QuickFilter type) {
    String matchTypeImage = 'quanbu_select.png';
    if (type == QuickFilter.yiji) {
      matchTypeImage = 'yiji_select.png';
    } else if (type == QuickFilter.jingcai) {
      matchTypeImage = 'jingzu_select.png';
    }
    return matchTypeImage;
  }
}

class MatchTypeSegmentWidget extends StatefulWidget {
  int initialIndex;
  Function(int) onSelectIndex;
  int type;
  MatchTypeSegmentWidget(this.onSelectIndex, this.initialIndex, this.type,
      {super.key});

  @override
  State<MatchTypeSegmentWidget> createState() => _MatchTypeSegmentWidgetState();
}

class _MatchTypeSegmentWidgetState extends State<MatchTypeSegmentWidget> {
  late int index;
  @override
  void initState() {
    super.initState();
    index = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(17), boxShadow: [
        BoxShadow(
            offset: Offset(0, 4),
            color: Colours.main.withOpacity(0.1),
            blurRadius: 4)
      ]),
      height: 34,
      child: CustomSlidingSegmentedControl<int>(
        initialValue: index,
        padding: 13,
        // height: 40,
        innerPadding: EdgeInsets.all(0),
        children: {
          0: item('全部', 'quanbu_select.png', 'quanbu_unselect.png', index == 0),
          1: item('一级', 'yiji_select.png', 'yiji_unselect.png', index == 1),
          2: item(widget.type == 0 ? '竞足' : '竞篮', 'jingzu_select.png',
              'jingzu_unselect.png', index == 2),
          3: item(
              '方案', 'guandian_select.png', 'guandian_unselect.png', index == 3),
          4: item(
              '情报', 'qingbao_select.png', 'qingbao_unselect.png', index == 4),
        },
        decoration: BoxDecoration(
          color: Color(0xFFFFE0E0),
          borderRadius: BorderRadius.circular(17),
        ),
        thumbDecoration: BoxDecoration(
          color: Color(0xFFF53F3F),
          borderRadius: BorderRadius.circular(17),
        ),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
        onValueChanged: (v) {
          widget.onSelectIndex(v);
          index = v;
          update();
        },
      ),
    );
  }

  item(String title, String selectImage, String unselectImage, bool select) {
    return Row(children: [
      Image.asset(
        Utils.getImgPath(select ? selectImage : unselectImage),
        width: 16,
      ),
      SizedBox(width: 2),
      Text(
        title,
        style: TextStyle(
            color: select ? Colours.white : Colours.main, fontSize: 12),
      )
    ]);
  }
}
