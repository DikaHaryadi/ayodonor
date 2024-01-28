import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../controllers/check_nik_controller.dart';
import '../controllers/pemeriksaan_controller.dart';
import '../controllers/themes_controller.dart';
import '../model/data_pendonor_model.dart';
import '../utils/Custom/custom_loading.dart';
import '../utils/Custom/custom_textfield.dart';
import '../utils/app_style.dart';
import '../utils/colors.dart';
import '../utils/components/storage_util.dart';
import '../utils/custom_btn.dart';
import '../utils/debouncer.dart';
import '../utils/reusable_text.dart';

class PemeriksaanPendonor extends StatefulWidget {
  final String nik;
  const PemeriksaanPendonor({super.key, required this.nik});

  @override
  State<PemeriksaanPendonor> createState() => _PemeriksaanPendonorState();
}

class _PemeriksaanPendonorState extends State<PemeriksaanPendonor> {
  bool isChecked = false;
  StorageUtil storage = StorageUtil();

  final Debouncer debouncer =
      Debouncer(delay: const Duration(milliseconds: 500));
  final CheckNikController checkNikController = Get.put(CheckNikController());
  ThemeController themeController = Get.put(ThemeController());
  PemeriksaanController controller = Get.put(PemeriksaanController());
  DataPendonorModel dataPendonorModel = DataPendonorModel();

