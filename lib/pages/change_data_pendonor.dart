import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:getdonor/controllers/change_data_pendonor_controller.dart';
import 'package:getdonor/controllers/check_nik_controller.dart';
import 'package:getdonor/model/data_pendonor_model.dart';
import 'package:getdonor/utils/Custom/custom_loading.dart';
import 'package:getdonor/utils/app_constants.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';

import '../controllers/themes_controller.dart';
import '../model/provinsi_model.dart';
import '../utils/Custom/custom_textfield.dart';
import '../utils/app_style.dart';
import '../utils/colors.dart';
import '../utils/components/storage_util.dart';
import '../utils/custom_btn.dart';
import '../utils/debouncer.dart';
import '../utils/reusable_text.dart';

class ChangeDataPendonor2 extends StatefulWidget {
  final String nik;
  const ChangeDataPendonor2({super.key, required this.nik});

  @override
  State<ChangeDataPendonor2> createState() => _ChangeDataPendonor2State();
}

class _ChangeDataPendonor2State extends State<ChangeDataPendonor2> {
  int? selectedProvinceId;
  int? selectedKotaId;
  int? selectedKecamatanId;
  bool isChecked = false;

  StorageUtil storage = StorageUtil();
  final Debouncer debouncer =
      Debouncer(delay: const Duration(milliseconds: 500));

  ThemeController themeController = Get.put(ThemeController());
  ChangeDataPendonorController controller =
      Get.put(ChangeDataPendonorController());
  final CheckNikController checkNikController = Get.put(CheckNikController());
  DataPendonorModel dataPendonorModel = DataPendonorModel();

