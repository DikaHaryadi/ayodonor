import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getdonor/controllers/donasi_controller.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/themes_controller.dart';
import 'package:getdonor/model/donasi_model.dart';
import 'package:getdonor/pages/info_pertolongan_pertama.dart';
import 'package:getdonor/utils/components/donasi_loading.dart';
import 'package:getdonor/utils/components/isi_donasi.dart';
import 'package:lottie/lottie.dart';

import '../utils/Custom/app_bar.dart';
import '../utils/app_constants.dart';
import '../utils/colors.dart';

// ignore: must_be_immutable
class Donasi extends StatelessWidget {
  Donasi({
    Key? key,
  }) : super(key: key);

  DonasiController donasiController = Get.put(DonasiController());
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await donasiController.refreshData();
      },
      child: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: CustomAppBar(
                  bgColor: Theme.of(context).scaffoldBackgroundColor,
                  iconColor: themeController.isDarkTheme()
                      ? Color(kLight.value)
                      : Color(kDark.value),
                  text: 'Donasi Kemanusiaan',
                  centerTitle: false,
                  actions: [
                    InkWell(
                      onTap: () {
                        Get.to(() => const InfoPertolonganPertama());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Image.asset(
                          'images/logo.png',
                          width: 50,
                        ),
                      ),
                    ),
                  ],
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back_ios),
                  ))),
          body: Obx(
            () => donasiController.isLoading.value
                ? const DonasiLoading()
                : ListView.builder(
                    itemCount: donasiController.donasiList.length,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      double width = Get.width;

                      DonasiModel donasiModel =
                          donasiController.donasiList[index];
                      String formattedDate = donasiModel.tanggal!;
                      DateTime donationDate = DateTime.parse(formattedDate);
                      double height = Get.height;

                      return GestureDetector(
                        onTap: () {
                          Get.to(() => IsiDonasi(idDonasi: index));
                        },
                        child: Container(
                          width: width,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: themeController.isDarkTheme()
                                  ? Color(kLightGrey.value)
                                  : Theme.of(context).scaffoldBackgroundColor,
                              border: Border.all(
                                  color: themeController.isDarkTheme()
                                      ? Color(kAksenDark.value)
                                      : Color(kLightGrey.value),
                                  width: 1.5),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Stack(
                            children: [
                              Container(
                                height: height * 0.2,
                                width: double.infinity,
                                color: Colors.transparent,
                              ),
                              Positioned(
                                  top: 10,
                                  bottom: 10,
                                  right: 5,
                                  left: 5,
                                  child: Container(
                                    width: width * 0.25,
                                    padding: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  )),
                              Positioned(
                                  top: 0,
                                  bottom: 5,
                                  right: 5,
                                  left: width * 0.4,
                                  child: Container(
                                    width: width * 0.45,
                                    padding: const EdgeInsets.only(
                                        right: 5, left: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            donasiModel.title!,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontFamily: 'Epilogue',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                                color: themeController
                                                        .isDarkTheme()
                                                    ? Color(kLight.value)
                                                    : Color(kDark.value)),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            donasiModel.deskripsi!,
                                            maxLines: 4,
                                            style: TextStyle(
                                                fontFamily: 'Barlow',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12,
                                                overflow: TextOverflow.ellipsis,
                                                color: themeController
                                                        .isDarkTheme()
                                                    ? Color(kAksenDark.value)
                                                    : Color(kLightGrey.value)),
                                          ),
                                          Expanded(child: Container()),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              donasiController
                                                  .formatTimeElapsed(
                                                      donationDate),
                                              style: TextStyle(
                                                  fontFamily: 'Barlow',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: themeController
                                                          .isDarkTheme()
                                                      ? Color(kAksenDark.value)
                                                      : Color(
                                                          kLightGrey.value)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                              Positioned(
                                  top: 10,
                                  bottom: 5,
                                  left: 5,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      width: width * 0.35,
                                      imageUrl: ApiUtils.getImageUrl(
                                          donasiModel.imgThumbnail!),
                                      errorWidget: (_, url, error) =>
                                          Image.asset('images/error_img.jpg'),
                                      placeholder: (context, url) =>
                                          LottieBuilder.asset(
                                              'images/feedback_loading.json'),
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          )),
    );
  }
}
