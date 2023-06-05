import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:sports/http/request_interceptor.dart';
import 'package:sports/locale/message.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/logic/service/match_service.dart';
import 'package:sports/logic/service/push_service.dart';
import 'package:sports/logic/service/resource_service.dart';
import 'package:sports/logic/service/third_login_service.dart';
import 'package:sports/logic/service/um_service.dart';
import 'package:sports/provider/theme_provider.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/app_config.dart';
import 'package:sports/util/lbt_dialog.dart';
import 'package:sports/util/online_contact.dart';
import 'package:sports/util/rsa_util.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/util/tip_resources.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/web_socket_connection.dart';
import 'package:sports/view/splash_page.dart';
import 'package:sports/widgets/app_float_widget.dart';

// import 'package:web_socket_channel/web_socket_channel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.configfromfile();
  await SpUtils.initSp();
  WsConnection.init();
  RsaUtil.init();
  // "F5E97BEC-347C-4C4A-86EE-C41C585AF397";
  // "3E059EB0-890F-4530-9928-E3ABC4E43CE3"
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp, // 竖屏 Portrait 模式
      DeviceOrientation.portraitDown,
    ],
  );
  await initServices();
  await Get.find<ResourceService>().getAppLaunch();
  await Get.find<ResourceService>().getNavigationTheme();
  runApp(const MyApp());
  // runApp(const MyApp());
  // SystemUiOverlayStyle uiStyle = const SystemUiOverlayStyle(
  //   systemNavigationBarColor: Colors.white,
  //   systemNavigationBarDividerColor: Colors.white,
  //   statusBarColor: Colors.white,
  //   systemNavigationBarIconBrightness: Brightness.light,
  //   statusBarIconBrightness: Brightness.light,
  //   statusBarBrightness: Brightness.light,
  // );

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
}

Future initServices() async {
  Get.putAsync(() => MatchService().init());
  Get.putAsync(() => ResourceService().init());
  Get.putAsync(() => UmService().init());
  Get.putAsync(() => PushService().init());
  Get.putAsync(() => ThirdLoginService().init());
  Get.putAsync(() => ConfigService().init());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // static const _platform = MethodChannel('customFlutterChannel');
  final pushService = Get.find<PushService>();

  @override
  void initState() {
    super.initState();
    // _platform.setMethodCallHandler(flutterMethod);
    WidgetsBinding.instance.addObserver(this);
    Connectivity().onConnectivityChanged.listen((event) {
      log("connectivity $event");
      HeaderDeviceInfo.networkSet(event);
    });
    Connectivity()
        .checkConnectivity()
        .then((event) => HeaderDeviceInfo.networkSet(event));

    TipResources.fetchTipResources();
    OnlineContact.instance.init();

    EasyLoading.instance.userInteractions = false;

    EasyRefresh.defaultHeaderBuilder = () {
      return const ClassicHeader(
        dragText: "下拉刷新",
        armedText: "松开刷新",
        failedText: "刷新失败",
        readyText: "正在刷新...",
        processingText: "正在刷新...",
        processedText: "刷新完成",
        messageText: '上次更新时间 %T',
        showMessage: false,
        iconTheme: IconThemeData(color: Colours.text_color),
        textStyle: TextStyle(fontSize: 12, color: Colours.grey_color1),
        messageStyle: TextStyle(fontSize: 10),
        // progressIndicatorSize: 32.0
      );
    };

    EasyRefresh.defaultFooterBuilder = () {
      return ClassicFooter(
        dragText: "上拉刷新",
        armedText: "松开刷新",
        failedText: "刷新失败",
        readyText: "正在加载更多的数据...",
        processingText: "正在加载更多的数据...",
        processedText: "刷新完成",
        noMoreText: "没有更多内容了~",
        messageText: '上次更新时间 %T',
        noMoreIcon: Container(),
        failedIcon: Container(),
        iconDimension: 0,
        spacing: 0,
        showMessage: false,
        textStyle: TextStyle(fontSize: 12),
        messageStyle: TextStyle(fontSize: 10),
        // progressIndicatorSize: 32.0
      );
    };
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // UpdateCheckDialog.checkUpdate();
      // Get.dialog(Dialog(
      //   child: NoNetworkWidget(),
      // ));
      User.fetchUserInfos();
      // if (pushService.jpush != null) {
      //   pushService.jpush!.setBadge(0);
      // }
    } else if (state == AppLifecycleState.inactive) {
      log('------inactive');
      Get.find<ConfigService>().saveConfig();
    } else if (state == AppLifecycleState.detached) {
      log('------detached');
    } else if (state == AppLifecycleState.paused) {
      log('------paused');
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return GetMaterialApp(
        title: '红球会',
        theme: ThemeProvider().getTheme(),
        debugShowCheckedModeBanner: false,
        home: const SplashPage(),
        getPages: Routes.getPages,
        onInit: () {
          EasyLoading.instance.userInteractions = false;
        },
        builder: EasyLoading.init(
          builder: (context, child) => AppFloatWidget(child: child),
        ),
        onReady: () async {
          // await WechatKitPlatform.instance.handleInitialWXReq();
        },
        locale: Get.deviceLocale,
        translations: LanguageInfoConfig(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        fallbackLocale: const Locale("zh", "CN"),
        supportedLocales: const [
          Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
          Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
        ],
        routingCallback: (value) {
          // log('routing cb -> ${Get.currentRoute}');
          LbtDialogUtil.checkShowDialog();
        },
      );
    });
  }
}
