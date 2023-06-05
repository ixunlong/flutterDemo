import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../res/colours.dart';
import '../res/styles.dart';
import 'common_button.dart';

class DescribeDialog extends StatelessWidget{
  const DescribeDialog({super.key, required this.content, required this.title, required this.confirmText});

  final String title;
  final List<String> content;
  final String confirmText;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 280,
        padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 16),
        decoration: BoxDecoration(
            color: Colours.white,
            borderRadius: BorderRadius.circular(8)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,style: Styles.mediumText(fontSize: 16)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: List.generate(content.length, (index) =>
                  Padding(
                    padding: EdgeInsets.only(top: index == 0?0:5),
                    child: Text(content[index].split('').join("\u200A"),
                      style: Styles.normalSubText(fontSize: 14).copyWith(letterSpacing: -0.3),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ),
            ),
            CommonButton(
              minWidth: Get.width,
              minHeight: 44,
              onPressed: Get.back,
              backgroundColor: Colours.main,
              text: confirmText,
              radius: 4,
              textStyle: const TextStyle(color: Colours.white,fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}