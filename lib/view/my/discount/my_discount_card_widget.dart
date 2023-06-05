import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/model/mine/my_coupon_entity.dart';
import 'package:sports/model/use1_coupon_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/common_button.dart';

class DashSeparator extends StatelessWidget {
  const DashSeparator({Key? key, this.height = 1, this.color = Colors.black})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 8.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}

enum MyDiscountUselessType {
  none,
  notStart,
  used,
  expired,
  notfit,
}

extension MyCouponEntityEx1 on MyCouponEntity {

  MyDiscountUselessType? get uselessType => {
    0:MyDiscountUselessType.none,
    -1:MyDiscountUselessType.notStart,
    1:MyDiscountUselessType.used,
    2:MyDiscountUselessType.expired,
  }[status];

}

class MyDiscountCardWidget extends StatefulWidget {
  const MyDiscountCardWidget({super.key,
    this.selectable = false,
    this.selected = false,
    this.toUse = true,
    this.myCoupon,
    this.use1Coupon});

  final bool selectable;
  final bool selected;
  final bool toUse;
  final MyCouponEntity? myCoupon;
  final Use1CouponEntity? use1Coupon;

  @override
  State<MyDiscountCardWidget> createState() => _MyDiscountCardWidgetState();
}

class _MyDiscountCardWidgetState extends State<MyDiscountCardWidget> {

  MyCouponEntity? get myCoupon => widget.myCoupon;
  Use1CouponEntity? get u1coupon => widget.use1Coupon;

  MyDiscountUselessType? get uselessType => myCoupon?.uselessType ?? (u1coupon?.canUse == 1 ? MyDiscountUselessType.none : null);
  bool get enable => uselessType == MyDiscountUselessType.none || uselessType == MyDiscountUselessType.notStart;
  bool get toUse => widget.toUse && (widget.myCoupon?.useUrl != null);
  bool get selectable => widget.selectable;
  bool get selected => widget.selected;
  String get title => widget.myCoupon?.name ?? u1coupon?.name ?? "";
  String get bottomDescribe => widget.myCoupon?.remark ?? u1coupon?.remark ?? "";
  String get condition => myCoupon?.condition ?? u1coupon?.condition ?? "";
  String get typeUpper => myCoupon?.typeUpper ?? u1coupon?.typeUpper ?? "";
  String get typeLower => myCoupon?.typeLower ?? u1coupon?.typeLower ?? "";
  String get limit => myCoupon?.maxLimit ?? "";
  // double get discountZhe => 8;
  late DateTime startTime;
  late DateTime endTime;

  Timer? t;

