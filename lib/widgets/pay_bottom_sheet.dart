import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/model/use1_coupon_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/my/discount/my_discount_card_widget.dart';
import 'package:sports/view/my/discount/my_discount_describe_page.dart';
import 'package:sports/widgets/no_data_widget.dart';

import 'common_bottomsheet.dart';
import 'common_button.dart';

const _grey99 = Color(0xff999999);
const _grey66 = Color(0xff666666);
const _greyEE = Color(0xffeeeeee);
const _textBlack = Color(0xff292d32);
const _textGrey = Color(0xffcccccc);
const _bgGrey = Color(0xfff2f2f2);
const _red1 = Color(0xFFF53F3F);

class DiscountBottomSheet extends StatefulWidget {
  const DiscountBottomSheet({super.key, required this.coupons, this.selected});

  final List<Use1CouponEntity> coupons;
  final Use1CouponEntity? selected;

  @override
  State<DiscountBottomSheet> createState() => _DiscountBottomSheetState();
}

class _DiscountBottomSheetState extends State<DiscountBottomSheet> {
  List<Use1CouponEntity> get coupons => widget.coupons;
  Use1CouponEntity? get selected => widget.selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 461,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: Colours.greyF7,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 56.5,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                    child: Row(
                  children: [
                    Image.asset(
                      Utils.getImgPath("arrow_left1.png"),
                      width: 24,
                      height: 24,
                    ).tap(() {
                      Get.back();
                    })
                  ],
                )),
                Text("选择优惠券"),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CommonButton(
                      onPressed: () {
                        Get.dialog(MyDiscountDescribeDialog());
                      },
                      text: "使用说明",
                      foregroundColor: Colours.grey666666,
                      textStyle:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    )
                  ],
                ))
              ],
            ),
          ),
          coupons.isEmpty
              ? const Expanded(
                  child: Center(
                  child: NoDataWidget(tip: "无可用优惠券"),
                ))
              : Expanded(
                  child: ListView.builder(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 12),
                  // children: [
                  //   ...List.generate(6, (index) => MyDiscountCardWidget(selectable: true).marginOnly(bottom: 10))
                  // ],
                  itemCount: coupons.length,
                  itemBuilder: (context, index) {
                    final entity = coupons[index];
                    bool isEnd = index == coupons.length - 1;
                    return MyDiscountCardWidget(
                            selectable: true,
                            selected: entity.id == selected?.id,
                            use1Coupon: entity)
                        .marginOnly(bottom: isEnd ? 0 : 10)
                        .tap(() {
                      if (entity.canUse == 1) {
                        Get.back(result: entity);
                      }
                    });
                  },
                )),
          SizedBox(height: 10),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 16),
            height: 44,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(4)),
            child: Text("不使用优惠券"),
          ).tap(() {
            log("不使用优惠券");
            Get.back(result: false);
          }),
          SizedBox(height: 20)
        ],
      ),
    );
  }
}

class PayBottomBackPara {
  PayBottomBackPara({this.is2pay = false, this.coupon});
  bool is2pay;
  Use1CouponEntity? coupon;
}

class PayBottomSheet extends StatefulWidget {
  const PayBottomSheet(
      {super.key, required this.amount, this.coupons = const []});

  final String amount;
  final List<Use1CouponEntity> coupons;

  static Future show(String amount,
      {List<Use1CouponEntity> coupons = const []}) async {
    return await Get.bottomSheet(
            CommonBottomSheet(
                child: PayBottomSheet(amount: amount, coupons: coupons)),
            enterBottomSheetDuration: Duration(milliseconds: 100),
            isDismissible: false) ??
        false;
  }

  @override
  State<PayBottomSheet> createState() => _PayBottomSheetState();
}

class _PayBottomSheetState extends State<PayBottomSheet> {
  double get amount => double.parse(widget.amount);
  // PlanInfoEntity? get plan => widget.plan;

  int canUseCount = 0;
  Use1CouponEntity? selectCoupon;
  List<Use1CouponEntity> get coupons => widget.coupons;
  double get price => amount - (selectCoupon?.gold ?? 0);

  @override
  void initState() {
    Get.find<ConfigService>().tipEnable = false;
    super.initState();
    for (final element in coupons) {
      if (element.autoSelect == 1) {
        selectCoupon = element;
      }
      if (element.canUse == 1) {
        canUseCount += 1;
      }
    }
  }

