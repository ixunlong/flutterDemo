import 'package:flutter/material.dart';
import 'package:sports/res/colours.dart';

class DataLeftList extends StatelessWidget {
  List<String> titles;
  int selectIndex;
  Function(int) onSelectIndex;
  DataLeftList(this.titles, this.selectIndex, this.onSelectIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colours.greyF5F7FA,
      width: 80,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
          itemCount: titles.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onSelectIndex(index),
              child: Stack(
                children: [
                  Container(
                    height: 60,
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    color: selectIndex == index
                        ? Colours.greyFD
                        : Colours.transparent,
                    alignment: Alignment.center,
                    child: Text(
                      titles[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colours.text_color1),
                    ),
                  ),
                  Visibility(
                      visible: selectIndex == index,
                      child: Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 3,
                          color: Colours.main_color,
                        ),
                      ))
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
