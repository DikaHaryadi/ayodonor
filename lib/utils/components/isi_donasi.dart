import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/donasi_controller.dart';
import 'package:getdonor/controllers/themes_controller.dart';
import 'package:getdonor/model/donasi_model.dart';
import 'package:getdonor/utils/Custom/shimmer_arrows.dart';
import 'package:getdonor/utils/app_constants.dart';
import 'package:getdonor/utils/components/app_bar.dart';
import 'package:getdonor/utils/reusable_text.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/font_size_controller.dart';
import '../app_style.dart';
import '../colors.dart';

enum _Tab {
  requirement,
  about,
}

class IsiDonasi extends StatefulWidget {
  final int idDonasi;
  const IsiDonasi({
    super.key,
    required this.idDonasi,
  });

  @override
  State<IsiDonasi> createState() => _IsiDonasiScreenState();
}

class _IsiDonasiScreenState extends State<IsiDonasi> {
  final ScrollController _scrollController = ScrollController();
  bool atBottom = true;

  final DonasiController donasiController = Get.put(DonasiController());
  final ThemeController themeController = Get.find();
  late DonasiModel donasi;
  late DateTime donationDate;

  final ResponsiveTextController responsiveTextController =
      Get.put(ResponsiveTextController());

  double percentage = 80.0;
  int baseMaxLines = 4;

  final selectedTab = ValueNotifier(_Tab.requirement);

  @override
  void initState() {
    super.initState();

    donasi = Get.find<DonasiController>().donasiList[widget.idDonasi];
    String formattedDate = donasi.tanggal!;
    donationDate = DateTime.parse(formattedDate);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          atBottom = false;
        });
      } else {
        setState(() {
          atBottom = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int maxLines =
        responsiveTextController.calculateMaxLines(percentage, baseMaxLines);

    final List<Widget> reqBank = [
      Text(
        donasi.namaPengguna!,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4),
      ),
      Text(
        donasi.namaBank!,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4),
      ),
      Text(
        donasi.nomerBank!,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4),
      ),
    ];

    final List<String> desBank = [
      'Nama Pemilik : ',
      'Nama Bank : ',
      'Nomor Bank : '
    ];

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomAppBar(
            bgColor: Theme.of(context).scaffoldBackgroundColor,
            iconColor: themeController.isDarkTheme()
                ? Color(kLight.value)
                : Color(kDarkicon.value),
            centerTitle: false,
            text: 'Donasi Kemanusiaan',
            automaticallyImplyLeading: false,
            child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon((Icons.arrow_back_ios))),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                controller: _scrollController,
                children: [
                  CachedNetworkImage(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 3,
                    imageUrl: donasi.imgThumbnail!.isNotEmpty
                        ? ApiUtils.getImageUrl(donasi.imgThumbnail!)
                        : 'https://elements-video-cover-images-0.imgix.net/files/220512242/Preview.jpg?auto=compress&crop=edges&fit=crop&fm=jpeg&h=800&w=1200&s=3702b1eeb3ed39c89cbef83a0ec2e371',
                    errorWidget: (_, url, error) =>
                        Image.asset('images/error_img.jpg'),
                    placeholder: (context, url) =>
                        LottieBuilder.asset('images/feedback_loading.json'),
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: ReusableText(
                        text: donasi.title!,
                        maxlines: maxLines,
                        textAlign: TextAlign.center,
                        style: appstyle(18, null, FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    donasiController.formatTimeElapsed(donationDate),
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: ValueListenableBuilder(
                      valueListenable: selectedTab,
                      builder: (context, value, child) {
                        return Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: themeController.isDarkTheme()
                                ? const Color(0xFF262626)
                                : Color(kLightGrey.value),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              AnimatedPositioned(
                                left: value == _Tab.requirement
                                    ? 0
                                    : (MediaQuery.of(context).size.width - 48) /
                                        2,
                                duration: const Duration(milliseconds: 300),
                                child: Container(
                                  height: 40,
                                  width:
                                      (MediaQuery.of(context).size.width - 48) /
                                          2,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8382DC),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedTab.value =
                                                _Tab.requirement;
                                          });
                                        },
                                        child: Container(
                                          height: 40,
                                          color: Colors.transparent,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Deskripsi",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedTab.value = _Tab.about;
                                          });
                                        },
                                        child: Container(
                                          height: 40,
                                          color: Colors.transparent,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Donasi",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: ValueListenableBuilder(
                      valueListenable: selectedTab,
                      builder: (context, value, child) {
                        return value == _Tab.requirement
                            ? Text(
                                donasi.deskripsi!,
                                textAlign: TextAlign.justify,
                                style: appstyle(
                                    14,
                                    themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kDark.value),
                                    FontWeight.w400),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        desBank[index],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(height: 1.4),
                                      ),
                                      Expanded(
                                        child: reqBank[
                                            index], // Access the Text widget from reqBank list
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (_, __) {
                                  return const SizedBox(height: 10);
                                },
                                itemCount: reqBank.length,
                              );
                      },
                    ),
                  ),
                ],
              ),
            ),
            ValueListenableBuilder(
              valueListenable: selectedTab,
              builder: (context, value, child) {
                return value == _Tab.requirement
                    ? atBottom
                        ? const AnimatedUpwardArrows()
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(kColorBtn.value),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    )),
                                child: Text(
                                  "Kirim Donasi".toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                    : const SizedBox.shrink();
              },
            ),
          ],
        ));
  }
}
