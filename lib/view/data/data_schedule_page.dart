import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:sports/logic/data/data_schedule_controller.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/data/data_schedule_item.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../res/colours.dart';
import '../../res/styles.dart';
import '../../widgets/loading_check_widget.dart';

class DataSchedulePage extends StatefulWidget {
  const DataSchedulePage({Key? key,this.leagueId, required this.tag}) : super(key: key);

  final int? leagueId;
  final String tag;

  @override
  State<DataSchedulePage> createState() => _DataSchedulePageState();
}
class _DataSchedulePageState extends State<DataSchedulePage>
    with AutomaticKeepAliveClientMixin{
  late DataScheduleController controller;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<DataScheduleController>(
      tag: widget.tag,
      initState: (state){
        controller = Get.put(DataScheduleController(
            widget.leagueId,
            seasonTag: widget.tag),
            tag: widget.tag);
      },
      didUpdateWidget: (oldWidget,state) {
        if (controller.visible) {
          controller = Get.put(DataScheduleController(
              widget.leagueId, seasonTag: widget.tag),
              tag: widget.tag);
          controller.getData();
        }
      },
      builder: (controller) {
        return VisibilityDetector(
          key: Key(widget.tag),
          onVisibilityChanged: (VisibilityInfo info) {
            controller.visible = !info.visibleBounds.isEmpty;
          },
          child: LoadingCheckWidget<int>(
            isLoading: controller.isLoading,
            loading: Container(),
            data: controller.data?.length,
            child: controller.isLoading?Container():Column(
              children: [
                _round(),
                Expanded(
                  child: EasyRefresh(
                    onRefresh: controller.getData,
                    child: ListViewObserver(
                      controller: controller.observerController,
                      onObserve: (model){
                        controller.setCurrentItem(model.firstChild?.index);
                        controller.setRound(controller.data?[model.firstChild?.index ?? 0].round);
                      },
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView(
                          // physics: const ClampingScrollPhysics(),
                          controller: controller.scrollController,
                          children: List.generate(
                            controller.data?.length ?? 0, (index) => DataScheduleItem(data: controller.data?[index])),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _round() {
    return Container(
      color: Colours.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
              onTap: () {
                controller.setCurrentItem(controller.currentItem - 1);
                controller.observerController.animateTo(
                    index: controller.currentItem,
                    duration: const Duration(milliseconds: 300), curve: Curves.easeOut,
                    alignment: 1/(controller.data![controller.currentItem].teamList!.length + 1));
              },
              child: Container(
                  color: Colours.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                  child: Image.asset(Utils.getImgPath("arrow_left.png")))
          ),
          GestureDetector(
            onTap: () async{
              await controller.showDatePicker();
              controller.observerController.jumpTo(
                  index: controller.currentItem,
                  alignment: 1/(controller.data![controller.currentItem].teamList!.length + 1));
            },
            child: Container(
              color: Colours.transparent,
              height: 38,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 30,right: 16),
              child: Row(
                  children: [
                    Text(
                      // RegExp(r"[0-9]").hasMatch(controller.round)?
                      // "第${controller.round}轮":
                        controller.round,
                        strutStyle: Styles.centerStyle(fontSize: 12),
                        style: Styles.mediumText(fontSize: 13)),
                    const Icon(Icons.arrow_drop_down,size: 16,color: Colours.grey_color1)
                  ]),
            ),
          ),
          GestureDetector(
              onTap: (){
                controller.setCurrentItem(controller.currentItem + 1);
                controller.observerController.animateTo(
                    index: controller.currentItem,
                    duration: const Duration(milliseconds: 300), curve: Curves.easeOut,
                    alignment: 1/(controller.data![controller.currentItem].teamList!.length + 1));
              },
              child: Container(
                  color: Colours.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                  child: Image.asset(Utils.getImgPath("arrow_right.png")))
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
