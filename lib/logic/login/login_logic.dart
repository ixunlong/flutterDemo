import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/logic/service/resource_service.dart';
import 'package:sports/logic/service/third_login_service.dart';
import 'package:sports/logic/service/um_service.dart';
import 'package:sports/model/auth_entity.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/regex.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/util/tip_resources.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/other/verification_code_view.dart';
import 'package:tencent_kit/tencent_kit.dart' as qq;
import 'package:wechat_kit/wechat_kit_platform_interface.dart' as wx;
// import 'package:weibo_kit/weibo_kit.dart' as wb;

enum LoginType { login, bind }

class LoginLogic extends GetxController {
  late final StreamSubscription<wx.BaseResp> _wechatListener;
  late final StreamSubscription<qq.BaseResp> _qqListener;
  // late final StreamSubscription<wb.BaseResp> _wbListener;
  final authChecked = false.obs;
  String? phone;
  Timer? _timer;
  var currentTime = 60.obs;
  LoginType type = LoginType.login;
  final thirdLoginService = Get.find<ThirdLoginService>();

  AuthEntity? auth;

  @override
  void onInit() async {
    final data = Get.arguments;
    if (data != null) {
      type = data as LoginType;
    }
    try {
      //第一次三方登录需要绑定才会传
      if (Get.parameters['auth'] != null) {
        String param = Get.parameters['auth'] as String;
        auth = AuthEntity.fromJson(jsonDecode(param));
      }
    } catch (e) {}

    // _wechatListener =
    //     wx.WechatKitPlatform.instance.respStream().listen((event) {
    //   // log('$event');
    //   if (event is wx.AuthResp) {
    //     wx.AuthResp auth = event;
    //     if (auth.errorCode == 0) {
    //       thirdLogin(wxCode: auth.code);
    //     }
    //   }
    // });
    // _qqListener = qq.Tencent.instance.respStream().listen((event) {
    //   log('$event');
    //   if (event is qq.LoginResp) {
    //     qq.LoginResp auth = event;
    //     if (auth.ret == 0) {
    //       thirdLogin(qqAccessToken: auth.accessToken, qqOpenid: auth.openid);
    //     }
    //   }
    // });
    // _wbListener = wb.Weibo.instance.respStream().listen((event) {
    //   log('$event');
    //   if (event is wb.AuthResp) {
    //     wb.AuthResp auth = event;
    //     if (auth.errorCode == 0) {
    //       thirdLogin(wbAccessToken: auth.accessToken, wbUid: auth.userId);
    //     }
    //   }
    // });

    // await wx.WechatKitPlatform.instance.handleInitialWXReq();

    Get.find<UmService>().login(type, userId: auth?.userId);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _wechatListener.cancel();
    _qqListener.cancel();
    // _wbListener.cancel();
    _timer?.cancel();
    super.onClose();
  }

  _checkAuth() {
    if (!authChecked.value) {
      // Utils.alertQuery("请同意用户协议与隐私政策");
      ToastUtils.show('请同意用户协议与隐私政策');
    }
    return authChecked.value;
  }

  agreeUserPrivacy() {
    Utils.onEvent('wode_dxdl_xy',
        params: {'wode_dxdl_xy': authChecked.value ? '0' : '1'});
    authChecked.value = !authChecked.value;
  }

  void _startCount() {
    currentTime.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentTime.value == 0) {
        _timer?.cancel();
      } else {
        currentTime--;
      }
    });
  }

  doSendSms(String phoneNum) async {
    if (!_checkAuth()) {
      return;
    }
    // final phone = phoneController.text;
    final reg = RegExp(Regex.phone);
    if (!reg.hasMatch(phoneNum)) {
      Utils.alertQuery("请输入正确的手机号");
      return;
    }
    // final result = await Api.kaptchaImage('1234');
    // print(result);
    final safe = await Get.dialog(VerificationCodeView());
    if (safe) {
      final result =
          await Api.sendSmsCode(phoneNum, type == LoginType.login ? 1 : 2);
      if (result == 200) {
        phone = phoneNum;
        _startCount();
        Get.toNamed(Routes.loginVerify, arguments: type);
      }
    }
  }

  resendSms() async {
    final result =
        await Api.sendSmsCode(phone!, type == LoginType.login ? 1 : 2);
    if (result == 200) {
      _startCount();
    }
  }

  doLogin(String code) async {
    if (!_checkAuth()) {
      return;
    }
    Utils.onEvent('wode_yjdl_dl');
    if (type == LoginType.bind) {
      final result = await Api.bindPhone(
          phone: phone!, smsCode: code, userId: auth?.userId);
      if (result != null) {
        SpUtils.loginAuth = result;
        loginSuccess();
        Get.until((route) => Get.currentRoute == Routes.navigation);
      }
    } else {
      final result = await Api.login(phone: phone!, smsCode: code);
      if (result != null) {
        SpUtils.loginAuth = result;
        loginSuccess();
        Get.close(2);
      }
    }
  }

  thirdLogin(
      {String? qqAccessToken,
      String? qqOpenid,
      String? wbAccessToken,
      String? wbUid,
      String? iosIdentityToken,
      String? wxCode}) async {
    final result = await Api.thirdLogin(
        qqAccessToken: qqAccessToken,
        qqOpenid: qqOpenid,
        wbAccessToken: wbAccessToken,
        wbUid: wbUid,
        iosIdentityToken: iosIdentityToken,
        wxCode: wxCode);
    if (result != null) {
      if (result.phone!.startsWith('2')) {
        Get.toNamed(Routes.login,
            arguments: LoginType.bind,
            preventDuplicates: false,
            parameters: {'auth': jsonEncode(result.toJson())});
        // auth = result;
      } else {
        SpUtils.loginAuth = result;
        loginSuccess();
        Get.back();
      }
    }
  }

  loginSuccess() {
    Get.find<ConfigService>().loadConfig();
    User.fetchUserInfos();
    Get.find<ResourceService>().getAppLogin();
  }

  onWechatLogin() {
    if (!_checkAuth()) {
      return;
    }
    Utils.onEvent('wd_dl', params: {'wd_dl': '0'});
    thirdLoginService.onWechatLogin();
  }

  onQQLogin() {
    if (!_checkAuth()) {
      return;
    }
    Utils.onEvent('wd_dl', params: {'wd_dl': '1'});
    thirdLoginService.onQQLogin();
  }

  // onWeiboLogin() {
  //   if (!_checkAuth()) {
  //     return;
  //   }
  //   Utils.onEvent('wd_dl', params: {'wd_dl': '2'});
  //   thirdLoginService.onWeiboLogin();
  // }

  onAppleLogin() async {
    if (!_checkAuth()) {
      return;
    }
    Utils.onEvent('wd_dl', params: {'wd_dl': '3'});
    final credential = await thirdLoginService.onAppleLogin();
    thirdLogin(iosIdentityToken: credential.identityToken);
  }
}
