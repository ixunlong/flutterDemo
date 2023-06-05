import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/online_contact.dart';
import 'package:sports/util/utils.dart';

import '../../res/styles.dart';

class ActivityBugPage extends StatefulWidget {
  const ActivityBugPage({super.key});

  @override
  State<ActivityBugPage> createState() => _ActivityBugPageState();
}

class _ActivityBugPageState extends State<ActivityBugPage> {
  @override
  Widget build(BuildContext context) {
    double ratio = Get.width / 375;
    double bgheight = ratio * 1121;
    double btnOffset = ratio * 294;
    double rewardOffset = ratio * 18;
    double ruleOffset = ratio * 4;
    return Scaffold(
      appBar: Styles.appBar(
        title: Text("活动规则"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: bgheight,
          width: Get.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(Utils.getImgPath("activity_bug_bg.png"))
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: btnOffset),
              Image.asset(Utils.getImgPath("activity_bug_btn.png")).tap(() {
                // Get.offNamed(Routes.myContact);
                OnlineContact.instance.openServiceWindow();
              }),
              SizedBox(height: rewardOffset),
              Image.asset(Utils.getImgPath("activity_bug_reward.png")),
              SizedBox(height: ruleOffset),
              Image.asset(Utils.getImgPath("activity_bug_rule.png"))
            ],
          ),
        ),
      ),
    );
  }
}