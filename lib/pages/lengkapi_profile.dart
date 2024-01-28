import 'dart:convert';

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/google_sigin_controller.dart';
import 'package:getdonor/controllers/themes_controller.dart';
import 'package:getdonor/pages/login.dart';
import 'package:getdonor/utils/Custom/custom_textfield.dart';
import 'package:getdonor/utils/app_constants.dart';
import 'package:getdonor/utils/app_style.dart';
import 'package:http/http.dart' as http;
import 'package:getdonor/utils/components/storage_util.dart';
import 'package:getdonor/utils/reusable_text.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../model/provinsi_model.dart';
import '../utils/colors.dart';
import '../utils/custom_btn.dart';

// ignore: must_be_immutable
class LengkapiProfile extends StatefulWidget {
  String statusLogin;
  LengkapiProfile({super.key, required this.statusLogin});

  @override
  State<LengkapiProfile> createState() => _LengkapiProfileState();
}

class _LengkapiProfileState extends State<LengkapiProfile> {
  final GoogleController controller = Get.put(GoogleController());
  final ThemeController themeController = Get.put(ThemeController());

  StorageUtil storage = StorageUtil();
  bool isChecked = false;
  int? selectedProvinceId;
  int? selectedKotaId;
  int? selectedKecamatanId;

  List<SelectedListItem> provinceListItems = [];
  List<SelectedListItem> kotaListItems = [];
  List<SelectedListItem> kecamatanListItems = [];

  void fetchProvinces() async {
    var response = await http
        .get(Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getProvinsi}'));
    if (response.statusCode == 200) {
      List<dynamic> provinceData = json.decode(response.body);

      setState(() {
        provinceListItems = provinceData.map((provinceJson) {
          var province = Province.fromJson(provinceJson);
          return SelectedListItem(
            name: province.namaProv,
            value: province.idProv.toString(),
            isSelected: false,
          );
        }).toList();
      });
    } else {
      // Handle the case where the server returns an error response
      print('Failed to load provinces');
    }
  }

  void fetchKota() async {
    print('get kota fetch' + selectedProvinceId.toString());
    var response = await http.get(Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.getKabKota}?id_prov=$selectedProvinceId'));

    if (response.statusCode == 200) {
      List<dynamic> provinceData = json.decode(response.body);

      setState(() {
        kotaListItems = provinceData.map((provinceJson) {
          var province = KabKota.fromJson(provinceJson);

          return SelectedListItem(
            name: province.namaKota,
            value: province.idKota.toString(),
            isSelected: false,
          );
        }).toList();
      });
    } else {
      // Handle the case where the server returns an error response
      print('Failed to load provinces');
    }
  }

  void fetchKecamatan() async {
    print('get kecamatan fetch' + selectedKotaId.toString());
    var response = await http.get(Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.getKecamatan}?id_kota=$selectedKotaId'));
    if (response.statusCode == 200) {
      List<dynamic> provinceData = json.decode(response.body);

      setState(() {
        kecamatanListItems = provinceData.map((provinceJson) {
          var province = Kecamatan.fromJson(provinceJson);
          return SelectedListItem(
            name: province.namaKecamatan,
            value: province.idKecamatan.toString(),
            isSelected: false,
          );
        }).toList();
      });
    } else {
      // Handle the case where the server returns an error response
      print('Failed to load provinces');
    }
  }

