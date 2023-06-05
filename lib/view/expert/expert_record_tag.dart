import 'package:flutter/cupertino.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/styles.dart';

class ExpertRecordTag extends StatelessWidget {
  const ExpertRecordTag({Key? key, required this.tagType, required this.text}) : super(key: key);

  final String? text;
  final TagType tagType;

  @override
  Widget build(BuildContext context) {
    return text == null || text == ''?Container():
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.fromBorderSide(
            BorderSide(width: 0.5,color: tagType.borderColor),
        ),
        color: tagType.backgroundColor
      ),
      child: Text(
        text!,
        strutStyle: Styles.centerStyle(fontSize: 10),
        style: TextStyle(
            fontSize: 10,
            height: 1,
            color: tagType.textColor
        )
      ),
    );
  }
}

class TagType{
  static TagType firstTag = TagType(
      textColor: Colours.main_color,
      borderColor: Colours.main_color,
      backgroundColor: Colours.redFFF2F2);

  static TagType secondTag = TagType(
      textColor: Colours.orangeFF6E1D,
      borderColor: Colours.orangeFF6E1D,
      backgroundColor: Colours.orangeFFEFE5);

  static TagType thirdTag = TagType(
      textColor: Colours.main_color);

  static TagType newFirstTag = TagType(
      textColor: Colours.main_color);

  Color textColor;
  Color borderColor;
  Color backgroundColor;

  TagType({
    this.textColor = Colours.transparent,
    this.backgroundColor = Colours.transparent,
    this.borderColor = Colours.transparent
  });
}