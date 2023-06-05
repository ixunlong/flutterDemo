import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:sports/logic/my/recharge_controller.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/model/recharge_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/regex.dart';
import '../../res/styles.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/my/web_page.dart';
import 'package:sports/view/other/recharge_type_view.dart';
import 'package:sports/widgets/common_bottomsheet.dart';
import 'package:sports/widgets/common_button.dart';

class RechargePage extends StatefulWidget {
  const RechargePage({super.key});

  @override
  State<RechargePage> createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage> {
  final controller = Get.put(RechargeController());

  final textController = TextEditingController();

  @override
  void initState() {
    Get.find<ConfigService>().tipEnable = false;
    super.initState();
  }

  @override
  void dispose() {
    Get.find<ConfigService>().tipEnable = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Styles.appBar(
          title: Column(children: [
            Text('充值'),
            if (User.info?.phone != null && User.auth?.type == 1)
              Text(
                User.info!.phone!.substring(0, 3) +
                    '****' +
                    User.info!.phone!.substring(7),
                style: TextStyle(
                    color: Colours.grey_color,
                    fontSize: 10,
                    fontWeight: FontWeight.w400),
              )
          ]),
          actions: [
            TextButton(
                onPressed: () {
                  Utils.onEvent('cz_mx');
                  Get.toNamed(Routes.coinHistory);
                },
                child: Text('明细',
                    style: TextStyle(
                        color: Colours.text_color1,
                        fontWeight: FontWeight.w400)))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GetBuilder<RechargeController>(
            initState: (_) {},
            builder: (_) {
              return SingleChildScrollView(
                child: Column(children: [
                  SizedBox(height: 16),
                  _header(),
                  SizedBox(height: 26),
                  _body(),
                  SizedBox(height: 2),
                  _bottom(),
                ]),
              );
            },
          ),
        ));
  }

  _header() {
    return Container(
      height: 100,
      width: double.infinity,
      padding: EdgeInsets.only(left: 30),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colours.main_color,
        borderRadius: BorderRadius.all(Radius.circular(4)),
        image: DecorationImage(
          image: AssetImage(Utils.getImgPath('recharge.png')),
          fit: BoxFit.fill, // 完全填充
        ),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              User.info?.gold == null
                  ? '0'
                  : User.info!.gold!.toStringAsFixed(2),
              style: TextStyle(
                  fontSize: 35,
                  color: Colours.white,
                  fontWeight: FontWeight.w500,
                  height: 1.1),
            ),
            Text('红钻余额', style: TextStyle(fontSize: 12, color: Colours.white))
          ]),
    );
  }

  _body() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '红钻充值',
            style: TextStyle(
                color: Colours.text_color,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 12),
          if (Platform.isAndroid) ...[
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: TextField(
                      controller: textController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            (RegExp(Regex.number9999)))
                      ],
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        fillColor: Colours.grey_color4,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide.none),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                        hintText: "自定义金额1元至9999元",
                        hintStyle:
                            TextStyle(fontSize: 14, color: Colours.grey_color1),
                        // suffixIconConstraints:
                        //     BoxConstraints(minHeight: 20, minWidth: 20),
                        // suffixIcon: textController.text.isEmpty
                        //     ? null
                        //     : GestureDetector(
                        //         onTap: () {
                        //           setState(() {
                        //             textController.text = '';
                        //           });
                        //         },
                        //         child: Padding(
                        //           padding: EdgeInsets.symmetric(horizontal: 10),
                        //           child: Image.asset(
                        //             Utils.getImgPath('close.png'),
                        //             width: 20,
                        //             height: 20,
                        //             // fit: BoxFit.cover,
                        //           ),
                        //         ),
                        //       ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CommonButton(
                  minHeight: 44,
                  minWidth: 109,
                  backgroundColor: Colours.main_color,
                  foregroundColor: Colours.white,
                  radius: 4,
                  onPressed: () async {
                    Utils.onEvent('cz_mx');
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (textController.text.isEmpty) {
                      ToastUtils.show('请输入金额');
                      return;
                    }
                    if (!controller.agree) {
                      ToastUtils.show('请先同意《用户充值协议》');
                      return;
                    }

                    final type = await Get.bottomSheet(
                        RechargeTypeView(money: textController.text));
                    if (type != null) {
                      PayType? payType;
                      if (type == 0) {
                        payType = PayType.alipay;
                      } else {
                        payType = PayType.wechat;
                      }
                      controller.generateOrder(
                          payAmt: double.parse(textController.text),
                          payType: payType);
                    }
                  },
                  text: '充值',
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: List.generate(
                controller.list.length, (index) => _moneyCard(index)),
          )
        ],
      ),
    );
  }

  _moneyCard(index) {
    RechargeEntity data = controller.list[index];
    return GestureDetector(
      onTap: () async {
        Utils.onEvent('cz_xx', params: {'cz_xx': '$index'});
        if (!controller.agree) {
          ToastUtils.show('请先同意《用户充值协议》');
          return;
        }
        controller.currentProduct = data;
        if (Platform.isIOS) {
          controller.generateOrder(index: index, payType: PayType.ios);
        } else {
          FocusScope.of(context).requestFocus(FocusNode());
          final type = await Get.bottomSheet(RechargeTypeView(
            data: data,
          ));
          if (type != null) {
            PayType? payType;
            if (type == 0) {
              payType = PayType.alipay;
            } else {
              payType = PayType.wechat;
            }
            controller.generateOrder(index: index, payType: payType);
          }
        }
      },
      child: Container(
        width: (Get.width - 49) / 3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colours.greyF5F7FA,
        ),
        height: 80,
        child: Column(children: [
          SizedBox(height: 17),
          Row(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.baseline,
            // textBaseline: TextBaseline.ideographic,
            children: [
              Text(
                data.gold!.toStringAsFixed(0),
                style: TextStyle(
                    fontSize: 19,
                    color: Colours.text_color,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 4),
              Text('红钻',
                  style: TextStyle(fontSize: 13, color: Colours.text_color))
            ],
          ),
          SizedBox(height: 8),
          Text('￥${data.payAmt!.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 13, color: Colours.grey_color))
        ]),
      ),
    );
  }

  _bottom() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => controller.onAgree(),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 5, 8),
                  child: Image.asset(
                    Utils.getImgPath(
                        controller.agree ? 'select.png' : 'unselect1.png'),
                    width: 14,
                    height: 14,
                  )),
            ),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: '充值即代表您已同意',
                  style: TextStyle(color: Colours.grey_color1, fontSize: 12)),
              TextSpan(
                  text: '《用户充值协议》',
                  style: TextStyle(color: Colours.main_color, fontSize: 12),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Get.toNamed(Routes.webview,
                          arguments: const WebPara("", Constant.payPolicyUrl,
                              longpress: true));
                    }),
            ])),
          ],
        ),
        SizedBox(height: 9),
        Text('充值说明',
            style: TextStyle(
                color: Colours.grey_color,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
        SizedBox(height: 5),
        _rechargeInfo(),
        SizedBox(height: 100),
      ],
    );
  }

  _rechargeInfo() {
    if (Platform.isAndroid) {
      return RichText(
          text: TextSpan(children: [
        TextSpan(
            text: '1. 红球会',
            style: TextStyle(color: Colours.grey_color1, fontSize: 12)),
        TextSpan(
            text: '非购彩平台',
            style: TextStyle(color: Colours.main_color, fontSize: 12)),
        TextSpan(
            text: '，红钻一经充值成功，只可用于购买平台内容付费服务，',
            style: TextStyle(color: Colours.grey_color1, fontSize: 12)),
        TextSpan(
            text: '不支持提现、购彩等操作',
            style: TextStyle(color: Colours.main_color, fontSize: 12)),
        TextSpan(
            text: '；\n2.若红钻充值和消费过程中遇到问题，请',
            style: TextStyle(color: Colours.grey_color1, fontSize: 12)),
        TextSpan(
            text: '联系客服',
            style: TextStyle(color: Colours.guestColorBlue, fontSize: 12),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.toNamed(Routes.myContact);
              }),
        TextSpan(
            text: '进行反馈。',
            style: TextStyle(color: Colours.grey_color1, fontSize: 12)),
      ]));
    } else {
      return RichText(
          text: TextSpan(children: [
        TextSpan(
            text: '1. 红球会',
            style: TextStyle(color: Colours.grey_color1, fontSize: 12)),
        TextSpan(
            text: '非购彩平台',
            style: TextStyle(color: Colours.main_color, fontSize: 12)),
        TextSpan(
            text: '，红钻一经充值成功，只可用于购买平台内容付费服务，',
            style: TextStyle(color: Colours.grey_color1, fontSize: 12)),
        TextSpan(
            text: '不支持提现、购彩等操作',
            style: TextStyle(color: Colours.main_color, fontSize: 12)),
        TextSpan(
            text:
                '；\n2. 购买红钻为AppStore应用内购买，所使用的Apple ID必须与下载红球会APP时使用的Apple ID一致；\n3. 如遇到苹果支付问题，建议App Store绑定支付宝(App Store-App栏目底部-快速链接-绑定支付宝)；\n4. 若红钻充值和消费过程中遇到问题，请',
            style: TextStyle(color: Colours.grey_color1, fontSize: 12)),
        TextSpan(
            text: '联系客服',
            style: TextStyle(color: Colours.guestColorBlue, fontSize: 12),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.toNamed(Routes.myContact);
              }),
        TextSpan(
            text: '进行反馈。',
            style: TextStyle(color: Colours.grey_color1, fontSize: 12)),
      ]));
    }
  }

  _onAndroidRecharge() {}
}
