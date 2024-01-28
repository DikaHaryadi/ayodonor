import 'package:flutter/material.dart';
import 'package:getdonor/utils/colors.dart';
import 'package:shimmer/shimmer.dart';

class TableLoading extends StatelessWidget {
  const TableLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: Color(kLight.value),
      baseColor: Colors.grey.shade300,
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
      ),
    );
  }
}
