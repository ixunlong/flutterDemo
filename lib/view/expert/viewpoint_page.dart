import 'dart:async';
import 'dart:io';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/service/um_service.dart';
import 'package:sports/model/expert/plan_Info_entity.dart';
import 'package:sports/model/home/lbt_entiry.dart';
import 'package:sports/model/use1_coupon_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/tip_resources.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/expert/expert_list_item.dart';
import 'package:sports/view/expert/viewpoint_widgets/content_view.dart';
import 'package:sports/view/expert/viewpoint_widgets/expert_info_view.dart';
import 'package:sports/view/expert/viewpoint_widgets/match_play_view.dart';
import 'package:sports/widgets/common_button.dart';
import 'package:sports/widgets/pay_bottom_sheet.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../res/routes.dart';
import '../../res/styles.dart';

const _grey99 = Color(0xff999999);
const _grey66 = Color(0xff666666);
const _greyEE = Color(0xffeeeeee);
const _textBlack = Color(0xff292d32);
const _textGrey = Color(0xffcccccc);
const _bgGrey = Color(0xfff2f2f2);
const _red1 = Color(0xFFF53F3F);

class ViewpointPage extends StatefulWidget {
  const ViewpointPage({super.key, this.planId});

  final int? planId;

  @override
  State<ViewpointPage> createState() => _ViewpointPageState();
}

class _ViewpointPageState extends State<ViewpointPage> {
  bool get focus => (planInfo?.isFocus ?? 0) > 0;
  bool get matchStart =>
      (planInfo?.matchTime?.difference(DateTime.now()).inSeconds ?? 1) < 0;
  bool get readable => planInfo?.canRead ?? false;
  bool get isCanPay => planInfo?.canPay ?? false;
  bool barShow = false;
  GlobalKey listKey = GlobalKey();
  GlobalKey expertKey = GlobalKey();
  double topOffset = 115;

  List<Use1CouponEntity>? coupons;

  late ExpertInfoView expertView = ExpertInfoView(
      planInfo: planInfo, toFocus: clickToFocus, toDetail: clickToExpert);

  final refreshController = EasyRefreshController(controlFinishRefresh: true);
  late int? planId = () {
    if (widget.planId != null) {
      return widget.planId;
    }
    if (Get.arguments is int) {
      return Get.arguments;
    }
    return 107;
  }.call();
  PlanInfoEntity? planInfo;
  Timer? t;
  List<LbtEntity> viewpointTips = TipResources.viewpointTips;

  requestCoupons() async {
    if (planInfo == null || !User.isLogin) {
      return;
    }
    double gold = double.parse(planInfo!.priceReal!);
    final getCoupons = await Api.coupon
        .use1Coupons(gold: gold, otherId: planInfo?.expertId ?? "");
    coupons = getCoupons ?? coupons;
    update();
  }

  doRequestData({bool loading = false}) async {
    if (planId == null) {
      return;
    }
    if (loading) {
      EasyLoading.show();
    }
    final data = await Api.getPlanInfo(planId!);
    if (loading) {
      EasyLoading.dismiss();
    }
    if (data == null) {
      return;
    }
    // log("get plan inf = ${data.toJson()}");
    planInfo = data;
    expertView = ExpertInfoView(
        planInfo: planInfo, toFocus: clickToFocus, toDetail: clickToExpert);
    requestCoupons();
    update();
  }

  clickToFocus() async => await User.needLogin(() async {
        final id = planInfo?.expertId;
        if (id == null) {
          return;
        }
        if (focus) {
          final result = await Utils.alertQuery('确认不再关注');
          if (result == true) {
            Utils.onEvent('gdxq_gz', params: {'gdxq_gz': '0'});
            if (await Api.expertUnfocus(id) == 200) {
              ToastUtils.show("取消关注成功");
            } else {
              ToastUtils.show("取消关注失败");
            }
          }
        } else {
          Utils.onEvent('gdxq_gz', params: {'gdxq_gz': '1'});
          if (await Api.expertFocus(id) == 200) {
            ToastUtils.show("关注成功");
          } else {
            ToastUtils.show("关注失败");
          }
        }
        await doRequestData();
      });

