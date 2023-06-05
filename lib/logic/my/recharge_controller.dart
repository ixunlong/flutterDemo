import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:alipay_kit/alipay_kit.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/mine/order_entity.dart';
import 'package:sports/model/recharge_entity.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/my/contact_page.dart';
import 'package:sports/widgets/common_dialog.dart';
import 'package:wechat_kit/wechat_kit_platform_interface.dart';

enum PayType { ios, alipay, wechat }

class RechargeController extends GetxController {
  StreamSubscription<List<PurchaseDetails>>? subscription;
  List<RechargeEntity> list = [];
  // List<PurchaseDetails> purchaseDetailList = [];
  bool agree = false;
  RechargeEntity? currentProduct;
  OrderEntity? currentOrder;
  int? androidPayType;
  StreamSubscription? alipayListener;
  StreamSubscription? wechatListener;
  RechargeController();

  @override
  void onInit() {
    super.onInit();
    if (Platform.isIOS) {
      subscription = InAppPurchase.instance.purchaseStream.listen((event) {
        // purchaseDetailList = event;
        iosPurchaseUpdated(event);
      });
    } else {
      alipayListener = Alipay.instance.payResp().listen((event) async {
        if (event.resultStatus == 9000) {
          Get.dialog(CommonDialog.hint(
            '您本次支付成功',
            confirmText: '我知道了',
          ));
          await User.fetchUserInfos(fetchFocus: false);
          update();
        } else if (event.resultStatus == 6001) {
        } else {
          final flag = await Get.dialog(CommonDialog.alert(
              '您本次支付失败！\n如您确认已支付可联系客服',
              confirmText: '联系客服'));
          if (flag == true) {
            Get.to(ContactPage());
          }
        }
      });
      wechatListener =
          WechatKitPlatform.instance.respStream().listen((event) async {
        if (event.errorCode == BaseResp.ERRORCODE_SUCCESS) {
          Get.dialog(CommonDialog.hint(
            '您本次支付成功',
            confirmText: '我知道了',
          ));
          await User.fetchUserInfos(fetchFocus: false);
          update();
        } else if (event.errorCode == BaseResp.ERRORCODE_USERCANCEL) {
        } else {
          final flag = await Get.dialog(CommonDialog.alert(
              '您本次支付失败！\n如您确认已支付可联系客服',
              confirmText: '联系客服'));
          if (flag == true) {
            Get.to(ContactPage());
          }
        }
        log('$event');
      });
    }
  }

  @override
  void onReady() async {
    super.onReady();
    User.fetchUserInfos(fetchFocus: false).then((value) => update());
    List<RechargeEntity>? result =
        await Api.getRechargeList(Platform.isIOS ? '2' : '1');
    if (Platform.isIOS) {
      InAppPurchase.instance.restorePurchases();
    }

    if (result != null) {
      list = result;
      update();
    }
  }

  @override
  void onClose() {
    subscription?.cancel();
    alipayListener?.cancel();
    wechatListener?.cancel();
    super.onClose();
  }

