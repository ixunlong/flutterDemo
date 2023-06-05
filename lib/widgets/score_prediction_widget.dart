import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';

class ScorePredictionWidget extends StatelessWidget {
  const ScorePredictionWidget(
      {Key? key,
      required this.homeLogo,
      required this.homeName,
      required this.guestLogo,
      required this.guestName,
      required this.homeScore,
      required this.guestScore})
      : super(key: key);

  final String homeLogo;
  final String homeName;
  final String guestLogo;
  final String guestName;
  final String homeScore;
  final String guestScore;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
            width: Get.width,
            fit: BoxFit.fitWidth,
            Utils.getImgPath("prediction_back.png")),
        Positioned.fill(
          child: Row(
            children: [
              Image.asset(Utils.getImgPath("prediction_text.png"))
                  .paddingOnly(left: 7, right: 9),
              Expanded(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    alignment: Alignment.center,
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: CachedNetworkImage(
                        placeholder: (context, url) => Styles.placeholderIcon(),
                        errorWidget: (context, url, error) =>
                            Image.asset(Utils.getImgPath("team_logo.png")),
                        imageUrl: homeLogo),
                  ),
                  Container(height: 3),
                  Text(homeName,
                      style: TextStyle(color: Colors.white, fontSize: 10),
                      overflow: TextOverflow.ellipsis)
                ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: Stack(
                  children: [
                    Image.asset(Utils.getImgPath("scoreboard.png")),
                    Positioned(
                        left: 10,
                        child: Text(homeScore,
                            style: TextStyle(
                                fontFamily: "Din",
                                fontSize: 28,
                                color: Colours.main,
                                fontWeight: FontWeight.w600))),
                    Positioned(
                        left: 59,
                        child: Text(guestScore,
                            style: TextStyle(
                                fontFamily: "Din",
                                fontSize: 28,
                                color: Colours.guestColorBlue,
                                fontWeight: FontWeight.w600)))
                  ],
                ),
              ),
              Expanded(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    alignment: Alignment.center,
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: CachedNetworkImage(
                        placeholder: (context, url) => Styles.placeholderIcon(),
                        errorWidget: (context, url, error) =>
                            Image.asset(Utils.getImgPath("team_logo.png")),
                        imageUrl: guestLogo),
                  ),
                  Container(height: 3),
                  Text(guestName,
                      style: TextStyle(color: Colors.white, fontSize: 10),
                      overflow: TextOverflow.ellipsis)
                ]),
              ),
              Container(width: 9)
            ],
          ),
        )
      ],
    );
  }
}
