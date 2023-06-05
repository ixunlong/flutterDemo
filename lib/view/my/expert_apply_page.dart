import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports/http/dio_utils.dart';
import 'package:sports/logic/my/expert_apply_controller.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/logic/service/resource_service.dart';
import 'package:sports/model/home/lbt_entiry.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/utils.dart';
import '../../res/styles.dart';
import 'package:sports/view/my/web_page.dart';
import 'package:sports/widgets/common_button.dart';
import 'package:sports/widgets/picture_preview_widget.dart';
import 'package:sports/widgets/select_bottomsheet.dart';

class ExpertApplyPage extends StatefulWidget {
  const ExpertApplyPage({super.key});

  @override
  State<ExpertApplyPage> createState() => _ExpertApplyPageState();
}

class _ExpertApplyPageState extends State<ExpertApplyPage> {
  final controller = Get.put(ExpertApplyController());
  double rowHeight = 52;

  @override
  void initState() {
    Get.find<ConfigService>().tipEnable = false;
    super.initState();
  }

  @override
  void dispose() {
    Get.find<ConfigService>().tipEnable = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banner = Get.find<ResourceService>().expertApplyBanner;
    return Scaffold(
      appBar: Styles.appBar(title: const Text('申请认证')),
      backgroundColor: Colours.greyF7,
      body: GetBuilder<ExpertApplyController>(
        builder: (_) {
          return SafeArea(
            child: ListView(
              children: [
                if (banner != null) ...[
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: () {
                        banner.doJump();
                      },
                      child: Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 343 / 160,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: Get.find<ResourceService>()
                                        .expertApplyBanner!
                                        .imgUrl ??
                                    '',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (banner.content.valuable == true)
                            Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 6, top: 8, bottom: 8),
                                  decoration: BoxDecoration(
                                      gradient: banner.content == null
                                          ? null
                                          : LinearGradient(
                                              colors: [
                                                  Colors.black.withAlpha(
                                                      (0xff * 0.8).toInt()),
                                                  Colors.black.withAlpha(
                                                      (0xff * 0.5).toInt()),
                                                  Colors.transparent,
                                                  Colors.transparent,
                                                  Colors.transparent,
                                                  Colors.transparent
                                                ],
                                              // stops: [0.2,0.5],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter)),
                                  child: Text(
                                    banner.content ?? "",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        height: 1.2),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                        ],
                      ),
                    ),
                  )
                ],
                const SizedBox(height: 10),
                _top(),
                const SizedBox(height: 10),
                _middle(),
                const SizedBox(height: 10),
                _bottom()
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _top() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: Colours.white,
        child: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: rowHeight,
              child: Row(
                children: [
                  _title('入驻头像'),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      if (controller.data.status == 0) {
                        return;
                      }
                      FocusScope.of(context).requestFocus(FocusNode());
                      final result = await Get.bottomSheet(
                          SelectBottomSheet(['拍照', '从手机相册选择']));
                      if (result == 0) {
                        controller.addPhotoFromCamera(0);
                      } else if (result == 1) {
                        controller.addPhotoFromGallary(0);
                      }
                    },
                    child: ClipOval(
                        child: controller.data.logo == null
                            ? Image.asset(
                                Utils.getImgPath('add_photo_small.png'),
                                fit: BoxFit.cover,
                                width: 34,
                                height: 34,
                              )
                            : CachedNetworkImage(
                                imageUrl: controller.data.logo!,
                                fit: BoxFit.cover,
                                width: 34,
                                height: 34,
                              )),
                  )
                ],
              ),
            ),
            _line(),
            SizedBox(
              height: rowHeight,
              child: Row(
                children: [
                  _title('专家昵称'),
                  Expanded(
                      child: TextField(
                    enabled: controller.data.status != 0,
                    controller: controller.nickNameController,
                    // focusNode: _focusNode,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        hintText: '请输入专家昵称2-6字',
                        hintStyle:
                            TextStyle(color: Colours.greyAA, fontSize: 14),
                        contentPadding: EdgeInsets.all(0)),
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.text,
                    // style: TextStyleUtils.commonTextStyle,
                  ))
                ],
              ),
            ),
            _line(),
            SizedBox(
              height: rowHeight,
              child: Row(
                children: [
                  _title('擅长领域'),
                  const Spacer(),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => controller.onSelectType(3),
                    child: Container(
                      height: 40,
                      child: Row(
                        children: [
                          Image.asset(
                            Utils.getImgPath(controller.data.type == 3
                                ? 'select.png'
                                : 'unselect.png'),
                            width: 14,
                            height: 14,
                          ),
                          const SizedBox(width: 3),
                          const Text(
                            '足球和篮球',
                            style: TextStyle(
                                fontSize: 14, color: Colours.grey_color),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => controller.onSelectType(1),
                    child: Container(
                      height: 40,
                      child: Row(
                        children: [
                          Image.asset(
                            Utils.getImgPath(controller.data.type == 1
                                ? 'select.png'
                                : 'unselect.png'),
                            width: 14,
                            height: 14,
                          ),
                          const SizedBox(width: 3),
                          const Text(
                            '足球',
                            style: TextStyle(
                                fontSize: 14, color: Colours.grey_color),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => controller.onSelectType(2),
                    child: Container(
                      height: 40,
                      child: Row(
                        children: [
                          Image.asset(
                            Utils.getImgPath(controller.data.type == 2
                                ? 'select.png'
                                : 'unselect.png'),
                            width: 14,
                            height: 14,
                          ),
                          const SizedBox(width: 3),
                          const Text(
                            '篮球',
                            style: TextStyle(
                                fontSize: 14, color: Colours.grey_color),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            _line(),
            Container(
              padding: const EdgeInsets.only(top: 15, bottom: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      _title('专家介绍'),
                      const Text(
                        '（入驻成功用户可见）',
                        style:
                            TextStyle(color: Colours.grey_color1, fontSize: 14),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    enabled: controller.data.status != 0,
                    controller: controller.infoController,
                    decoration: const InputDecoration(
                      fillColor: Colours.greyF7,
                      filled: true,
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      hintText:
                          '请输入您的专家介绍，可以通过描述自身的优势，擅长的赛事等方面进行描述（建议20-50字之间）',
                      contentPadding: EdgeInsets.all(10),
                      hintStyle: TextStyle(
                        color: Colours.greyAA,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    // style: TextStyleUtils.commonTextStyle,
                    maxLines: 3,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      // EventViewModel.setEventValue(_event, field, value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _middle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colours.white,
      child: Column(children: [
        SizedBox(
          height: rowHeight,
          child: Row(
            children: [
              _title('姓名'),
              Expanded(
                  child: TextField(
                enabled: controller.data.status != 0,
                controller: controller.nameController,
                // focusNode: _focusNode,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: '请输入真实姓名',
                    hintStyle: TextStyle(color: Colours.greyAA, fontSize: 14),
                    contentPadding: EdgeInsets.all(0)),
                textAlign: TextAlign.right,
                keyboardType: TextInputType.text,
                // onChanged:,
                // style: TextStyleUtils.commonTextStyle,
              ))
            ],
          ),
        ),
        _line(),
        SizedBox(
          height: rowHeight,
          child: Row(
            children: [
              _title('身份证号'),
              Expanded(
                  child: TextField(
                enabled: controller.data.status != 0,
                controller: controller.idController,
                // focusNode: _focusNode,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: '请输入您的身份证号码',
                    hintStyle: TextStyle(color: Colours.greyAA, fontSize: 14),
                    contentPadding: EdgeInsets.all(0)),
                textAlign: TextAlign.right,
                keyboardType: TextInputType.text,
                // style: TextStyleUtils.commonTextStyle,
              ))
            ],
          ),
        ),
        _line(),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 15, bottom: 16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _title('上传身份证照片'),
            const SizedBox(height: 4),
            const Text(
              '我们将严格保密您上传的资料，请放心上传',
              style: TextStyle(color: Colours.greyAA, fontSize: 12),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Flexible(
                    fit: FlexFit.tight,
                    child: Column(
                      children: [
                        GestureDetector(
                            onTap: () async {
                              if (controller.data.status == 0) {
                                return;
                              }
                              FocusScope.of(context).requestFocus(FocusNode());
                              final result = await Get.bottomSheet(
                                  SelectBottomSheet(['拍照', '从手机相册选择']));
                              if (result == 0) {
                                controller.addPhotoFromCamera(1);
                              } else if (result == 1) {
                                controller.addPhotoFromGallary(1);
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: controller.data.idCard1 == null
                                  ? Image.asset(
                                      Utils.getImgPath('id_card_front.png'),
                                      width: double.infinity,
                                      height: 121,
                                      fit: BoxFit.cover,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: controller.data.idCard1!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 121,
                                    ),
                            )

                            // controller.idCardFront == null
                            //     ? Image.asset(
                            //         Utils.getImgPath('id_card_front.png'),
                            //         width: double.infinity,
                            //         height: 121,
                            //         fit: BoxFit.fill,
                            //       )
                            //     : Image.asset(controller.idCardFront!.path),
                            ),
                        const SizedBox(height: 6),
                        const Text(
                          '上传人像面',
                          style: TextStyle(color: Colours.greyAA, fontSize: 12),
                        )
                      ],
                    )),
                const SizedBox(
                  width: 15,
                ),
                Flexible(
                    fit: FlexFit.tight,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (controller.data.status == 0) {
                              return;
                            }
                            FocusScope.of(context).requestFocus(FocusNode());
                            final result = await Get.bottomSheet(
                                SelectBottomSheet(['拍照', '从手机相册选择']));
                            if (result == 0) {
                              controller.addPhotoFromCamera(2);
                            } else if (result == 1) {
                              controller.addPhotoFromGallary(2);
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: controller.data.idCard2 == null
                                ? Image.asset(
                                    Utils.getImgPath('id_card_back.png'),
                                    width: double.infinity,
                                    height: 121,
                                    fit: BoxFit.cover,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: controller.data.idCard2!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 121,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          '上传国徽面',
                          style: TextStyle(color: Colours.greyAA, fontSize: 12),
                        )
                      ],
                    ))
              ],
            )
          ]),
        )
      ]),
    );
  }

  Widget _bottom() {
    final resource = Get.find<ResourceService>();
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
          color: Colours.white,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _title('证明截图'),
            const SizedBox(height: 4),
            const Text(
              '入驻其他平台证明截图或过往比赛分析作品',
              style: TextStyle(color: Colours.greyAA, fontSize: 12),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              itemCount: controller.otherImage.length + 1 > 6
                  ? 6
                  : controller.otherImage.length + 1,
              padding: const EdgeInsets.only(bottom: 0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 6, mainAxisSpacing: 6),
              itemBuilder: (context, index) {
                if (index == controller.otherImage.length) {
                  return GestureDetector(
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      final result = await Get.bottomSheet(
                          SelectBottomSheet(['拍照', '从手机相册选择']));
                      if (result == 0) {
                        controller.addPhotoFromCamera(3);
                      } else if (result == 1) {
                        controller.addPhotoFromGallary(3);
                      }
                    },
                    child: Image.asset(Utils.getImgPath('add_image1.png')),
                  );
                } else {
                  return GestureDetector(
                    onTap: () async {
                      Get.dialog(
                          PicturePreview(
                              imageUrl: controller.otherImage[index]),
                          useSafeArea: false);
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: controller.otherImage[index],
                          fit: BoxFit.cover,
                          // width: double.infinity,
                          // height: 121,
                        ),
                        // Image.asset(
                        //   controller.otherImage[index],
                        //   fit: BoxFit.cover,
                        // ),
                        Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                controller.onDeleteImage(index);
                              },
                              child: Container(
                                width: 22,
                                height: 22,
                                color: Colours.blackColor,
                                child: const Icon(
                                  Icons.close,
                                  color: Colours.white,
                                  size: 14,
                                ),
                              ),
                            ))
                      ],
                    ),
                  );
                }
              },
            ),
          ]),
        ),
        const SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: rowHeight,
          color: Colours.white,
          child: Row(
            children: [
              _title('联系微信'),
              Expanded(
                  child: TextField(
                enabled: controller.data.status != 0,
                controller: controller.wxController,
                // focusNode: _focusNode,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: '请输入正确的微信号，以便与您联系',
                    hintStyle: TextStyle(color: Colours.greyAA, fontSize: 14),
                    contentPadding: EdgeInsets.all(0)),
                textAlign: TextAlign.right,
                keyboardType: TextInputType.text,
                // onChanged:,
                // style: TextStyleUtils.commonTextStyle,
              ))
            ],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            SizedBox(width: 16),
            GestureDetector(
              onTap: () => controller.onAgree(),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 5, 8),
                  child: Image.asset(
                    Utils.getImgPath(
                        controller.agree ? 'select.png' : 'unselect1.png'),
                    width: 14,
                    height: 14,
                  )),
            ),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: '我已阅读并同意',
                  style: TextStyle(color: Colours.grey_color1, fontSize: 12)),
              TextSpan(
                  text: '《自媒体协议》',
                  style: TextStyle(color: Colours.main_color, fontSize: 12),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Routes.agreements.toSelfMedia();
                      // Get.toNamed(Routes.webview,
                      //     arguments: const WebPara("", Constant.payPolicyUrl,
                      //         longpress: true));
                    }),
            ])),
          ],
        ),
        const SizedBox(height: 28),
        const Text('工作时间：周一至周五 8:30至17:30',
            style: TextStyle(color: Colours.grey_color, fontSize: 12)),
        const SizedBox(height: 8),
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                  text: '入驻客服微信：${resource.expertContact?.content}',
                  style:
                      const TextStyle(color: Colours.grey_color, fontSize: 12)),
              TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (resource.expertContact != null) {
                        Clipboard.setData(ClipboardData(
                            text: resource.expertContact!.content??''));
                        ToastUtils.show("已复制");
                      }
                    },
                  text: ' 复制',
                  style: const TextStyle(
                      color: Colours.guestColorBlue, fontSize: 12))
            ])),
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CommonButton.large(
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              controller.onApply();
            },
            text: '提交申请',
            radius: 24,
            minHeight: 48,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _title(String text) {
    return Text(text,
        style: const TextStyle(color: Colours.text_color1, fontSize: 16));
  }

  Widget _line() {
    return Container(
      width: double.infinity,
      height: 0.5,
      color: Colours.greyEE,
    );
  }
}
