import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sports/util/utils.dart';

class MatchIntelligenceCard extends StatelessWidget {
  const MatchIntelligenceCard(
      {Key? key, required this.data, required this.benefit})
      : super(key: key);

  final bool benefit;
  final List<String> data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.only(
                top: 50.0, left: 13, right: 15, bottom: 15),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(1, 0),
                      blurRadius: 3,
                      blurStyle: BlurStyle.solid)
                ]),
            child: Column(
              children: _buildContent(),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
                color: Color(benefit ? 0xFFF53F3F : 0xFF3ED14D),
                borderRadius: const BorderRadius.only(
                    topRight: Radius.elliptical(11, 30),
                    bottomRight: Radius.elliptical(4, 10))),
            // CustomPaint(
            //   painter: Painter(),
            //   child: ColoredBox(
            //     color: Color(benefit?0xFFF53F3F:0xFF3ED14D),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              child: Text(
                benefit ? "有利" : "不利",
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildContent() {
    List<Widget> list = [];
    for (var element = 1; element < data.length; element++) {
      list.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Image.asset(
                Utils.getImgPath("info_dian.png"),
                fit: BoxFit.contain,
                width: 10,
                height: 10,
              ),
            ),
            Container(width: 5),
            Flexible(
              fit: FlexFit.tight,
              child: Text(
                data[element].split('').join('\u200A'),
                style: const TextStyle(
                    fontSize: 14,
                    ),
              ),
            ),
          ],
        )
      );
    }
    return list;
  }
}
