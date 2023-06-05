import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:tencent_kit/tencent_kit.dart' as qq;
import 'package:wechat_kit/wechat_kit_platform_interface.dart' as wx;
// import 'package:weibo_kit/weibo_kit.dart' as wb;

class ThirdLoginService extends GetxService {
  Future<ThirdLoginService> init() async {
    return this;
  }

  initThird() async {
    wx.WechatKitPlatform.instance.registerApp(
      appId: 'wxf9a3dc7fb5feadb9',
      universalLink: 'https://www.qiuxiangbiao.cn/app/',
    );
    await qq.Tencent.instance.setIsPermissionGranted(granted: true);
    await qq.Tencent.instance.registerApp(appId: '102033150');
    // await wb.Weibo.instance.registerApp(
    //     appKey: '1945433844',
    //     universalLink: 'https://www.qiuxiangbiao.cn/app/',
    //     scope: <String>[
    //       wb.WeiboScope.ALL,
    //     ]);
  }

  onWechatLogin() {
    wx.WechatKitPlatform.instance.auth(
      scope: <String>[wx.WechatScope.SNSAPI_USERINFO],
      state: 'auth',
    );
  }

  onQQLogin() {
    qq.Tencent.instance.login(
      scope: <String>[qq.TencentScope.GET_SIMPLE_USERINFO],
    );
  }

  // onWeiboLogin() {
  //   wb.Weibo.instance.auth(appKey: '1945433844', scope: <String>[
  //     wb.WeiboScope.ALL,
  //   ]);
  // }

  Future<AuthorizationCredentialAppleID> onAppleLogin() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    return credential;
  }
}
