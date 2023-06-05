import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/mine/my_coupon_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/my/discount/my_discount_card_widget.dart';
import 'package:sports/view/my/discount/my_discount_useless_page.dart';
import 'package:sports/widgets/no_data_widget.dart';

import '../../../res/styles.dart';
import '../../../widgets/describe_dialog.dart';

class MyDiscountPage extends StatefulWidget {
  const MyDiscountPage({super.key});

  @override
  State<MyDiscountPage> createState() => _MyDiscountPageState();
}

class _MyDiscountPageState extends State<MyDiscountPage> {
  List<MyCouponEntity>? coupons;

  final refreshController = EasyRefreshController(
      controlFinishRefresh: true, controlFinishLoad: true);
  final scrollController = ScrollController();

  requestCoupons() async {
    final getCoupons = await Api.coupon.myCoupons(status: 1) ?? [];
    coupons = getCoupons;
    update();
  }

  @override
  void initState() {
    super.initState();
    // requestCoupons();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refreshController.callRefresh(scrollController: scrollController);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.appBar(
        title: Text("优惠券"),
        actions: [
          // IconButton(onPressed: (){
          //   log("message");
          //   Get.to(Activity1zhePage());
          // }, icon: Icon(Icons.abc))
        ],
      ),
      backgroundColor: Colours.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: EasyRefresh.builder(
              controller: refreshController,
              onRefresh: () async {
                await requestCoupons();
                refreshController.finishRefresh();
              },
              onLoad: () async {
                // await Future.delayed(Duration(seconds: 1));
                refreshController.finishLoad(IndicatorResult.noMore);
              },
              footer: ClassicFooter(
                position: IndicatorPosition.locator,
                dragText: "上拉刷新",
                armedText: "松开刷新",
                failedText: "刷新失败",
                readyText: "正在加载更多的数据...",
                processingText: "正在加载更多的数据...",
                processedText: "刷新完成",
                noMoreText: "没有更多优惠券了~",
                messageText: '上次更新时间 %T',
                noMoreIcon: Container(),
                failedIcon: Container(),
                iconDimension: 0,
                spacing: 0,
                showMessage: false,
                textStyle: TextStyle(fontSize: 12),
                messageStyle: TextStyle(fontSize: 10),
                // progressIndicatorSize: 32.0
              ),
              childBuilder: (context, physics) {
                return (coupons?.isEmpty ?? false)?
                  NoDataWidget(needScroll: true, physics: physics,tip: '暂无可用优惠券'
                  ): Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: CustomScrollView(
                          controller: scrollController,
                          physics: physics,
                          slivers: [
                            SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    childCount: (coupons?.isEmpty ?? false)
                                        ? 1
                                        : (coupons?.length ?? 0),
                                    (context, index) {
                              final coupon = coupons?[index];
                              return MyDiscountCardWidget(myCoupon: coupon)
                                  .marginOnly(top: 12);
                            })),
                            const FooterLocator.sliver()
                          ],
                        ),
                      );
              },
            )),
            _bottomRow()
          ],
        ),
      ),
    );
  }

  Widget _bottomBtn(String title, FutureOr Function() onPressed,
      {bool icon = false}) {
    return TextButton(
        style: TextButton.styleFrom(
            textStyle: TextStyle(fontSize: 12),
            foregroundColor: Colours.grey666666),
        onPressed: onPressed,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title),
            SizedBox(width: 5),
            // RightArrowWidget(width: 4,height: 7,color: Colours.grey666666,)
            if (icon)
              Image.asset(Utils.getImgPath("arrow_right.png"),
                  width: 4, height: 7)
          ],
        ));
  }

  Widget _bottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _bottomBtn("优惠券使用说明", () {
          // Get.to(()=>MyDiscountDescribePage());
          Get.dialog(const DescribeDialog(
            content: [
              "1) 每个订单只能使用一张优惠券，不能累计重复使用。",
              "2) 优惠券请在有效期内使用，不支持兑现、找零。",
              "3) 优惠券仅支持允许使用“优惠券”的商品。",
              "4) 使用优惠券下单后如取消订单，系统恢复该优惠券，并可以再次使用。"
            ],
            title: "优惠券使用说明",
            confirmText: '知道了',
          ));
        }),
        Container(
          color: Color(0xffd9d9d9),
          width: 1,
          height: 10,
        ).marginSymmetric(horizontal: 4),
        _bottomBtn("已过期/已使用券", () {
          Get.to(() => MyDiscountUselessPage());
        }, icon: true),
      ],
    );
  }
}
