import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/http/request_interceptor.dart';
import 'package:sports/logic/login/login_logic.dart';
import 'package:sports/model/auth_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/app_config.dart';
import 'package:sports/util/method_channel_utils.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
// import 'package:umeng_verify_sdk/umeng_verify_sdk.dart';

class UmService extends GetxService {
  //adroid qxb 6334192c0584462
  final _androidAppkey = '646875317dddcc5bad4e4025';
  final _iosAppkey = '633418ef88ccdf4b7e3c9138';
  final _androidTestkey = '6385cbfa88ccdf4b7e73d5b3';
  final _iosTestkey = '6385ccdf88ccdf4b7e73d6fa';
  final _loginAndroidSecret =
      'NmfGUSxFPlwpM95EWaRAWJeKukiFv0pWxwVG+p8Ecxyn7zBlhjZVtcB5BmOOt7lkvBxfCpH0jb3iiikKwyAfPfq8IJgTaTer0zP1RWoRaP7+9WE7/X6u08yPhNZSu5Q/5SKjKPbRXUaSQvy3RxNAapwkic5tolw5GnmGqx2VAakyUgiADpFPC00Nz+jJIxX8dPvYrFYTIuDFF+8dcyFmkbQi05ZFo/MSEdp3L1qR+t7VsenfGVjZunE49qJ8KyTs/r1l+7jxhK+1bccCXccfLgKV4yOyPL0Vh9EqvIk5kTAzth1p6Vg+7i+JqkoG7H56';
  final _loginIosSecret =
      'buNMYdfqG5ZI/C6xIAYniC3CPKThnzvRabwO8U1fhru07pRHMSXRpFqGwKotyDGXgDDRKHBT/KF+E06LjMC0DGBBF+bkzeJ+cLgW3KKQ0ezxlXDD8RTOiro7Cpnl3q7vYn8i9sRzP1OBxvpEJN95IW7Gl1Irg3NQL7/az4cTATOwAr/61CnQhvbZYi/Tvb4xYu1/Vz3SNvYd18G58IQBIYDZRape3kHnRn6l2+Gf1dKR8OXLfFwuWjnN855lFpOBkPkIu37eM52kEUKnmCQaxg==';
  // final _loginIosSecret =
  //     'lScVteMwKwvHcC1o3C/nHGekVLMBHoSDYkh54wMD+sWxZrAls6+4u0yRME7T+JhBRJK7Mmp2Gx/A/Lp7RAmJFkw4FWC0whOV9C4zotJWHt69sRHO03Gpnh1ysS4ThPQxD8tIG4qnA5LTrsb8eePnCTG+YTe+N2PknW4i6QmbZolu2ymj7pCIII8lUQp6ENN2tP3AOW+KNoJtpjdtbDlPZyOILaabUTN/h8PxajYc9t+gpSw8sNu2ZA05s0yNWjNVkqBt565Cv2Q=';
  //充值初始来源记录
  var payOriginRoute = '';

  Future<UmService> init() async {
    return this;
  }

  void initUm() async {
    String channel = 'Umeng';
    String iosKey = _iosTestkey;
    String androidKey = _androidTestkey;
    if (!AppConfig.config.isDebug) {
      // if (Platform.isIOS) {
      //   channel = 'iOS';
      // } else {
      //   channel = 'Android';
      // }
      channel = HeaderDeviceInfo.channel;
      iosKey = _iosAppkey;
      androidKey = _androidAppkey;
    }
    await UmengCommonSdk.initCommon(_androidAppkey, _iosAppkey, channel);
    UmengCommonSdk.setPageCollectionModeManual();
    // UmengVerifySdk.accelerateLoginPageWithTimeout(3);
  }

  void signIn() {
    if (User.info != null) {
      UmengCommonSdk.onProfileSignIn(User.info!.id!);
    }
  }

