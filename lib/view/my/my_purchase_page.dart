import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/mine/order_list_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/expert/expert_list_item.dart';
import 'package:sports/widgets/loading_check_widget.dart';
import 'package:sports/widgets/no_data_widget.dart';

import '../../res/styles.dart';
import '../../widgets/describe_dialog.dart';

class MyPurchasePage extends StatefulWidget {
  const MyPurchasePage({super.key});

  @override
  State<MyPurchasePage> createState() => _MyPurchasePageState();
}

class _MyPurchasePageState extends State<MyPurchasePage> {
  final List<String> viewStatus = [
    "",
    "expert_hong.png",
    "expert_hei.png",
    "",
    "expert_zou.png",
    "2zhong1.png",
    "3zhong1.png",
    "3zhong2.png"
  ];
  int page = 1;
  int pageSize = 10;
  bool isLoading = true;
  List<OrderListEntity>? list;
  EasyRefreshController refresh =
      EasyRefreshController(controlFinishLoad: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      getNew();
    });
  }

  getNew() async {
    page = 1;
    List<OrderListEntity>? result = await Api.orderList(page, pageSize);
    if (result != null) {
      setState(() {
        list = result;
        refresh.resetFooter();
        isLoading = false;
      });
    }
  }

  getMore() async {
    page++;
    List<OrderListEntity>? result = await Api.orderList(page, pageSize);
    if (result != null) {
      setState(() {
        list!.addAll(result);
        if (result.length < pageSize) {
          refresh.finishLoad(IndicatorResult.noMore);
        } else {
          refresh.finishLoad(IndicatorResult.success);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.appBar(title: const Text('我的已购')),
      backgroundColor: Colours.scaffoldBg,
      body: EasyRefresh(
        onRefresh: () => getNew(),
        onLoad: () => getMore(),
        controller: refresh,
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
          noData: NoDataWidget(
            tip: '你还没有订单哦',
          ),
          data: list?.length,
          child: ListView.builder(
            itemCount: list?.length ?? 0,
            itemBuilder: (context, index) {
              return _cell(index);
            },
          ),
        ),
      ),
    );
  }

  _cell(int index) {
    OrderListEntity data = list![index];
    return Container(
      margin: EdgeInsets.only(left: 10, top: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colours.white,
      ),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 18),
      child: Column(children: [
        Container(
          height: 52,
          child: Row(children: [
            GestureDetector(
              onTap: () => Get.toNamed(Routes.expertDetail,
                  arguments: data.expertId,
                  parameters: {"index": "${(data.sportsId ?? 1) - 1}"}),
              child: Row(children: [
                ClipOval(
                    child: CachedNetworkImage(
                  imageUrl: data.expertLogo ?? '',
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                )),
                SizedBox(width: 10),
                Text(
                  data.expertName ?? '',
                  style: TextStyle(color: Colours.text_color, fontSize: 15),
                ),
                SizedBox(width: 6),
                Image.asset(
                  Utils.getImgPath('arrow_right.png'),
                  width: 6,
                  height: 10,
                )
              ]),
            ),
            Spacer(),
            Text(
              data.status == 1 ? '已完成' : '已退款',
              style: TextStyle(color: Colours.text_color1, fontSize: 12),
            )
          ]),
        ),
        Container(
          width: double.infinity,
          height: 0.5,
          color: Colours.grey_color2,
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Utils.onEvent('wd_wdyg_djgd');
            Get.toNamed(Routes.expertViewpoint, arguments: data.planId);
          },
          child: Stack(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                plan(data),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (data.couponInfo1 != null) ...[
                            Row(
                              children: [
                                Text(
                                  '${data.couponInfo1}',
                                  style: TextStyle(
                                      color: Colours.grey_color1, fontSize: 12),
                                ),
                                Text(
                                  '${data.couponInfo2}',
                                  style: TextStyle(
                                      color: Colours.main, fontSize: 12),
                                )
                              ],
                            ),
                            SizedBox(height: 4),
                          ],
                          Text(
                            '下单时间 ${data.createTime}',
                            style: TextStyle(
                                color: Colours.grey_color1, fontSize: 12),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '订单编号 ${data.id}',
                                style: TextStyle(
                                    color: Colours.grey_color1, fontSize: 12),
                              ),
                              SizedBox(width: 2),
                              GestureDetector(
                                onTap: () {
                                  // Clipboard.setData(
                                  //     ClipboardData(text: data.id));
                                  // ToastUtils.show("已复制订单编号");
                                },
                                child: Image.asset(
                                  Utils.getImgPath('copy_1.png'),
                                  width: 16,
                                  height: 16,
                                ),
                              ),
                            ],
                          ),
                          data.activityId != null
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    children: [
                                      Text(
                                        "本单享受${data.activityId == 1 ? "首购不中退款" : "粉丝不中退款"}",
                                        strutStyle:
                                            Styles.centerStyle(fontSize: 12),
                                        style: const TextStyle(
                                            color: Colours.grey99,
                                            fontSize: 12),
                                      ),
                                      Container(width: 4),
                                      Image.asset(
                                              width: 11,
                                              height: 11,
                                              Utils.getImgPath(
                                                  "question_mark.png"))
                                          .tap(() {
                                        Get.dialog(const DescribeDialog(
                                            content: [
                                              "1) 观点不中：观点推荐选项首选和次选均不中，则为不中。",
                                              "2) 不中退时间：比赛赛果确认后的半小时内，实付红钻金额自动退款至红钻余额内。"
                                            ],
                                            title: "不中退说明",
                                            confirmText: "知道了"));
                                      })
                                    ],
                                  ),
                                )
                              : Container(),
                        ]),
                    Column(
                      children: [
                        Text(
                          '实付${data.gold!.toStringAsFixed(2)}红钻',
                          style: TextStyle(
                              color: Colours.text_color1,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            if (viewStatus[int.parse(data.planStatus!)].isNotEmpty)
              Positioned(
                  top: 10,
                  right: 0,
                  child: Image.asset(Utils.getImgPath(
                      viewStatus[int.parse(data.planStatus!)])))
          ]),
        ),
      ]),
    );
  }

  Widget plan(OrderListEntity data) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: data.matchList!.map((e) => oneMatch(e)).toList(),
    );
  }

  Widget oneMatch(MatchList e) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          e.matchInfo ?? '',
          style: const TextStyle(
              color: Colours.text_color1,
              fontSize: 15,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 5),
        ...e.playInfoList!
            .map(
              (info) => Row(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                    // height: 14,
                    // width: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.5,
                          color: Colours.main_color,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(2))),
                    child: Text(
                      ViewType.playType(e.playType.toString()),
                      style: TextStyle(
                          fontSize: 10, color: Colours.main_color, height: 1),
                      strutStyle: StrutStyle(
                          forceStrutHeight: true, height: 1.1, fontSize: 10),
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    '${info.code}：${info.name}  ',
                    style: TextStyle(
                        color: info.win == 1
                            ? Colours.main_color
                            : Colours.text_color1),
                    strutStyle: Styles.centerStyle(fontSize: 14),
                  )
                ],
              ),
            )
            .toList(),
        SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 0.5,
          color: Colours.greyEE,
        )
      ],
    );
  }
}
