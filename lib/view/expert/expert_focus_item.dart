import 'package:flutter/material.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/expert/expert_list_item.dart';

import '../../model/expert/expert_views_entity.dart';
import '../../res/colours.dart';

class ExpertFocusItem extends StatefulWidget {
  const ExpertFocusItem({Key? key, required this.focusList}) : super(key: key);

  final List<Rows> focusList;

  @override
  State<ExpertFocusItem> createState() => _ExpertFocusItemState();
}

class _ExpertFocusItemState extends State<ExpertFocusItem> {
  var expend = false;

  @override
  Widget build(BuildContext context) {
    if(widget.focusList.length == 1){
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colours.greyF5F5F5, width: 4))),
          child: ExpertListItem(entity: widget.focusList[0]));
    }
    List<Widget> list = List.generate(widget.focusList.length,
      (index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: index == widget.focusList.length - 1 || !expend?null:const Border(
            bottom: BorderSide(color: Colours.greyEE, width: 0.5))),
        child: ExpertListItem(entity: widget.focusList[index],isExpertDetailView: index == 0?false:true)));
      list.add(Container(
      height: 30,
      alignment: Alignment.topCenter,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colours.greyF5F5F5, width: 4))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(expend?"收起观点":"更多观点",style: TextStyle(fontSize: 12,color: Colours.grey99)),
          Container(width: 2),
          Image.asset(Utils.getImgPath(expend?"arrow_up.png":"arrow_down.png"))
        ],
      )
    ).tap(() => setState(() {
        expend = !expend;
      })));
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: expend?list:[list.first,list.last],
    );
  }
}