  void login(LoginType type, {String? userId}) async {
    // if (Platform.isAndroid) {
    //   UmengVerifySdk.register_android();
    // }
    // final reslut = await UmengVerifySdk.setVerifySDKInfo(
    //     _loginAndroidSecret, _loginIosSecret);
    // log('result: $reslut');
    // if (Platform.isIOS) {
    //   UmengVerifySdk.checkEnvAvailableWithAuthType_ios(
    //           'UMPNSAuthTypeLoginToken')
    //       .then((value) {
    //     log('$value');
    //   });
    // } else {
    //   UmengVerifySdk.checkEnvAvailable_android(UMEnvCheckType.type_login);
    //   UmengVerifySdk.setTokenResultCallback_android((result) {
    //     log('$result');
    //   });
    // }

    // log('$result');
    // UMCustomModel uiConfig = UMCustomModel();
    // // var Colours;
    // uiConfig.autoHideLoginLoading = false;
    // uiConfig.navColor = Colours.white.value;
    // uiConfig.navTitle = ['', Colours.white.value, 15];
    // uiConfig.navBackImage = 'back';
    // // uiConfig.navBackButtonFrame = [-1, -1, 48, 48];
    // uiConfig.logoImage = 'logo';
    // uiConfig.logoIsHidden = false;

    // // uiConfig.sloganIsHidden = true;
    // uiConfig.sloganText = ['', Colours.text_color1.value, 0];
    // uiConfig.numberColor = Colours.text_color1.value;
    // uiConfig.numberFont = 22;
    // uiConfig.loginBtnText = [
    //   type == LoginType.login ? '本机号码一键登录' : '本机号码一键绑定',
    //   Colours.white.value,
    //   16
    // ];
    // uiConfig.loginBtnBgImg_android = 'red_rectangle';
    // uiConfig.loginBtnBgImgs_ios = [
    //   'red_rectangle',
    //   'red_rectangle',
    //   'red_rectangle'
    // ];
    // // uiConfig.privacyColors = [
    // //   Colours.grey_color1.value,
    // //   Colours.main_color.value
    // // ];

    // uiConfig.checkBoxImages = ['unselect', 'select'];

    // uiConfig.privacyOne = ['《服务协议》', Constant.serviceAgreementUrl];
    // uiConfig.privacyTwo = ['《隐私政策》', Constant.privacyPolicyUrl];
    // uiConfig.privacyConectTexts = ['以及', '和'];
    // uiConfig.privacyOperatorPreText = '《';
    // uiConfig.privacyOperatorSufText = '》';

    // uiConfig.changeBtnTitle = [
    //   type == LoginType.login ? '短信登录' : '短信绑定',
    //   Colours.text_color1.value,
    //   15
    // ];

    // double screenWidth = Get.width;
    // if (Platform.isIOS) {
    //   uiConfig.checkBoxImageEdgeInsets_ios = [0, 2, 4, 2];
    //   uiConfig.navBackButtonFrame = [16, 16, 24, 24];
    //   uiConfig.logoFrame = [screenWidth / 2 - 40, 50, 80, 80];
    //   uiConfig.numberFrame = [screenWidth / 2 - 62, 150, 0, 0];
    //   uiConfig.sloganFrame = [screenWidth / 2 - 73, 190, 150, 20];
    //   // uiConfig.privacyFrame = [10, 270, screenWidth - 20, 60];
    //   uiConfig.loginBtnFrame = [(screenWidth - 335) / 2, 240, -1, 335, 48];
    //   uiConfig.changeBtnFrame = [screenWidth / 2 - 35, 300, 70, 25];
    //   uiConfig.checkBoxWH = 24;
    // } else {
    //   uiConfig.navBackButtonFrame = [-1, -1, 21, 21];
    //   uiConfig.logoFrame = [50, -1, 80, 80];
    //   uiConfig.numberFrame = [0, 142, -1, -1];
    //   uiConfig.sloganFrame = [180, -1, -1, -1];
    //   // uiConfig.privacyFrame = [0, 270, -1, -1];
    //   uiConfig.loginBtnFrame = [0, 240, -1, 335, 48];
    //   uiConfig.changeBtnFrame = [300, -1, -1, -1];
    //   uiConfig.checkBoxWH = 19;
    // }

    // uiConfig.navIsHidden = true;
    // uiConfig.sloganText = ['123'];
    // UmengVerifySdk.getLoginTokenWithTimeout(10, uiConfig);
    // UmengVerifySdk.getVerifyTokenWithTimeout_ios(10)
    //     .then((value) {
    //   log('$value');
    // });
    // UmengVerifySdk.getLoginTokenCallback((result) async {
    //   // UmengVerifySdk.hideLoginLoading();
    //   log('$result');
    //   if (result['resultCode'] == '700002') {
    //     bool isChecked = result['isChecked'];
    //     if (!isChecked) {
    //       if (Platform.isIOS) {
    //         MethodChannelUtils.showHudWithStatus('请同意服务条款');
    //       }
    //     }
    //   } else if (result['resultCode'] == '700001') {
    //     UmengVerifySdk.cancelLoginVCAnimated(true);
    //   } else if (result['resultCode'] == '600000') {
    //     Utils.onEvent('wode_yjdl_dl');
    //     if (type == LoginType.login) {
    //       //成功
    //       final data = await quickLogin(result['token']);
    //       UmengVerifySdk.cancelLoginVCAnimated(true);
    //       if (data != null) {
    //         Get.back();
    //         ToastUtils.show('登录成功');
    //       } else {
    //         ToastUtils.show('登录失败，请重新登录');
    //       }
    //     } else {
    //       final data = await Api.bindPhone(
    //           tokenCode: result['token'], userId: userId ?? User.auth!.userId);
    //       if (data != null) {
    //         UmengVerifySdk.cancelLoginVCAnimated(true);
    //         SpUtils.loginAuth = data;
    //         Get.find<LoginLogic>(tag: '1').loginSuccess();
    //         Get.until((route) => Get.currentRoute == Routes.navigation);
    //         // ToastUtils.show('绑定成功');
    //       } else {
    //         UmengVerifySdk.cancelLoginVCAnimated(true);
    //         // ToastUtils.show('绑定失败，请重新绑定');
    //       }
    //     }
    //   } else if (result['resultCode'] == '600015') {
    //     UmengVerifySdk.cancelLoginVCAnimated(true);
    //     ToastUtils.show('登录失败，请重新登录');
    //   }
    // });
    // UmengVerifySdk.setTokenResultCallback_android((result) async {
    //   String code = result['code'];
    //   log('result $result');
    //   if (code == '700001') {
    //     UmengVerifySdk.cancelLoginVCAnimated(true);
    //     // Get.toNamed(Routes.login);
    //     // onPressed();
    //   } else if (code == '600000') {
    //     Utils.onEvent('wode_yjdl_dl');
    //     if (type == LoginType.login) {
    //       final data = await quickLogin(result['token']);
    //       if (data != null) {
    //         UmengVerifySdk.quitLoginPage_android();
    //         Get.back();
    //       } else {
    //         UmengVerifySdk.hideLoginLoading();
    //       }
    //     } else {
    //       final data = await Api.bindPhone(
    //           tokenCode: result['token'], userId: userId ?? User.auth!.userId);
    //       if (data != null) {
    //         UmengVerifySdk.quitLoginPage_android();
    //         SpUtils.loginAuth = data;
    //         Get.find<LoginLogic>(tag: '1').loginSuccess();
    //         Get.until((route) => Get.currentRoute == Routes.navigation);
    //       } else {
    //         UmengVerifySdk.quitLoginPage_android();
    //         UmengVerifySdk.hideLoginLoading();
    //       }
    //     }
    //   } else if (code == '600004' ||
    //       code == '600005' ||
    //       code == '600007' ||
    //       code == '600008' ||
    //       code == '600009' ||
    //       code == '600010' ||
    //       code == '600011' ||
    //       code == '600012' ||
    //       code == '600013' ||
    //       code == '600014' ||
    //       code == '600015' ||
    //       code == '600017' ||
    //       code == '600021' ||
    //       code == '600025') {
    //     // UmengVerifySdk.hideLoginLoading();
    //     UmengVerifySdk.quitLoginPage_android();
    //     ToastUtils.show('调用一键登录失败：${result['msg']}\n请使用短信验证码方式登录');
    //   } else {
    //     UmengVerifySdk.hideLoginLoading();
    //   }
    // });

    // UmengVerifySdk.debugLoginUIWithController();
  }

  Future<AuthEntity?> quickLogin(String token) async {
    final result = await Api.login(token: token);
    if (result != null) {
      SpUtils.loginAuth = result;
      Get.find<LoginLogic>(tag: '0').loginSuccess();
      return result;
    }
    return null;
  }
}
