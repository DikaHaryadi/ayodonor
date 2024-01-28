import 'package:flutter/material.dart';
import 'package:getdonor/utils/colors.dart';
import 'package:getdonor/utils/reusable_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key, required this.text, this.color, required this.onTap})
      : super(key: key);

  final String text;
  final Color? color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height * 0.065,
        color: Color(kOrange.value),
        child: Center(
          child: ReusableText(
              text: text,
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Epilogue',
                  color: Color(kLight.value),
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
