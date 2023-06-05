import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/service/um_service.dart';
import 'package:sports/model/expert/expert_focus_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/common_button.dart';
import 'package:sports/widgets/loading_check_widget.dart';
import 'package:sports/widgets/no_data_widget.dart';

class MyFocusExpertView extends StatefulWidget {
  const MyFocusExpertView({super.key});

  @override
  State<MyFocusExpertView> createState() => _MyFocusExpertViewState();
}

class _MyFocusExpertViewState extends State<MyFocusExpertView>
    with AutomaticKeepAliveClientMixin {
  int page = 1;
  int pageSize = 15;
  int total = 0;
  bool isLoading = true;
  List<Contents> list = [];
  List<String> justUnFocus = [];
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
    return EasyRefresh(
      controller: refresh,
      onRefresh: () async {
        await getNew();
      },
      onLoad: () async {
        await getMore();
      },
      child: LoadingCheckWidget<int>(
        isLoading: isLoading,
        loading: Container(
            width: Get.width,
            height: 50,
            alignment: Alignment.center,
            child: const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    color: Colours.text_color, strokeWidth: 2))),
        data: list.length,
        noData: NoDataWidget(
          tip: '暂无关注的专家',
          needScroll: true,
          buttonText: "去关注",
          onTap: () => Get.toNamed(Routes.expertAll),
        ),
        child: ListView.builder(
            itemBuilder: (context, index) => _cell(index),
            itemCount: list.length),
      ),
    );
  }

  _cell(int index) {
    Contents data = list[index];
    return GestureDetector(
      onTap: () {
        Get.find<UmService>().payOriginRoute = 'zjzy';
        Utils.onEvent('wd_wdgz_djzj');
        Get.toNamed(Routes.expertDetail, arguments: data.id!);
      },
      child: Container(
        color: Colours.white,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
              child: Row(children: [
                Container(
                  alignment: Alignment.center,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colours.greyEE, width: 0.5),
                    shape: BoxShape.circle),
                  child: CachedNetworkImage(
                    width: 42,
                    height: 42,
                    fit: BoxFit.cover,
                    imageUrl: data.logo!,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  data.name!,
                  style: TextStyle(
                      color: Colours.text_color1, fontWeight: FontWeight.w500),
                ),
                Spacer(),
                CommonButton(
                  onPressed: () => onFocus(data),
                  minHeight: 24,
                  minWidth: 56,
                  side: BorderSide(
                      color: justUnFocus.contains(data.id!)
                          ? Colours.main_color
                          : Colours.grey_color1,
                      width: 0.5),
                  text: justUnFocus.contains(data.id!) ? '关注' : '已关注',
                  textStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: justUnFocus.contains(data.id!)
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

  Future getNew() async {
    page = 1;
    ExpertFocusEntity? data = await Api.expertFocusList(page, pageSize);
    justUnFocus = [];
    if (data?.contents != null && data?.total != null) {
      list = data!.contents!;
      total = data.total!;
      refresh.resetFooter();
    }
    isLoading = false;
    setState(() {});
  }

  Future getMore() async {
    page++;
    ExpertFocusEntity? data = await Api.expertFocusList(page, pageSize);
    if (data?.contents != null) {
      list.addAll(data!.contents!);
      if (data.contents!.length < 15) {
        refresh.finishLoad(IndicatorResult.noMore);
      } else {
        refresh.finishLoad(IndicatorResult.success);
      }
    }
    setState(() {});
  }

  onFocus(Contents data) async {
    if (justUnFocus.contains(data.id!)) {
      Utils.onEvent('wd_wdgz_gzan', params: {'wd_wdgz_gzan': '1'});
      Api.expertFocus(data.id!);
      justUnFocus.remove(data.id!);
    } else {
      Utils.onEvent('wd_wdgz_gzan', params: {'wd_wdgz_gzan': '0'});
      final result = await Utils.alertQuery('确认不再关注');
      if (result == true) {
        Api.expertUnfocus(data.id!);
        justUnFocus.add(data.id!);
      }
    }
    update();
  }

  @override
  bool get wantKeepAlive => true;
}
