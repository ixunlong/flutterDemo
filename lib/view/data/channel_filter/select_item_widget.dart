import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';

class SelectItemWidget extends StatelessWidget {
  static const contentWidth = 36 + 18;

  const SelectItemWidget(
      {super.key,
      required this.imgUrl,
      required this.name,
      this.selected,
      this.selectFn,
      this.longPress});

  final String imgUrl;
  final String name;
  final bool? selected;
  final void Function()? selectFn;
  final void Function()? longPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: selectFn,
        onLongPress: longPress,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Container(
            // color: Colors.amber,
            width: 36 + 18,
            child: Column(
              children: [
                SizedBox(
                  width: 36 + 18,
                  height: 36 + 9,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 9,
                        right: 9,
                        child: image(),
                      ),
                      if (selected != null)
                        Positioned(
                            right: 0,
                            top: 0,
                            child: Image.asset(Utils.getImgPath(selected!
                                ? "data_channel_remove.png"
                                : "data_channel_add.png")))
                    ],
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                text()
              ],
            ),
          ),
        ));
  }

  Widget text() => Text(name,
      style: const TextStyle(fontSize: 12, color: Colours.text_color1),
      maxLines: 1,
      overflow: TextOverflow.ellipsis);

  Widget image() {
    const size = 36.0;
    return SizedBox(
      width: size,
      height: size,
      child: CachedNetworkImage(
        imageUrl: imgUrl,
        placeholder: (context, url) =>
            Styles.placeholderIcon(width: size, height: size),
        errorWidget: (context, url, error) => Image.asset(
            Utils.getImgPath("data_channel_icon.png"),
            width: size,
            height: size),
      ),
    );
  }
}