  void iosRecharge(int index) async {
    RechargeEntity data = list[index];
    EasyLoading.show();
    bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      ToastUtils.show('无法连接到App Store');
      return;
    }
    ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails({data.productId!});
    if (response.productDetails.isEmpty) {
      ToastUtils.show('无法查询到相关商品');
      return;
    }
    final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: response.productDetails.first,
        applicationUserName: currentOrder?.id);
    try {
      await InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      if (e is PlatformException) {
        if (e.code == 'storekit_duplicate_product_object') {
          ToastUtils.show('存在未完成订单，请联系客服');
        } else {
          ToastUtils.show('支付失败，请联系客服');
        }
      }
    }

    // print(reponse);
  }

  // void restorePurchase() async {
  //   await InAppPurchase.instance.restorePurchases();
  // }

  void iosPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      log('PurchaseUpdated==================${purchaseDetails.status}');
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // _showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // _handleError(purchaseDetails.error!);
          ToastUtils.show('支付失败');
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          // bool valid = await _verifyPurchase(purchaseDetails);
          // if (valid) {
          //   _deliverProduct(purchaseDetails);
          // } else {
          //   _handleInvalidPurchase(purchaseDetails);
          // }
          try {
            await verifyIosPay(
                currentOrder?.id,
                purchaseDetails.verificationData.serverVerificationData,
                purchaseDetails.productID);
          } catch (e) {}
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          EasyLoading.showToast('支付已取消');
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  void generateOrder(
      {double? payAmt, int? index, required PayType payType}) async {
    currentOrder = null;
    int type;
    if (payType == PayType.alipay) {
      type = 1;
    } else if (payType == PayType.wechat) {
      type = 2;
    } else {
      type = 3;
    }
    RechargeEntity? data;
    if (index != null) {
      data = list[index];
    }
    OrderEntity? order = await Api.generatePayOrder(
        itemId: data?.id, payAmt: payAmt, payType: type, showLoading: true);
    if (order != null) {
      currentOrder = order;
      if (payType == PayType.alipay) {
        Alipay.instance.pay(orderInfo: order.otherId!);
      } else if (payType == PayType.wechat) {
        Map<String, dynamic> wxParam = jsonDecode(order.otherId!);
        // Map<String, dynamic> wxParam = json['authorization'];
        String appid = wxParam['appid'] ?? '';
        String partnerid = wxParam['partnerid'] ?? '';
        String timestamp = wxParam['timestamp'] ?? '';
        String prepayid = wxParam['prepayid'] ?? '';
        String sign = wxParam['sign'] ?? '';
        String package = wxParam['package'] ?? '';
        String noncestr = wxParam['noncestr'] ?? '';
        WechatKitPlatform.instance.pay(
            appId: appid,
            partnerId: partnerid,
            prepayId: prepayid,
            package: package,
            nonceStr: noncestr,
            timeStamp: timestamp,
            sign: sign);
        // WechatKitPlatform.instance.pay(
        //     appId: 'wxf9a3dc7fb5feadb9',
        //     partnerId: '1635249686',
        //     prepayId: 'wx060951107159836fc4a94a06158f900000',
        //     package: 'Sign=WXPay',
        //     nonceStr: '400356189EDFD94144A61CD77BB5BF77C1C5103D',
        //     timeStamp: '1670291471',
        //     sign:
        //         'mg7Lie0yTP08dU4xt3KIHbJR8Ep5Hpq/ltWap6GAA20LoZ/ptZUpZDNgSLJl862ddZlmJy3uFmG7rukhSBxMaQ3PSuoLMKBcPErQGwtaJvIrr34wtj1H9Fwl2eTCUWMTxVbCaV541nb/7JiIiKCoX9vQZd+XRnx/Lac3cO42X7yp2JM2eZm5d7GymxKQclXJ4pkmajKpCm71LoKA8BeSBYOawrmfSfve4lErv5dahPcGqOrp+B2A0Tv9lLVAGZapMxmfCzBb19EeR+NOOX9jGq1/1U9Lj+HpM+KdsLRzAS2EfFFMe0AxhU85q+IoNVnUCUrbhGFzi1uvfK0SPDOkcw==');
      } else {
        iosRecharge(index!);
      }
    }
  }

  verifyIosPay(String? orderId, String receipt, String productId) async {
    int? code = await Api.verifyIosPay(orderId, receipt, productId);
    EasyLoading.dismiss();
    if (code == 200) {
      if (currentOrder != null) {
        Get.dialog(CommonDialog.hint(
          '您本次支付成功',
          confirmText: '我知道了',
        ));
      }
      await User.fetchUserInfos(fetchFocus: false);
      update();
    } else {
      ToastUtils.show('充值失败，请联系客服');
    }
  }

  void onAgree() {
    Utils.onEvent('wode_dxdl_xy', params: {'wode_dxdl_xy': agree ? '0' : '1'});
    agree = !agree;
    update();
  }
}
