import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../model/expert/expert_idea_list_entity.dart';

class ExpertDetailIdeaItem extends StatelessWidget {
  final ExpertIdeaListRows? entity;

  const ExpertDetailIdeaItem({
    Key? key,
    required this.entity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent, //点击空白处收起键盘
      onTap: () {
        //do sth..
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // 左侧标题和发布时间
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "这里是标题，可以折行，但最多两行",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "发布时间：2021-11-11",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // 右侧图片
              Container(
                width: 125,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: const DecorationImage(
                    image:
                        AssetImage("assets/images/bottom_vibration_hint.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
