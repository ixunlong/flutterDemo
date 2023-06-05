import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/my/coin_history_controller.dart';
import 'package:sports/model/mine/coin_history_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/widgets/no_data_widget.dart';
import '../../res/styles.dart';
import 'package:sports/util/date_utils_extension.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/loading_check_widget.dart';
import 'package:sticky_headers/sticky_headers.dart';

class CoinHistoryPage extends StatefulWidget {
  const CoinHistoryPage({super.key});

  @override
  State<CoinHistoryPage> createState() => _CoinHistoryPageState();
}

class _CoinHistoryPageState extends State<CoinHistoryPage> {
  final controller = Get.put(CoinHistoryController());
  final refresh = EasyRefreshController(controlFinishLoad: true);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.appBar(
        title: Text('红钻明细'),
      ),
      body: EasyRefresh(
        controller: refresh,
        onRefresh: () async {
          await controller.getData();
          refresh.resetFooter();
        },
        onLoad: () async {
          List<CoinHistoryEntity>? data = await controller.getMore();
          if (data != null && data.length < controller.pageSize) {
            refresh.finishLoad(IndicatorResult.noMore);
          } else {
            refresh.finishLoad(IndicatorResult.success);
          }
        },
        child: GetBuilder<CoinHistoryController>(
          builder: (_) {
            return LoadingCheckWidget<int>(
              isLoading: controller.isLoading,
              noData: NoDataWidget(needScroll: true),
              loading: Container(
                  width: Get.width,
                  height: 50,
                  alignment: Alignment.center,
                  child: const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colours.text_color, strokeWidth: 2))),
              data: controller.dateList?.length,
              child: ListView.builder(
                  itemCount: controller.dateList?.length ?? 0,
                  itemBuilder: (context, index) {
                    return StickyHeader(
                      header: Container(
                        height: 30.0,
                        color: Colours.greyF5F5F5,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        alignment: Alignment.center,
                        child: Text(
                          '${DateFormat.yM('zh_cn').format(controller.dateList![index])}',
                          style: const TextStyle(
                              color: Colours.grey_color, fontSize: 12),
                        ),
                      ),
                      // content: ListView.separated(
                      //   shrinkWrap: true,
                      //   itemCount: controller.groupCoinList![index].length,
                      //   itemBuilder: (context, i) {
                      //     return _cell(controller.groupCoinList![index][i]);
                      //   },
                      //   separatorBuilder: (context, index) => Container(
                      //     height: 0.5,
                      //     width: double.infinity,
                      //     color: Colours.grey_color2,
                      //   ),
                      // )

                      content: Column(
                          children: List.generate(
                              controller.groupCoinList![index].length,
                              (index1) => _cell(
                                  controller.groupCoinList![index][index1],
                                  (index ==
                                          controller.groupCoinList!.length -
                                              1) &&
                                      (index1 ==
                                          controller
                                                  .groupCoinList!.last.length -
                                              1)))),
                    );
                    // return Theme(
                    //   data:
                    //       Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    //   child: ExpansionTile(
                    //     initiallyExpanded: true,
                    //     // trailing: Text('bbbb'),
                    //     title: Text('2022年7月'),
                    //     // backgroundColor: Colours.grey_color1,
                    //     // collapsedBackgroundColor: Colors.red,
                    //     children: [
                    //       _cell(),
                    //       _cell(),
                    //       _cell(),
                    //       _cell(),
                    //       _cell(),
                    //     ],
                    //   ),
                    // );
                    // },
                  }),
            );
          },
        ),
      ),
    );
  }

  _cell(CoinHistoryEntity data, bool isLast) {
    // CoinHistoryEntity data = controller.list![index];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Get.toNamed(Routes.coinDetial, arguments: data.id);
      },
      child: Container(
          padding: EdgeInsets.fromLTRB(16, 18, 16, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    Utils.getImgPath(
                        data.goldSign == 1 ? 'coin_add.png' : 'coin_minus.png'),
                    width: 44,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(children: [
                          Text(
                            data.memo ?? '',
                            style: TextStyle(
                                color: Colours.text_color, fontSize: 15),
                          ),
                          Spacer(),
                          Text(
                              (data.goldSign == 1 ? '+' : '-') +
                                  (data.goldChange!.toStringAsFixed(2)),
                              style: TextStyle(
                                  color: Colours.main_color,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500)),
                        ]),
                        SizedBox(height: 4),
                        Row(children: [
                          Text(
                              DateUtilsExtension.formatDateString(
                                  data.createTime!, 'MM-dd HH:mm'),
                              style: TextStyle(
                                  color: Colours.grey_color, fontSize: 12)),
                          Spacer(),
                          Text('余额 ${data.goldAfter!.toStringAsFixed(2)}',
                              style: TextStyle(
                                  color: Colours.grey_color, fontSize: 12))
                        ])
                      ],
                    ),
                  ),
                  // Column(
                  //   children: [Text('7-10 11:11'), Spacer(), Text('余额 100')],
                  // )
                ],
              ),
              SizedBox(height: 18),
              if (!isLast)
                Container(
                  padding: EdgeInsets.only(left: 16),
                  height: 0.5,
                  width: double.infinity,
                  color: Colours.grey_color2,
                )
            ],
          )),
    );
  }
}
