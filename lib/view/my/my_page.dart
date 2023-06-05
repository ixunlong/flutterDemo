import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';
import 'package:sports/http/api.dart';
import 'package:sports/http/apis/mine_api.dart';
import 'package:sports/logic/service/resource_service.dart';
import 'package:sports/model/mine/my_coupon_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/tip_resources.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/my/contact_page.dart';
import 'package:sports/view/my/msg/msg_page.dart';
import 'package:sports/view/my/my_edit_page.dart';
import 'package:sports/view/my/setting_page.dart';
import 'package:sports/widgets/common_button.dart';
import 'package:sports/widgets/common_dialog.dart';
import 'package:sports/widgets/game_entry_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:sports/widgets/share_bottom_sheet.dart';
import 'package:tencent_kit/tencent_kit_platform_interface.dart';
import 'package:wechat_kit/wechat_kit_platform_interface.dart';
// import 'package:weibo_kit/weibo_kit_platform_interface.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

mixin _MyPageMixin on State<MyPage> {
  double opcaity = 0;
}

class MyRoundShapeBorder extends ShapeBorder {
  @override
  // TODO: implement dimensions
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(rect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..moveTo(rect.left, rect.top)
      ..lineTo(rect.right, rect.top)
      ..lineTo(rect.right, rect.bottom - 10)
      ..quadraticBezierTo((rect.left + rect.right) / 2, rect.bottom, rect.left,
          rect.bottom - 10);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // TODO: implement paint
  }

  @override
  ShapeBorder scale(double t) => const RoundedRectangleBorder();
}

