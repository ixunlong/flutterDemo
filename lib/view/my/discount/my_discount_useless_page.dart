import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/mine/my_coupon_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/utils.dart';

import 'package:sports/view/my/discount/my_discount_card_widget.dart';
import 'package:sports/widgets/no_data_widget.dart';

import '../../../res/styles.dart';

class MyDiscountUselessPage extends StatefulWidget {
  const MyDiscountUselessPage({super.key});

  @override
  State<MyDiscountUselessPage> createState() => _MyDiscountUselessPageState();
}

class _MyDiscountUselessPageState extends State<MyDiscountUselessPage> {
  List<MyCouponEntity>? coupons;
  final refreshController = EasyRefreshController(
      controlFinishRefresh: true, controlFinishLoad: true);
  final scrollController = ScrollController();

  requestCoupons() async {
    final getCoupons = await Api.coupon.myCoupons(status: 0) ?? [];
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
        title: Text("已使用/已过期券"),
      ),
      backgroundColor: Colours.scaffoldBg,
      body: EasyRefresh(
        controller: refreshController,
        onRefresh: () async {
          await requestCoupons();
          refreshController.finishRefresh();
        },
        onLoad: (coupons?.isEmpty ?? true)
            ? null
            : () async {
                refreshController.finishLoad(IndicatorResult.noMore);
              },
        footer: ClassicFooter(
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
        child: ListView.builder(
          controller: scrollController,
          itemCount: (coupons?.isEmpty ?? false) ? 1 : (coupons?.length ?? 0),
          padding: EdgeInsets.only(
              left: 12,
              right: 12,
              bottom: MediaQuery.of(context).padding.bottom),
          itemBuilder: (context, index) {
            if (coupons?.isEmpty ?? false) {
              return NoDataWidget(
                tip: '暂无相关优惠券',
              );
            }
            final coupon = coupons?[index];
            return MyDiscountCardWidget(
              toUse: false,
              myCoupon: coupon,
            ).marginOnly(top: 12);
          },
        ),
      ),
    );
  }
}