  @override
  void initState() {
    if (checkNikController.dataPendonorList.isNotEmpty) {
      dataPendonorModel = checkNikController.dataPendonorList[0];
      print(
          'dataPendonorList type: ${checkNikController.dataPendonorList.runtimeType}');
      print('dataPendonorModel type: ${dataPendonorModel.runtimeType}');
    }

    controller.nikController.text = widget.nik;
    controller.usernameController.text = dataPendonorModel.name!;
    controller.instansiController.text = storage.getInstansiBekerja();

    controller.golDarah.value = dataPendonorModel.golDarah!;
    controller.rhesus.value = dataPendonorModel.rhesus!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                'Pemeriksaan belum disimpan',
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
                    child: const Text('Lanjutkan Pemeriksaan')),
                TextButton(
                    onPressed: () => Get.back(result: true),
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
              text: 'Pemeriksaan Kesehatan',
              maxlines: 2,
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  color: themeController.isDarkTheme()
                      ? Color(kLight.value)
                      : Color(kLightGrey.value),
                  fontWeight: FontWeight.w600),
            ),
            Text('Nama Pendonor -> ${dataPendonorModel.name}',
                maxLines: 4,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 14,
                      color: themeController.isDarkTheme()
                          ? Color(kLight.value)
                          : Color(kDarkGrey.value),
                      fontWeight: FontWeight.normal,
                    )),
            const SizedBox(height: 20),
            Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  CustomTextField(
                    controller: controller.nikController,
                    hintText: 'Nomor Induk Kependudukan',
                    maxLength: 16,
                    readOnly: true,
                    keyboardType: TextInputType.none,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: controller.usernameController,
                    hintText: 'Nama Sesuai KTP',
                    readOnly: true,
                    keyboardType: TextInputType.none,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: controller.instansiController,
                    hintText: 'Nama Instansi',
                    readOnly: true,
                    keyboardType: TextInputType.none,
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => CustomTextField(
                      hintText: controller.tglPemeriksaan.value.isNotEmpty
                          ? DateFormat.yMMMMd('id_ID').format(
                              DateTime.tryParse(
                                      controller.tglPemeriksaan.value) ??
                                  DateTime.now(),
                            )
                          : 'Masukan Tanggal Pemeriksaan',
                      keyboardType: TextInputType.none,
                      readOnly: true,
                      suffixIcon: IconButton(
                          onPressed: () {
                            DateTime? selectedDate = DateTime.tryParse(
                                controller.tglPemeriksaan.value);

                            showDatePicker(
                              context: context,
                              locale: const Locale("id", "ID"),
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime(1850),
                              lastDate: DateTime(2030),
                              builder: (BuildContext context, Widget? child) {
                                ThemeData currentTheme =
                                    themeController.isDarkTheme()
                                        ? ThemeData.dark()
                                        : ThemeData.light();
                                return Theme(
                                  data: currentTheme,
                                  child: child!,
                                );
                              },
                            ).then((newSelectedDate) {
                              if (newSelectedDate != null) {
                                controller.tglPemeriksaan.value =
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
                    controller: controller.beratBadanController,
                    hintText: 'Berat Badan',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: controller.tinggiBadanController,
                    hintText: 'Tinggi Badan',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: controller.asamUratController,
                    hintText: 'Asam Urat',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: themeController.isDarkTheme()
                              ? Color(kLight.value)
                              : Color(kLightGrey.value),
                          width: 1),
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 5),
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
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ReusableText(
                                text: 'Pemeriksaan Tekanan Darah',
                                style: appstyle(
                                    16,
                                    themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kDark.value),
                                    FontWeight.w500)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: controller.tekananDarahController,
                          hintText: 'Tekanan Darah',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: controller.systolicController,
                          maxLines: 10,
                          hintText: 'Systolic Pendonor',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: controller.diastolicController,
                          hintText: 'Diastolic Pendonor',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: controller.pulseController,
                          hintText: 'Pulse Pendonor',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: controller.heartRateController,
                          hintText: 'Heart Rate Pendonor',
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 5),
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
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ReusableText(
                                text: 'Golongan Darah Pendonor',
                                style: appstyle(
                                    16,
                                    themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kDark.value),
                                    FontWeight.w500)),
                          ),
                        ),
                        Row(
                          children: [
                            Obx(
                              () => Radio<String>(
                                  value: 'A',
                                  groupValue: controller.golDarah.value,
                                  activeColor: Colors.red,
                                  onChanged: (value) =>
                                      controller.golDarah.value = value!),
                            ),
                            ReusableText(
                                text: 'A',
                                style: appstyle(
                                    14,
                                    themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kDark.value),
                                    FontWeight.normal)),
                            Expanded(child: Container()),
                            Obx(
                              () => Radio<String>(
                                  value: 'B',
                                  groupValue: controller.golDarah.value,
                                  activeColor: Colors.red,
                                  onChanged: (value) =>
                                      controller.golDarah.value = value!),
                            ),
                            ReusableText(
                                text: 'B',
                                style: appstyle(
                                    14,
                                    themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kDark.value),
                                    FontWeight.normal)),
                            Expanded(child: Container()),
                            Obx(
                              () => Radio<String>(
                                  value: 'O',
                                  groupValue: controller.golDarah.value,
                                  activeColor: Colors.red,
                                  onChanged: (value) =>
                                      controller.golDarah.value = value!),
                            ),
                            ReusableText(
                                text: 'O',
                                style: appstyle(
                                    14,
                                    themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kDark.value),
                                    FontWeight.normal)),
                            Expanded(child: Container()),
                            Obx(
                              () => Radio<String>(
                                  value: 'AB',
                                  groupValue: controller.golDarah.value,
                                  activeColor: Colors.red,
                                  onChanged: (value) =>
                                      controller.golDarah.value = value!),
                            ),
                            ReusableText(
                                text: 'AB',
                                style: appstyle(
                                    14,
                                    themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kDark.value),
                                    FontWeight.normal)),
                            const SizedBox(width: 15)
                          ],
                        ),
                        Row(
                          children: [
                            Obx(
                              () => Radio<String>(
                                  value: 'N/A',
                                  groupValue: controller.golDarah.value,
                                  activeColor: Colors.red,
                                  onChanged: (value) =>
                                      controller.golDarah.value = value!),
                            ),
                            ReusableText(
                                text: 'Tidak Tahu',
                                style: appstyle(
                                    14,
                                    themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kDark.value),
                                    FontWeight.normal)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 5),
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
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ReusableText(
                                text: 'Resus',
                                style: appstyle(
                                    16,
                                    themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kDark.value),
                                    FontWeight.w500)),
                          ),
                        ),
                        Row(
                          children: [
                            Obx(
                              () => Radio<String>(
                                  value: '+',
                                  groupValue: controller.rhesus.value,
                                  activeColor: Colors.red,
                                  onChanged: (value) =>
                                      controller.rhesus.value = value!),
                            ),
                            ReusableText(
                                text: '+',
                                style: appstyle(
                                    14,
                                    themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kDark.value),
                                    FontWeight.normal)),
                            Expanded(child: Container()),
                            Obx(
                              () => Radio<String>(
                                  value: '-',
                                  groupValue: controller.rhesus.value,
                                  activeColor: Colors.red,
                                  onChanged: (value) =>
                                      controller.rhesus.value = value!),
                            ),
                            ReusableText(
                                text: '-',
                                style: appstyle(
                                    14,
                                    themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kDark.value),
                                    FontWeight.normal)),
                            const SizedBox(width: 15)
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 5),
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
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ReusableText(
                                text: 'Diabetes?',
                                style: appstyle(
                                    16,
                                    themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kDark.value),
                                    FontWeight.w500)),
                          ),
                        ),
                        Row(
                          children: [
                            Obx(
                              () => Radio<String>(
                                value: '1',
                                groupValue: controller.gula.value,
                                activeColor: Colors.red,
                                onChanged: (value) =>
                                    controller.gula.value = value!,
                              ),
                            ),
                            ReusableText(
                              text: 'Ada',
                              style: appstyle(
                                  14,
                                  themeController.isDarkTheme()
                                      ? Color(kLight.value)
                                      : Color(kDark.value),
                                  FontWeight.normal),
                            ),
                            Expanded(child: Container()),
                            Obx(
                              () => Radio<String>(
                                value: '0',
                                groupValue: controller.gula.value,
                                activeColor: Colors.red,
                                onChanged: (value) =>
                                    controller.gula.value = value!,
                              ),
                            ),
                            ReusableText(
                              text: 'Tidak',
                              style: appstyle(
                                  14,
                                  themeController.isDarkTheme()
                                      ? Color(kLight.value)
                                      : Color(kDark.value),
                                  FontWeight.normal),
                            ),
                            const SizedBox(width: 15)
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 5),
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
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ReusableText(
                                text: 'Kolesterol',
                                style: appstyle(
                                    16,
                                    themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kDark.value),
                                    FontWeight.w500)),
                          ),
                        ),
                        Row(
                          children: [
                            Obx(
                              () => Radio<String>(
                                value: '1',
                                groupValue: controller.kolesterol.value,
                                activeColor: Colors.red,
                                onChanged: (value) =>
                                    controller.kolesterol.value = value!,
                              ),
                            ),
                            ReusableText(
                              text: 'Ada',
                              style: appstyle(
                                  14,
                                  themeController.isDarkTheme()
                                      ? Color(kLight.value)
                                      : Color(kDark.value),
                                  FontWeight.normal),
                            ),
                            Expanded(child: Container()),
                            Obx(
                              () => Radio<String>(
                                value: '0',
                                groupValue: controller.kolesterol.value,
                                activeColor: Colors.red,
                                onChanged: (value) =>
                                    controller.kolesterol.value = value!,
                              ),
                            ),
                            ReusableText(
                              text: 'Tidak',
                              style: appstyle(
                                  14,
                                  themeController.isDarkTheme()
                                      ? Color(kLight.value)
                                      : Color(kDark.value),
                                  FontWeight.normal),
                            ),
                            const SizedBox(width: 15)
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 5),
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
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ReusableText(
                                text: 'Status Pendonor',
                                style: appstyle(
                                    16,
                                    themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kDark.value),
                                    FontWeight.w500)),
                          ),
                        ),
                        Row(
                          children: [
                            Obx(
                              () => Radio<String>(
                                value: '1',
                                groupValue: controller.status.value,
                                activeColor: Colors.red,
                                onChanged: (value) =>
                                    controller.status.value = value!,
                              ),
                            ),
                            ReusableText(
                              text: 'Diterima',
                              style: appstyle(
                                  14,
                                  themeController.isDarkTheme()
                                      ? Color(kLight.value)
                                      : Color(kDark.value),
                                  FontWeight.normal),
                            ),
                            Expanded(child: Container()),
                            Obx(
                              () => Radio<String>(
                                value: '0',
                                groupValue: controller.status.value,
                                activeColor: Colors.red,
                                onChanged: (value) =>
                                    controller.status.value = value!,
                              ),
                            ),
                            ReusableText(
                              text: 'Ditolak',
                              style: appstyle(
                                  14,
                                  themeController.isDarkTheme()
                                      ? Color(kLight.value)
                                      : Color(kDark.value),
                                  FontWeight.normal),
                            ),
                            const SizedBox(width: 15)
                          ],
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
                                'Saya ${storage.getNameDokter()} telah melakukan pemeriksaan terhadap ${dataPendonorModel.name}',
                            maxlines: 3,
                            style: appstyle(
                                14,
                                themeController.isDarkTheme()
                                    ? Color(kLight.value)
                                    : Color(kDark.value),
                                FontWeight.w500)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    onTap: () async {
                      if (isChecked == false) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        Get.snackbar('ATENTION :',
                            "* Anda belum menyetujui persyaratan");
                      } else if (controller.status.value.isEmpty ||
                          controller.kolesterol.value.isEmpty ||
                          controller.gula.value.isEmpty ||
                          controller.golDarah.isEmpty ||
                          controller.rhesus.value.isEmpty ||
                          controller.heartRateController.text.isEmpty ||
                          controller.pulseController.text.isEmpty ||
                          controller.diastolicController.text.isEmpty ||
                          controller.systolicController.text.isEmpty ||
                          controller.tekananDarahController.text.isEmpty ||
                          controller.asamUratController.text.isEmpty ||
                          controller.tinggiBadanController.text.isEmpty ||
                          controller.beratBadanController.text.isEmpty ||
                          controller.tglPemeriksaan.isEmpty) {
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); // Close the keyboard
                        controller.isLoading.value = true;
                        Get.snackbar(
                            'ATENTION :', "* Harap mengisi semua data");
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
                            controller.postPemeriksaanDokter();
                          },
                        );
                        SmartDialog.dismiss();
                      }
                    },
                    text: 'Kirim Hasil Pemeriksaan',
                  ),
                  const SizedBox(height: 10)
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
