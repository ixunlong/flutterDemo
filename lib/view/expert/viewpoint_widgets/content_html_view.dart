import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class PlanContentHtmlView extends StatelessWidget {
  PlanContentHtmlView({super.key,required this.htmldata});

  final String htmldata;

  final Map<String, Style> style = {
      "body": Style(
          fontWeight: FontWeight.w400,
          padding: EdgeInsets.zero,
          margin: Margins(bottom: Margin(0)),
          fontSize: FontSize(17),
          color: const Color(0xff444444),
          lineHeight: const LineHeight(1.4),
          letterSpacing: -0.5,
          textAlign: TextAlign.justify
          ),
      "html":Style(
        margin: Margins.zero,
        padding: EdgeInsets.zero
      ),
      "p": Style(
        margin: Margins.zero,
        padding: EdgeInsets.zero
      ),
    };
  final regC = RegExp(r"[\u4e00-\u9fa5]");

  String getData(String content) {
    var regCom = RegExp(r'<\/p>[.\n]<p>');
    String append = '';
    String? com = content
        .split("<p>&nbsp;</p>")
        .join("<div style= 'height: 20;width: 200px;'>  </div>")
        .split(regCom)
        .join("</p><div style= 'height: 20;width: 200px;'>  </div><p>")
        .split("/><p>")
        .join("/><div style= 'height: 20;width: 200px;'>  </div><p>")
        .split("/><img")
        .join("/><div style= 'height: 20;width: 200px;'>  </div><img");
    // if(com.endsWith("v>") != true) {
    //   com = "$com<div style= 'height: 25;width: 200px;'>  </div>";
    // }
    com.split("").forEach((element) {
      if (regC.hasMatch(element)) {
        append += "$element\u200A";
      } else {
        append += element;
      }
    });
    var newData = "";
    newData = """
    <!DOCTYPE html>
      <html>
        <body>$append</body>
      </html>
    """;
    return newData;
  }

  late String data = getData(htmldata);

  @override
  Widget build(BuildContext context) {
    // log("plan content $htmldata");
    // log("plan content html = $data");
    if (htmldata.trim().isEmpty) {
      return Container();
    }
    return Html(data: data,style: style);
  }
}