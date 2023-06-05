import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/widgets/common_button.dart';

// ignore: must_be_immutable
class CommonDialog extends StatelessWidget {
  late int type;
  final String title;
  final String? content;
  String? confirmText;
  String? cancelText;

  String? selectText1;
  String? selectText2;
  TextAlign? contentAlign;
  // const CommonDialog(this.title, {super.key, this.content});

  ///提示框 单个按钮
  CommonDialog.hint(this.title,
      {super.key, this.content, this.confirmText = '确定'}) {
    type = 0;
  }

  ///确认框
  ///返回 true false
  CommonDialog.alert(this.title,
      {super.key,
      this.content,
      this.confirmText = '确定',
      this.cancelText = '取消'}) {
    type = 1;
  }

  ///选择框
  ///返回 0选项一 1选项二
  CommonDialog.select(this.title, this.selectText1, this.selectText2,
      {super.key,
      this.content,
      this.cancelText = '取消',
      this.contentAlign = TextAlign.left}) {
    type = 2;
  }

  @override
  Widget build(BuildContext context) {
    double top = 24;
    double bottom = 28;
    if ((type == 0 || (content == null && type == 1))) {
      top = 0;
      bottom = 0;
    }
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: SizedBox(
        width: 280,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            height: (type == 0 || (content == null && type == 1)) ? 110 : null,
            padding: EdgeInsets.fromLTRB(16, top, 16, bottom),
            child: Column(
                mainAxisAlignment: (type == 0 || (content == null && type == 1))
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colours.text_color1,
                        fontWeight: FontWeight.w500),
                  ),
                  if (content != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      content!,
                      textAlign: contentAlign ?? TextAlign.center,
                      style: const TextStyle(
                          fontSize: 14, color: Colours.grey_color),
                    ),
                  ]
                ]),
          ),
          Container(
            width: double.infinity,
            height: 0.5,
            color: Colours.grey_color2,
          ),
          _bottom()
        ]),
      ),
    );
  }

  Widget _bottom() {
    Widget widget;
    if (type == 0) {
      widget = CommonButton(
          onPressed: () => Get.back(),
          text: confirmText ?? '',
          minWidth: double.infinity,
          minHeight: 44,
          textStyle: TextStyle(fontWeight: FontWeight.w500),
          foregroundColor: Colours.main_color);
    } else if (type == 1) {
      widget = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: CommonButton(
                onPressed: () => Get.back(result: false),
                text: cancelText ?? '',
                minHeight: 44,
                textStyle: TextStyle(fontWeight: FontWeight.w500),
                foregroundColor: Colours.grey_color),
          ),
          Container(
            width: 0.5,
            height: 44,
            color: Colours.grey_color2,
          ),
          Flexible(
            fit: FlexFit.tight,
            child: CommonButton(
                onPressed: () => Get.back(result: true),
                text: confirmText ?? '',
                minHeight: 44,
                textStyle: TextStyle(fontWeight: FontWeight.w500),
                foregroundColor: Colours.main_color),
          ),
        ],
      );
    } else {
      widget = Column(
        children: [
          CommonButton(
              onPressed: () => Get.back(result: 0),
              text: selectText1 ?? '',
              minWidth: double.infinity,
              minHeight: 44,
              textStyle: TextStyle(fontWeight: FontWeight.w500),
              foregroundColor: Colours.main_color),
          Container(
            width: double.infinity,
            height: 0.5,
            color: Colours.grey_color2,
          ),
          CommonButton(
            onPressed: () => Get.back(result: 1),
            text: selectText2 ?? '',
            minWidth: double.infinity,
            minHeight: 44,
            textStyle: TextStyle(fontWeight: FontWeight.w500),
            foregroundColor: Colours.main_color,
          ),
          Container(
            width: double.infinity,
            height: 0.5,
            color: Colours.grey_color2,
          ),
          CommonButton(
              onPressed: () => Get.back(),
              text: cancelText ?? '',
              minWidth: double.infinity,
              minHeight: 44,
              textStyle: TextStyle(fontWeight: FontWeight.w500),
              foregroundColor: Colours.grey_color),
        ],
      );
    }
    return widget;
  }
}
