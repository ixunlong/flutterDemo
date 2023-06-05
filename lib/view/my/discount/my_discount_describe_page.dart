import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sports/model/home/lbt_entiry.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/tip_resources.dart';
import 'package:sports/widgets/common_button.dart';

class MyDiscountDescribeDialog extends StatelessWidget {
  MyDiscountDescribeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _content()
        ],
      ),
    );
  }

  final List<LbtEntity> tips = TipResources.discountDescribes ?? [
    LbtEntity(content: "1) 每个订单只能使用一张优惠券，不能累计重复使用。"),
    LbtEntity(content: "2) 优惠券请在有效期内使用，不支持兑现、找零。"),
    LbtEntity(content: "3) 优惠券仅支持允许使用“优惠券”的商品。"),
    LbtEntity(content: "4) 使用优惠券下单后如取消订单，系统恢复该优惠券，并可以再次使用。")
  ];

  Widget _content() {
    return Container(
      width: 280,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8)
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.only(top: 8),
            height: 62,
            alignment: Alignment.center,
            child: Text("优惠券使用说明",style: TextStyle(fontSize: 16,color: Colours.text_color,fontWeight: FontWeight.w600),),
          ),
          ...tips.map((e) => Text(e.content ?? "",style: TextStyle(fontSize: 14,color: Colours.grey666666)).marginOnly(bottom: 5)),
          CommonButton(onPressed: (){
            Get.back();
          },
          minHeight: 44,
          backgroundColor: Colours.main_color,
          foregroundColor: Colors.white,
          radius: 4,
          text: "知道了").marginOnly(bottom: 24,top: 16)
        ],
      ),
    );
  }
}

class MyDiscountDescribePage extends StatefulWidget {
  const MyDiscountDescribePage({super.key});

  @override
  State<MyDiscountDescribePage> createState() => _MyDiscountDescribePageState();
}

class _MyDiscountDescribePageState extends State<MyDiscountDescribePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}