import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/common_button.dart';

class SystemAvatarsPage extends StatefulWidget {
  const SystemAvatarsPage({super.key});

  @override
  State<SystemAvatarsPage> createState() => _SystemAvatarsPageState();
}

class _SystemAvatarsPageState extends State<SystemAvatarsPage> {
  List<String> avatars = [];
  int? selectIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final data = await Api.getSystemAvatar();
      if (data != null) {
        for (int i = 0; i < data.length; i++) {
          if (data[i] == User.info?.avatar) {
            selectIndex = i;
          }
        }
        avatars = data;
        update();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.appBar(title: Text('头像替换')),
      backgroundColor: Colours.scaffoldBg,
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                height: 160,
                alignment: Alignment.center,
                color: Colours.white,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: selectIndex == null
                        ? User.info?.avatar ?? ''
                        : avatars[selectIndex!],
                    width: 80,
                    height: 80,
                    errorWidget: (context, url, error) => Image.asset(
                        Utils.getImgPath("my_header.png"),
                        fit: BoxFit.fill),
                    // placeholder: (context, url) => Image.asset(
                    //     Utils.getImgPath("my_header.png"),
                    //     fit: BoxFit.fill)
                  ),
                ),
              ),
              SizedBox(height: 10),
              Wrap(
                  spacing: 0.5,
                  runSpacing: 0.5,
                  children: List.generate(
                      avatars.length,
                      (index) => GestureDetector(
                            onTap: () {
                              selectIndex = index;
                              update();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: selectIndex == index
                                      ? Colours.redFFF2F2
                                      : Colours.white,
                                  border: selectIndex == index
                                      ? Border.all(
                                          color: Colours.main, width: 1)
                                      : null),
                              height: 140,
                              width: (Get.width - 1) / 3,
                              alignment: Alignment.center,
                              child: CachedNetworkImage(
                                imageUrl: avatars[index],
                                width: 80,
                                height: 80,
                              ),
                            ),
                          )))
            ],
          ),
          Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: SafeArea(
                child: CommonButton.large(
                  backgroundColor: (selectIndex == null ||
                          avatars[selectIndex!] == User.info?.avatar)
                      ? Colours.grey_color1
                      : Colours.main,
                  onPressed: () => updateAvatar(),
                  text: '确认替换',
                ),
              ))
        ],
      ),
    );
  }

  updateAvatar() async {
    if (selectIndex == null || avatars[selectIndex!] == User.info?.avatar) {
      ToastUtils.show('头像未更改');
      return;
    }
    int? code =
        await Api.avatarUpdate(avatars[selectIndex!], showLoading: true);
    if (code != null && code == 200) {
      ToastUtils.show('头像替换成功');
      await User.fetchUserInfos(fetchFocus: false);
      Get.back();
      // update();
    }
  }
}
