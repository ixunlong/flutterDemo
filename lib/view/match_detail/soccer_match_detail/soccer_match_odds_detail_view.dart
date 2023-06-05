import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/match/soccer_match_odds_detail_controller.dart';
import 'package:sports/model/match/match_info_entity.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/data/data_left_list.dart';
import 'package:sports/widgets/loading_check_widget.dart';

import '../../../res/colours.dart';
import '../../../widgets/custom_indicator.dart';

class SoccerMatchOddsDetailView extends StatelessWidget {
  SoccerMatchOddsDetailView({Key? key}) : super(key: key);

  final controller = Get.put(SoccerMatchOddsDetailController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SoccerMatchOddsDetailController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: controller.detail.info?.topColor ?? Colours.red_color,
          appBar: Styles.appBar(
            backgroundColor: controller.detail.info?.topColor ?? Colours.red_color,
            titleTextStyle: const TextStyle(fontSize: 14,color: Colours.white),
            title: SizedBox(
              width: MediaQuery.of(context).size.width - 140,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Text(controller.detail.info?.baseInfo?.homeName ?? "",
                    overflow: TextOverflow.ellipsis).alignEnd),
                  const Text(" vs "),
                  Expanded(child: Text(controller.detail.info?.baseInfo?.guestName ?? "",
                    overflow: TextOverflow.ellipsis).alignStart)
                ]),
            ),
            leadingColor: Colours.white
          ),
          body: Container(
            decoration: const BoxDecoration(
                color: Colours.white,
                borderRadius: BorderRadius.only( topRight: Radius.circular(10),topLeft: Radius.circular(10)) ),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: TabBar(
                    controller: controller.tabController,
                    tabs: List.generate(
                        controller.typeList.length,
                            (index) =>
                            Tab(text: controller.typeList[index])),
                    indicator: const CustomIndicator(
                        borderSide: BorderSide(
                            width: 2, color: Colours.main_color),
                        indicatorBottom: 1,
                        indicatorWidth: 15),
                    labelColor: Colours.main_color,
                    labelPadding:
                    const EdgeInsets.symmetric(horizontal: 5),
                    unselectedLabelColor: Colours.grey_color,
                    labelStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                    unselectedLabelStyle: const TextStyle(fontSize: 16),
                    onTap: (value) {
                      controller.typeIndex = value;
                    },
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: controller.tabController,
                    children: List.generate(
                      controller.typeList.length, (index) =>
                        LoadingCheckWidget<int>(
                          isLoading: false,
                          data: controller.companies[index].length,
                          child: Row(
                            children: [
                              DataLeftList(
                                  controller.companies[index].map((e) => e.name ?? "").toList(),
                                  controller.selectIndex[index],
                                      (p0) {
                                    controller.setSelectIndex(index, p0);
                                    controller.requestData(p0);
                                  }),
                              Expanded(
                                  child: rightPage(index)
                              )
                            ],
                          ),
                        )
                    )
                  ),
                )
              ],
            ),
          )
        );
      }
    );
  }

  Widget rightPage(int i){
    return Column(
      children: [
        Container(height: 7),
        Row(
          children: [
            Expanded(flex: 2,child: Text(controller.headTypeList[i][0],style: Styles.normalSubText(fontSize: 12)).center),
            Expanded(flex: 2,child: Text(controller.headTypeList[i][1],style: Styles.normalSubText(fontSize: 12)).center),
            Expanded(flex: 2,child: Text(controller.headTypeList[i][2],style: Styles.normalSubText(fontSize: 12)).center),
            Expanded(flex:1,child: Text("时",style: Styles.normalSubText(fontSize: 12).copyWith(color: Colours.transparent)).center),
            Expanded(flex:3,child: Text("时间",style: Styles.normalSubText(fontSize: 12)).center)
          ],
        ).paddingSymmetric(horizontal: 16),
        Expanded(
          child: LoadingCheckWidget<int>(
            isLoading: false,
            data: controller.data[i].length,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: List.generate(controller.data[i].length, (index) {
                  var entity = controller.data[i][index];
                  var data = controller.formSingleLine(controller.data[i][index].data ?? []);
                  return Container(
                    height: 44,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colours.greyEE,width: 0.5))
                    ),
                    child: Row(
                      children: [
                        Expanded(flex: 2,child: (entity.closed == "封"? Text("-",style: TextStyle(fontSize: 12,color: Colours.text_color)):data[0]).center),
                        Expanded(flex: 2,child:
                        (i == 1 || i == 3?
                        Text(entity.line ?? "",
                            style: TextStyle(fontSize: 12,color: Colours.text_color))
                            :entity.closed == "封"? Text("封",style: TextStyle(fontSize: 12,color: Colours.text_color)):data[1]).center),
                        Expanded(flex: 2,child: (entity.closed == "封"? Text("-",style: TextStyle(fontSize: 12,color: Colours.text_color)):data[2]).center),
                        Expanded(flex:1,child: Stack(
                          children: [
                            SizedBox(height: Get.height,child: Text("时",style: Styles.normalSubText(fontSize: 12).copyWith(color: Colours.transparent)).center),
                            if(entity.beginFlag == true)Positioned(child: Image.asset(Utils.getImgPath("odds_match_begin.png")))
                          ],
                        )),
                        Expanded(flex: 3,child: Text(entity.updateTime.isNullOrEmpty == true?"":DateTime.parse(entity!.updateTime!).formatedString("MM/dd HH:mm"),style: const TextStyle(fontSize: 12,color: Colours.grey99)).center)
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        )
      ],
    );
  }
}