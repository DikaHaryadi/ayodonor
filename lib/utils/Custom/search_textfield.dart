import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/utils/colors.dart';
import 'package:getdonor/utils/reusable_text.dart';
import 'package:ionicons/ionicons.dart';

import '../../controllers/themes_controller.dart';

class CustomTextFieldSearch extends StatefulWidget {
  final double offset;
  final String name;
  final TextEditingController textEditingController;
  final Function(String) function;
  final IconData? suffixIcon;
  final String nameTextField;
  final String subName;
  final Function()? clearFunction;
  const CustomTextFieldSearch(
      {Key? key,
      required this.offset,
      required this.name,
      this.suffixIcon,
      required this.textEditingController,
      required this.function,
      required this.nameTextField,
      required this.subName,
      required this.clearFunction})
      : super(key: key);

  @override
  State<CustomTextFieldSearch> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextFieldSearch> {
  bool search = false;
  bool textVisible = false;
  final ThemeController themeController = Get.put(ThemeController());

  // Function to update the visibility of the clear icon
  void _updateTextVisibility() {
    setState(() {
      textVisible = widget.textEditingController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    // Add a listener to the textEditingController
    widget.textEditingController.addListener(_updateTextVisibility);
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    widget.textEditingController.removeListener(_updateTextVisibility);
    super.dispose();
  }

  Widget change(double width) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      top: 10,
      left: 10,
      bottom: 10,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 150,
        width: widget.offset > 30
            ? search
                ? width
                : 20
            : width,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: search
              ? TextField(
                  controller: widget.textEditingController,
                  onChanged: widget.function,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      hintStyle: TextStyle(
                          color: themeController.isDarkTheme()
                              ? Color(kLight.value)
                              : Color(kLightGrey.value),
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                      hintText: widget.nameTextField,
                      filled: true,
                      fillColor: themeController.isDarkTheme()
                          ? Color(kLightBlueContent.value).withOpacity(0.3)
                          : Color(kLightGrey.value).withOpacity(0.3),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            search = false;
                            widget.textEditingController.clear();
                            textVisible = false;
                            widget.clearFunction?.call();
                          });
                        },
                        child: Icon(
                          Icons.close,
                          color: themeController.isDarkTheme()
                              ? Color(kLight.value)
                              : Color(kLightBlueContent.value).withOpacity(1),
                        ),
                      ),
                      suffixIcon: InkWell(
                          onTap: widget.clearFunction,
                          child: Icon(
                            widget.suffixIcon,
                            color: Colors.red.shade800,
                          ))),
                )
              : Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          search = true;
                        });
                      },
                      child: const Icon(
                        Icons.search,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 50,
      color: Colors.transparent,
      width: width,
      child: Stack(
        children: [
          change(width * .95),
          Positioned(
            top: 5,
            right: 10,
            child: search
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(widget.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      Text(widget.subName,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: themeController.isDarkTheme()
                                      ? Color(kLight.value)
                                      : Color(kLightGrey.value))),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class CustomTextFieldSearchStockDarah extends StatefulWidget {
  final double offset;
  final String name;
  final TextEditingController textEditingController;
  final Function(String) function;
  final String nameTextField;
  final Function()? clearFunction;
  const CustomTextFieldSearchStockDarah({
    Key? key,
    required this.offset,
    required this.name,
    required this.textEditingController,
    required this.function,
    required this.nameTextField,
    required this.clearFunction,
  }) : super(key: key);

  @override
  State<CustomTextFieldSearchStockDarah> createState() =>
      _CustomTextFieldSearchStockDarahState();
}

class _CustomTextFieldSearchStockDarahState
    extends State<CustomTextFieldSearchStockDarah> {
  bool search = false;
  bool textVisible = false;
  final ThemeController themeController = Get.find();

  // Function to update the visibility of the clear icon
  void _updateTextVisibility() {
    setState(() {
      textVisible = widget.textEditingController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    // Add a listener to the textEditingController
    widget.textEditingController.addListener(_updateTextVisibility);
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    widget.textEditingController.removeListener(_updateTextVisibility);
    super.dispose();
  }

  Widget change(double width) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      top: 10,
      right: search ? 10 : 0,
      bottom: 10,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 150,
        width: widget.offset > 30
            ? (search ? width - 40 : 20)
            : (search ? width : 40),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: search
              ? TextField(
                  controller: widget.textEditingController,
                  onChanged: widget.function,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    hintStyle: TextStyle(
                        fontSize: 14,
                        color: themeController.isDarkTheme()
                            ? Color(kLight.value)
                            : Color(kDark.value),
                        fontWeight: FontWeight.w300),
                    hintText: widget.nameTextField,
                    filled: true,
                    fillColor: themeController.isDarkTheme()
                        ? Color(kAksenDark.value).withOpacity(0.3)
                        : Color(kLightGrey.value).withOpacity(0.4),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          search = false;
                          widget.textEditingController.clear();
                          textVisible = false;
                          widget.clearFunction?.call();
                        });
                      },
                      child: Icon(
                        Ionicons.close,
                        color: themeController.isDarkTheme()
                            ? Color(kLight.value)
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                )
              : Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          search = true;
                        });
                      },
                      child: Icon(
                        Icons.search,
                        color: themeController.isDarkTheme()
                            ? Color(kLight.value)
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 50,
      color: Theme.of(context).scaffoldBackgroundColor,
      width: width,
      child: Stack(
        children: [
          change(width * .96),
          Positioned(
            top: 13,
            left: 10,
            child: search
                ? Container()
                : ReusableText(
                    text: widget.name,
                    style: TextStyle(
                        fontSize: 16,
                        color: themeController.isDarkTheme()
                            ? Color(kLight.value)
                            : Color(kDark.value).withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins'),
                    // style: appstyle(
                    //     16,
                    //     themeController.isDarkTheme()
                    //         ? Color(kLight.value)
                    //         : Color(kDark.value).withOpacity(0.5),
                    //     FontWeight.bold),
                  ),
          ),
          Positioned(
            top: 0,
            right: 15,
            bottom: 0,
            child: Visibility(
              visible: textVisible,
              child: InkWell(
                onTap: () {
                  setState(() {
                    widget.textEditingController.clear();
                    textVisible = false;
                    widget.clearFunction?.call();
                  });
                },
                child: const Icon(
                  Ionicons.close_circle,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
