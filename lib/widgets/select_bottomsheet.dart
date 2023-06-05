import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sports/res/colours.dart';

class SelectBottomSheet extends StatelessWidget {
  List<String> titles;
  String? top;
  SelectBottomSheet(
    this.titles, {
    super.key,
    this.top,
  });

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
          color: Colours.greyFD,
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (top != null)
                  Container(
                    height: 52,
                    color: Colours.greyFD,
                    child: Center(
                        child: Text(
                      top!,
                      style: TextStyle(fontSize: 17, color: Colours.grey99),
                    )),
                  ),
                MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  removeBottom: true,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: titles.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Get.back(result: index);
                        },
                        child: Container(
                          height: 52,
                          color: Colours.greyFD,
                          child: Center(
                              child: Text(
                            titles[index],
                            style: TextStyle(
                                fontSize: 17, color: Colours.text_color1),
                          )),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Container(
                        width: double.infinity,
                        height: 0.5,
                        color: Colours.grey_color2,
                      );
                    },
                  ),
                ),
                Container(
                  height: 10,
                  width: double.infinity,
                  color: Colours.greyF7,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 52,
                    color: Colours.greyFD,
                    child: Center(
                        child: Text('取消',
                            style: TextStyle(
                                fontSize: 17, color: Colours.text_color1))),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
