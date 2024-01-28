import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../colors.dart';

class FeedBackLoading extends StatelessWidget {
  const FeedBackLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      children: List.generate(
        20,
        (index) => Shimmer.fromColors(
            highlightColor: Color(kLight.value),
            baseColor: const Color(0xFFE0E0E0),
            child: Container(
              height: Get.height * 0.15,
              width: Get.width * 0.95,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Color(kDarkGrey.value),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: AspectRatio(
                  aspectRatio: 2 / 1,
                  child: Container(
                    color: Color(kDarkGrey.value),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
