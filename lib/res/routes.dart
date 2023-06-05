import 'package:get/get.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/middleware/um_middleware.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/view/activity/activity_1zhe_page.dart';
import 'package:sports/view/activity/activity_bug_page.dart';
import 'package:sports/view/data/data_page.dart';
import 'package:sports/view/data/second_data_page.dart';
import 'package:sports/view/expert/expert_detail_page.dart';
import 'package:sports/view/expert/expert_page.dart';
import 'package:sports/view/expert/viewpoint_page.dart';
import 'package:sports/view/home/home_page.dart';
import 'package:sports/view/home/home_video_news_page.dart';
import 'package:sports/view/home/news_transition.dart';
import 'package:sports/view/home/news_view.dart';
import 'package:sports/view/login/login_page.dart';
import 'package:sports/view/login/login_verify_page.dart';
import 'package:sports/view/match/basketball/basket_filter_page.dart';
import 'package:sports/view/match/config/basket_config_page.dart';
import 'package:sports/view/match/config/basket_odds_config_page.dart';
import 'package:sports/view/match/config/basket_odds_type_page.dart';
import 'package:sports/view/match/config/basket_push_config_page.dart';
import 'package:sports/view/match/config/odds_company_page.dart';
import 'package:sports/view/match/config/odds_show_page.dart';
import 'package:sports/view/match/config/alert_range_page.dart';
import 'package:sports/view/match/config/soccer_config_page.dart';
import 'package:sports/view/match/config/soccer_odds_config_page.dart';
import 'package:sports/view/match/config/soccer_odds_type_page.dart';
import 'package:sports/view/match/config/soccer_push_config_page.dart';
import 'package:sports/view/match/config/soccer_sound_page.dart';
import 'package:sports/view/match/match_filter_page.dart';
import 'package:sports/view/match/match_page.dart';
import 'package:sports/view/match_detail/basketball_match_detail/bb_detail_page.dart';
import 'package:sports/view/match_detail/basketball_match_detail/bb_odds_detail_view.dart';
import 'package:sports/view/match_detail/soccer_match_detail/soccer_match_detail_page.dart';
import 'package:sports/view/match_detail/soccer_match_detail/soccer_match_odds_detail_view.dart';
import 'package:sports/view/my/about_us_page.dart';
import 'package:sports/view/my/account_bind_page.dart';
import 'package:sports/view/my/account_safe_page.dart';
import 'package:sports/view/my/account_verify_page.dart';
import 'package:sports/view/my/coin_detail_page.dart';
import 'package:sports/view/my/coin_history_page.dart';
import 'package:sports/view/my/contact_page.dart';
import 'package:sports/view/my/discount/my_discount_page.dart';
import 'package:sports/view/my/expert_apply_page.dart';
import 'package:sports/view/my/expert_apply_success_page.dart';
import 'package:sports/view/my/expert_request_type_page.dart';
import 'package:sports/view/my/msg/msg_page.dart';
import 'package:sports/view/my/my_focus_page.dart';
import 'package:sports/view/my/my_purchase_page.dart';
import 'package:sports/view/my/privacy_setting_page.dart';
import 'package:sports/view/my/push_setting_page.dart';
import 'package:sports/view/my/recharge_page.dart';
import 'package:sports/view/my/select_focus_team_page.dart';
import 'package:sports/view/my/setting_page.dart';
import 'package:sports/view/my/system_avatars_page.dart';
import 'package:sports/view/my/web_page.dart';
import 'package:sports/view/navigation_page.dart';
import 'package:sports/view/team/basketball/basket_team_detail_page.dart';
import 'package:sports/view/team/soccer_team_detail_page.dart';

import '../view/expert/expert_all_page.dart';
import '../view/expert/expert_search_page.dart';
import '../view/match_detail/soccer_match_detail/soccer_data_bottom_dialog.dart';