class _MyPageState extends State<MyPage>
    with _MyPageMixin, AutomaticKeepAliveClientMixin {
  List<MyCouponEntity> coupons = [];

  int msgNum = 0;
  bool refreshing = false;

  _onVisible() async {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark));
    log("on my page visible");
    await User.fetchUserInfos();
    if (User.isLogin) {
      coupons = await Api.coupon.myCoupons() ?? [];
      Future.delayed(Duration(milliseconds: 500)).then((value) {
        Future.wait(
                [MineApi.getMsgUnreadCount(), MineApi.getInterUnreadCount()])
            .then((value) {
          int msg = 0;
          for (var i in value) {
            msg += i ?? 0;
          }
          msgNum = msg;
          update();
        });
      });
    }
    update();
  }

  _onUnvisible() async {}

  final CarouselController carouselController = CarouselController();
  final scrollController = ScrollController();
  bool autoPlay = true;
  double topOpacity = 0;

  scrolling() {
    if (scrollController.offset < 0 && autoPlay) {
      carouselController.stopAutoPlay();
      autoPlay = false;
    }
    if (scrollController.offset >= 0 && !autoPlay) {
      carouselController.startAutoPlay();
      autoPlay = true;
    }
    final top = MediaQuery.of(context).padding.top;
    final off = scrollController.offset - top;
    // log("scroll ${scrollController.offset - top}");
    if (off < 0) {
      topOpacity = 0;
    } else {
      topOpacity = off / 40 > 1 ? 1 : off / 40;
    }
    update();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    scrollController.addListener(() {
      scrolling();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final list = ListView(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      controller: scrollController,
      padding: EdgeInsets.zero,
      // physics: const ClampingScrollPhysics(),
      // physics: BouncingScrollPhysics(),
      children: [
        Stack(
          children: [
            Positioned.fill(
              child: OverflowBox(
                alignment: Alignment.bottomCenter,
                maxHeight: 1000,
                child: ClipPath(
                        clipBehavior: Clip.hardEdge,
                        clipper: ProsteBezierCurve(
                            position: ClipPosition.bottom,
                            list: [
                              BezierCurveSection(
                                start: const Offset(0, 1000 - 6),
                                top: Offset(Get.width / 2, 999),
                                end: Offset(Get.width, 1000 - 6),
                              ),
                            ]),
                        child: Image.asset(Utils.getImgPath("longbg.png"),
                            fit: BoxFit.fitHeight))
                    .sized(height: 1000),
              ),
            ),
            ClipPath(
              clipBehavior: Clip.hardEdge,
              clipper: ProsteBezierCurve(position: ClipPosition.bottom, list: [
                BezierCurveSection(
                  start: Offset(0, 225 + MediaQuery.of(context).padding.top),
                  top: Offset(
                      Get.width / 2, 230 + MediaQuery.of(context).padding.top),
                  end: Offset(
                      Get.width, 225 + MediaQuery.of(context).padding.top),
                ),
              ]),
              child: Container(
                  // decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //         image: AssetImage(Utils.getImgPath("my_topbg.png")),
                  //         fit: BoxFit.fill)),
                  height: 230 + MediaQuery.of(context).padding.top,
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // SafeArea(child: Container()),
                          // _topArea()
                          SizedBox(height: 17),
                          _userInfo(),
                          Spacer(),
                          _topArea()
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ),
        VisibilityDetector(
          key: Key("my_page"),
          child: SizedBox(height: 16),
          onVisibilityChanged: (info) {
            if (!info.visibleBounds.size.isEmpty) {
              update();
              _onVisible();
            } else {
              _onUnvisible();
            }
          },
        ),
        _roundBox(Column(
          children: [
            _cell(
                Image.asset(Utils.getImgPath("my_coupon.png"),
                    width: 24, height: 24),
                coupons.isEmpty || !User.isLogin
                    ? "优惠券"
                    : "优惠券(${coupons.length})", onTap: () async {
              Utils.onEvent('wd_yhq');
              await User.needLogin(() async {
                await Get.toNamed(Routes.myCoupons);
              });
              // await Get.to(() => ActivityBugPage());
            }),
            const Divider(
              height: 0.5,
              indent: 16,
              endIndent: 16,
              color: Color(0xffeeeeee),
            ),
            _cell(
                Image.asset(Utils.getImgPath("my_buy.png"),
                    width: 24, height: 24),
                "已购方案", onTap: () {
              User.needLogin(() {
                Utils.onEvent('wd_wdyg');
                Get.toNamed(Routes.myPurchase);
              });
            }),
            const Divider(
              height: 0.5,
              indent: 16,
              endIndent: 16,
              color: Color(0xffeeeeee),
            ),
            _cell(
                Image.asset(Utils.getImgPath("my_focus.png"),
                    width: 24, height: 24),
                "我的关注", onTap: () {
              User.needLogin(() {
                Utils.onEvent('wd_wdgz');
                Get.toNamed(Routes.myFocus);
              });
            }),
          ],
        )),
        if (Get.find<ResourceService>().webgames != null)
          _roundBox(GameEntryWidget(
                  lbts: Get.find<ResourceService>().webgames!,
                  scroll: !refreshing,
                  carouselController: carouselController))
              .marginOnly(top: 10),
        const SizedBox(height: 10),
        _roundBox(Column(
          children: [
            // _cell(
            //   Image.asset(Utils.getImgPath("my_expert.png"),
            //       width: 24, height: 24),
            //   "专家申请",
            //   onTap: () {
            //     Utils.onEvent('wd_zjsq');
            //     Get.toNamed(Routes.expertRequestType);
            //   },
            // ),
            // const Divider(
            //   height: 0.5,
            //   indent: 16,
            //   endIndent: 16,
            //   color: Color(0xffeeeeee),
            // ),
            // _cell(
            //     Image.asset(Utils.getImgPath("my_invite.png"),
            //         width: 24, height: 24),
            //     "邀请好友",
            //     text: Get.find<ResourceService>().inviteTip?.content,
            //     onTap: () async {
            //   share();
            // }),
            // const Divider(
            //   height: 0.5,
            //   indent: 16,
            //   endIndent: 16,
            //   color: Color(0xffeeeeee),
            // ),
            _cell(
              Image.asset(Utils.getImgPath("my_contact.png"),
                  width: 24, height: 24),
              "联系客服",
              onTap: () {
                Utils.onEvent('wd_lxkf');
                Get.to(() => ContactPage());
              },
            )
          ],
        )),
        const SizedBox(height: 10),
        _roundBox(Column(
          children: [
            // _cell(
            //     Image.asset(Utils.getImgPath("my_push.png"),
            //         width: 24, height: 24),
            //     "通知设置", onTap: () async {
            //   Utils.onEvent('wd_tssz');
            //   // AppSettings.openNotificationSettings();
            //   Get.toNamed(Routes.myPushSetting);

            //   // openAppSettings();
            // }),
            // const Divider(
            //   height: 0.5,
            //   indent: 16,
            //   endIndent: 16,
            //   color: Color(0xffeeeeee),
            // ),
            _cell(
                Image.asset(Utils.getImgPath("my_setting.png"),
                    width: 24, height: 24),
                "更多设置", onTap: () async {
              Utils.onEvent('wd_gdsz');
              await Get.to(() => SettingPage());
              update();
            }),
          ],
        )),
        SizedBox(
          height: 50,
        ),
      ],
    );
    return Scaffold(
        // appBar: Styles.appBar(
        //   backgroundColor: Color(0xFFF53F3F),
        // ),
        backgroundColor: Color(0xFFF7F7F7),
        body: Stack(
          children: [
            Positioned.fill(
              child: EasyRefresh(
                  onRefresh: () async {
                    refreshing = true;
                    update();
                    await User.fetchUserInfos();
                    refreshing = false;
                    update();
                  },
                  child: list),
            ),
            Positioned(
                top: 0,
                right: 0,
                left: 0,
                height: MediaQuery.of(context).padding.top + 44,
                child: Container(
                    // color: const Color(0xFF636779).withOpacity(topOpacity),
                    // padding: EdgeInsets.only(
                    //     top: MediaQuery.of(context).padding.top, right: 16),
                    // alignment: Alignment.centerRight,
                    // child: Image.asset(Utils.getImgPath("icon_msg.png"),
                    //         width: 24, height: 24)
                    //     .tap(() {
                    //   msgNum = 0;
                    //   User.needLogin(() => Get.toNamed(Routes.myMsg));
                    // }).badge(msgNum == 0 ? null : Utils.numLimit(msgNum)),
                    ))
          ],
        ));
  }

  _userInfo() {
    final top = MediaQuery.of(context).padding.top;
    return Container(
        // height: 170,
        padding: const EdgeInsets.only(top: 25, left: 4),
        alignment: Alignment.bottomCenter,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                        // borderRadius: BorderRadius.circular(30),
                        color: Color(0xFFD9D9D9)),
                    child: CachedNetworkImage(
                      imageUrl: User.info?.avatar ?? "",
                      fadeInDuration: Duration.zero,
                      fadeOutDuration: Duration.zero,
                      errorWidget: (context, url, error) => Image.asset(
                          Utils.getImgPath("my_header.png"),
                          fit: BoxFit.fill),
                      // placeholder: (context, url) => Image.asset(
                      //     Utils.getImgPath("my_header.png"),
                      //     fit: BoxFit.fill)
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Row(
                  children: [
                    Container(
                        constraints: const BoxConstraints(maxWidth: 180),
                        child: Text(
                            User.info?.name ?? (User.isLogin ? "" : "登录/注册"),
                            maxLines: 1,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                letterSpacing: 1),
                            overflow: TextOverflow.ellipsis)),
                    const SizedBox(width: 8),
                    // User.isLogin
                    //     ? const Icon(Icons.edit_sharp,
                    //         size: 15, color: Colors.white)
                    //     : Container()
                  ],
                )
              ],
            ).tap(() {
              if (User.isLogin) {
                Utils.onEvent('wode_pd_xgzl');
                Get.to(() => MyEditPage());
              } else {
                Utils.onEvent('wode_pd_dl');
                User.needLogin(() async {
                  update();
                });
              }
            }),
          ],
        ));
  }

  Widget _roundBox(Widget child) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: child,
    );
  }

  _cell(Widget icon, String title, {void Function()? onTap, String? text}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            height: 52,
            child: Row(
              children: [
                SizedBox(width: 20, height: 20, child: icon),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(fontSize: 15),
                ),
                const Spacer(),
                if (text != null)
                  Text(text,
                      style:
                          const TextStyle(fontSize: 14, color: Colours.main)),
                const SizedBox(width: 10),
                Image.asset(Utils.getImgPath("arrow_right.png"))
              ],
            ),
          ),
        ],
      ).marginSymmetric(horizontal: 16),
    );
  }

  _topArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8)),
        // boxShadow: [
        //   BoxShadow(
        //       color: Color(0x409B9B9B), offset: Offset(0, 4), blurRadius: 6)
        // ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                User.info?.gold == null
                    ? '0.00'
                    : User.info!.gold!.toStringAsFixed(2),
                // "${User.info?.gold.toStringAsFixed(2) ?? 0}",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                "红钻余额",
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
          SizedBox(
            width: 80,
            height: 32,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  textStyle: TextStyle(fontSize: 16),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                      side: BorderSide.none,
                      borderRadius: BorderRadius.circular(16))),
              onPressed: () async {
                Utils.onEvent('wd_cz');
                final tip = TipResources.switchRecharge;
                if (tip != null) {
                  Utils.alertQuery(tip.content ?? "");
                  return;
                }
                if (User.auth == null) {
                  final result = await Get.dialog(CommonDialog.select(
                    '您尚未登录',
                    '去登录（推荐）',
                    '游客访问',
                    content:
                        '游客登录状态下充值会有以下限制：\n1.充值红钻及购买记录，无法转移至其他账号，仅限本设备使用；\n2.APP卸载后，充值的红钻无法找回。',
                  ));
                  if (result == 0) {
                    User.needLogin(() => Get.toNamed(Routes.recharge));
                    update();
                  } else if (result == 1) {
                    await User.visitorLogin();
                    Get.toNamed(Routes.recharge);
                    update();
                  }
                } else {
                  Get.toNamed(Routes.recharge);
                }
              },
              child: Text("充值"),
            ),
          ),
        ],
      ),
    );
  }

  share() async {
    String url = 'https://www.qiuxiangbiao.com/mp/h5/qxb.html?id=c11011';
    String title = '分享给你一个看比赛和数据的APP';
    String content = '看比分、看数据、看专家推荐，就来红球会！';
    String logoUrl = 'https://oss.qiuxiangbiao.com/prod/resource/qxb_logo.png';
    final jsonStr = Get.find<ResourceService>().inviteInfo?.content;
    if (jsonStr != null) {
      final json = jsonDecode(jsonStr);
      url = json['url'];
      title = json['title'];
      content = json['content'];
      logoUrl = json['logo'];
    }
    final File logo = await DefaultCacheManager().getSingleFile(logoUrl);
    // String imageUri =
    //     'https://oss.qiuxiangbiao.com/prod/resource/qxb_logo.png';
    final ByteData bytes =
        await rootBundle.load(Utils.getImgPath('qxb_logo.png'));
    final Uint8List thumbImage = bytes.buffer.asUint8List();
    ShareBottomSheet.show(onShareWx: () {
      WechatKitPlatform.instance.shareWebpage(
          scene: WechatScene.SESSION,
          title: title,
          description: content,
          thumbData: thumbImage,
          webpageUrl: url);
      getCoupon();
    }, onShareTimeline: () {
      WechatKitPlatform.instance.shareWebpage(
          scene: WechatScene.TIMELINE,
          title: title,
          description: content,
          thumbData: thumbImage,
          webpageUrl: url);
      getCoupon();
    }, onShareQQ: () async {
      TencentKitPlatform.instance.shareWebpage(
          scene: TencentScene.SCENE_QQ,
          title: title,
          summary: content,
          appName: '红球会',
          imageUri: Uri.file(logo.path),
          targetUrl: url);
      getCoupon();
    }, onShareQQZone: () async {
      TencentKitPlatform.instance.shareWebpage(
          scene: TencentScene.SCENE_QZONE,
          title: title,
          summary: content,
          appName: '红球会',
          imageUri: Uri.file(logo.path),
          targetUrl: url);
      getCoupon();
    }, onShareWb: () async {
      // WeiboKitPlatform.instance.shareWebpage(
      //     thumbData: thumbImage,
      //     title: title,
      //     description: content,
      //     webpageUrl: url);
      getCoupon();
    });
  }

  void getCoupon() async {
    if (User.isLogin) {
      await Api.joinActivity('invite1');
      Get.find<ResourceService>().getAppLogin().then((value) {
        update();
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
