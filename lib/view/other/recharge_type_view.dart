import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:sports/model/recharge_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/common_bottomsheet.dart';
import 'package:sports/widgets/common_button.dart';

class RechargeTypeView extends StatefulWidget {
  RechargeEntity? data;
  String? money;
  RechargeTypeView({super.key, this.data, this.money});

  @override
  State<RechargeTypeView> createState() => _RechargeTypeViewState();
}

class _RechargeTypeViewState extends State<RechargeTypeView> {
  int? selectIndex;

  @override
  Widget build(BuildContext context) {
    double money = 0;
    if (widget.data == null) {
      money = double.parse(widget.money!);
    } else {
      money = widget.data!.payAmt!;
    }

    return CommonBottomSheet(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('支付金额',
            style: TextStyle(fontSize: 16, color: Colours.text_color1)),
        SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '￥',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colours.text_color1),
            ),
            SizedBox(width: 6),
            Text(
              '${money.toStringAsFixed(2)}',
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                  color: Colours.text_color1),
            )
          ],
        ),
        SizedBox(height: 4),
        Text(
          widget.data == null
              ? '合计充值${double.parse(widget.money!).toStringAsFixed(2)}红钻'
              : '${widget.data?.description}',
          style: TextStyle(color: Colours.main_color, fontSize: 12),
        ),
        SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: Colours.greyF5F7FA,
          ),
          child: Column(children: [
            Container(
              padding: EdgeInsets.fromLTRB(13, 15, 20, 15),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    selectIndex = 0;
                  });
                },
                child: Row(children: [
                  Image.asset(
                    Utils.getImgPath('alipay.png'),
                    width: 22,
                  ),
                  SizedBox(width: 8),
                  Text('支付宝支付'),
                  Spacer(),
                  Image.asset(
                    Utils.getImgPath(
                        selectIndex == 0 ? 'select.png' : 'unselect.png'),
                    width: 18,
                    height: 18,
                  )
                ]),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(13, 15, 20, 15),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    selectIndex = 1;
                  });
                },
                child: Row(children: [
                  Image.asset(
                    Utils.getImgPath('wechat_pay.png'),
                    width: 22,
                  ),
                  SizedBox(width: 8),
                  Text('微信支付'),
                  Spacer(),
                  Image.asset(
                    Utils.getImgPath(
                        selectIndex == 1 ? 'select.png' : 'unselect.png'),
                    width: 18,
                    height: 18,
                  )
                ]),
              ),
            )
          ]),
        ),
        SizedBox(height: 40),
        CommonButton.large(
            onPressed: () {
              if (selectIndex == null) {
                ToastUtils.show('请选择支付方式');
                return;
              }
              Get.back(result: selectIndex);
            },
            text: '确认支付'),
        SizedBox(height: 20),
      ],
    ));
  }
}