class RoutesAgreement {
  toService() async => await Get.toNamed(Routes.webview,
      arguments:
          const WebPara("", Constant.serviceAgreementUrl, longpress: true));
  toPrivicy() async => await Get.toNamed(Routes.webview,
      arguments: const WebPara("", Constant.privacyPolicyUrl, longpress: true));
  toRecharge() async => await Get.toNamed(Routes.webview,
      arguments: const WebPara("", Constant.payPolicyUrl, longpress: true));
  toLess18() async => await Get.toNamed(Routes.webview,
      arguments: const WebPara("", Constant.less18PolicyUrl, longpress: true));
  toSelfMedia() async => await Get.toNamed(Routes.webview,
      arguments:
          const WebPara("", Constant.selfmediaPolicyUrl, longpress: true));
}

class Routes {
  static const navigation = '/navigation';
  static const home = '/home';
  static const match = '/match';
  static const expert = '/expert';
  static const data = '/data';
  static const matchSift = '/match/sift';
  static const soccerMatchDetail = '/soccer/detail';
  static const soccerDataDialog = '/soccer/detail/dialog';
  static const soccerOddsDetail = '/soccer/detail/oddsDetail';
  static const login = '/login';
  static const loginVerify = '/login/verify';
  static const webview = '/webview';
  static const homenews = "/home/news";
  static const homeVideoNews = "/home/videoNews";
  static const recharge = "/my/recharge";
  static const myFocus = "/my/focus";
  static const myPurchase = "/my/purchase";
  static const coinHistory = "/my/coin/history";
  static const coinDetial = "/my/coin/detail";
  static const expertViewpoint = "/expert/viewpoint";
  static const mySetting = "/my/setting";
  static const myAboutus = "/my/aboutus";
  static const myPrivicySetting = "/my/privicySetting";
  static const myContact = "/my/contact";
  static const myPushSetting = "/my/pushSetting";
  static const expertDetail = "/expert/detail";
  static const viewpoint = "/expert/viewpoint";
  static const expertSearch = "/expert/search";
  static const expertApply = "/expert/apply";
  static const expertRequestType = "/my/requestType";
  static const expertAll = "/expert/all";
  static const expertApplySuccess = "/expert/apply/success";
  static const dataPoints = "/data/dataPoints";
  static const dataSchedule = "/data/dataSchedule";
  static const dataOther = "/data/dataOther";
  static const dataSecond = "/data/dataSecond";
  static const accountSafe = "/my/accountSafe";
  static const accountBind = "/my/accountBind";
  static const accountVerify = "/my/accountVerify";
  static const activity1zhe = "/activity/1zhe";
  static const activityBug = "/activity/bug";
  static const myCoupons = "/my/coupons";
  static const myMsg = "/my/msg";
  static const soccerTeamDetail = "/soccer/teamDetail";
  static const systemAvatars = "/my/systemAvatars";
  static const selectFocusTeam = "/focus/selectTeam";
  static const soccerConfig = "/soccer/config";
  static const alertRangeConfig = "/config/alertRange";
  static const soccerOddsConfig = "/soccer/oddsConfig";
  static const soccerOddsType = "/soccer/oddsType";
  static const oddsCompany = "/odds/company";
  static const oddsShow = "/odds/show";
  static const soccerPushConfig = "/soccer/pushConfig";
  static const soccerSoundConfig = "/soccer/soundConfig";
  static const basketballConfig = "/basketball/config";
  static const basketOddsConfig = "/basketball/oddsConfig";
  static const basketOddsType = "/basket/oddsType";
  static const basketPushConfig = "/basket/pushConfig";
  static const basketMatchDetail = "/basket/detail";
  static const basketFilter = "/basket/filter";
  static const basketTeamDetail = "/basket/teamDetail";
  static const basketOddsDetail = '/basket/detail/oddsDetail';

  static final agreements = RoutesAgreement();

