import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/model/expert/expert_search_entity.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';

import '../../logic/expert/expert_search_page_controller.dart';
import '../../res/colours.dart';
import '../../res/routes.dart';
import '../../widgets/common_button.dart';
import '../../widgets/no_data_widget.dart';

class ExpertSearchPage extends StatefulWidget {
  const ExpertSearchPage({Key? key}) : super(key: key);

  @override
  State<ExpertSearchPage> createState() => _ExpertSearchPageState();
}

class _ExpertSearchPageState extends State<ExpertSearchPage> {
  final controller = Get.put(ExpertSearchPageController());

  @override
  void initState() {
    controller.focus = FocusNode();
    Future.delayed(const Duration(milliseconds: 200)).then((value) => FocusScope.of(context).requestFocus(controller.focus));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpertSearchPageController>(builder: (controller) {
      return Scaffold(
        appBar: Styles.appBar(toolbarHeight: 0),
        backgroundColor: Colours.white,
        body: SafeArea(
          child: Column(
            children: [
              _searchBar(),
              Expanded(
                child: controller.findList.isEmpty && controller.str != ''
                ?NoDataWidget(
                  needScroll: true,tip: "没有相关专家，查看全部专家",
                  buttonText: "去查看",
                  onTap: ()=>Get.toNamed(Routes.expertAll),
                )
                :ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) => _cell(index),
                  itemCount: controller.findList.length),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _searchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 8, bottom: 8,right: 16,left: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: Get.back,
            child: Image.asset(Utils.getImgPath('arrow_back.png'))),
          Expanded(
            child: Container(
                padding: const EdgeInsets.only(right: 10),
                height: 34,
                child: TextField(
                  controller: controller.textController,
                  enabled: true,
                  maxLines: 1,
                  strutStyle: StrutStyle(height: 1.2,fontSize: 16),
                  cursorColor: Colours.main_color,
                  focusNode: controller.focus,
                  onTap: () =>
                      FocusScope.of(context).requestFocus(controller.focus),
                  onChanged: (str) => controller.str = str,
                  onSubmitted: (str) {
                    controller.focus.unfocus();
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colours.greyF7F7F7,
                    prefixIcon: Image.asset(Utils.getImgPath("search_icon_black.png"),
                      color: Colours.grey99,width: 16,height: 16),
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(35 / 2))),
                    hintText: "搜索专家",
                    hintStyle: const TextStyle(fontSize: 16,height: 1.2)),
                )),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: controller.focus.unfocus,
            child: Text("搜索",style: Styles.normalText(fontSize: 16)))
        ],
      ),
    );
  }

  _cell(int index) {
    ExpertSearchEntity data = controller.findList[index];
    return Container(
      color: Colours.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.expertDetail,
                      arguments: data.id!);
                  },
                  child: Container(
                    width: Get.width / 2,
                    height: 50,
                    color: Colours.transparent,
                    child: _expertInfoWidget(data))),
                CommonButton(
                  onPressed: () => controller.setFocus(data.id, index)
                  ,
                  minHeight: 24,
                  minWidth: 56,
                  side: BorderSide(
                    color: data.isFocus!=0 && data.isFocus!=null
                      ? Colours.grey_color1
                      : Colours.main_color,
                    width: 0.5),
                  text: data.isFocus!=0 && data.isFocus!=null? '已关注' : '关注',
                  textStyle: TextStyle(
                    fontSize: 13,
                    height: 1.3,
                    color: data.isFocus!=0 && data.isFocus!=null
                      ? Colours.grey_color1
                      : Colours.main_color),
                )
              ]),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16),
            height: 0.5,
            color: Colours.grey_color2,
          )
        ],
      ),
    );
  }

  Widget _expertInfoWidget(ExpertSearchEntity entity) {
    return GestureDetector(
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colours.greyEE,width: 0.5)
            ),
            child: ClipOval(
                child: CachedNetworkImage(
                  width: 40,
                  height: 40,
                  fit: BoxFit.fitWidth,
                  imageUrl: entity.logo ?? '',
                )
            ),
          ),
          Container(width: 7),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(formSpan(entity.name ?? '', controller.str)),
              // Padding(
              //   padding: const EdgeInsets.only(top: 4),
              //   child: Row(
              //     children: [
              //       entity.firstTag == null || entity.firstTag == ''
              //           ? Container()
              //           : ExpertRecordTag(
              //               tagType: TagType.firstTag, text: entity.firstTag),
              //       Container(width: 8),
              //       entity.secondTag == null || entity.secondTag == ''
              //           ? Container()
              //           : ExpertRecordTag(
              //               tagType: TagType.secondTag, text: entity.secondTag)
              //     ],
              //   ),
              // )
            ],
          )
        ],
      ),
    );
  }

  InlineSpan formSpan(String src, String pattern) {
    List<TextSpan> span = [];
    RegExp regExp = RegExp(pattern, caseSensitive: false);
    src.splitMapJoin(regExp, onMatch: (Match match) {
      span.add(TextSpan(
          text: match.group(0),
          style: const TextStyle(
              fontWeight: FontWeight.w500, color: Colours.main_color)));
      return '';
    }, onNonMatch: (str) {
      span.add(TextSpan(
          text: str,
          style: const TextStyle(
              fontWeight: FontWeight.w500, color: Colours.text_color)));
      return '';
    });
    return TextSpan(children: span);
  }
}