  List<SelectedListItem> provinceListItems = [];
  List<SelectedListItem> kotaListItems = [];
  List<SelectedListItem> kecamatanListItems = [];
  var selectedprovinceData;

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
              controller.provinsi.value = item.value!;
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
        'Kabupaten atau Kota',
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
            print('req selected' + item.value!.toString());
            setState(() {
              selectedKotaId = int.parse(item.value!);
              controller.kabAtaukota.value = item.value!;
              controller.kotaController.text = item.name;
              fetchKota();
            });
          }
        }
        if (list.isEmpty) {
          print('req not empty');
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
        'Kecamatan',
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
              selectedKecamatanId = int.parse(item.value!);
              controller.kecamatan.value = item.value!;
              controller.kecamatanController.text = item.name;
              fetchKecamatan();
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

  void preselectProvince() async {
    DataPendonorModel data1 = DataPendonorModel();
    data1 = checkNikController.dataPendonorList[0];
    print('selected${data1.provinsi}');
    var response = await http.get(Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.getProvinsi}?id_prov=${data1.provinsi}'));
    if (response.statusCode == 200) {
      selectedprovinceData = json.decode(response.body);
      setState(() {
        selectedProvinceId = int.parse(data1.provinsi.toString());
        controller.provinsiController.text =
            selectedprovinceData[0]['nama_prov'].toString();
        controller.provinsi.value =
            selectedprovinceData[0]['id_prov'].toString();
      });
    } else {
      // Handle the case where the server returns an error response
      print('Failed to load provinces');
    }
  }

  void preselectKota() async {
    DataPendonorModel data1 = DataPendonorModel();
    data1 = checkNikController.dataPendonorList[0];
    print('selected provid di function kota${data1.provinsi}');
    var response = await http.get(Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.getKabKota}?id_prov=${data1.provinsi}?id_kota=${data1.kabAtaukota}'));
    if (response.statusCode == 200) {
      selectedprovinceData = json.decode(response.body);
      setState(() {
        selectedProvinceId = int.parse(data1.provinsi.toString());
        selectedKotaId = int.parse(data1.kabAtaukota.toString());
        fetchKota();
        controller.kotaController.text =
            selectedprovinceData[0]['nama'].toString();
        controller.kabAtaukota.value =
            selectedprovinceData[0]['id_kota'].toString();
      });
    } else {
      // Handle the case where the server returns an error response
      print('Failed to load provinces');
    }
  }

  void preselectKecamatan() async {
    DataPendonorModel data1 = DataPendonorModel();
    data1 = checkNikController.dataPendonorList[0];
    print('selected kec preselect${data1.kabAtaukota}');
    var response = await http.get(Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.getKecamatan}?id_kota=${data1.kabAtaukota}?id_kecamatan=${data1.kecamatan}'));
    if (response.statusCode == 200) {
      selectedprovinceData = json.decode(response.body);
      setState(() {
        selectedKecamatanId = selectedprovinceData[0]['id_kecamatan'];
        fetchKecamatan();
        controller.kecamatanController.text =
            selectedprovinceData[0]['nama_kecamatan'].toString();
        controller.kecamatan.value =
            selectedprovinceData[0]['id_kecamatan'].toString();
      });
    } else {
      // Handle the case where the server returns an error response
      print('Failed to load provinces');
    }
  }

  @override
  void initState() {
    preselectProvince();
    preselectKota();
    preselectKecamatan();
    fetchProvinces();

    if (checkNikController.dataPendonorList.isNotEmpty) {
      dataPendonorModel = checkNikController.dataPendonorList[0];
    }

    controller.nikController.text = widget.nik;
    controller.usernameController.text = dataPendonorModel.name!;
    controller.tempatKelahiranController.text = dataPendonorModel.tempatLahir!;
    controller.phoneController.text = dataPendonorModel.phone!;
    controller.jlnRumahController.text = dataPendonorModel.jlnRumah!;
    controller.kodePosController.text = dataPendonorModel.kodepos!;
    controller.pekerjaanController.text = dataPendonorModel.pekerjaan!;

    controller.golDarah.value = dataPendonorModel.golDarah!;
    controller.rhesus.value = dataPendonorModel.rhesus!;
    controller.tglKelahiran.value = dataPendonorModel.tglLahir!;

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
                    child: const Text('Terus Mengedit')),
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
              text: 'Mengubah data pendonor',
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
                    focusNode: controller.nikFocusNode,
                    hintText: 'Nomor Induk Kependudukan',
                    maxLength: 16,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: controller.usernameController,
                    focusNode: controller.usernameFocusNode,
                    hintText: 'Nama Sesuai KTP',
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => CustomTextField(
                      hintText: controller.tglKelahiran.value.isNotEmpty
                          ? DateFormat.yMMMMd('id_ID').format(
                              DateTime.tryParse(
                                      controller.tglKelahiran.value) ??
                                  DateTime.now(),
                            )
                          : 'Masukan Tanggal Lahir Anda',
                      keyboardType: TextInputType.none,
                      readOnly: true,
                      suffixIcon: IconButton(
                          onPressed: () {
                            DateTime? selectedDate = DateTime.tryParse(
                                controller.tglKelahiran.value);

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
                    controller: controller.tempatKelahiranController,
                    focusNode: controller.tempatKelahiranFocusNode,
                    hintText: 'Tempat Lahir',
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                      hintText: 'Provinsi',
                      controller: controller.provinsiController,
                      prefixIcon: IconButton(
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
                      controller: controller.kotaController,
                      hintText: 'Kabupaten atau Kota',
                      prefixIcon: IconButton(
                        onPressed: () {
                          print('press');
                          fetchKota();
                          _showKotaPicker(context);
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
                      prefixIcon: IconButton(
                        onPressed: () {
                          print('press');
                          fetchKecamatan();
                          _showKecamatanPicker(context);
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
                    maxLength: 5,
                    hintText: 'Kode Pos',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: controller.pekerjaanController,
                    focusNode: controller.pekerjaanFocusNode,
                    hintText: 'Pekerjaan Sesuai KTP',
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: controller.phoneController,
                    focusNode: controller.phoneFocusNode,
                    hintText: 'No.Telp',
                    maxLength: 12,
                    keyboardType: TextInputType.phone,
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
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          child: Column(
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
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
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
                                'Saya ${storage.getNameDokter()} menyetujui telah mengubah data ${dataPendonorModel.name}',
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
                      } else if (controller.usernameController.text.isEmpty ||
                          controller.nikController.text.isEmpty ||
                          controller.phoneController.text.isEmpty ||
                          controller.rhesus.value.isEmpty ||
                          controller.jlnRumahController.text.isEmpty ||
                          controller.kodePosController.text.isEmpty ||
                          controller.tglKelahiran.isEmpty ||
                          controller.tempatKelahiranController.text.isEmpty ||
                          controller.golDarah.isEmpty ||
                          controller.pekerjaanController.text.isEmpty) {
                        controller.showProgress.value = true;
                        Get.snackbar(
                            'ATENTION :', "* Harap mengisi semua data");
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); // Close the keyboard
                      } else if (controller.nikController.text.length < 16) {
                        controller.showProgress.value = true;
                        Get.snackbar('ATENTION :',
                            "* Nomor Induk Kependudukan tidak boleh kurang dari 16 digit");
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); // Close the keyboard
                      } else if (controller.kodePosController.text.length < 5) {
                        controller.showProgress.value = true;
                        Get.snackbar('ATENTION :',
                            "* Kode Pos tidak boleh kurang dari 5 digit");
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); // Close the keyboard
                      } else if (controller.phoneController.text.length < 12) {
                        controller.showProgress.value = true;
                        Get.snackbar('ATENTION :',
                            "* Nomer Telepon tidak boleh kurang dari 12 digit");
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); // Close the keyboard
                      } else if (controller.phoneController.text.isEmpty ||
                          !RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
                              .hasMatch(controller.phoneController.text)) {
                        controller.showProgress.value = true;
                        Get.snackbar(
                            'ATENTION :', '* Nomer telpon wajib diisi');
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); // Close the keyboard
                      } else if (controller.jlnRumahController.text.isEmpty) {
                        controller.showProgress.value = true;
                        Get.snackbar(
                            'ATENTION :', '* Alamat Rumah harus diisi');
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); // Close the keyboard
                      } else if (controller.kodePosController.text.isEmpty) {
                        controller.showProgress.value = true;
                        Get.snackbar('ATENTION :', '* Kode Pos harus diisi');
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); // Close the keyboard
                      } else if (!RegExp(r'^[a-z A-Z]+$')
                          .hasMatch(controller.pekerjaanController.text)) {
                        controller.showProgress.value = true;
                        Get.snackbar('Atetion :',
                            '* Pekerjaan tidak boleh berisi angka');
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); // Close the keyboard
                      } else {
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); // Close the keyboard
                        controller.showProgress.value = true;
                        controller.showProgress.value
                            ? SmartDialog.showLoading(
                                animationType: SmartAnimationType.scale,
                                builder: (_) => const CustomLoading(),
                              )
                            : controller.showProgress.value = false;
                        await Future.delayed(const Duration(seconds: 2));
                        SmartDialog.dismiss();
                        debouncer(
                          () {
                            controller.editProfileKhususDokter(
                                dataPendonorModel.email!);
                          },
                        );
                      }
                    },
                    text: 'Ubah Data Pendonor',
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