  @override
  void initState() {
    super.initState();
    t = Timer.periodic(Duration(seconds: 1), (timer) {
      update();
    });
    startTime = DateTime.tryParse(myCoupon?.startTime ?? u1coupon?.startTime ?? "") ?? DateTime.now();
    endTime = DateTime.tryParse(myCoupon?.endTime ?? u1coupon?.endTime ?? "") ?? DateTime.now();
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  Widget _timeDesc(Color? disableColor) {
    Widget text = Text("");
    final isUseless = (uselessType == MyDiscountUselessType.expired || uselessType == MyDiscountUselessType.used);
    final tstyle = TextStyle(fontSize: 12,color: disableColor ?? Colours.grey66);
    final now = DateTime.now();
    if (isUseless) {
      text = Text("有效期至${endTime.formatedString("yyyy.MM.dd")}",style: tstyle,);
    } else if (startTime.difference(now).inSeconds > 0) {
      String msg = "";
      final dif = startTime.difference(now);
      final days = dif.inDays;
      final hours = dif.inHours - dif.inDays * 24;
      final minutes = dif.inMinutes - dif.inHours * 60;
      final seconds = dif.inSeconds - dif.inMinutes * 60;
      final nums = [days,hours,minutes,seconds];
      final names = ["天","小时","分钟","秒"];
      
      var valid = false;
      for (var i = 0; i < nums.length; i++) {
        if (!valid) { valid = nums[i] > 0;}
        if (valid) {
          final num = nums[i];
          msg += "${"00$num".lastString(2)}${names[i]}";
        }
      }
      msg += "后";
      
      text = Text.rich(TextSpan(
        style: tstyle,
        children: [
          TextSpan(text: "待生效",style: TextStyle(color: Color(0xFF2766D6))),
          TextSpan(text: msg)
        ]
      ));
    } else if (endTime.difference(now).inDays < 1) {
      final expDur = endTime.difference(DateTime.now()); 
      final hours = expDur.inHours;
      final minutes = expDur.inMinutes - expDur.inHours * 60;
      final seconds = expDur.inSeconds - expDur.inMinutes * 60;
      text = Text.rich(TextSpan(
        style:TextStyle(fontSize: 12,color: Colours.grey666666),
        children: [
          TextSpan(text: "仅剩 ",style: TextStyle(color: disableColor ?? Colours.grey66)),
          TextSpan(text: "${"0$hours".lastString(2)}:${"0$minutes".lastString(2)}:${"0$seconds".lastString(2)}",style:TextStyle(color: disableColor ?? Colours.main_color))
        ]
      ));
    } else {
      text = Text("有效期至${endTime.formatedString("yyyy.MM.dd")}",style: tstyle);
    }
    
    return Container(
      child: text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final disableColor = enable ? null : Colours.grey_color1;
    final con = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8)
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Container(
            // padding: EdgeInsets.symmetric(horizontal: 12),
            height: 82.5,
            child: Column(
              children: [
                Expanded(
                  flex: 7,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                    Text(title,style: TextStyle(fontSize: 16,color: disableColor ?? Colours.text_color1,fontWeight: FontWeight.w600),).marginOnly(bottom: 5),
                    Spacer(),
                    Text.rich(TextSpan(
                      children: [
                        TextSpan(text: "$typeUpper",style: TextStyle(color: disableColor ?? Colours.main_color,fontSize: 30)),
                        TextSpan(text: typeLower,style: TextStyle(fontSize: 12,color: disableColor ?? Colours.main_color)),
                        // TextSpan(text: limit,style: TextStyle(fontSize: 12,color: disableColor ?? Colours.main_color)),
                      ]
                    )),
                    if (selectable)
                    Container(
                      alignment: Alignment.bottomRight,
                      width: 34,
                      child: Image.asset(Utils.getImgPath(selected ? "select.png" : "unselect.png"),width: 16,height: 16,).marginOnly(bottom: 5))
                  ],),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    // Text.rich(TextSpan(
                    //   style: TextStyle(fontSize: 12,color: Colours.grey666666),
                    //   children: [
                    //     TextSpan(text: "仅剩"),
                    //     TextSpan(text: "09:23:50",style: TextStyle(color: disableColor ?? Colours.main_color))
                    //   ]
                    // )),
                    _timeDesc(disableColor),
                    Spacer(),
                    Text(condition,style: TextStyle(color: disableColor ?? Colours.main_color,fontSize: 12),),
                    if (selectable)
                    SizedBox(width: 34,)
                  ],),
                )
              ],
            ),
          ),
          const DashSeparator(color: Color(0xffeeeeee)),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.centerLeft,
                    constraints: BoxConstraints(minHeight: 40),
                    child: Text(bottomDescribe,style: TextStyle(fontSize: 12,color: disableColor ?? const Color(0xff666666)),),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  height: 40,
                  alignment: Alignment.center,
                  child:!toUse ? null : CommonButton(onPressed: () {
                    if(uselessType == MyDiscountUselessType.none) {
                      Utils.doRoute(myCoupon?.useUrl ?? "");
                    }
                  },
                  foregroundColor: Colors.white,
                  backgroundColor: Colours.main_color.withOpacity(uselessType == MyDiscountUselessType.notStart ? 0.5 : 1),
                  radius: 4,
                  minHeight: 24,
                  minWidth: 56,
                  textStyle: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),
                  text: "去使用"),
                )
              ],
            ),
          )
        ],
      ),
    );
    String? imgpath = null;
    if (uselessType == MyDiscountUselessType.used) {
      imgpath = "my_discount_used.png";
    } else if (uselessType == MyDiscountUselessType.expired) {
      imgpath = "my_discount_expired.png";
    }

    return Stack(
      children: [
        con,
        if (imgpath != null)
        Positioned(right: 0,bottom: 0,child: Image.asset(Utils.getImgPath(imgpath)),)
      ],
    );
  }
}