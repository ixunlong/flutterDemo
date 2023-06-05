import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/utils.dart';

class CommonBottomSheet extends StatelessWidget {
  final Widget child;
  const CommonBottomSheet({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      enableDrag: false,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      onClosing: () {},
      builder: (context) {
        return Container(
          // height: 700,
          padding: EdgeInsets.symmetric(horizontal: 16),
          color: Colors.white,
          child: SafeArea(
            child: ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 10),
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Image.asset(
                          Utils.getImgPath('bottomsheet_close.png'),
                          width: 24,
                          height: 24),
                    ),
                  ),
                  child
                ]),
          ),
        );
      },
    );
  }
}
