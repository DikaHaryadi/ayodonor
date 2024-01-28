import 'package:getdonor/utils/colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class DonasiLoading extends StatelessWidget {
  const DonasiLoading({
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
            baseColor: Colors.grey.shade300,
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
                  aspectRatio: 4 / 3,
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
