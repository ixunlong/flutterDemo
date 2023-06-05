import 'package:flutter/material.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/my/my_focus_expert_view.dart';
import 'package:sports/view/my/my_focus_team_view.dart';

import '../../res/styles.dart';

class MyFocusPage extends StatefulWidget {
  const MyFocusPage({super.key});

  @override
  State<MyFocusPage> createState() => _MyFocusPageState();
}

class _MyFocusPageState extends State<MyFocusPage>
    with TickerProviderStateMixin {
  late TabController _controller;
  int currentIndex = 1;
  final List<String> _tabs = ['专家', '球队'];

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.appBar(
        title: SizedBox(
          height: 34,
          child: Styles.defaultTabBar(
              tabs: _tabs.map((f) {
                return Text(f);
              }).toList(),
              controller: _controller,
              onTap: (value) {
                currentIndex = value;
                if (value == 1) {
                  Utils.onEvent('wd_wdgz_gzan', params: {'wd_wdgz_gzan': '2'});
                }
              },
              labelPadding: EdgeInsets.symmetric(horizontal: 15),
              fontSize: 17,
              // labelPadding: const EdgeInsets.symmetric(horizontal: 13),
              isScrollable: true),
        ),
      ),
      backgroundColor: Colours.greyFD,
      body: TabBarView(
          controller: _controller,
          children: List.generate(_tabs.length, (index) {
            if (index == 0) {
              return const MyFocusExpertView();
            } else if (index == 1) {
              return const MyFocusTeamView();
            }
            return Container();
          })),
    );
  }
}
