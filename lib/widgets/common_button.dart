import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/styles.dart';
// import 'package:motoilet/res/colours.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    Key? key,
    this.text = '',
    this.widget,
    this.textStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    this.foregroundColor,
    this.disabledTextColor,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.minHeight = 44.0,
    this.minWidth,
    // this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.radius,
    this.side = BorderSide.none,
    this.padding = EdgeInsets.zero,
    required this.onPressed,
  }) : super(key: key);

  const CommonButton.large(
      {Key? key,
      this.text = '',
      this.widget,
      this.textStyle =
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      this.foregroundColor = Colours.white,
      this.disabledTextColor,
      this.backgroundColor = Colours.main_color,
      this.disabledBackgroundColor,
      this.minHeight = 44.0,
      this.minWidth = double.infinity,
      // this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
      this.radius = 4,
      this.side = BorderSide.none,
      this.padding = EdgeInsets.zero,
      required this.onPressed})
      : super(key: key);

  final Widget? widget;
  final String? text;
  final TextStyle? textStyle;
  final Color? foregroundColor;
  final Color? disabledTextColor;
  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final double? minHeight;
  final double? minWidth;
  final double? radius;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;

  final BorderSide side;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: minHeight,
      width: minWidth,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith(
            (states) {
              // if (states.contains(MaterialState.disabled)) {
              //   return disabledTextColor ??
              //       (isDark
              //           ? Colours.dark_text_disabled
              //           : Colours.text_disabled);
              // }
              return foregroundColor ?? Colours.main_color;
            },
          ),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            // if (states.contains(MaterialState.disabled)) {
            //   return disabledBackgroundColor ??
            //       (isDark
            //           ? Colours.dark_button_disabled
            //           : Colours.button_disabled);
            // }
            return backgroundColor ?? Colors.transparent;
          }),
          minimumSize: (minWidth == null || minHeight == null)
              ? null
              : MaterialStateProperty.all<Size>(Size(minWidth!, minHeight!)),
          // padding: MaterialStateProperty.all<EdgeInsetsGeometry>(padding),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? minHeight! / 2),
            ),
          ),
          side: MaterialStateProperty.all<BorderSide>(side),
          padding: MaterialStateProperty.all(padding),
        ),
        child: widget == null
            ? Text(
                text ?? '',
                style: textStyle,
                strutStyle:
                    Styles.centerStyle(fontSize: textStyle?.fontSize ?? 16),
              )
            : Center(child: widget!),
      ),
    );
  }
}
