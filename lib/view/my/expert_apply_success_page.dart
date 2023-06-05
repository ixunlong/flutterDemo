import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sports/logic/service/resource_service.dart';
import 'package:sports/model/expert/expert_apply_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/common_button.dart';
import '../../res/styles.dart';
import 'package:sports/util/date_utils_extension.dart';

class ExpertApplySuccessPage extends StatefulWidget {
  const ExpertApplySuccessPage({super.key});

  @override
  State<ExpertApplySuccessPage> createState() => _ExpertApplySuccessPageState();
}

class _ExpertApplySuccessPageState extends State<ExpertApplySuccessPage> {
  ExpertApplyEntity data = Get.arguments;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // data = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    String image = '';
    String title = '';
    String content = '';
    if (data.status == 0) {
      image = 'apply_status0.png';
      title = '审核中';
      content = '入驻专员会在5个工作日内联系您并最终告知您申请结果。';
    } else if (data.status == 1) {
      image = 'apply_status1.png';
      title = '审核通过';
      content = '经评估，您的综合素质符合红球会专家入驻标准，已正式成为平台专家!';
    } else {
      image = 'apply_status2.png';
      title = '审核未通过';
      content = '很遗憾，您的入驻申请未通过，如需再次申请，请联系客服后重新提交资料。';
    }
    return Scaffold(
      backgroundColor: Colours.scaffoldBg,
      appBar: Styles.appBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Container(
            color: Colours.white,
            padding: EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              children: [
                SizedBox(height: 60),
                Image.asset(
                  Utils.getImgPath(image),
                  width: 52,
                ),
                SizedBox(height: 20),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 22,
                      color: Colours.text_color1,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20),
                Text(content,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colours.text_color1)),
                if (data.status == 0) ...[
                  SizedBox(height: 20),
                  Text(
                      '申请时间: ${DateUtilsExtension.formatDateString(data.createTime!, 'yyyy-MM-dd HH:mm')}',
                      style:
                          TextStyle(fontSize: 12, color: Colours.grey_color1)),
                  SizedBox(height: 30),
                  Divider(height: 0.5, color: Colours.greyEE),
                  SizedBox(height: 30),
                  Text('请耐心等待审核结果，可通过上传其他证明图片加速审核。',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, color: Colours.text_color1)),
                ],
                SizedBox(height: 40),
                bottom()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bottom() {
    // if (data.status == 1) {
    //   return
    // } else {

    // }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CommonButton(
          onPressed: () {
            final resource = Get.find<ResourceService>();
            if (resource.expertContact != null) {
              // Clipboard.setData(
              //     ClipboardData(text: resource.expertContact!.content));
              // ToastUtils.show("已复制客服微信号");
            }
          },
          text: '客服微信',
          side: BorderSide(color: Colours.main),
          minWidth: (Get.width - 122) / 2,
          minHeight: 48,
        ),
        if (data.status != 1) ...[
          Spacer(),
          CommonButton(
            onPressed: () {
              Get.offNamed(Routes.expertApply, arguments: data);
            },
            text: data.status == 0 ? '上传图片' : '重新申请',
            // side: BorderSide(color: Colours.main),
            backgroundColor: Colours.main,
            foregroundColor: Colours.white,
            minWidth: (Get.width - 122) / 2,
            minHeight: 48,
          )
        ]
      ],
    );
  }
}
// class ExpertApplySuccessPage extends StatelessWidget {
//   const ExpertApplySuccessPage({super.key});

//   @override
//   Widget build(BuildContext context) {

//   }
// }