  @override
  void dispose() {
    Get.find<ConfigService>().tipEnable = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      child: Column(
        children: [
          Text(
            "确认支付",
            style: TextStyle(fontSize: 16, color: _textBlack),
          ),
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  // textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(price.toStringAsFixed(2),
                        style: TextStyle(
                            fontSize: 36,
                            color: _textBlack,
                            fontWeight: FontWeight.w500)),
                    Padding(
                      padding: EdgeInsets.only(bottom: 7),
                      child: Text(' 红钻',
                          style: TextStyle(
                              fontSize: 20,
                              color: _textBlack,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                // Text.rich(
                //   TextSpan(children: [
                //     TextSpan(
                //         text: price.toStringAsFixed(2),
                //         style: TextStyle(fontSize: 36)),
                //     TextSpan(text: " 红钻", style: TextStyle(fontSize: 20))
                //   ]),
                //   style:
                //       TextStyle(color: _textBlack, fontWeight: FontWeight.w500),
                // ),
                if (selectCoupon != null)
                  Text(
                    amount.toStringAsFixed(2),
                    style: TextStyle(
                        fontSize: 12,
                        color: Colours.grey_color1,
                        decoration: TextDecoration.lineThrough),
                  ),
              ])),
          discountLine(),
          const SizedBox(height: 10),
          CommonButton(
            onPressed: () {
              Get.back(
                  result:
                      PayBottomBackPara(is2pay: true, coupon: selectCoupon));
            },
            text: "确认支付",
            foregroundColor: Colors.white,
            backgroundColor: _red1,
            minWidth: double.infinity,
            radius: 4,
            textStyle: TextStyle(fontWeight: FontWeight.w500),
          ).marginOnly(top: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(text: "支付即代表您已同意"),
                style: TextStyle(fontSize: 12, color: _grey99),
              ).paddingOnly(top: 14, bottom: 14),
              CommonButton(
                onPressed: () {
                  Get.toNamed(Routes.webview,
                      arguments: {"url": Constant.payPolicyUrl});
                },
                text: "《用户充值协议》",
                textStyle: TextStyle(fontSize: 12),
              )
            ],
          ).marginOnly(bottom: 10),
        ],
      ),
    );
  }

  Widget discountLine() {
    Widget discountDesc =
        const Text("不使用优惠券", style: TextStyle(color: Colours.main_color));
    if (selectCoupon != null) {
      discountDesc = Row(
        children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
              height: 14,
              decoration: BoxDecoration(
                  color: Colours.main_color,
                  borderRadius: BorderRadius.circular(3)),
              child: Text(
                "${selectCoupon?.typeUpper ?? ""}${selectCoupon?.typeLower ?? ""}",
                style:
                    TextStyle(color: Colors.white, fontSize: 10, height: 1.4),
              )).marginOnly(right: 2.5),
          Text(
            "-${selectCoupon?.gold?.toStringAsFixed(2)}红钻",
            style:
                TextStyle(fontSize: 14, color: Colours.main_color, height: 1.4),
          ),
        ],
      );
    } else if (canUseCount == 0) {
      discountDesc = Text(
        "暂无可用",
        style: TextStyle(fontSize: 14, color: Colours.grey_color1),
      );
    }

    return Container(
      height: 52,
      padding: EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
          color: Colours.greyF5F7FA, borderRadius: BorderRadius.circular(4)),
      child: Row(
        children: [
          Image.asset(Utils.getImgPath("my_discount_wallet.png")),
          SizedBox(
            width: 5,
          ),
          Text("优惠券"),
          Spacer(),
          discountDesc,
          SizedBox(width: 6),
          Image.asset(Utils.getImgPath("arrow_right.png"))
        ],
      ),
    ).tap(() async {
      log("selected = ${selectCoupon}");
      final result = await Get.bottomSheet(
          DiscountBottomSheet(coupons: coupons, selected: selectCoupon),
          isDismissible: false,
          barrierColor: Colors.transparent);
      if (result is Use1CouponEntity) {
        selectCoupon = result;
      } else if (result == false) {
        selectCoupon = null;
      }
      update();
    });
  }
}
