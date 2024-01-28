import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/model/utama_berita_model.dart';
import 'package:getdonor/utils/app_constants.dart';
import 'package:getdonor/utils/app_style.dart';
import 'package:getdonor/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../controllers/themes_controller.dart';

class CarouselSliderDataFound extends StatefulWidget {
  final List<BeritaUtamaModel> carouselList;
  final Function(int) onTap;

  const CarouselSliderDataFound({
    Key? key,
    required this.carouselList,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CarouselSliderDataFound> createState() =>
      _CarouselSliderDataFoundState();
}

class _CarouselSliderDataFoundState extends State<CarouselSliderDataFound> {
  int _current = 0;
  late List<Widget> imageSlider;
  final dateTime = DateFormat("EEE, d/M/y", 'id_ID');

  final ThemeController themeController = Get.find();

  @override
  void initState() {
    imageSlider = widget.carouselList
        .map((e) => GestureDetector(
              onTap: () {
                widget.onTap(_current);
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: ApiUtils.getImageUrl(e.img!),
                        errorWidget: (_, url, error) =>
                            Image.asset('images/error_img.jpg'),
                        placeholder: (context, url) =>
                            LottieBuilder.asset('images/feedback_loading.json'),
                        fit: BoxFit.cover,
                        width: 1000,
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(10),
                          color: Color(kDark.value).withOpacity(0.15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e.title!,
                                textAlign: TextAlign.left,
                                style: appstyle(
                                    14, Color(kLight.value), FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                e.subtitle!,
                                textAlign: TextAlign.justify,
                                maxLines: 3,
                                style: TextStyle(
                                    fontFamily: 'Barlow',
                                    fontWeight: FontWeight.w700,
                                    color: Color(kLight.value),
                                    fontSize: 10),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    e.namaPembuat!,
                                    textAlign: TextAlign.justify,
                                    maxLines: 3,
                                    style: TextStyle(
                                        fontFamily: 'Barlow',
                                        fontWeight: FontWeight.w700,
                                        color: Color(kLight.value),
                                        fontSize: 10),
                                  ),
                                  Text(
                                    dateTime.format(DateTime.parse(e.tanggal!)),
                                    textAlign: TextAlign.justify,
                                    maxLines: 3,
                                    style: TextStyle(
                                        fontFamily: 'Barlow',
                                        fontWeight: FontWeight.w700,
                                        color: Color(kLight.value),
                                        fontSize: 10),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ))
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
            items: imageSlider,
            options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                })),
        Center(
          child: AnimatedSmoothIndicator(
            activeIndex: _current,
            count: widget.carouselList.length,
            effect: ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                spacing: 5,
                activeDotColor: themeController.isDarkTheme()
                    ? Color(kLight.value)
                    : Color(kDark.value)),
          ),
        )
      ],
    );
  }
}
