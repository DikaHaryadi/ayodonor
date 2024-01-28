import 'package:flutter/material.dart';
import 'package:getdonor/utils/colors.dart';
import 'package:shimmer/shimmer.dart';

class CarouselLoading extends StatelessWidget {
  const CarouselLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: Color(kLight.value),
      baseColor: const Color(0xFFE0E0E0),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            decoration: BoxDecoration(
              color: Color(kDarkGrey.value),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Color(kDarkGrey.value),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Color(kDarkGrey.value)),
              ),
              const SizedBox(
                width: 3,
              ),
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Color(kDarkGrey.value)),
              ),
              const SizedBox(
                width: 3,
              ),
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Color(kDarkGrey.value)),
              ),
              const SizedBox(
                width: 3,
              ),
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Color(kDarkGrey.value)),
              ),
              const SizedBox(
                width: 3,
              ),
            ],
          )
        ],
      ),
    );
  }
}
