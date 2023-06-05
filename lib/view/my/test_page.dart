import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/login/login_logic.dart';
import 'package:sports/logic/service/um_service.dart';
import 'package:sports/view/login/login_page.dart';
import 'package:sports/view/match_detail/soccer_match_detail/soccer_match_detail_page.dart';
import 'package:sports/view/my/my_page.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final logic = Get.put(UmService());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      child: Column(
        children: [
          TextButton(
            child: Text('Umeng'),
            onPressed: () async {
              logic.login(LoginType.login);
            },
          ),
          TextButton(
              onPressed: () {
                Get.to(() => const LoginPage(),
                    transition: Transition.downToUp);
              },
              child: Text("登录")),
          TextButton(
              onPressed: () {
                Get.to(() => const MyPage(), transition: Transition.downToUp);
              },
              child: Text("我的1")),
          TextButton(
              onPressed: () {
                Get.to(() => const SoccerMatchDetailPage(),
                    transition: Transition.downToUp, arguments: 3233);
              },
              child: Text("足球详情")),
        ],
      ),
    ));
  }
}
