import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/loading_check_widget.dart';
import 'package:sports/widgets/no_data_widget.dart';

import '../../../logic/team/basketball/bb_team_schedule_controller.dart';
import '../../../model/team/bb_team/bb_team_schedule_entity.dart';
import '../../../res/routes.dart';
import '../../../res/styles.dart';

class BasketTeamScheduleView extends StatefulWidget {
  const BasketTeamScheduleView({super.key});

  @override
  State<BasketTeamScheduleView> createState() => _BasketTeamScheduleViewState();
}

class _BasketTeamScheduleViewState extends State<BasketTeamScheduleView>
    with AutomaticKeepAliveClientMixin {
  final BbTeamScheduleController controller =
      Get.put(BbTeamScheduleController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BbTeamScheduleController>(
      initState: (state) async{
        await controller.requestYears();
        await controller.requestData();
        controller.isLoading = false;
        Future.delayed(Duration(milliseconds: 500)).then((value) => controller.initObserver());
      },
      builder: (controller) {
        return LoadingCheckWidget<bool>(
          isLoading: controller.isLoading,
          loading: Container(),
          data: controller.years.isEmpty,
          child: Container(
            color: Colours.greyF7,
            child: Column(
              children: [
                if(controller.years.isNotEmpty) _pageChoice(),
                Expanded(
                  child: LoadingCheckWidget<int>(
                    isLoading: controller.isLoading,
                    data: controller.matchGroup?.length,
                    loading: Container(),
                    child:
                    // ListViewObserver(
                    //   controller: controller.observerController,
                    //   child:
                    MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: controller.matchGroup?.length == 0?
                        const NoDataWidget():
                        ListView(
                          // controller: controller.isLoading?controller.scrollController:null,
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(controller.matchGroup?.length ?? 0,
                            (index) => _listItem(index).paddingOnly(bottom: controller.matchGroup?.length==index+1?50:0))
                        ),
                      ),
                    // ),
                  )
                )
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _pageChoice() {
    return Container(
      color: Colours.white,
      padding: const EdgeInsets.only(left: 12, right: 8, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
              await controller.showDatePicker();
              await controller.requestData();
              await Future.delayed(const Duration(microseconds: 500)).then(
                  (value) => controller.observerController.jumpTo(
                      index: controller.years[controller.yearIndex].year
                                  .toString() ==
                              DateTime.now().formatedString('yyyy')
                          ? controller.data?.matchGroup?.indexWhere((element) =>
                                  element.title ==
                                  DateTime.now().formatedString('yyyy-MM')) ??
                              0
                          : (controller.data?.matchGroup?.length ?? 1) - 1));
            },
            child: Container(
              height: 24,
              width: 58,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 6, right: 2),
              decoration: BoxDecoration(
                  color: Colours.greyF5F7FA,
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(controller.years[controller.yearIndex].year ?? '',
                        strutStyle: Styles.centerStyle(fontSize: 12),
                        style: const TextStyle(
                            fontSize: 12, color: Colours.text_color)),
                    const SizedBox(width: 2),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Image.asset(Utils.getImgPath('down_arrow.png')),
                    )
                  ]),
            ),
          ),
          Container(width: 5),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  controller.typeList?.length ?? 0,
                  (childIndex) => controller.typeList?[childIndex].leagueName != null?Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () async{
                      controller.getType(childIndex);
                    },
                    child: Container(
                      height: 24,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: controller.typeIndex == childIndex? Colours.redFFECEE : Colours.white
                      ),
                      child: Text(controller.typeList?[childIndex].leagueName ?? "",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: controller.typeIndex == childIndex
                            ? Colours.main_color
                            : Colours.grey66),
                        strutStyle: Styles.centerStyle(fontSize: 14)),
                    ),
                  ),
                ):Container()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listItem(itemIndex) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 12, right: 12),
      decoration: BoxDecoration(
          color: Colours.white, borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: Get.width,
                height: 38,
                alignment: Alignment.center,
                child: Text(
                    "${(controller.matchGroup?[itemIndex].title ?? "").split('-').join('年')}月",
                    style: Styles.mediumText(fontSize: 13))),
            Column(
              children: List.generate(
                  controller.matchGroup?[itemIndex].matchArray?.length ?? 0,
                  (index) => _childItem(
                      controller.matchGroup?[itemIndex].matchArray?[index])),
            )
          ],
        ),
      ),
    );
  }

  Widget _childItem(MatchArray? entity) {
    return GestureDetector(
      onTap: () =>
          Get.toNamed(Routes.basketMatchDetail, arguments: entity?.matchId.toInt()),
      child: Stack(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 16),
                SizedBox(
                  width: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(entity?.matchTime ?? "-",
                          style: Styles.normalSubText(fontSize: 11)),
                      Text(
                        (entity?.leagueName != null && entity?.leagueName != ''
                                ? "${entity!.leagueName}\u2000"
                                : "") +
                            (entity?.kindName != null && entity?.kindName != ''
                                ? entity!.kindName!
                                : ""),
                        style: Styles.normalSubText(fontSize: 11),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
                Container(width: 7),
                Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(entity?.guestName ?? "-",
                          style: Styles.normalText(fontSize: 13),
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Container(
                    alignment: Alignment.centerRight,
                    width: 21,
                    height: 21,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: CachedNetworkImage(
                        placeholder: (context, url) => Styles.placeholderIcon(),
                        errorWidget: (context, url, error) =>
                            Image.asset(Utils.getImgPath("basket_team_logo.png")),
                        imageUrl: entity?.guestLogo ?? ""),
                  ),
                ),
                Container(
                  width: 66,
                  alignment: Alignment.center,
                  child: Text(controller.formScore(1, entity),
                          style: Styles.mediumText(fontSize: 15)),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Container(
                    width: 21,
                    height: 21,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            Styles.placeholderIcon(),
                        errorWidget: (context, url, error) =>
                            Image.asset(Utils.getImgPath("basket_team_logo.png")),
                        imageUrl: entity?.homeLogo ?? ''),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(entity?.homeName ?? '-',
                        style: Styles.normalText(fontSize: 13),
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start),
                  )),
                Container(width: 10)
              ],
            ),
          ),
          if(entity?.matchResult!=null)
          Positioned(
            right: 0,top: 0,
            child: Container(
              height: 14,width: 14,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(2),topRight: Radius.circular(2)),
                color: entity?.matchResult==1?Colours.main:Colours.green
              ),
              child: Text(entity?.matchResult==1?"胜":"负",style: TextStyle(fontSize: 10,color: Colors.white))
          ))
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
