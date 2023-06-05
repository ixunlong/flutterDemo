import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../util/date_utils_extension.dart';

class DateTabBar extends StatefulWidget{

  const DateTabBar({
    super.key,
    required this.dateList,
    this.controller,
    this.onTap,
    this.indicatorColor,
    this.indicatorSize,
    this.labelColor,
    this.labelStyle,
    this.labelPadding,
    this.automaticIndicatorColorAdjustment = true,
    this.indicatorWeight = 2.0,
    this.indicatorPadding = EdgeInsets.zero,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
    this.selectLabelColor,
    this.textStyle,
    this.subTextStyle,
    this.indicator,
  });

  final Decoration? indicator;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? labelPadding;
  final Color? labelColor;
  final TabController? controller;
  final List<DateTime> dateList;
  final ValueChanged<int>? onTap;
  final Color? indicatorColor;
  final TabBarIndicatorSize? indicatorSize;
  final Color? selectLabelColor;
  final Color? unselectedLabelColor;
  final double indicatorWeight;
  final bool automaticIndicatorColorAdjustment;
  final EdgeInsetsGeometry indicatorPadding;
  final TextStyle? unselectedLabelStyle;
  final TextStyle? textStyle;
  final TextStyle? subTextStyle;

  @override
  State<DateTabBar> createState() => DateTabBarState();

}

class DateTabBarState extends State<DateTabBar>{
  @override
  Widget build(BuildContext context) {
    return ExtendedTabBar(
      physics: const ClampingScrollPhysics(),
      onTap: (value) {
        widget.onTap?.call(value);
      },
      tabs: widget.dateList.map((e) {
        return Column(
          children: [
            Text(
              DateFormat.E('zh_cn').format(e),
              style: widget.textStyle,
            ),
            Text(
              DateUtilsExtension.formatDateTime(e, 'MM/dd'),
              // DateFormat.MMMd('zh_cn').format(e),
              style: widget.subTextStyle,
              strutStyle: StrutStyle(
                // fontSize: 10,
                // leading: 0,
                height: 1,
                forceStrutHeight: true, // 关键属性 强制改为文字高度
              ),
            ),
          ],
        );
      }).toList(),
      indicator: widget.indicator,
      indicatorPadding: widget.indicatorPadding,
      indicatorWeight: widget.indicatorWeight,
      automaticIndicatorColorAdjustment: widget.automaticIndicatorColorAdjustment,
      labelPadding: widget.labelPadding,
      controller: widget.controller,
      indicatorColor: widget.indicatorColor,
      indicatorSize: widget.indicatorSize,
      isScrollable: true,
      labelColor: widget.labelColor,
      unselectedLabelColor: widget.unselectedLabelColor,
      labelStyle: widget.labelStyle,
    );
  }

}