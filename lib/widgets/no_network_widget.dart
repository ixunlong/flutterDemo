import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sports/util/utils.dart';
import 'package:get/get.dart';

class NoNetworkWidget extends StatelessWidget {
  const NoNetworkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Utils.getImgPath("net_unavailable.png"),
            width: 157.5,
            height: 157.5,
          ),
          SizedBox(
            height: 15,
          ),
          Text("网络不稳定").marginSymmetric(vertical: 27.5),
          SizedBox(
            width: 90,
            height: 35,
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6))),
                onPressed: () {},
                child: Text("重新连接")),
          )
        ],
      ),
    );
  }
}
