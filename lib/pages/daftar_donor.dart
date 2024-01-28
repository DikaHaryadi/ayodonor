import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/daftar_donor_controller.dart';
import 'package:getdonor/controllers/themes_controller.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';

import '../utils/Custom/custom_loading.dart';
import '../utils/Custom/custom_textfield.dart';
import '../utils/app_style.dart';
import '../utils/colors.dart';
import '../utils/debouncer.dart';
import '../utils/reusable_text.dart';

class DaftarDonor extends StatelessWidget {
  final DaftarDonorController controller;
  const DaftarDonor({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Debouncer debouncer =
        Debouncer(delay: const Duration(milliseconds: 500));
    ThemeController themeController = Get.put(ThemeController());

    TextEditingController nikController = TextEditingController();
    TextEditingController instansiController = TextEditingController();
    TextEditingController waktuPelaksanaanController = TextEditingController();
    TextEditingController alamatController = TextEditingController();
    TextEditingController tglPelaksanaanController = TextEditingController();
    TextEditingController tglPendonoran = TextEditingController();

    nikController.text = controller.nik!;
    instansiController.text = controller.namaInstansi!;
    waktuPelaksanaanController.text =
        '${controller.timeFormat.format(controller.timeFormat.parse(controller.waktuDimulai!))} s/d ${controller.timeFormat.format(controller.timeFormat.parse(controller.waktuBerakhir!))}';
    alamatController.text = controller.lokasiDonor!;
    tglPelaksanaanController.text =
        controller.dateTime.format(DateTime.parse(controller.tanggalDonor!));
    tglPendonoran.text = DateFormat.yMMMMd('id_ID').format(
      DateTime.now(),
    );

    return Scaffold(
        body: GetBuilder<DaftarDonorController>(
      init: controller,
      builder: (_) {
        return Center(
          child: controller.showloading
              ? SizedBox(
                  width: Get.width,
                  height: Get.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'images/online_doctor.json',
                      ),
                      const SizedBox(height: 15),
                      ReusableText(
                          text: 'Please wait ...',
                          style: appstyle(
                              16, Color(kDarkGrey.value), FontWeight.normal)),
                    ],
                  ),
                )
              : NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverAppBar(
                      elevation: 10,
                      backgroundColor: themeController.isDarkTheme()
                          ? Color(kLightGrey.value)
                          : Color(kLightBlueContent.value),
                      centerTitle: false,
                      automaticallyImplyLeading: false,
                      title: Text('Pendaftaran Donor Darah',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(kLight.value),
                              fontSize: 16)),
                    )
                  ],
                  body: WillPopScope(
                    onWillPop: () async {
                      return await showDialog(
                        context: Get.overlayContext!,
                        builder: (context) => AlertDialog(
                          title: const Text(
                            'Konfirmasi',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                          content: ReusableText(
                              text:
                                  'Apakah anda yakin tidak jadi pendaftaran pendonoran darah?',
                              maxlines: 2,
                              style: appstyle(14, null, FontWeight.normal)),
                          actions: [
                            TextButton(
                                onPressed: () => Get.back(result: false),
                                child: const Text('Tidak')),
                            TextButton(
                                onPressed: () {
                                  if (controller.tanggalDonor!.isNotEmpty ==
                                      true) {
                                    try {
                                      DateTime parsedDate = DateTime.parse(
                                          controller.tanggalDonor!);
                                      print(
                                          'ini di willpopscope nilai dari tanggal yg di klike ${parsedDate.toString()}');
                                      // Do something with the parsedDate
                                    } catch (e) {
                                      // Handle the case where the date string is invalid
                                      print(
                                          'Invalid date format: ${controller.tanggalDonor}');
                                    }
                                    // Clear the dat after parsing or handling
                                    controller.tanggalDonor =
                                        controller.tanggalDonor;
                                  }
                                  Get.back(result: true);
                                },
                                child: const Text('Keluar')),
                          ],
                        ),
                      );
                    },
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Text('NIK',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w400)),
                        const SizedBox(height: 5),
                        CustomTextField(
                          controller: nikController,
                          hintText: '',
                          prefixIcon: const Icon(Ionicons.card_outline),
                          keyboardType: TextInputType.text,
                          readOnly: true,
                        ),
                        const SizedBox(height: 10),
                        Text('Nama Unit Transfusi Darah (UTD)',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w400)),
                        const SizedBox(height: 5),
                        CustomTextField(
                          controller: instansiController,
                          hintText: '',
                          maxLines: 3,
                          prefixIcon: const Icon(Icons.local_hospital_outlined),
                          keyboardType: TextInputType.none,
                          readOnly: true,
                        ),
                        const SizedBox(height: 10),
                        Text('Waktu Pelaksanaan',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w400)),
                        const SizedBox(height: 5),
                        CustomTextField(
                          controller: waktuPelaksanaanController,
                          hintText: '',
                          prefixIcon: const Icon(Icons.timer_outlined),
                          keyboardType: TextInputType.none,
                          readOnly: true,
                        ),
                        const SizedBox(height: 10),
                        Text('Alamat Unit Transfusi Darah (UTD)',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w400)),
                        const SizedBox(height: 5),
                        CustomTextField(
                          controller: alamatController,
                          hintText: '',
                          maxLines: 10,
                          prefixIcon: const Icon(Ionicons.map_outline),
                          keyboardType: TextInputType.none,
                          readOnly: true,
                        ),
                        const SizedBox(height: 10),
                        Text('Tanggal Pelaksanaan',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w400)),
                        const SizedBox(height: 5),
                        CustomTextField(
                          controller: tglPelaksanaanController,
                          hintText: '',
                          prefixIcon: const Icon(Icons.date_range_outlined),
                          keyboardType: TextInputType.none,
                          readOnly: true,
                        ),
                        const SizedBox(height: 10),
                        Text('Tanggal Pendaftaran Donor',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w400)),
                        const SizedBox(height: 5),
                        CustomTextField(
                          controller: tglPendonoran,
                          hintText: '',
                          keyboardType: TextInputType.none,
                          readOnly: true,
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () async {
                                return await showDialog(
                                  context: Get.overlayContext!,
                                  builder: (context) => AlertDialog(
                                    title: const Text(
                                      'Konfirmasi Pendaftaran',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    content: ReusableText(
                                        text:
                                            'Apakah anda yakin ingin mendaftarkan diri untuk pendonoran darah?',
                                        maxlines: 2,
                                        style: appstyle(
                                            14, null, FontWeight.normal)),
                                    actions: [
                                      TextButton(
                                          onPressed: () async {
                                            controller.progressDaftar = true;
                                            controller.progressDaftar
                                                ? SmartDialog.showLoading(
                                                    animationType:
                                                        SmartAnimationType
                                                            .scale,
                                                    builder: (_) =>
                                                        const CustomLoading(),
                                                  )
                                                : controller.progressDaftar =
                                                    false;
                                            debouncer(
                                              () async {
                                                await controller.register();
                                              },
                                            );
                                            await Future.delayed(
                                                const Duration(seconds: 2));
                                            SmartDialog.dismiss();
                                          },
                                          child: const Text('Saya yakin')),
                                      TextButton(
                                          onPressed: () =>
                                              Get.back(result: true),
                                          child: const Text('Kembali')),
                                    ],
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              )),
                              child: Text(
                                "Daftar Donor".toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    ));
  }
}
