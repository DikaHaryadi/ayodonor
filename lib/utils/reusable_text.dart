import 'package:flutter/material.dart';

class ReusableText extends StatelessWidget {
  const ReusableText(
      {Key? key,
      required this.text,
      required this.style,
      this.maxlines,
      this.textAlign})
      : super(key: key);

  final String text;
  final TextStyle style;
  final int? maxlines;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxlines == 0 ? 2 : maxlines,
      softWrap: false,
      textAlign: textAlign ?? TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: style,
    );
  }
}