  void _showProvincePicker(BuildContext context) {
    print('here');
    DropDownState(DropDown(
      bottomSheetTitle: const Text(
        'Pilih Provinsi',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      submitButtonChild: const Text(
        'Done',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      data: provinceListItems,
      selectedItems: (List<dynamic> selectedList) {
        List<String> list = [];
        for (var item in selectedList) {
          if (item is SelectedListItem) {
            list.add(item.name);
            print(item.value);
            setState(() {
              selectedProvinceId = int.parse(item.value!);
              controller.provinsi.value = selectedProvinceId.toString();
              controller.provinsiController.text = item.name;
            });
          }
        }
        if (list.isEmpty) {
          controller.provinsi.value = list.first;
        }
        //Navigator.pop(context); // Close the bottom sheet
      },
      enableMultipleSelection: false,
    )).showModal(context);
  }

  void _showKotaPicker(BuildContext context) {
    DropDownState(DropDown(
      bottomSheetTitle: const Text(
        'Pilih Kabupaten atau Kota',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      submitButtonChild: const Text(
        'Done',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      data: kotaListItems,
      selectedItems: (List<dynamic> selectedList) {
        List<String> list = [];
        for (var item in selectedList) {
          if (item is SelectedListItem) {
            list.add(item.name);
            print(item.value);
            setState(() {
              fetchKota();
              selectedKotaId = int.parse(item.value!);
              controller.kabAtaukota.value = selectedKotaId.toString();
              controller.kabAtaukotaController.text = item.name;
            });
          }
        }
        if (list.isEmpty) {
          controller.kabAtaukota.value = list.first;
        }
        //Navigator.pop(context); // Close the bottom sheet
      },
      enableMultipleSelection: false,
    )).showModal(context);
  }

  void _showKecamatanPicker(BuildContext context) {
    print('here');
    DropDownState(DropDown(
      bottomSheetTitle: const Text(
        'Pilih Kecamatan',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      submitButtonChild: const Text(
        'Done',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      data: kecamatanListItems,
      selectedItems: (List<dynamic> selectedList) {
        List<String> list = [];
        for (var item in selectedList) {
          if (item is SelectedListItem) {
            list.add(item.name);
            print(item.value);
            setState(() {
              fetchKecamatan();
              selectedKecamatanId = int.parse(item.value!);
              controller.kecamatan.value = selectedKecamatanId.toString();
              controller.kecamatanController.text = item.name;
            });
          }
        }
        if (list.isEmpty) {
          controller.kecamatan.value = list.first;
        }
        //Navigator.pop(context); // Close the bottom sheet
      },
      enableMultipleSelection: false,
    )).showModal(context);
  }

  @override
  void initState() {
    fetchProvinces();
    // fetchKota();
    // fetchKecamatan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller.emailController.text = storage.getStatus() == '1'
        ? storage.getEmail()
        : storage.getStatus() == '2'
            ? storage.getemailGoogle()
            : storage.getEmailFb();

    controller.usernameController.text = storage.getStatus() == '1'
        ? storage.getName()
        : storage.getStatus() == '2'
            ? storage.getUserGoogle()
            : storage.getUserFb();

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
                      child: const Text('Lanjutkan Pengisian Akun')),
                  TextButton(
                      onPressed: () {
                        controller.signOut();
                        Get.off(() => const Login());
                      },
                      child: const Text('Kembali')),
                ],
              ),
            );
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
            children: [
              ReusableText(
                  text: 'Selamat Datang!',
                  style: appstyle(
                      30,
                      themeController.isDarkTheme()
                          ? Color(kLight.value)
                          : Color(kDark.value),
                      FontWeight.w600)),
              Text('Lengkapi profile untuk melanjutkan',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      )),
              const SizedBox(height: 20),
              CustomTextField(
                controller: controller.nikController,
                focusNode: controller.nikFocusNode,
                hintText: 'Nomor Induk Kependudukan',
                maxLength: 16,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: controller.emailController,
                focusNode: controller.emailFocusNode,
                hintText: '',
                keyboardType: TextInputType.emailAddress,
                readOnly: true,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: controller.usernameController,
                focusNode: controller.usernameFocusNode,
                hintText: '',
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: controller.phoneController,
                focusNode: controller.phoneFocusNode,
                hintText: 'Nomer Telepon',
                maxLength: 12,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              Obx(
                () => CustomTextField(
                  hintText: controller.tglKelahiran.value.isNotEmpty
                      ? DateFormat.yMMMMd('id_ID').format(
                          DateTime.tryParse(controller.tglKelahiran.value) ??
                              DateTime.now(),
                        )
                      : 'Masukan Tanggal Lahir Anda',
                  keyboardType: TextInputType.none,
                  readOnly: true,
                  suffixIcon: IconButton(
                      onPressed: () {
                        DateTime? selectedDate =
                            DateTime.tryParse(controller.tglKelahiran.value);

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
                            controller.tglKelahiran.value =
                                newSelectedDate.toLocal().toString();
                          }
                        });
                      },
                      icon: const Icon(Ionicons.calendar)),
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: controller.tempatKelahiranController,
                focusNode: controller.tempatKelahiranFocusNode,
                hintText: 'Tempat Lahir',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                  hintText: 'Provinsi',
                  controller: controller.provinsiController,
                  suffixIcon: IconButton(
                    onPressed: () {
                      print('press');
                      _showProvincePicker(context);
                      print('after press');
                    },
                    icon: const Icon(Icons.search),
                  ),
                  readOnly: true,
                  keyboardType: TextInputType.none),
              const SizedBox(height: 10),
              CustomTextField(
                  controller: controller.kabAtaukotaController,
                  hintText: 'Kabupaten atau Kota',
                  suffixIcon: IconButton(
                    onPressed: () {
                      print('press');
                      fetchKota();
                      selectedProvinceId == null
                          ? Get.snackbar('Perhatian',
                              'Provinsi Harus Di isi Terlebih Dahulu')
                          : _showKotaPicker(context);
                      print('after press');
                    },
                    icon: const Icon(Icons.search),
                  ),
                  readOnly: true,
                  keyboardType: TextInputType.none),
              const SizedBox(height: 10),
              CustomTextField(
                  controller: controller.kecamatanController,
                  hintText: 'Kecamatan',
                  suffixIcon: IconButton(
                    onPressed: () {
                      print('press');
                      fetchKecamatan();
                      selectedKotaId == null
                          ? Get.snackbar('Error',
                              'Kabupaten atau Kota Harus Di isi Terlebih Dahulu')
                          : _showKecamatanPicker(context);
                      print('after press');
                    },
                    icon: const Icon(Icons.search),
                  ),
                  readOnly: true,
                  keyboardType: TextInputType.none),
              const SizedBox(height: 10),
              CustomTextField(
                controller: controller.jlnRumahController,
                maxLines: 10,
                hintText: 'Alamat Rumah',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: controller.kodePosController,
                focusNode: controller.kodePosFc,
                maxLength: 5,
                hintText: 'Kode Pos',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: controller.pekerjaanController,
                focusNode: controller.pekerjaanFocusNode,
                hintText: 'Pekerjaan',
                keyboardType: TextInputType.text,
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
                            text: 'Jenis Kelamin',
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
                            value: 'Pria',
                            groupValue: controller.gender.value,
                            activeColor: Colors.red,
                            onChanged: (value) =>
                                controller.gender.value = value!,
                          ),
                        ),
                        ReusableText(
                          text: 'Pria',
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
                            value: 'Wanita',
                            groupValue: controller.gender.value,
                            activeColor: Colors.red,
                            onChanged: (value) =>
                                controller.gender.value = value!,
                          ),
                        ),
                        ReusableText(
                          text: 'Wanita',
                          style: appstyle(
                              14,
                              themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kDark.value),
                              FontWeight.normal),
                        ),
                        const SizedBox(width: 10)
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
                        const SizedBox(width: 10)
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
                  mainAxisSize: MainAxisSize.min,
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
                      child: ReusableText(
                          text: 'Rhesus',
                          style: appstyle(
                              16,
                              themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kDark.value),
                              FontWeight.w500)),
                    ),
                    Column(
                      children: [
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
                                text: '+ (plus)',
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
                                text: '- (minus)',
                                style: appstyle(
                                    14,
                                    themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kDark.value),
                                    FontWeight.normal)),
                            const SizedBox(width: 10)
                          ],
                        ),
                        Row(
                          children: [
                            Obx(
                              () => Radio<String>(
                                  value: 'N/A',
                                  groupValue: controller.rhesus.value,
                                  activeColor: Colors.red,
                                  onChanged: (value) =>
                                      controller.rhesus.value = value!),
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
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                      child: ReusableText(
                          text: 'Kesiapan Pendonor',
                          style: appstyle(
                              16,
                              themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kDark.value),
                              FontWeight.w500)),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ReusableText(
                                text:
                                    'Bersediakah saudara donor pada waktu\nbulan puasa?',
                                style: appstyle(14, Color(kDarkGrey.value),
                                    FontWeight.w500)),
                          ),
                          Row(
                            children: [
                              Obx(
                                () => Radio<String>(
                                    value: 'Ya',
                                    groupValue: controller.puasa.value,
                                    activeColor: Colors.red,
                                    onChanged: (value) =>
                                        controller.puasa.value = value!),
                              ),
                              ReusableText(
                                  text: 'Ya',
                                  style: appstyle(
                                      14,
                                      themeController.isDarkTheme()
                                          ? Color(kLight.value)
                                          : Color(kDark.value),
                                      FontWeight.normal)),
                              Expanded(child: Container()),
                              Obx(
                                () => Radio<String>(
                                    value: 'Tidak',
                                    groupValue: controller.puasa.value,
                                    activeColor: Colors.red,
                                    onChanged: (value) =>
                                        controller.puasa.value = value!),
                              ),
                              ReusableText(
                                  text: 'Tidak',
                                  style: appstyle(
                                      14,
                                      themeController.isDarkTheme()
                                          ? Color(kLight.value)
                                          : Color(kDark.value),
                                      FontWeight.normal)),
                              const SizedBox(width: 10)
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ReusableText(
                                text:
                                    'Bersediakah saudara donor saat\ndibutuhkan untuk keperluan tertentu\n(di luar donor rutin)',
                                style: appstyle(14, Color(kDarkGrey.value),
                                    FontWeight.w500)),
                          ),
                          Row(
                            children: [
                              Obx(
                                () => Radio<String>(
                                    value: 'Ya',
                                    groupValue: controller.dibutuhkan.value,
                                    activeColor: Colors.red,
                                    onChanged: (value) =>
                                        controller.dibutuhkan.value = value!),
                              ),
                              ReusableText(
                                  text: 'Ya',
                                  style: appstyle(
                                      14,
                                      themeController.isDarkTheme()
                                          ? Color(kLight.value)
                                          : Color(kDark.value),
                                      FontWeight.normal)),
                              Expanded(child: Container()),
                              Obx(
                                () => Radio<String>(
                                    value: 'Tidak',
                                    groupValue: controller.dibutuhkan.value,
                                    activeColor: Colors.red,
                                    onChanged: (value) =>
                                        controller.dibutuhkan.value = value!),
                              ),
                              ReusableText(
                                  text: 'Tidak',
                                  style: appstyle(
                                      14,
                                      themeController.isDarkTheme()
                                          ? Color(kLight.value)
                                          : Color(kDark.value),
                                      FontWeight.normal)),
                              const SizedBox(width: 10)
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
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
                  ReusableText(
                      text: 'Saya mensetujui persyaratan',
                      style: appstyle(
                          14,
                          themeController.isDarkTheme()
                              ? Color(kLight.value)
                              : Color(kDark.value),
                          FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 10),
              CustomButton(
                onTap: () async {
                  if (isChecked == false) {
                    FocusScope.of(context)
                        .requestFocus(FocusNode()); // Close the keyboard
                    Get.snackbar(
                        'ATENTION :', "* Anda belum menyetujui persyaratan");
                  } else if (controller.nikController.text.length < 16) {
                    Get.snackbar('ATENTION :',
                        "* Nomor Induk Kependudukan tidak boleh kurang dari 16 digit");
                    FocusScope.of(context)
                        .requestFocus(FocusNode()); // Close the keyboard
                  } else if (controller.kodePosController.text.length < 5) {
                    Get.snackbar('ATENTION :',
                        "* Kode Pos tidak boleh kurang dari 5 digit");
                    FocusScope.of(context)
                        .requestFocus(FocusNode()); // Close the keyboard
                  } else if (controller.jlnRumahController.text.isEmpty) {
                    Get.snackbar('ATENTION :', '* Jalan RUmah harus diisi');
                    FocusScope.of(context)
                        .requestFocus(FocusNode()); // Close the keyboard
                  } else if (controller.phoneController.text.length < 12) {
                    Get.snackbar('ATENTION :',
                        "* Nomer Telepon tidak boleh kurang dari 12 digit");
                    FocusScope.of(context)
                        .requestFocus(FocusNode()); // Close the keyboard
                  } else if (controller.provinsi.value == '' ||
                      controller.kabAtaukota.value == '' ||
                      controller.kecamatan.value == '') {
                    Get.snackbar(
                        'ATENTION :', "* Identitas Alamat tidak boleh kosong");
                    FocusScope.of(context)
                        .requestFocus(FocusNode()); // Close the keyboard
                  } else if (controller.nikController.text.isNotEmpty &&
                      controller.tempatKelahiranController.text.isNotEmpty &&
                      controller.phoneController.text.isNotEmpty &&
                      controller.golDarah.isNotEmpty) {
                    await controller.completeProfile(
                        widget.statusLogin,
                        controller.nikController.text,
                        storage.getStatus() == '1'
                            ? storage.getEmail()
                            : storage.getStatus() == '2'
                                ? storage.getemailGoogle()
                                : storage.getEmailFb(),
                        controller.usernameController.text,
                        controller.phoneController.text,
                        controller.gender.value,
                        controller.tglKelahiran.value,
                        controller.tempatKelahiranController.text,
                        controller.golDarah.value,
                        controller.rhesus.value,
                        controller.provinsi.toString(),
                        controller.kabAtaukota.toString(),
                        controller.kecamatan.toString(),
                        controller.jlnRumahController.text,
                        controller.kodePosController.text,
                        controller.pekerjaanController.text,
                        controller.puasa.value,
                        controller.dibutuhkan.value);
                    // Setelah data berhasil dikirim, Anda dapat melakukan navigasi atau tindakan lain yang sesuai.
                  } else {
                    // Tampilkan pesan kesalahan jika data belum lengkap
                    Get.snackbar(
                        'Error', 'Lengkapi semua data terlebih dahulu.');
                  }
                },
                text: 'Selanjutnya',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
