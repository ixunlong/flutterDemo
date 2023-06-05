import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/widgets/common_button.dart';

class VideoSpeedBottomsheet extends StatefulWidget {
  final double initSpeed;
  const VideoSpeedBottomsheet(this.initSpeed, {super.key});

  @override
  State<VideoSpeedBottomsheet> createState() => _VideoSpeedBottomsheetState();
}

class _VideoSpeedBottomsheetState extends State<VideoSpeedBottomsheet> {
  final List<double> speedList = [0.5, 0.75, 1, 1.25, 1.5, 2, 3];
  late int selectIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectIndex =
        speedList.indexWhere((element) => element == widget.initSpeed);
  }

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
                SizedBox(height: 30),
                Text(
                  '请选择倍速',
                  style: TextStyle(color: Colours.text_color1, fontSize: 16),
                ),
                SizedBox(height: 30),
                Wrap(
                  spacing: (Get.width - 76 * 4) / 5 - 1,
                  runSpacing: 12,
                  children: List.generate(
                      speedList.length,
                      (index) => GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              // selectIndex = index;
                              Get.back(result: speedList[index]);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                    color: index == selectIndex
                                        ? Colours.main
                                        : Colours.transparent),
                                color: index == selectIndex
                                    ? Colours.redFFECEE
                                    : Colours.greyF5F7FA,
                              ),
                              alignment: Alignment.center,
                              width: 76,
                              height: 76,
                              child: Text(
                                '${speedList[index].toString()}X',
                                style: TextStyle(
                                    color: index == selectIndex
                                        ? Colours.main
                                        : Colours.text_color1,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          )),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: CommonButton.large(
                    onPressed: () {
                      Get.back();
                    },
                    radius: 4,
                    text: '取消',
                    backgroundColor: Colours.greyF2,
                    foregroundColor: Colours.grey66,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
