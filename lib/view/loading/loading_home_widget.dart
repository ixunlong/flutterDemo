import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/widgets/shimmer_loading_widget.dart';

import '../../res/colours.dart';

class LoadingHomeWidget extends StatelessWidget {
  const LoadingHomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildHead(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
            child: Container(
              height: 32,
              width: Get.width,
              color: Colours.greyEE,
            ),
          ),
          loadingHomeList()
        ],
      ),
    );
  }

  Widget loadingHomeList(){
    return SingleChildScrollView(
      child: Column(
        children: List.generate(10, (index) => _buildList()),
      ),
    );
  }
  Widget _buildHead() {
    return Column(
      children: [
        const SizedBox(height: 10),
        ShimmerLoading(
          width: Get.width,
          height: (Get.width - 32)*0.45,
          borderRadius: BorderRadius.circular(10)),
        Container(height: 15),
        ShimmerLoading(
            width: Get.width,
            height: 32,
            borderRadius: BorderRadius.circular(5)),
        Container(height: 10),
        Row(
          children: [
            ShimmerLoading(
              width: 40,
              height: 80,
              borderRadius: BorderRadius.circular(5)),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (index) => _buildCard()),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildList() {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 16),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colours.greyEE))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerLoading(width: Get.width - 160, height: 16),
              Container(height: 5),
              ShimmerLoading(width: 16*6, height: 16),
              Container(height: 10),
              ShimmerLoading(width: 16*9, height: 16),
            ],
          ),
          ShimmerLoading(width: 110, height: 70),
        ],
      ),
    );
  }

  Widget _buildCard() {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: SizedBox(
        width: Get.width/2 - 30,
        height: 100,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: ShimmerLoading(
            color: Colours.greyEE, // 底色
            borderRadius: BorderRadius.circular(5),
            width: Get.width, height: Get.height
          )
        ),
      ),
    );
  }
}