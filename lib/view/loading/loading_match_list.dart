import 'package:flutter/material.dart';
import 'package:sports/widgets/shimmer_loading_widget.dart';

import '../../res/colours.dart';

class LoadingMatchList extends StatelessWidget {
  const LoadingMatchList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(10, (index) => _buildLoadingWidget()),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colours.grey_color2))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            _buildLoadingHead(),
            const SizedBox(height: 14),
            _buildLoadingBody(),
            const SizedBox(height: 16),
            _buildLoadingBottom()
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingHead() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ShimmerLoading(width: 16*5, height: 16),
        ShimmerLoading(width: 16*1, height: 16),
        ShimmerLoading(width: 16*5, height: 16),
      ],
    );
  }

  Widget _buildLoadingBody() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ShimmerLoading(width: 21, height: 21),
        ShimmerLoading(width: 21*4, height: 21),
        ShimmerLoading(width: 21, height: 21,shape: BoxShape.circle),
        ShimmerLoading(width: 21*1.5, height: 21),
        ShimmerLoading(width: 21, height: 21,shape: BoxShape.circle),
        ShimmerLoading(width: 21*4, height: 21),
        ShimmerLoading(width: 21, height: 21)
      ],
    );
  }

  Widget _buildLoadingBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShimmerLoading(width: 16*8, height: 16)
      ],
    );
  }

}