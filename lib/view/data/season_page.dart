import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/model/data/league_channel_entity.dart';

import '../../logic/data/data_season_controller.dart';
import '../../res/colours.dart';
import '../../res/styles.dart';
import '../../util/utils.dart';
import '../../widgets/common_button.dart';

class SeasonPage extends StatefulWidget {
  const SeasonPage({Key? key, this.data, this.type}) : super(key: key);

  final LeagueChannelEntity? data;
  final int? type;

  @override
  State<SeasonPage> createState() => _SeasonPageState();
}

class _SeasonPageState extends State<SeasonPage> with AutomaticKeepAliveClientMixin{
  late DataSeasonController controller = Get.put(DataSeasonController(),tag: "${widget.data?.leagueId}${widget.type ?? ""}");
  String tag = "";
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<DataSeasonController>(
      tag: "${widget.data?.leagueId}${widget.type ?? ""}",
      initState: (state){
        controller.getData(widget.data,"${widget.data?.leagueId}${widget.type ?? ""}");
        tag = "${widget.data?.leagueId}${widget.type ?? ""}";
      },
      didUpdateWidget: (oldWidget,state){
        if(tag != "${widget.data?.leagueId}${widget.type ?? ""}") {
          controller.getData(widget.data,"${widget.data?.leagueId}${widget.type ?? ""}");
          tag = "${widget.data?.leagueId}${widget.type ?? ""}";
        }
      },
      builder: (controller) {
        return SizedBox(
          height: Get.height,
          child: Column(
              children: [
                pageChoice(),
                Expanded(
                    child: controller.isLoading?Container()
                    :PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: controller.pageController,
                      onPageChanged: (index) => controller.setIndex(index),
                      children: controller.page,
                    ))
              ]),
        );
      }
    );
  }

  Widget pageChoice(){
    return Padding(
      padding: const EdgeInsets.only(left: 12,right:8,top: 5,bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Utils.onEvent("sjpd_lx",params: {"sjpd_lx":0});
              controller.showDatePicker();
            },
            child: Container(
              key: ValueKey(widget.data?.leagueId),
              height: 24,
              width: 57,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 6,right: 2),
              decoration: BoxDecoration(
                  color: Colours.greyF5F7FA,
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(controller.currentSeason.length > 4?
                    ("${controller.currentSeason.substring(2,4)}/${controller.currentSeason.substring(7,9)}")
                    :controller.currentSeason,
                      strutStyle: Styles.centerStyle(fontSize: 12),
                      style: const TextStyle(fontSize: 12,color: Colours.text_color)),
                    const SizedBox(width: 2),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Image.asset(Utils.getImgPath('down_arrow.png')),
                    )
                  ]),
            ),
          ),
          Container(width: 6),
          Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                controller.typeList.length, (childIndex) => Flexible(
                  flex: 1,
                  child: CommonButton(
                  minWidth: 58,
                    minHeight: 24,
                    onPressed: () async{
                      Utils.onEvent("sjpd_lx",params: {"sjpd_lx":controller.umengList.indexOf(controller.typeList[childIndex])});
                        controller.pageController.jumpToPage(childIndex);
                    },
                    text: controller.typeList[childIndex],
                    backgroundColor:
                    controller.typeIndex == childIndex ? Colours.redFFECEE : Colours.white,
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: controller.typeIndex == childIndex
                        ? Colours.main_color
                        : Colours.grey66),
                  ),
            ),
          ))
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
