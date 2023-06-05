import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';

class BottomVibrationHintPage extends StatelessWidget {
  const BottomVibrationHintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.appBar(title: Text('震动提示说明')),
      body: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 10),
          child: Column(
            children: [
              Image.asset(
                Utils.getImgPath('bottom_vibration_hint.png'),
                fit: BoxFit.fill,
                width: double.infinity,
              ),
              SizedBox(height: 20),
              Text(
                '切换底部导航栏时，APP会震动提示哦',
                style: TextStyle(color: Colours.grey66, fontSize: 12),
              )
            ],
          )),
    );
  }
}
