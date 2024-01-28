import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/pages/rootpage.dart';
import 'package:getdonor/utils/app_style.dart';
import 'package:getdonor/utils/colors.dart';
import 'package:getdonor/utils/reusable_text.dart';
import 'package:lottie/lottie.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  const SuccessDialog({Key? key, required this.title, required this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          Center(
            child: Lottie.asset('images/success.json',
                height: 100, fit: BoxFit.fitHeight),
          ),
          const Spacer(),
          ReusableText(
              text: title,
              textAlign: TextAlign.center,
              maxlines: 3,
              style: appstyle(16, Color(kDark.value), FontWeight.bold)),
          const SizedBox(height: 10),
          ReusableText(
              text: subtitle,
              textAlign: TextAlign.center,
              maxlines: 4,
              style: appstyle(14, Color(kDarkGrey.value), FontWeight.normal)),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Get.offAll(() => const RootPage());
            },
            child: Container(
              alignment: Alignment.center,
              width: width * 0.5,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.green),
              child: ReusableText(
                text: 'Go to Home',
                textAlign: TextAlign.center,
                style: appstyle(16, Color(kLight.value), FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
