import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/widgets/shimmer_loading_widget.dart';

import '../../res/colours.dart';

class LoadingExpertWidget extends StatelessWidget{
  const LoadingExpertWidget ({super.key});

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                ShimmerLoading(
                    width: Get.width,
                    height: (Get.width - 32)*0.45,
                    borderRadius: BorderRadius.circular(10)),
                Container(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(4, (index) => _loadingExpertTopListItem())
                ),
                Container(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (index) => _loadingExpertTopListItem())
                ),
              ],
            ),
          ),

          Container(height: 20),
          Row(
            children: [
              Container(width: 16),
              Container(width: 20*3.5,height: 20,color: Colours.greyEE),
              Container(width: 25),
              Container(width: 20*3.5,height: 20,color: Colours.greyEE)
            ],
          ),
          Container(height: 10),
          loadingExpertList(false)
        ],
      ),
    );
  }

  Widget loadingExpertList(bool isExpertDetail){
    return SingleChildScrollView(
      child: Column(
        children: List.generate(10, (index) => _loadingExpertListItem(isExpertDetail)),
      ),
    );
  }

  Widget _loadingExpertTopListItem(){
    return Column(
      children: [
        const ShimmerLoading(width: 46,height: 46,shape: BoxShape.circle),
        Container(height: 4),
        const ShimmerLoading(width: 16*3,height: 16),
        Container(height: 4),
        const ShimmerLoading(width: 16*3,height: 16)
      ],
    );
  }

  Widget _loadingExpertListItem(isExpertDetail){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colours.greyF5F5F5,width: 4))
      ),
      child: Column(
          children: [
            isExpertDetail?Container():Padding(
              padding: const EdgeInsets.only(top: 8),
              child:_loadingExpertInfoWidget(),
            ),
            Container(height: 8),
            _loadingContentWidget(),
            Container(height: 10),
            _loadingMatchInfoWidget(),
            Container(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _loadingTimeAndViewsWidget(),
                _loadingTimeAndViewsWidget()
              ],
            ),
            Container(height: 8),
          ]
      ),
    );
  }

  Widget _loadingTimeAndViewsWidget() {
    return Row(
      children: [
        const ShimmerLoading(height: 10,width: 10*3),
        Container(width: 5),
        const ShimmerLoading(height: 10,width: 10*3)
      ],
    );
  }

  Widget _loadingMatchInfoWidget() {
    return ShimmerLoading(
      width: Get.width,
      height: 26,
      borderRadius: BorderRadius.circular(5));
  }

  Widget _loadingContentWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerLoading(height: 16,width: Get.width),
        Container(height: 7),
        const ShimmerLoading(height: 16,width: 16*7),
      ],
    );
  }

  Widget _loadingExpertInfoWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Row(
              children: [
                const ShimmerLoading(width: 40, height: 40,shape: BoxShape.circle),
                Container(width: 7),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ShimmerLoading(height: 16,width: 16*3.5),
                    Container(height: 7),
                    Row(
                      children: [
                        const ShimmerLoading(height: 10,width: 10*3),
                        Container(width: 5),
                        const ShimmerLoading(height: 10,width: 10*3),
                      ],
                    )
                  ],
                )
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const ShimmerLoading(height: 16,width: 16*3.5),
            Container(height: 7),
            const ShimmerLoading(height: 10,width: 10*3),
          ],
        )
      ],
    );
  }
}