  static final getPages = [
    GetPage(name: navigation, page: () => NavigationPage()),
    GetPage(name: home, page: () => HomePage()),
    GetPage(
        name: match,
        page: () => const MatchPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: expert,
        page: () => const ExpertPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: data,
        page: () => const DataPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: login,
        page: () => const LoginPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: loginVerify,
        page: () => const LoginVerifyPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: matchSift,
        page: () => const MatchFilterPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: soccerMatchDetail,
        page: () => const SoccerMatchDetailPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: soccerDataDialog,
        page: () => const SoccerDataBottomDialog(),
        opaque: false,
        fullscreenDialog: true),
    GetPage(name: soccerOddsDetail, page: () => SoccerMatchOddsDetailView()),
    GetPage(name: myMsg, page: () => const MsgPage()),
    GetPage(
        name: webview,
        page: () => const WebPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: homenews,
        page: () => const NewsView(),
        middlewares: [UmMiddleware()],
        transitionDuration: const Duration(milliseconds: 100),
        customTransition: NewsTransition()
        ),
    GetPage(
        name: homeVideoNews,
        page: () => const HomeVideoNewsPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: recharge,
        page: () => const RechargePage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: myFocus,
        page: () => const MyFocusPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: coinHistory,
        page: () => const CoinHistoryPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: coinDetial,
        page: () => const CoinDetailPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: myPurchase,
        page: () => const MyPurchasePage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: expertViewpoint,
        page: () => const ViewpointPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: mySetting,
        page: () => const SettingPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: myAboutus,
        page: () => const AboutUsPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: myPrivicySetting,
        page: () => const PrivacySettingPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: myContact,
        page: () => const ContactPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: myPushSetting,
        page: () => const PushSettingPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: expertDetail,
        page: () => const ExpertDetailPage(),
        parameters: const {"index": "0"},
        middlewares: [UmMiddleware()]),
    GetPage(
        name: expertSearch,
        page: () => const ExpertSearchPage(),
        middlewares: [UmMiddleware()],
        transition: Transition.rightToLeft,
        fullscreenDialog: true),
    GetPage(
        name: viewpoint,
        page: () => const ViewpointPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: expertApply,
        page: () => const ExpertApplyPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: expertRequestType,
        page: () => ExpertRequestTypePage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: expertAll,
        page: () => ExpertAllPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: expertApplySuccess,
        page: () => const ExpertApplySuccessPage(),
        middlewares: [UmMiddleware()]),
    // GetPage(
    //     name: dataPoints,
    //     page: () => const DataPointsPage(),
    //     middlewares: [UmMiddleware()]),
    // GetPage(
    //     name: dataSchedule,
    //     page: () => const DataSchedulePage(),
    //     middlewares: [UmMiddleware()]),
    GetPage(
        name: dataSecond,
        page: () => SecondDataPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: accountSafe,
        page: () => const AccountSafePage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: accountBind,
        page: () => const AccountBindPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: accountVerify, 
        page: () => const AccountVerifyPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: activity1zhe,
        page: () => Activity1zhePage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: activityBug,
        page: () => const ActivityBugPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: myCoupons,
        page: () => const MyDiscountPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: soccerTeamDetail,
        page: () => const SoccerTeamDetailPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: systemAvatars,
        page: () => const SystemAvatarsPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: selectFocusTeam,
        page: () => const SelectFocusTeamPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: soccerConfig,
        page: () => const SoccerConfigPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: alertRangeConfig,
        page: () => const AlertRangePage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: soccerOddsConfig,
        page: () => const SoccerOddsConfigPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: soccerOddsType,
        page: () => const SoccerOddsTypePage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: oddsCompany,
        page: () => const OddsCompanyPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: oddsShow,
        page: () => const OddsShowPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: soccerPushConfig,
        page: () => const SoccerPushConfigPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: soccerSoundConfig,
        page: () => const SoccerSoundPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: basketballConfig,
        page: () => const BasketConfigPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: basketOddsConfig,
        page: () => const BasketOddsConfigPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: basketOddsType,
        page: () => const BasketOddsTypePage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: basketPushConfig,
        page: () => const BasketPushConfigPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: basketMatchDetail,
        page: () => const BbDetailPage(),
        middlewares: [UmMiddleware()]),
    GetPage(name: basketOddsDetail, page: () => BbOddsDetailView()),
    GetPage(
        name: basketFilter,
        page: () => const BasketFilterPage(),
        middlewares: [UmMiddleware()]),
    GetPage(
        name: basketTeamDetail,
        page: () => const BasketTeamDetailPage(),
        middlewares: [UmMiddleware()]),
  ];
}
