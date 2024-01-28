import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/themes_controller.dart';
import 'package:getdonor/model/berita_indo_model.dart';
import 'package:getdonor/utils/app_constants.dart';
import 'package:getdonor/utils/app_style.dart';
import 'package:getdonor/utils/colors.dart';
import 'package:getdonor/utils/reusable_text.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BeritaIndoFound extends StatefulWidget {
  final List<BeritaIndoModel> beritaIndo;
  final Function(int) onTap;

  const BeritaIndoFound({
    Key? key,
    required this.beritaIndo,
    required this.onTap,
  }) : super(key: key);

  @override
  State<BeritaIndoFound> createState() => _BeritaIndoFoundState();
}

class _BeritaIndoFoundState extends State<BeritaIndoFound> {
  int _current = 0;
  late List<Widget> imageSlider;

  final ThemeController themeController = Get.find();

  @override
  void initState() {
    imageSlider = widget.beritaIndo
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
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.centerLeft,
                          color: themeController.isDarkTheme()
                              ? Color(kAksenDark.value).withOpacity(0.25)
                              : Color(kLightGrey.value).withOpacity(0.15),
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
                              ReusableText(
                                text: e.deskripsi!,
                                textAlign: TextAlign.justify,
                                maxlines: 3,
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Color(kLight.value),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Barlow'),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ReusableText(
                                  text: e.typeBerita!,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontFamily: 'Barlow',
                                      color: Color(kLight.value),
                                      fontWeight: FontWeight.w700),
                                ),
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
            count: widget.beritaIndo.length,
            effect: ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                spacing: 5,
                dotColor: Color(kAksenDark.value).withOpacity(.3),
                activeDotColor: themeController.isDarkTheme()
                    ? Color(kLightBlueContent.value)
                    : const Color(0xFF8382DC)),
          ),
        )
      ],
    );
  }
}