  clickToPay() async {
    Utils.onEvent('gdxq_zfyd');
    if (!isCanPay) {
      ToastUtils.show(planInfo?.footerContent ?? "观点所含比赛已开始，当前不可付费阅读！");
      return;
    }
    // if (User.auth == null) {
    //   final result = await Get.dialog(CommonDialog.select(
    //     '您尚未登录',
    //     '去登录（推荐）',
    //     '游客访问',
    //     content:
    //         '游客登录状态下充值会有以下限制：\n1.充值红钻及购买记录，无法转移至其他账号，仅限本设备使用；\n2.APP卸载后，充值的红钻无法找回。',
    //   ));
    //   // bool ulogin = User.isLogin;
    //   if (result == 0) {
    //     User.needLogin(() async {
    //       await doRequestData();
    //       doPayAction();
    //     });
    //   } else if (result == 1) {
    //     await User.visitorLogin();
    //     doPayAction();
    //   }
    // } else {
    //   doPayAction();
    // }
    bool ulogin = User.isLogin;
    User.needLogin(() async {
      if (!ulogin) {
        await doRequestData();
      }
      if (planInfo?.isFocus == 0 && planInfo?.activityId == 2) {
        bool toPay = await showModalBottomSheet(
            context: context,
            constraints: BoxConstraints(
                maxWidth: Get.width,
                maxHeight: 289 + (GetPlatform.isAndroid ? 0 : 17)),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(Utils.getImgPath("bottomsheet_close.png"))
                        .tap(Get.back),
                    Container(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("专家已设置粉丝不中退款",
                            style: Styles.mediumText(fontSize: 18)),
                        Container(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 36),
                          alignment: Alignment.center,
                          child: Text("您需要关注该专家以后，购买该观点才能享受不中退款。",
                              style: Styles.normalSubText(fontSize: 16),
                              textAlign: TextAlign.center),
                        ),
                        Container(height: 50),
                        CommonButton(
                          minWidth: Get.width,
                          minHeight: 44,
                          onPressed: () async {
                            await Api.expertFocus(planInfo?.expertId ?? "");
                            Get.back(result: true);
                          },
                          backgroundColor: Colours.main,
                          text: "关注并支付",
                          radius: 4,
                          textStyle: const TextStyle(
                              color: Colours.white, fontSize: 16),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 16, bottom: GetPlatform.isAndroid ? 0 : 17),
                          child: GestureDetector(
                            onTap: () {
                              Get.back(result: true);
                            },
                            child: Container(
                              width: Get.width,
                              alignment: Alignment.center,
                              child: Text(
                                "不关注并支付",
                                style: const TextStyle(
                                    color: Colours.grey99, fontSize: 14),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            });
        if (toPay) doPayAction();
      } else {
        doPayAction();
      }
    });
  }

  clickToExpert() async {
    Utils.onEvent('gdxq_zjtx');
    final expertId = planInfo?.expertId;
    if (expertId?.isEmpty ?? true) {
      return;
    }
    Get.toNamed(Routes.expertDetail,
        arguments: expertId!,
        parameters: {"index": "${(planInfo?.sportsId ?? 1) - 1}"});
  }

  doPayAction() async {
    final price = planInfo?.priceReal;
    if (price == null) {
      return;
    }
    final gold = double.tryParse(price);
    if (gold == null) {
      return;
    }
    final b = await PayBottomSheet.show(price, coupons: coupons ?? []);
    PayBottomBackPara payPara =
        (b is PayBottomBackPara) ? b : PayBottomBackPara(is2pay: false);
    if (!payPara.is2pay) {
      Utils.onEvent('gdxq_zfyd_qxzf');
      return;
    }
    Utils.onEvent('gdxq_zfyd_qrzf',
        params: {'gdxq_zfyd_qrzf': Get.find<UmService>().payOriginRoute});
    // 购买请求
    EasyLoading.show();
    try {
      final result = await Api.planOrder(gold, "${planId}",
          couponGold: payPara.coupon?.gold,
          couponId:
              payPara.coupon?.id == null ? null : "${payPara.coupon?.id}");
      EasyLoading.dismiss();
      if (result?.data['c'] == 200) {
        await Future.delayed(Duration(milliseconds: 400));
        await doRequestData();
        ToastUtils.show("解锁成功");
      } else if (result?.data['c'] == 1002) {
        final b = await Utils.alertQuery("余额不足，是否前往充值") ?? false;
        if (b) {
          Get.toNamed(Routes.recharge);
        }
      } else {
        final msg = result?.data['m'];
        ToastUtils.show(msg);
      }
    } catch (err) {
    } finally {
      EasyLoading.dismiss();
    }

    // log("plan order result = ${result?.data}");
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final boxlist = listKey.currentContext?.findRenderObject() as RenderBox;
      final l2 = boxlist.localToGlobal(Offset.zero);
      topOffset = l2.dy;
    });
    doRequestData(loading: true);
    if (!matchStart) {
      t = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (matchStart) {
          Future.delayed(const Duration(seconds: 1)).then((value) {
            doRequestData();
          });
          timer.cancel();
        }
        // update();
      });
    }
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) async {
        if (Platform.isIOS) {
          int sensitivity = 30;
          if (details.delta.dx > sensitivity) {
            bool b = await focusRequest();
            if (b) Get.back();
          }
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          return focusRequest();
        },
        child: Scaffold(
          // backgroundColor: Colours.scaffoldBg,
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () async {
                var result = await focusRequest();
                if (result == true) Get.back();
              },
              behavior: HitTestBehavior.translucent,
              child: Image.asset(
                Utils.getImgPath('arrow_back.png'),
                color: Colors.black,
              ),
            ),
            titleSpacing: 0,
            title: AnimatedSwitcher(
                duration: Duration(milliseconds: 400),
                child: barShow ? expertView.expertBar() : null),
            centerTitle: true,
          ),
          body: VisibilityDetector(
            key: Key("expert viewpoint detail"),
            onVisibilityChanged: (info) {
              if (info.visibleBounds.isEmpty) {
                return;
              }
              doRequestData();
            },
            child: SafeArea(
              top: false,
              bottom: false,
              child: planInfo == null
                  ? Container()
                  : Container(
                      child: NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            RenderBox? box = expertKey.currentContext
                                ?.findRenderObject() as RenderBox?;
                            if (box == null) {
                              return true;
                            }
                            final local =
                                box.localToGlobal(Offset(0, box.size.height));
                            final b = local.dy < topOffset - 70;
                            if (b != barShow) {
                              barShow = b;
                              update();
                            }
                            // log("scroll ${notification} ${local}");
                            return true;
                          },
                          child: EasyRefresh(
                            controller: refreshController,
                            onRefresh: () async {
                              await doRequestData();
                              refreshController.finishRefresh();
                            },
                            child: Column(
                              children: [
                                Expanded(
                                    child: ListView(
                                  key: listKey,
                                  children: [
                                    _titleHeader(),
                                    const Divider(
                                        height: 0.5, indent: 16, endIndent: 16),
                                    expertView
                                        .expertRow(key: expertKey)
                                        .marginOnly(top: 10),
                                    const SizedBox(height: 4),
                                    ...(planInfo?.matchBries?.map((e) =>
                                            MatchPlayView(
                                                planInfo: planInfo,
                                                match: e)) ??
                                        []),
                                    const SizedBox(height: 4),
                                    if (planInfo?.matchBries?.isEmpty ?? true)
                                      const SizedBox(height: 14),
                                    // _allReadBox(),
                                    PlanContentView(
                                        planInfo: planInfo, readable: readable),
                                    if (!readable) const SizedBox(height: 12),
                                    _tip(),
                                    if (planInfo?.pushPlan != null && readable)
                                      _otherViewPoints(),
                                    const SizedBox(height: 50),
                                  ],
                                )),
                                if (planInfo?.showFooter ?? false) _BuyBottom()
                              ],
                            ),
                          )),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  _titleHeader() {
    final pv = planInfo?.pv ?? 0;
    String pvStr = "${pv}人已浏览";
    if (pv > 10000) {
      pvStr = "${pv ~/ 10000}+人已浏览";
    }
    return Container(
      // height: 148,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            planInfo?.planTitle ?? "",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 22, color: _textBlack, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10),
          DefaultTextStyle(
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xff999999),
                  fontWeight: FontWeight.w400),
              child: Row(
                children: [
                  Text((planInfo?.pubTime?.formatedString("yyyy-MM-dd HH:mm") ??
                          "") +
                      " 发布"),
                  Spacer(),
                  Text(pvStr),
                ],
              ))
        ],
      ),
    );
  }

  Widget _tip() {
    final tipStyle = TextStyle(fontSize: 12, color: Colours.grey_color1);
    final tips = viewpointTips.isEmpty
        ? [
            LbtEntity(content: "友情提示"),
            LbtEntity(
                content:
                    "1.体育赛事数据、观点等信息仅供参考，不构成平台对您的任何买卖建议或承诺保证。 \n2.本平台不提供任何购彩服务，如需购彩请前往彩票店。")
          ]
        : viewpointTips;
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...tips.map((e) => Text(
                e.content ?? "",
                style: tipStyle,
              ).marginOnly(bottom: 6))
        ],
      ),
    );
  }

  Widget _otherViewPoints() {
    List<Widget> others = [];
    final pushPlans = planInfo?.pushPlan ?? [];
    for (var idx = 0; idx < pushPlans.length; idx++) {
      others.add(
          ExpertListItem(entity: pushPlans[idx], isExpertDetailView: true)
              .marginSymmetric(horizontal: 16));
      if (idx < pushPlans.length - 1) {
        others.add(Container(
          height: 4,
          color: const Color(0xfff5f5f5),
        ));
      }
    }

    return Container(
      color: Color(0xfff5f5f5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 10),
          Container(
            // padding: EdgeInsets.symmetric(horizontal: 16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '该专家的其他推荐',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          backgroundColor: Colors.white,
                          fontSize: 16,
                          height: 1.1,
                          color: _textBlack,
                          fontWeight: FontWeight.w600),
                    ).marginOnly(left: 16),
                    SizedBox(width: 5),
                    Text(
                      "(${planInfo!.pushPlan!.length})",
                      style: TextStyle(
                          fontSize: 12,
                          height: 1.1,
                          color: Colours.grey_color1),
                    )
                  ],
                ).marginOnly(top: 16, bottom: 12),
                ...others
                // ExpertListItem(entity: planInfo!.pushPlan!)
              ],
            ),
          )
        ],
      ),
    );
  }

  _BuyBottom() {
    final coupon = coupons?.filterOrNull((item) => item.autoSelect == 1)?.first;
    final price =
        (double.tryParse(planInfo?.priceReal ?? "") ?? 0) - (coupon?.gold ?? 0);
    final nprice =
        coupon == null ? planInfo?.priceReal : price.toStringAsFixed(2);
    return Column(
      children: [
        if (planInfo?.footerContent?.isNotEmpty ?? false)
          Container(
            height: 28,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Image.asset(Utils.getImgPath("planinfo_alert.png")),
                const SizedBox(width: 5),
                Text(
                  planInfo?.footerContent ?? "观点所含比赛已开始，当前不可付费阅读！",
                  style: TextStyle(
                      fontSize: 12, color: !isCanPay ? _red1 : _grey99),
                )
              ],
            ),
          ),
        const Divider(height: 1),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 56,
          child: Row(
            children: [
              coupon != null
                  ? Text(
                      "${price.toStringAsFixed(2)}红钻",
                      style: const TextStyle(
                          color: _red1,
                          fontWeight: FontWeight.w500,
                          height: 1.4),
                    )
                  : Text("${planInfo?.priceReal ?? "0"}红钻",
                      style: const TextStyle(
                          color: _red1,
                          fontWeight: FontWeight.w500,
                          height: 1.4)),
              const SizedBox(width: 5),
              if (nprice != planInfo?.price)
                Text(
                  "${planInfo?.price ?? "0"}红钻",
                  style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      fontSize: 12,
                      color: _grey99,
                      height: 1.4),
                ),
              const Spacer(),
              Stack(
                children: [
                  Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: CommonButton(
                        minHeight: 40,
                        minWidth: 108,
                        foregroundColor: !isCanPay ? _textGrey : Colors.white,
                        backgroundColor: !isCanPay ? _bgGrey : _red1,
                        textStyle: const TextStyle(fontWeight: FontWeight.w500),
                        onPressed: clickToPay,
                        text: "支付阅读"),
                  ),
                  planInfo?.activityId != null
                      ? Positioned(
                          top: 2,
                          right: 0,
                          child: Image.asset(Utils.getImgPath(
                              planInfo?.activityId == 1
                                  ? "refund_first.png"
                                  : "refund_fans.png")))
                      : Container()
                ],
              ),
            ],
          ),
        ),
        SafeArea(bottom: true, top: false, child: Container())
      ],
    );
  }

  static final focusTipedMap = {};

  Future<bool> focusRequest() async {
    if (focusTipedMap[planInfo?.planId] ?? false) {
      return true;
    }
    if (planInfo?.isFocus == 0 && readable && planInfo?.planStatus == 0) {
      focusTipedMap[planInfo?.planId] = true;
      var result = await Get.dialog(askFocus());
      return result;
    } else {
      return true;
    }
  }

  Widget askFocus() {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: SizedBox(
        width: 280,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 33),
              child: Text(
                "如果您认为专家的观点写的还不错可以关注一下哟！",
                textAlign: TextAlign.center,
                style: Styles.mediumText(fontSize: 16),
              )),
          Container(
            width: double.infinity,
            height: 0.5,
            color: Colours.grey_color2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: CommonButton(
                    onPressed: () => Get.back(result: true),
                    text: "以后再说",
                    minHeight: 44,
                    textStyle: const TextStyle(fontWeight: FontWeight.w500),
                    foregroundColor: Colours.grey_color),
              ),
              Container(
                width: 0.5,
                height: 44,
                color: Colours.grey_color2,
              ),
              Flexible(
                fit: FlexFit.tight,
                child: CommonButton(
                    onPressed: () async {
                      Api.expertFocus(planInfo?.expertId ?? "");
                      Get.back(result: true);
                    },
                    text: "关注",
                    minHeight: 44,
                    textStyle: const TextStyle(fontWeight: FontWeight.w500),
                    foregroundColor: Colours.main_color),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
