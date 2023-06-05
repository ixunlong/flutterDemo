import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/utils.dart';

class ShareBottomSheet extends StatelessWidget {
  List images = [
    'share_wx.png',
    'share_timeline.png',
    'share_qq.png',
    'share_qqzone.png',
    'share_wb.png'
  ];
  List titles = ['微信', '朋友圈', 'QQ', 'QQ空间', '微博'];

  VoidCallback? onShareWx;
  VoidCallback? onShareTimeline;
  VoidCallback? onShareQQ;
  VoidCallback? onShareQQZone;
  VoidCallback? onShareWb;

  ShareBottomSheet(
      {super.key,
      this.onShareWx,
      this.onShareTimeline,
      this.onShareQQ,
      this.onShareQQZone,
      this.onShareWb});

  static show(
      {VoidCallback? onShareWx,
      VoidCallback? onShareTimeline,
      VoidCallback? onShareQQ,
      VoidCallback? onShareQQZone,
      VoidCallback? onShareWb}) {
    Get.bottomSheet(ShareBottomSheet(
        onShareWx: onShareWx,
        onShareTimeline: onShareTimeline,
        onShareQQ: onShareQQ,
        onShareQQZone: onShareQQZone,
        onShareWb: onShareWb));
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
                SizedBox(height: 14),
                Text(
                  '分享至',
                  style: TextStyle(color: Colours.grey99),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      List.generate(titles.length, (index) => item(index)),
                ),
                SizedBox(height: 24),
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

  item(int index) {
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          if (onShareWx != null) {
            onShareWx!();
          }
        } else if (index == 1) {
          if (onShareTimeline != null) {
            onShareTimeline!();
          }
        } else if (index == 2) {
          if (onShareQQ != null) {
            onShareQQ!();
          }
        } else if (index == 3) {
          if (onShareQQZone != null) {
            onShareQQZone!();
          }
        } else if (index == 4) {
          if (onShareWb != null) {
            onShareWb!();
          }
        }
      },
      child: Column(children: [
        Image.asset(Utils.getImgPath(images[index]), width: 50),
        SizedBox(height: 4),
        Text(
          titles[index],
          style: TextStyle(fontSize: 12, color: Colours.grey99),
        )
      ]),
    );
  }
}
