import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/team/my_team_focus_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/common_button.dart';
import 'package:sports/widgets/loading_check_widget.dart';
import 'package:sports/widgets/no_data_widget.dart';

class MyFocusTeamView extends StatefulWidget {
  const MyFocusTeamView({super.key});

  @override
  State<MyFocusTeamView> createState() => _MyFocusTeamViewState();
}

class _MyFocusTeamViewState extends State<MyFocusTeamView>
    with AutomaticKeepAliveClientMixin {
  List<MyTeamFocusEntity> list = [];
  bool isLoading = true;
  // List<Contents> list = [];
  // List<String> justUnFocus = [];
  EasyRefreshController refresh =
      EasyRefreshController(controlFinishLoad: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getNew();
    });
  }

  @override
  Widget build(BuildContext context) {
    return (!isLoading && list.isEmpty)
        ? NoDataWidget(
            tip: '暂无关注球队',
            buttonText: '去关注',
            onTap: goSelectTeam)
        : Column(
            children: [
              Expanded(
                child: EasyRefresh(
                  controller: refresh,
                  onRefresh: () async {
                    await getNew();
                  },
                  // onLoad: () async {
                  //   await getMore();
                  // },
                  child: LoadingCheckWidget<int>(
                    isLoading: isLoading,
                    noData: const NoDataWidget(needScroll: true),
                    loading: Container(
                        width: Get.width,
                        height: 50,
                        alignment: Alignment.center,
                        child: const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colours.text_color, strokeWidth: 2))),
                    data: list,
                    child: ListView.builder(
                        itemBuilder: (context, index) => _cell(index),
                        itemCount: list.length),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: CommonButton.large(
                    onPressed: goSelectTeam,
                    text: '关注更多球队',
                    backgroundColor: Colours.white,
                    side: BorderSide(color: Colours.greyEE),
                    textStyle: TextStyle(
                        color: Colours.grey66,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              )
            ],
          );
  }

  _cell(int index) {
    MyTeamFocusEntity data = list[index];
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.soccerTeamDetail, arguments: data.id);
      },
      child: Container(
        color: Colours.white,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
              child: Row(children: [
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colours.greyEE, width: 0.5),
                    borderRadius: BorderRadius.circular(150),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: data.logo!,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  data.nameChsShort ?? '',
                  style: TextStyle(
                      color: Colours.text_color1, fontWeight: FontWeight.w500),
                ),
                Spacer(),
                CommonButton(
                  onPressed: () => onFocus(data),
                  minHeight: 24,
                  minWidth: 56,
                  side: BorderSide(
                      color: data.focus == 0
                          ? Colours.main_color
                          : Colours.grey_color1,
                      width: 0.5),
                  text: data.focus == 0 ? '关注' : '已关注',
                  textStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: data.focus == 0
                          ? Colours.main_color
                          : Colours.grey_color1),
                )
              ]),
            ),
            Container(
              margin: EdgeInsets.only(left: 16),
              height: 0.5,
              color: Colours.grey_color2,
            )
          ],
        ),
      ),
    );
  }

  goSelectTeam() async {
    Utils.onEvent('wd_wdgz_gzan', params: {'wd_wdgz_gzan': '3'});
    await Get.toNamed(Routes.selectFocusTeam);
    getNew();
  }

  Future getNew() async {
    List<MyTeamFocusEntity>? result = await Api.teamFocusList();
    // justUnFocus = [];
    if (result != null) {
      list = result;
    }
    isLoading = false;
    update();
  }

  // Future getMore() async {
  //   page++;
  //   ExpertFocusEntity? data = await Api.expertFocusList(page, pageSize);
  //   if (data?.contents != null) {
  //     list.addAll(data!.contents!);
  //     if (data.contents!.length < 15) {
  //       refresh.finishLoad(IndicatorResult.noMore);
  //     } else {
  //       refresh.finishLoad(IndicatorResult.success);
  //     }
  //   }
  //   setState(() {});
  // }

  onFocus(MyTeamFocusEntity data) async {
    if (data.focus == 1) {
      final alert = await Utils.alertQuery('确认不再关注');
      if (alert == true) {
        final result = await Api.focusTeam(data.id!, 2);
        if (result == 200) {
          data.focus = 0;
        } else {
          ToastUtils.showDismiss("取消关注失败");
        }
      }
    } else {
      final result = await Api.focusTeam(data.id!, 1);
      if (result == 200) {
        data.focus = 1;
      }
    }
    update();
  }

  @override
  bool get wantKeepAlive => true;
}
