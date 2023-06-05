import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:sports/http/apis/comments.dart';
import 'package:sports/model/home/home_news_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/app_news_float2_widget.dart';
import 'package:tencent_kit/tencent_kit_platform_interface.dart';
import 'package:wechat_kit/wechat_kit.dart';
// import 'package:weibo_kit/weibo_kit_platform_interface.dart';

class NewsShareBottomSheet extends StatelessWidget {
  const NewsShareBottomSheet(
      {super.key,
      required this.news,
      this.classId,
      this.collection,
      this.fuchuang});

  final shareItems = const [
    ['share_wx.png', '微信'],
    ['share_timeline.png', '朋友圈'],
    ['share_qq.png', 'QQ'],
    ['share_qqzone.png', 'QQ空间'],
    ['share_wb.png', '微博'],
    ['share_clipboard.png', '复制链接'],
  ];

  final HomeNewsEntity news;
  final int? classId;

  final void Function()? collection;
  final void Function()? fuchuang;

  Future share(String name) async {
    final url = news.h5url ??
        "https://www.qiuxiangbiao.com/newsDetail?id=${news.id}&cid=$classId";

    final String title = news.title ?? "";
    String content = '看比分、看数据、看专家推荐，就来红球会！';
    final File logo = await DefaultCacheManager().getSingleFile(
        'https://oss.qiuxiangbiao.com/prod/resource/qxb_logo.png');
    // String imageUri =
    //     'https://oss.qiuxiangbiao.com/prod/resource/qxb_logo.png';
    final ByteData bytes =
        await rootBundle.load(Utils.getImgPath('qxb_logo.png'));
    final Uint8List thumbImage = bytes.buffer.asUint8List();
    switch (name) {
      case '微信':
        WechatKitPlatform.instance.shareWebpage(
            scene: WechatScene.SESSION,
            title: title,
            description: content,
            thumbData: thumbImage,
            webpageUrl: url);
        break;
      case '朋友圈':
        WechatKitPlatform.instance.shareWebpage(
            scene: WechatScene.TIMELINE,
            title: title,
            description: content,
            thumbData: thumbImage,
            webpageUrl: url);
        break;
      case 'QQ':
        TencentKitPlatform.instance.shareWebpage(
            scene: TencentScene.SCENE_QQ,
            title: title,
            summary: content,
            appName: '红球会',
            imageUri: Uri.file(logo.path),
            targetUrl: url);
        break;
      case 'QQ空间':
        TencentKitPlatform.instance.shareWebpage(
            scene: TencentScene.SCENE_QZONE,
            title: title,
            summary: content,
            appName: '红球会',
            imageUri: Uri.file(logo.path),
            targetUrl: url);
        break;
      case '微博':
        // WeiboKitPlatform.instance.shareWebpage(
        //   thumbData: thumbImage,
        //   title: title,
        //   description: content,
        //   webpageUrl: url);
        break;
      case '复制链接':
        Clipboard.setData(ClipboardData(text: url))
            .then((value) => ToastUtils.show("已复制分享链接"));
        break;
      default:
    }

    //通知后台用户已分享新闻
    final id = news.id;
    if (id != null) {
      NewsComments.newsSupport(id, type: 3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        backgroundColor: Colors.white,
        onClosing: () {},
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        clipBehavior: Clip.hardEdge,
        builder: (context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 24,
                ),
                _shareRow().marginSymmetric(horizontal: 20),
                const SizedBox(
                  height: 16,
                ),
                _funcRow().marginSymmetric(horizontal: 20),
                const SizedBox(
                  height: 24,
                ),
                Container(color: Colours.greyF7, height: 10),
                Container(
                  height: 52,
                  alignment: Alignment.center,
                  child: const Text(
                    "取消",
                    style: TextStyle(color: Colours.text_color1, fontSize: 17),
                  ),
                ).tap(() {
                  Get.back();
                }),
              ],
            ),
          );
        });
  }

  Widget _shareRow() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            ...shareItems.map((e) => _btn(e[0], e[1]).tap(() async {
                  await share(e[1]);
                  Get.back();
                }).marginOnly(right: (Get.width - 32 - 20) / 5 - 50))
          ],
        ),
      );

  Widget _funcRow() => Container(
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          children: [
            // _btn("comment_collection.png", "收藏").tap(() {
            //   Get.back();
            //   collection?.call();
            // }),
            _btn("comment_fuchuang.png",
                    AppNewsFloat2Widget.existNews(news.id ?? 0) ? "取消浮窗" : "浮窗")
                .tap(() {
              Get.back();
              if (AppNewsFloat2Widget.existNews(news.id ?? 0)) {
                AppNewsFloat2Widget.delNews(news.id);
              } else {
                news.classId = classId ?? news.classId;
                AppNewsFloat2Widget.addNews(news).then((value) {});
              }
            }),
            // ...List.generate(4, (index) => Container(width: 50,))
          ],
        ),
      );

  Widget _btn(String img, String name) {
    return Column(
      children: [
        Image.asset(Utils.getImgPath(img), width: 50, height: 50),
        const SizedBox(height: 4),
        Text(
          name,
          style: const TextStyle(color: Colours.grey66, fontSize: 12),
        )
      ],
    );
  }
}
