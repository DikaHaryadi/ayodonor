import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:getdonor/utils/app_style.dart';
import 'package:getdonor/utils/custom_btn.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../controllers/aftap_controller.dart';
import '../controllers/themes_controller.dart';
import '../utils/Custom/custom_loading.dart';
import '../utils/Custom/custom_textfield.dart';
import '../utils/colors.dart';
import '../utils/debouncer.dart';
import '../utils/reusable_text.dart';

class AftapPendonor extends StatefulWidget {
  final int idAftap;
  const AftapPendonor({super.key, required this.idAftap});

  @override
  State<AftapPendonor> createState() => _AftapPendonorState();
}

class _AftapPendonorState extends State<AftapPendonor> {
  bool isChecked = false;

  final Debouncer debouncer =
      Debouncer(delay: const Duration(milliseconds: 500));

  ThemeController themeController = Get.put(ThemeController());

  AftapController controller = Get.put(AftapController());

  late var aftap;

  @override
  void initState() {
    aftap = Get.find<AftapController>().pemeriksaanModelList[widget.idAftap];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller.nikController.text = aftap.nik.toString();
    controller.usernameController.text = aftap.userId.toString();
    controller.golDarah.value = aftap.golDarah.toString();
    controller.rhesus.value = aftap.resus.toString();
    controller.instansiController.text = aftap.instansi.toString();

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.red;
      }
      return Colors.blue;
    }

    return Scaffold(
        body: SafeArea(
            child: WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: Get.overlayContext!,
          builder: (context) => AlertDialog(
            title: const Text(
              'Perubahan belum disimpan',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            content: ReusableText(
                text: 'Perubahan yang Anda buat tidak akan disimpan',
                maxlines: 2,
                style: appstyle(14, null, FontWeight.normal)),
            actions: [
              TextButton(
                  onPressed: () => Get.back(result: false),
                  child: const Text('Lanjutkan Pengisian Data Darah')),
              TextButton(
                  onPressed: () {
                    Get.back(result: true);
                    controller.tglPengambilanDarah.value = '';
                  },
                  child: const Text('Hapus')),
            ],
          ),
        );
      },
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          const SizedBox(height: 20),
          ReusableText(
            text: 'Pengambilan Darah',
            maxlines: 2,
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                color: themeController.isDarkTheme()
                    ? Color(kLight.value)
                    : Color(kLightGrey.value),
                fontWeight: FontWeight.w600),
          ),
          Text('Nama Pendonor -> ${aftap.userId}',
              maxLines: 4,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 14,
                    color: themeController.isDarkTheme()
                        ? Color(kLight.value)
                        : Color(kDarkGrey.value),
                    fontWeight: FontWeight.normal,
                  )),
          const SizedBox(height: 20),
          Obx(
            () => CustomTextField(
              hintText: controller.tglPengambilanDarah.value.isNotEmpty
                  ? DateFormat.yMMMMd('id_ID').format(
                      DateTime.tryParse(controller.tglPengambilanDarah.value) ??
                          DateTime.now(),
                    )
                  : 'Tanggal Pengambilan Darah',
              keyboardType: TextInputType.none,
              readOnly: true,
              suffixIcon: IconButton(
                  onPressed: () {
                    DateTime? selectedDate =
                        DateTime.tryParse(controller.tglPengambilanDarah.value);
                    showDatePicker(
                      context: context,
                      locale: const Locale("id", "ID"),
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(1850),
                      lastDate: DateTime(2030),
                      builder: (BuildContext context, Widget? child) {
                        ThemeData currentTheme = themeController.isDarkTheme()
                            ? ThemeData.dark()
                            : ThemeData.light();
                        return Theme(
                          data: currentTheme,
                          child: child!,
                        );
                      },
                    ).then((newSelectedDate) {
                      if (newSelectedDate != null) {
                        controller.tglPengambilanDarah.value =
                            newSelectedDate.toLocal().toString();
                      }
                    });
                  },
                  icon: Icon(
                    Ionicons.calendar,
                    color: themeController.isDarkTheme()
                        ? Color(kLight.value)
                        : const Color(0xFF9B9B9B),
                  )),
            ),
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: controller.usernameController,
            hintText: 'Nama Pendonor',
            // readOnly: true,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: controller.nikController,
            hintText: 'Nomor Induk Kependudukan',
            readOnly: true,
            keyboardType: TextInputType.none,
          ),
          const SizedBox(height: 10),
          Container(
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            decoration: BoxDecoration(
              color: themeController.isDarkTheme()
                  ? Color(kAksenDark.value)
                  : const Color(0x97BCBABA),
            ),
            child: RichText(
              text: TextSpan(
                text: 'Golongan Darah : ',
                style: appstyle(
                    13,
                    themeController.isDarkTheme()
                        ? Color(kLight.value)
                        : Color(kDark.value),
                    FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                      text:
                          '${controller.golDarah.toString()}${controller.rhesus.toString()}',
                      style: appstyle(
                          13,
                          themeController.isDarkTheme()
                              ? Color(kLight.value)
                              : Color(kDark.value),
                          FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: controller.instansiController,
            hintText: 'Instansi Pendonoran Darah',
            readOnly: true,
            keyboardType: TextInputType.none,
          ),
          const SizedBox(height: 20),
          ReusableText(
            text: 'Informasi Pemeriksaan',
            maxlines: 2,
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: themeController.isDarkTheme()
                    ? Color(kLight.value)
                    : Color(kLightGrey.value),
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            decoration: BoxDecoration(
              border: Border.all(
                  color: themeController.isDarkTheme()
                      ? Color(kLight.value)
                      : Color(kLightGrey.value),
                  width: 1),
              color: themeController.isDarkTheme()
                  ? Color(kAksenDark.value)
                  : const Color(0x97BCBABA),
            ),
            child: RichText(
              text: TextSpan(
                text: 'Tanggal Pemeriksaan : ',
                style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontSize: 14,
                    color: themeController.isDarkTheme()
                        ? Color(kLight.value)
                        : Color(kLightGrey.value),
                    fontWeight: FontWeight.normal),
                children: <TextSpan>[
                  TextSpan(
                      text:
                          controller.dateTime.format(DateTime.parse(aftap.tgl)),
                      style: TextStyle(
                          fontSize: 13,
                          color: themeController.isDarkTheme()
                              ? Color(kLight.value)
                              : Color(kLightGrey.value),
                          fontWeight: FontWeight.normal)),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: themeController.isDarkTheme()
                  ? Color(kAksenDark.value)
                  : Color(kLight.value),
              border: Border.all(
                  color: themeController.isDarkTheme()
                      ? Color(kLight.value)
                      : Color(kAksenDark.value)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: 'Tinggi Badan : ',
                          style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 13,
                              color: themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kLightGrey.value),
                              fontWeight: FontWeight.normal),
                          children: <TextSpan>[
                            TextSpan(
                                text: aftap.tinggiBadan,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kLightGrey.value),
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: 'Berat Badan : ',
                          style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 13,
                              color: themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kLightGrey.value),
                              fontWeight: FontWeight.normal),
                          children: <TextSpan>[
                            TextSpan(
                                text: aftap.beratBadan,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kLightGrey.value),
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: 'Kolesterol : ',
                          style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 13,
                              color: themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kLightGrey.value),
                              fontWeight: FontWeight.normal),
                          children: <TextSpan>[
                            TextSpan(
                                text: aftap.kolesterol == '0'
                                    ? 'Tidak ada'
                                    : aftap.kolesterol == '1'
                                        ? 'Ada'
                                        : '',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kLightGrey.value),
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: 'Gula : ',
                          style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 13,
                              color: themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kLightGrey.value),
                              fontWeight: FontWeight.normal),
                          children: <TextSpan>[
                            TextSpan(
                                text: aftap.gula == '0'
                                    ? 'Tidak ada'
                                    : aftap.gula == '1'
                                        ? 'Ada'
                                        : '',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kLightGrey.value),
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: 'Asam Urat : ',
                          style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 13,
                              color: themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kLightGrey.value),
                              fontWeight: FontWeight.normal),
                          children: <TextSpan>[
                            TextSpan(
                                text: aftap.asamUrat,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kLightGrey.value),
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: 'Nama Dokter : ',
                          style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 13,
                              color: themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kLightGrey.value),
                              fontWeight: FontWeight.normal),
                          children: <TextSpan>[
                            TextSpan(
                                text: aftap.namaDokter,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kLightGrey.value),
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: 'Tekanan Darah : ',
                          style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 13,
                              color: themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kLightGrey.value),
                              fontWeight: FontWeight.normal),
                          children: <TextSpan>[
                            TextSpan(
                                text: aftap.tekananDarah,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kLightGrey.value),
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: 'Systolic : ',
                          style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 13,
                              color: themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kLightGrey.value),
                              fontWeight: FontWeight.normal),
                          children: <TextSpan>[
                            TextSpan(
                                text: aftap.systolic,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kLightGrey.value),
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: 'Diastolic : ',
                          style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 13,
                              color: themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kLightGrey.value),
                              fontWeight: FontWeight.normal),
                          children: <TextSpan>[
                            TextSpan(
                                text: aftap.diastolic,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kLightGrey.value),
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: 'Pulse : ',
                          style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 13,
                              color: themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kLightGrey.value),
                              fontWeight: FontWeight.normal),
                          children: <TextSpan>[
                            TextSpan(
                                text: aftap.pulse,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kLightGrey.value),
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: 'Heart Rate : ',
                          style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 13,
                              color: themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kLightGrey.value),
                              fontWeight: FontWeight.normal),
                          children: <TextSpan>[
                            TextSpan(
                                text: aftap.heartRate,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kLightGrey.value),
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ReusableText(
                            text: 'Status : ',
                            style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 13,
                              color: themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kLightGrey.value),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          aftap.status == '0'
                              ? Icon(
                                  Icons.close,
                                  color: Color(kRed.value),
                                )
                              : aftap.status == '1'
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  : const SizedBox
                                      .shrink(), // Use SizedBox() instead of an empty string
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
              Flexible(
                child: ReusableText(
                    text:
                        'Saya telah melakukan pengambilan darah terhadap ${aftap.userId}',
                    maxlines: 3,
                    style: appstyle(
                        14,
                        themeController.isDarkTheme()
                            ? Color(kLight.value)
                            : Color(kDark.value),
                        FontWeight.w500)),
              ),
              const SizedBox(width: 10)
            ],
          ),
          const SizedBox(height: 30),
          CustomButton(
            onTap: () async {
              if (isChecked == false) {
                FocusScope.of(context).requestFocus(FocusNode());
                Get.snackbar(
                    'ATENTION :', "* Anda belum menyetujui persyaratan");
              } else if (controller.tglPengambilanDarah.isEmpty) {
                FocusScope.of(context)
                    .requestFocus(FocusNode()); // Close the keyboard
                controller.isLoading.value = true;
                Get.snackbar(
                    'ATENTION :', "* Harap mengisi tanggal pengambilan darah");
              } else {
                FocusScope.of(context)
                    .requestFocus(FocusNode()); // Close the keyboard
                controller.isLoading.value = true;
                controller.isLoading.value
                    ? SmartDialog.showLoading(
                        animationType: SmartAnimationType.scale,
                        builder: (_) => const CustomLoading(),
                      )
                    : controller.isLoading.value = false;
                await Future.delayed(const Duration(seconds: 2));
                debouncer(
                  () {
                    controller.postPengambilanDarah();
                  },
                );
                SmartDialog.dismiss();
              }
            },
            text: 'Konfirmasi Pengambilan Darah',
          ),
          const SizedBox(height: 10),
        ],
      ),
    )));
  }
}
