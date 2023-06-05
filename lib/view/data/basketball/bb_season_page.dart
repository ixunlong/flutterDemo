import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/data/basketball/bb_data_season_controller.dart';
import 'package:sports/model/data/league_channel_entity.dart';

import '../../../res/colours.dart';
import '../../../res/styles.dart';
import '../../../util/utils.dart';
import '../../../widgets/common_button.dart';

class BbSeasonPage extends StatefulWidget {
  const BbSeasonPage({Key? key, this.id, this.type}) : super(key: key);

  final int? id;
  final int? type;

  @override
  State<BbSeasonPage> createState() => _BbSeasonPageState();
}

class _BbSeasonPageState extends State<BbSeasonPage> with AutomaticKeepAliveClientMixin{
  late BbDataSeasonController controller = Get.put(BbDataSeasonController(),tag: "${widget.id}${widget.type ?? ""}");
  String tag = "";
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<BbDataSeasonController>(
      tag: "${widget.id}${widget.type ?? ""}",
      initState: (state){
        controller.request(widget.id,"${widget.id}${widget.type ?? ""}");
        tag = "${widget.id}${widget.type ?? ""}";
      },
      didUpdateWidget: (oldWidget,state){
        if(tag != "${widget.id}${widget.type ?? ""}" && controller.seasonList.isNotEmpty) {
          controller.getData(widget.id,"${widget.id}${widget.type ?? ""}");
          tag = "${widget.id}${widget.type ?? ""}";
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
              // Utils.onEvent("sjpd_lx",params: {"sjpd_lx":0});
              controller.showDatePicker();
            },
            child: Container(
              key: ValueKey(widget.id),
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
                    Text(controller.season.length > 4?
                    ("${controller.season.substring(2,4)}/${controller.season.substring(7,9)}")
                    :controller.season,
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
