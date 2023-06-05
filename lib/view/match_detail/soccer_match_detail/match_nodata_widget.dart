import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sports/model/match/match_info_entity.dart';
import 'package:sports/util/utils.dart';

class MatchNodataWidget extends StatefulWidget {
  const MatchNodataWidget({super.key, this.info});

  final MatchInfoEntity? info;

  @override
  State<MatchNodataWidget> createState() => _MatchNodataWidgetState();
}

class _MatchNodataWidgetState extends State<MatchNodataWidget> {
  MatchInfoEntity? get info => widget.info;
  Timer? t;
  @override
  void initState() {
    super.initState();
    t = Timer.periodic(Duration(seconds: 1), (timer) {
      update();
    });
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (info?.state == MatchState.notStart) {
      try {
        String dur = "";
        final time = DateFormat("yyyy-MM-dd HH:mm:ss")
            .parse(info?.baseInfo?.matchTime ?? "");
        final now = DateTime.now();
        final seconds = time.difference(now).inSeconds;
        if (seconds < 0) {
          throw Error();
        }
        final day = seconds ~/ (3600 * 24);
        final hour = (seconds - day * 3600 * 24) ~/ 3600;
        final min = (seconds - day * 3600 * 24 - 3600 * hour) ~/ 60;
        final sec = (seconds - day * 3600 * 24 - 3600 * hour - min * 60);
        final l = [day, hour, min, sec];
        final ld = ["天", "小时", "分钟", "秒"];
        var idx = 0;
        for (var i = 0; i < l.length; i++) {
          if (l[i] != 0) {
            idx = i;
            break;
          }
        }
        for (var i = idx; i < l.length; i++) {
          dur += "${l[i]}${ld[i]}";
        }
        return Container(
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Utils.getImgPath("match_wait.png")),
              SizedBox(
                height: 20,
              ),
              Text("距比赛开始还有 $dur")
            ],
          ),
        );
      } catch (err) {}
    }

    return Container(
      // alignment: Alignment.center,
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(Utils.getImgPath("match_nodata.png")),
          SizedBox(height: 20),
          Text("暂无数据")
        ],
      ),
    );
  }
}
