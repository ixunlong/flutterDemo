import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/view/loading/loading_expert_list.dart';

class LoadingExpertDetail extends StatelessWidget {
  const LoadingExpertDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildLoadingAchievement(),
          Container(width: Get.width,height: 10,color: Colours.greyF5F5F5),
          const LoadingExpertWidget().loadingExpertList(true)
        ],
      ),
    );
  }

  Widget _buildLoadingAchievement() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 15, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 16,width: 16*2,color: Colours.greyEE),
          Container(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
                3, (index) => Container(
              width: (Get.width - 32-24)/3,
              height: (Get.width - 32-24)/5,
              decoration: BoxDecoration(
                color: Colours.greyEE,
                borderRadius: BorderRadius.circular(5.0),
              ),
            )),
          ),
          Container(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                  15, (index) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(width: 26,height: 26,decoration: const BoxDecoration(shape: BoxShape.circle,color: Colours.greyEE))
              )),
            ),
          ),
        ],
      ),
    );
  }
}
