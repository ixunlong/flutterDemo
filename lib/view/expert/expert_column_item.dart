//专家-专栏
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sports/model/expert/expert_idea_entity.dart';

import '../../res/colours.dart';
import '../../util/utils.dart';
import 'expert_record_tag.dart';

class ExpertColumnItem extends StatelessWidget {
  final ExpertIdeaEntity entity;

  const ExpertColumnItem({
    Key? key,
    required this.entity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        //do sth..
      },
      child: Stack(
        children: [
          Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 6),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: _expertInfoWidget(),
                      onTap: () {
                        //do sth..跳转专家页面
                      },
                    ),
                    entity.subs != 0 && entity.subsEndTime != null
                        ? _overTimeWidget()
                        : _followCountWidget(),
                  ]),
            ),
            Container(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 2,
              decoration: const BoxDecoration(
                color: Color(0xffededed),
                shape: BoxShape.rectangle,
              ),
            ),
            Container(height: 10),
            entity.subs != 0
                ? _expertIdeaInfoWidget()
                : _expertIdeaInfoWidget(),
            Container(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              height: 3,
              decoration: const BoxDecoration(
                color: Color(0xffededed),
                shape: BoxShape.rectangle,
              ),
            ),
          ])
        ],
      ),
    );
  }

  ///专家观点
  Widget _expertIdeaInfoWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(entity.subsWeek.toString(),
                style: const TextStyle(
                    color: Color(0xfff3233e),
                    fontSize: 15,
                    fontWeight: FontWeight.w500)),
            const Text("价格",
                style: TextStyle(
                    color: Colours.grey666666,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ],
        )),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text("不限",
                style: TextStyle(
                    color: Color(0xfff3233e),
                    fontSize: 15,
                    fontWeight: FontWeight.w500)),
            Text("价格",
                style: TextStyle(
                    color: Colours.grey666666,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ],
        )),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text("7",
                style: TextStyle(
                    color: Color(0xfff3233e),
                    fontSize: 15,
                    fontWeight: FontWeight.w500)),
            Text("有限期(天)",
                style: TextStyle(
                    color: Colours.grey666666,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ],
        )),
        Expanded(
            child: GestureDetector(
          onTap: () {
            // 处理按钮点击事件
          },
          child: Container(
            width: 55,
            height: 25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.red,
            ),
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Text('订阅TA',
                style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        )),
      ],
    );
  }

  Widget _followCountWidget() {
    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(entity.subsCnt.toString(),
                style: const TextStyle(
                    color: Colours.redFA9F9F,
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
            const Text("带红人数",
                style: TextStyle(
                    color: Colours.grey666666,
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
          ]),
    );
  }

  Widget _overTimeWidget() {
    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(entity.subsEndTime.toString(),
                style: const TextStyle(
                    color: Colours.grey666666,
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
            const Text("专栏到期",
                style: TextStyle(
                    color: Colours.grey666666,
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
          ]),
    );
  }

  Widget _expertInfoWidget() {
    return Row(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colours.grey_color2,
                  width: 0.5,
                  strokeAlign: BorderSide.strokeAlignOutside),
              shape: BoxShape.circle),
          child: CachedNetworkImage(
              fit: BoxFit.cover,
              width: 44,
              height: 44,
              placeholder: (context, url) => Container(),
              errorWidget: (context, url, error) => Container(),
              imageUrl: entity.logo ?? ''),
        ),
        Container(width: 7),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entity.name ?? '',
                style: const TextStyle(fontWeight: FontWeight.w500)),
            Container(height: 2),
            Row(
              children: [
                entity.tags == null || entity.tags == ''
                    ? Container()
                    : ExpertRecordTag(
                        tagType: TagType.firstTag, text: entity.tags),
                Container(width: 6),
              ],
            )
          ],
        )
      ],
    );
  }
}
