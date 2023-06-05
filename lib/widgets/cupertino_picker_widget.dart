import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/common_button.dart';

class CupertinoPickerWidget extends StatelessWidget {
  final List<String> items;
  final String? title;
  final int initialIndex;
  final String? eventId;
  late FixedExtentScrollController controller;
  CupertinoPickerWidget(this.items,
      {super.key, this.title, this.initialIndex = 0, this.eventId}) {
    controller = FixedExtentScrollController(initialItem: initialIndex);
  }
  // : ;

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
            // padding: EdgeInsets.all(10),
            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.only(
            //         topLeft: Radius.circular(10), topRight: Radius.circular(10))),
            // height: 250,
            color: Colors.white,
            child: SafeArea(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    title ?? '',
                    style: TextStyle(color: Colours.text_color1, fontSize: 16),
                  ),
                ),
                // Container(
                //   height: 40,
                //   decoration: const BoxDecoration(
                //       border:
                //           Border(bottom: BorderSide(color: Colours.grey_color2))),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: <Widget>[
                //       TextButton(
                //         onPressed: () {
                //           // Navigator.pop(context);
                //           Get.back();
                //         },
                //         child: const Icon(
                //           Icons.close,
                //           size: 20,
                //           color: Colours.grey_color1,
                //         ),
                //       ),
                //       Text(title ?? ''),
                //       TextButton(
                //         onPressed: () {
                //           // Navigator.pop(context, controller.selectedItem);
                //           Get.back(result: controller.selectedItem);
                //         },
                //         child: const Icon(Icons.check,
                //             size: 20, color: Colours.main_color),
                //       ),
                //     ],
                //   ),
                // ),
                DefaultTextStyle(
                  style: const TextStyle(
                    color: Colours.text_color1,
                    fontSize: 22,
                  ),
                  child: Container(
                    height: 147,
                    child: CupertinoPicker(
                      scrollController: controller,
                      selectionOverlay:
                          const CupertinoPickerDefaultSelectionOverlay(
                        background: Colours.black11,
                      ),

                      diameterRatio: 1,
                      // offAxisFraction: 0.2, //轴偏离系数
                      // useMagnifier: true, //使用放大镜
                      // magnification: 1.5, //当前选中item放大倍数
                      itemExtent: 36, //行高
                      // backgroundColor: Colors.amber, //选中器背景色
                      onSelectedItemChanged: (value) {
                        // print("value = $value, 性别：${pickerChildren[value]}");
                      },
                      children: items.map((data) {
                        return Center(
                          child: Text(
                            data,
                            style: const TextStyle(color: Colours.text_color1),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 30, bottom: 20, left: 16, right: 16),
                  child: Row(children: [
                    Flexible(
                      child: CommonButton(
                        minWidth: double.infinity,
                        minHeight: 44,
                        backgroundColor: Colours.greyF2,
                        foregroundColor: Colours.grey_color,
                        radius: 4,
                        onPressed: () {
                          Get.back();
                        },
                        text: '取消',
                      ),
                    ),
                    SizedBox(width: 16),
                    Flexible(
                      child: CommonButton(
                        minWidth: double.infinity,
                        minHeight: 44,
                        backgroundColor: Colours.main_color,
                        foregroundColor: Colours.white,
                        radius: 4,
                        onPressed: () {
                          if (eventId != null) {
                            Utils.onEvent(eventId!, params: {
                              eventId!: '${controller.selectedItem + 1}'
                            });
                          }
                          Get.back(result: controller.selectedItem);
                        },
                        text: '确定',
                      ),
                    )
                  ]),
                ),
              ]),
            ));
      },
    );
  }
}
