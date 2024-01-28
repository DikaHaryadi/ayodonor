// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/themes_controller.dart';
import 'package:getdonor/pages/tentang.dart';
import 'package:getdonor/utils/app_style.dart';
import 'package:getdonor/utils/colors.dart';
import 'package:getdonor/utils/reusable_text.dart';

class ExpandableContainer extends StatefulWidget {
  final String? textContent;
  final String textTitle;
  // final String? cekStok;
  // final int? idInstansi;
  // final String? namaInstansi;
  final Widget? statistik;

  const ExpandableContainer(
      {Key? key,
      this.textContent,
      // this.cekStok = '',
      required this.textTitle,
      // this.idInstansi,
      // this.namaInstansi,
      this.statistik})
      : super(key: key);
  @override
  _ExpandableContainerState createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<ExpandableContainer>
    with SingleTickerProviderStateMixin {
  ThemeController themeController = Get.put(ThemeController());
  late AnimationController _animationController;
  late Animation<double> animation;
  bool _isExpanded = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Color(kAksenDark.value),
            blurRadius: 2.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: ExpansionPanelList(
        elevation: 1,
        expandedHeaderPadding: const EdgeInsets.all(0),
        expansionCallback: (int index, bool isExpanded) {
          toggleExpansion();
        },
        children: [
          ExpansionPanel(
            backgroundColor: _isExpanded
                ? const Color(0xFF8382DC)
                : themeController.isDarkTheme()
                    ? const Color(0xFF262626)
                    : Theme.of(context).scaffoldBackgroundColor,
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return InkWell(
                onTap: toggleExpansion,
                child: Container(
                    padding: const EdgeInsets.all(16),
                    child: ReusableText(
                        text: widget.textTitle,
                        maxlines: 2,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: _isExpanded ? 'Poppins' : 'Epilogue',
                            color: _isExpanded
                                ? Theme.of(context).textTheme.titleLarge!.color
                                : themeController.isDarkTheme()
                                    ? Color(kLight.value)
                                    : Color(kDark.value),
                            fontWeight: _isExpanded
                                ? FontWeight.normal
                                : FontWeight.w500))),
              );
            },
            body: FadeTransition(
              opacity: animation,
              child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFF2A2B2F),
                      border:
                          Border.all(color: Color(kAksenDark.value), width: 1)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: widget.statistik ??
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: widget.textContent,
                              style: appstyle(
                                  14, Color(kLight.value), FontWeight.w400),
                            ),
                            const TextSpan(text: ' '),
                            TextSpan(
                                text: 'hubungi pmi',
                                style: appstyle(
                                    14,
                                    const Color.fromARGB(255, 125, 168, 218),
                                    FontWeight.w400),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.to(() => const Tentang());
                                  })
                          ],
                        ),
                      )),
            ),
            isExpanded: _isExpanded,
          ),
        ],
      ),
    );
  }
}
