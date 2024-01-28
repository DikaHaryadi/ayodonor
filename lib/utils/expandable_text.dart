import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/themes_controller.dart';
import 'package:getdonor/utils/colors.dart';

// ignore: must_be_immutable
class ExpandableTextWidget extends StatefulWidget {
  final String text;
  Color? color;

  ExpandableTextWidget({Key? key, required this.text, this.color})
      : super(key: key);

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  late String firstHalf;
  late String secondHalf;

  bool hiddenText = true;

  ThemeController themeController = Get.put(ThemeController());

  double textHeight = Get.height / 8.04;

  @override
  void initState() {
    super.initState();
    if (widget.text.length > textHeight) {
      firstHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf =
          widget.text.substring(textHeight.toInt() + 1, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: secondHalf.isEmpty
            ? Text(
                firstHalf,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Epilogue',
                    color: widget.color,
                    fontWeight: FontWeight.normal),
              )
            : InkWell(
                onTap: () {
                  setState(() {
                    hiddenText = !hiddenText;
                  });
                },
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                      text: (hiddenText
                          ? ('$firstHalf...')
                          : (firstHalf + secondHalf)),
                      style: TextStyle(
                          fontSize: 14,
                          height: 1.3,
                          color: widget.color ??
                              (themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kDark.value)),
                          fontFamily: 'Epilogue',
                          fontWeight: FontWeight.normal),
                      children: <TextSpan>[
                        TextSpan(
                            text: hiddenText ? 'Lihat selengkapnya' : '',
                            style: TextStyle(
                                fontFamily: 'Epilogue',
                                fontSize: 14,
                                color: Color(kLightGrey.value)),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                setState(() {
                                  hiddenText = !hiddenText;
                                });
                              }),
                      ]),
                ),
              ));
  }
}
