import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sports/model/match/match_info_entity.dart';
import 'package:sports/model/match/match_text_live_entity.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/match_detail/soccer_match_detail/match_nodata_widget.dart';

class TextLiveWidget extends StatelessWidget {
  const TextLiveWidget({super.key, this.texts = const [],this.info});

  final List<MatchLiveTextEntity> texts;

  // final detail = Get.find<SoccerMatchDetailController>();

  final MatchInfoEntity? info;

  @override
  Widget build(BuildContext context) {
    if (texts.isEmpty) {
      return MatchNodataWidget(info: info);
    }
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      color: Colors.white,
      child: Column(children: [
        const SizedBox(height: 10),
        ...List.generate(texts.length, (index) {
          final e = texts[index];
          return e.isAnimated
              ? _cell(e)
              : _cell(e)
                  .animate(
                    key: Key("${e.processTime} ${e.content} ${index}"),
                    onComplete: (controller) {
                      e.isAnimated = true;
                    },
                  )
                  .fadeIn(duration: 500.ms, begin: 0, end: 1);
        })
      ]),
    );
  }

  Widget _cell(MatchLiveTextEntity text) {
    String time = text.processTime ?? "";
    if (!time.endsWith("'") && time.isNotEmpty) {
      time += "'";
    }

    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(time,
                  style: const TextStyle(
                      fontSize: 14, color: Color(0xFF292D32), height: 1.4))
              .sized(width: 36),
          Expanded(
              child: Text(
            text.content ?? "",
            style: const TextStyle(
                color: Color(0xFF666666), fontSize: 14, height: 1.4),
          ))
        ],
      ),
    );
  }
}
