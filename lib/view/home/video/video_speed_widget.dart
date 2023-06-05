import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:sports/res/colours.dart';
// import 'package:umeng_verify_sdk/umeng_verify_sdk.dart';

class VideoSpeedWidget extends StatelessWidget {
  Function(double) onSpeedChanged;
  VideoSpeedWidget({super.key, required this.onSpeedChanged});

  final List<double> speedList = [0.5, 0.75, 1, 1.25, 1.5, 2, 3];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
          speedList.length,
          (index) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onSpeedChanged(speedList[index]),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colours.black.withOpacity(0.4),
                  ),
                  alignment: Alignment.center,
                  width: 84,
                  height: 84,
                  child: Text(
                    '${speedList[index].toString()}X',
                    style: TextStyle(
                        color: Colours.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              )),
    );
  }
}
