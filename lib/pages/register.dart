import 'dart:convert';

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/themes_controller.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../controllers/register_controller.dart';
import '../model/provinsi_model.dart';
import '../utils/Custom/custom_loading.dart';
import 'package:http/http.dart' as http;
import '../utils/Custom/custom_textfield.dart';
import '../utils/app_constants.dart';
import '../utils/app_style.dart';
import '../utils/colors.dart';
import '../utils/components/app_bar.dart';
import '../utils/custom_btn.dart';
import '../utils/debouncer.dart';
import '../utils/reusable_text.dart';

class Register extends StatefulWidget {
  final int tag;
  const Register({
    Key? key,
    required this.tag,
  }) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool? passwordVisible = true;
  int? selectedProvinceId;
  int? selectedKotaId;
  int? selectedKecamatanId;

  // late int widget.tag;
  List<String> roles = [
    'Pendonor',
    'Dokter',
    'Petugas AFTAP',
  ];
  // Provinsi? selectedProvinsi;
  int? selectedInstansiId;

  bool isChecked = false;
  final RegistrationController controller = Get.put(RegistrationController());

  // TextEditingController instansiController = TextEditingController();
  final ThemeController themeController = Get.find();

  List<Instansi> instansiUtd = [];
  List<SelectedListItem> instansiUtdItems = [];

  List<SelectedListItem> provinceListItems = [];
  List<SelectedListItem> kotaListItems = [];
  List<SelectedListItem> kecamatanListItems = [];

  void fetchInstansi() async {
    var response = await http
        .get(Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getInstansi}'));
    print('response' + response.body.toString());
    if (response.statusCode == 200) {
      List<dynamic> instansiData = json.decode(response.body);
      print('data' + instansiData.toString());
      setState(() {
        instansiUtdItems = instansiData.map((instansiData) {
          var province = Instansi.fromJson(instansiData);
          return SelectedListItem(
            name: province.namaInstansi,
            value: province.idInstansi.toString(),
            isSelected: false,
          );
        }).toList();
      });
    } else {
      // Handle the case where the server returns an error response
      print('Failed to load provinces');
    }
  }

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

  void _showInstansiPicker(BuildContext context) {
    print('here');
    DropDownState(DropDown(
      bottomSheetTitle: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: 'Tempat kerja unit transfusi darah',
            maxlines: 2,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Poppins'),
          ),
          ReusableText(
            text:
                'Harap mengisi nama instansi yang sesuai dengan tempat bekerja saat ini',
            maxlines: 2,
            style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 14,
                fontFamily: 'Barlow'),
          ),
        ],
      ),
      submitButtonChild: const Text(
        'Done',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      data: instansiUtdItems,
      selectedItems: (List<dynamic> selectedList) {
        List<String> list = [];
        for (var item in selectedList) {
          if (item is SelectedListItem) {
            list.add(item.name);
            print(item.value);
            setState(() {
              selectedInstansiId = int.parse(item.value!);
              controller.instansiBekerjaController.text =
                  selectedInstansiId.toString();
            });
          }
        }
        if (list.isNotEmpty) {
          controller.instansiBekerjaController.text = list.first;
        }
        //Navigator.pop(context); // Close the bottom sheet
      },
      enableMultipleSelection: false,
    )).showModal(context);
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
              selectedKotaId = int.parse(item.value!);
              controller.kabAtaukota.value = selectedKotaId.toString();
              controller.kotaController.text = item.name;
              fetchKota();
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
              selectedKecamatanId = int.parse(item.value!);
              controller.kecamatan.value = selectedKecamatanId.toString();
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

  @override
  void initState() {
    passwordVisible = true;
    fetchProvinces();
    fetchInstansi();
    // fetchKota();
    // fetchKecamatan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Debouncer debouncer = Debouncer(
      delay: const Duration(milliseconds: 300),
    );

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CustomAppBar(
          bgColor: Theme.of(context).scaffoldBackgroundColor,
          iconColor: themeController.isDarkTheme()
              ? Color(kLight.value)
              : Color(kDark.value),
          text: widget.tag == 0
              ? 'Pendaftaran Akun Pendonor'
              : widget.tag == 1
                  ? 'Pendaftaran Akun Dokter'
                  : widget.tag == 2
                      ? 'Pendaftaran Akun Petugas AFTAP'
                      : '',
          fontFamily: 'Epilogue',
          automaticallyImplyLeading: false,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          const SizedBox(height: 20),
          ReusableText(
            text: 'Selamat Datang!',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 30,
                color: themeController.isDarkTheme()
                    ? Color(kLight.value)
                    : Color(kLightGrey.value),
                fontWeight: FontWeight.w600),
          ),
          Text(
              widget.tag == 0
                  ? 'Isi detail untuk mendaftarkan akun anda'
                  : widget.tag == 1
                      ? 'Harap mengisi data dokter yang sesuai'
                      : widget.tag == 2
                          ? 'Isi detail untuk daftar sebagai petugas AFTAP'
                          : '',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 16,
                    color: themeController.isDarkTheme()
                        ? Color(kLight.value)
                        : Color(kDarkGrey.value),
                    fontWeight: FontWeight.normal,
                  )),
          const SizedBox(height: 20),
          widget.tag == 0
              ? Container(
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
                        () => controller.image.value != null
                            ? Center(
                                child: InkWell(
                                onTap: () {
                                  FocusScope.of(context).requestFocus(
                                      FocusNode()); // Close the keyboard
                                  controller.dialogLocationImg(context);
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 160,
                                      height: 160,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: FileImage(
                                                controller.image.value!),
                                            fit: BoxFit.cover),
                                        border: Border.all(
                                          width: 4,
                                          color: Color(kAksenDark.value),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            spreadRadius: 2,
                                            blurRadius: 10,
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 4,
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            width: 4,
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                          ),
                                          color: Colors.green,
                                        ),
                                        child: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                            : GestureDetector(
                                onTap: () async {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  controller.dialogLocationImg(context);
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(kLightGrey.value),
                                              width: 1)),
                                      child: ReusableText(
                                          text: 'Pilih Foto',
                                          style: appstyle(
                                              14,
                                              themeController.isDarkTheme()
                                                  ? Color(kLight.value)
                                                  : Color(kDarkGrey.value),
                                              FontWeight.w500)),
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: ReusableText(
                                        text:
                                            '<- Harap memasukan foto yang sesuai',
                                        maxlines: 2,
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            color: themeController.isDarkTheme()
                                                ? Color(kAksenDark.value)
                                                : Color(kLightGrey.value),
                                            fontWeight: FontWeight.w300),
                                      ),
                                    )
                                  ],
                                ),
                              ),
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
                                  builder:
                                      (BuildContext context, Widget? child) {
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
                          controller: controller.kotaController,
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
                        focusNode: controller.kelurahanFc,
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
                        hintText: 'Pekerjaan Sesuai KTP',
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: controller.emailController,
                        focusNode: controller.emailFocusNode,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: controller.passController,
                        focusNode: controller.passFocusNode,
                        hintText: 'Password',
                        keyboardType: TextInputType.multiline,
                        maxLines: 1,
                        obscureText: passwordVisible,
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              passwordVisible =
                                  passwordVisible == true ? false : true;
                            });
                          },
                          child: Icon(
                              passwordVisible!
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : const Color(0xFF9B9B9B)),
                        ),
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
                        color: themeController.isDarkTheme()
                            ? Color(kAksenDark.value)
                            : Color(kLight.value),
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
                        color: themeController.isDarkTheme()
                            ? Color(kAksenDark.value)
                            : Color(kLight.value),
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
                              margin: const EdgeInsets.only(left: 8, top: 10),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: ReusableText(
                                        text:
                                            'Bersediakah saudara donor pada waktu\nbulan puasa?',
                                        style: appstyle(
                                            14,
                                            themeController.isDarkTheme()
                                                ? Color(kLight.value)
                                                : Color(kDarkGrey.value),
                                            FontWeight.w500)),
                                  ),
                                  Row(
                                    children: [
                                      Obx(
                                        () => Radio<String>(
                                            value: 'Ya',
                                            groupValue: controller.puasa.value,
                                            activeColor: Colors.red,
                                            onChanged: (value) => controller
                                                .puasa.value = value!),
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
                                            onChanged: (value) => controller
                                                .puasa.value = value!),
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
                                        style: appstyle(
                                            14,
                                            themeController.isDarkTheme()
                                                ? Color(kLight.value)
                                                : Color(kDarkGrey.value),
                                            FontWeight.w500)),
                                  ),
                                  Row(
                                    children: [
                                      Obx(
                                        () => Radio<String>(
                                            value: 'Ya',
                                            groupValue:
                                                controller.dibutuhkan.value,
                                            activeColor: Colors.red,
                                            onChanged: (value) => controller
                                                .dibutuhkan.value = value!),
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
                                            groupValue:
                                                controller.dibutuhkan.value,
                                            activeColor: Colors.red,
                                            onChanged: (value) => controller
                                                .dibutuhkan.value = value!),
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
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
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
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          widget.tag == 1
              ? Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(children: [
                    CustomTextField(
                      controller: controller.usernameController,
                      focusNode: controller.usernameFocusNode,
                      hintText: 'Nama Dokter (Tanpa Gelar)',
                      maxLines: 2,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 10),
                    Obx(
                      () => controller.image.value != null
                          ? Center(
                              child: InkWell(
                              onTap: () {
                                FocusScope.of(context).requestFocus(
                                    FocusNode()); // Close the keyboard
                                controller.dialogLocationImg(context);
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: 160,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: FileImage(
                                              controller.image.value!),
                                          fit: BoxFit.cover),
                                      border: Border.all(
                                        width: 4,
                                        color: Color(kAksenDark.value),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          color: Colors.black.withOpacity(0.1),
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 4,
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 4,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                        color: Colors.green,
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                          : GestureDetector(
                              onTap: () async {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                controller.dialogLocationImg(context);
                              },
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(kLightGrey.value),
                                            width: 1)),
                                    child: ReusableText(
                                        text: 'Pilih Foto',
                                        style: appstyle(
                                            14,
                                            themeController.isDarkTheme()
                                                ? Color(kLight.value)
                                                : Color(kDarkGrey.value),
                                            FontWeight.w500)),
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: ReusableText(
                                      text:
                                          '<- Harap memasukan foto yang sesuai',
                                      maxlines: 2,
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          color: themeController.isDarkTheme()
                                              ? Color(kAksenDark.value)
                                              : Color(kLightGrey.value),
                                          fontWeight: FontWeight.w300),
                                    ),
                                  )
                                ],
                              ),
                            ),
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
                    CustomTextField(
                      controller: controller.jlnRumahController,
                      focusNode: controller.kelurahanFc,
                      hintText: 'Alamat Rumah',
                      maxLines: 10,
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: controller.emailController,
                      focusNode: controller.emailFocusNode,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: controller.passController,
                      focusNode: controller.passFocusNode,
                      hintText: 'Password',
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      obscureText: passwordVisible,
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            passwordVisible =
                                passwordVisible == true ? false : true;
                          });
                        },
                        child: Icon(
                            passwordVisible!
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: themeController.isDarkTheme()
                                ? Color(kLight.value)
                                : const Color(0xFF9B9B9B)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                        controller: controller.instansiBekerjaController,
                        hintText: 'Tempat kerja unit transfusi darah.',
                        prefixIcon: const Icon(Icons.home_work_outlined),
                        suffixIcon: IconButton(
                          onPressed: () {
                            print('press');
                            _showInstansiPicker(context);
                            print('after press');
                          },
                          icon: const Icon(Icons.search),
                        ),
                        readOnly: true,
                        keyboardType: TextInputType.none),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 2,
                      color: themeController.isDarkTheme()
                          ? Color(kAksenDark.value)
                          : Color(kLight.value),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
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
                                  'Saya mengaku sebagai dokter yang bertugas\npada Palang Merah Indonesia',
                              maxlines: 2,
                              style: appstyle(
                                  14,
                                  themeController.isDarkTheme()
                                      ? Color(kLight.value)
                                      : Color(kDark.value),
                                  FontWeight.w500)),
                        ),
                      ],
                    ),
                  ]),
                )
              : const SizedBox.shrink(),
          widget.tag == 2
              ? Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(children: [
                    CustomTextField(
                      controller: controller.nikController,
                      focusNode: controller.nikFocusNode,
                      maxLength: 18,
                      hintText: 'ID Petugas AFTAP',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    Obx(
                      () => controller.image.value != null
                          ? Center(
                              child: InkWell(
                              onTap: () {
                                FocusScope.of(context).requestFocus(
                                    FocusNode()); // Close the keyboard
                                controller.dialogLocationImg(context);
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: 160,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: FileImage(
                                              controller.image.value!),
                                          fit: BoxFit.cover),
                                      border: Border.all(
                                        width: 4,
                                        color: Color(kAksenDark.value),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          color: Colors.black.withOpacity(0.1),
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 4,
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 4,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                        color: Colors.green,
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                          : GestureDetector(
                              onTap: () async {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                controller.dialogLocationImg(context);
                              },
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(kLightGrey.value),
                                            width: 1)),
                                    child: ReusableText(
                                        text: 'Pilih Foto',
                                        style: appstyle(
                                            14,
                                            themeController.isDarkTheme()
                                                ? Color(kLight.value)
                                                : Color(kDarkGrey.value),
                                            FontWeight.w500)),
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: ReusableText(
                                      text:
                                          '<- Harap memasukan foto yang sesuai',
                                      maxlines: 2,
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          color: themeController.isDarkTheme()
                                              ? Color(kAksenDark.value)
                                              : Color(kLightGrey.value),
                                          fontWeight: FontWeight.w300),
                                    ),
                                  )
                                ],
                              ),
                            ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: controller.usernameController,
                      focusNode: controller.usernameFocusNode,
                      hintText: 'Nama Petugas AFTAP',
                      maxLines: 2,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: controller.phoneController,
                      focusNode: controller.phoneFocusNode,
                      maxLength: 12,
                      hintText: 'No.Telp',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: controller.jlnRumahController,
                      hintText: 'Alamat Rumah',
                      maxLines: 10,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: controller.emailController,
                      focusNode: controller.emailFocusNode,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: controller.passController,
                      focusNode: controller.passFocusNode,
                      hintText: 'Password',
                      keyboardType: TextInputType.multiline,
                      maxLines: 1,
                      obscureText: passwordVisible,
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            passwordVisible =
                                passwordVisible == true ? false : true;
                          });
                        },
                        child: Icon(
                            passwordVisible!
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: themeController.isDarkTheme()
                                ? Color(kLight.value)
                                : const Color(0xFF9B9B9B)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                        controller: controller.instansiBekerjaController,
                        hintText: 'Tempat kerja unit transfusi darah',
                        prefixIcon: const Icon(Icons.home_work_outlined),
                        suffixIcon: IconButton(
                          onPressed: () {
                            print('press');
                            _showInstansiPicker(context);
                            print('after press');
                          },
                          icon: const Icon(Icons.search),
                        ),
                        readOnly: true,
                        keyboardType: TextInputType.none),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 2,
                      color: themeController.isDarkTheme()
                          ? Color(kAksenDark.value)
                          : Color(kLight.value),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
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
                                  'Saya mengaku sebagai petugas AFTAP yang bekerja di ${controller.instansiBekerjaController.text}',
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
                  ]),
                )
              : const SizedBox.shrink(),
          const SizedBox(height: 30),
          CustomButton(
            onTap: () async {
              if (widget.tag == 0) {
                if (isChecked == false) {
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); // Close the keyboard
                  Get.snackbar(
                      'ATENTION :', "* Anda belum menyetujui persyaratan");
                } else if (controller.nikController.text.isEmpty ||
                    controller.kodePosController.text.isEmpty ||
                    controller.gender.isEmpty ||
                    controller.tglKelahiran.isEmpty ||
                    controller.tempatKelahiranController.text.isEmpty ||
                    controller.golDarah.isEmpty ||
                    controller.pekerjaanController.text.isEmpty) {
                  controller.showProgress.value = true;
                  Get.snackbar('ATENTION :', "* Harap mengisi semua data");
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
                } else if (controller.emailController.text.isEmpty ||
                    !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(controller.emailController.text)) {
                  controller.showProgress.value = true;
                  Get.snackbar(
                      'ATENTION :', '*Harap mengisi email dengan benar');
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); // Close the keyboard
                } else if (controller.passController.text.isEmpty ||
                    controller.passController.text.length < 8 ||
                    !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                        .hasMatch(controller.passController.text)) {
                  controller.showProgress.value = true;
                  Get.snackbar('ATENTION :',
                      '*Harap masukan password minimal :\n8 karakter, huruf besar, angka dan symbol');
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); // Close the keyboard
                } else if (controller.phoneController.text.isEmpty ||
                    !RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
                        .hasMatch(controller.phoneController.text)) {
                  controller.showProgress.value = true;
                  Get.snackbar('ATENTION :', '* Nomer telpon wajib diisi');
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); // Close the keyboard
                } else if (controller.provinsi.value.isEmpty ||
                    controller.provinsi.value == '') {
                  controller.showProgress.value = true;
                  Get.snackbar('ATENTION :', '* Provinsi harus diisi');
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); // Close the keyboard
                } else if (controller.kabAtaukota.value.isEmpty) {
                  controller.showProgress.value = true;
                  Get.snackbar('ATENTION :', '* Kabupaten / Kota harus diisi');
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); // Close the keyboard
                } else if (controller.kecamatan.value.isEmpty) {
                  controller.showProgress.value = true;
                  Get.snackbar('ATENTION :', '* Kecamatan harus diisi');
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); // Close the keyboard
                } else if (controller.jlnRumahController.text.isEmpty) {
                  controller.showProgress.value = true;
                  Get.snackbar('ATENTION :', '* Alamat Rumah harus diisi');
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); // Close the keyboard
                } else if (controller.kodePosController.text.isEmpty) {
                  controller.showProgress.value = true;
                  Get.snackbar('ATENTION :', '* Kode Pos harus diisi');
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); // Close the keyboard
                } else if (controller.image.value == null) {
                  controller.showProgress.value = true;
                  Get.snackbar('ATENTION :', '* Foto wajib dimasukan');
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); // Close the keyboard
                } else if (!RegExp(r'^[a-z A-Z]+$')
                    .hasMatch(controller.pekerjaanController.text)) {
                  controller.showProgress.value = true;
                  Get.snackbar(
                      'Atetion :', '* Pekerjaan tidak boleh berisi angka');
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
                      controller.register();
                    },
                  );
                }
              } else if (widget.tag == 1) {
                if (isChecked == false) {
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); // Close the keyboard
                  Get.snackbar(
                      'ATENTION :', "* Anda belum menyetujui persyaratan");
                } else if (controller.usernameController.text.isEmpty ||
                    controller.phoneController.text.isEmpty ||
                    controller.gender.value == '' ||
                    controller.instansiBekerjaController.text.isEmpty ||
                    controller.passController.text.isEmpty) {
                  Get.snackbar('ATENTION :', "* Harap mengisi semua data");
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); // Close the keyboard
                } else if (controller.emailController.text.isEmpty ||
                    !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(controller.emailController.text)) {
                  controller.showProgress.value = true;
                  Get.snackbar(
                      'ATENTION :', '*Harap mengisi email dengan benar');
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); // Close the keyboard
                } else if (controller.passController.text.isEmpty ||
                    controller.passController.text.length < 8 ||
                    !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                        .hasMatch(controller.passController.text)) {
                  controller.showProgress.value = true;
                  Get.snackbar('ATENTION :',
                      '*Harap masukan password minimal :\n8 karakter, huruf besar, angka dan symbol');
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); // Close the keyboard
                } else if (controller.image.value == null) {
                  controller.showProgress.value = true;
                  Get.snackbar('ATENTION :', '* Foto wajib dimasukan');
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
                      controller.registerDokter();
                    },
                  );
                }
              } else if (widget.tag == 2) {
                if (isChecked == false) {
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); // Close the keyboard
                  Get.snackbar(
                      'ATENTION :', "* Anda belum menyetujui persyaratan");
                } else if (controller.nikController.text.isEmpty ||
                    controller.usernameController.text.isEmpty ||
                    controller.phoneController.text.isEmpty ||
                    controller.jlnRumahController.text.isEmpty ||
                    controller.gender.value == '' ||
                    controller.instansiBekerjaController.text.isEmpty ||
                    controller.passController.text.isEmpty) {
                  Get.snackbar('ATENTION :', "* Harap mengisi semua data");
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); // Close the keyboard
                } else if (controller.nikController.text.length < 18) {
                  controller.showProgress.value = true;
                  Get.snackbar('ATENTION :',
                      '*ID Petugas AFTAP tidak boleh kurang dari 18 digits');
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); // Close the keyboard
                } else if (controller.emailController.text.isEmpty ||
                    !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(controller.emailController.text)) {
                  controller.showProgress.value = true;
                  Get.snackbar(
                      'ATENTION :', '*Harap mengisi email dengan benar');
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); // Close the keyboard
                } else if (controller.passController.text.isEmpty ||
                    controller.passController.text.length < 8 ||
                    !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                        .hasMatch(controller.passController.text)) {
                  controller.showProgress.value = true;
                  Get.snackbar('ATENTION :',
                      '*Harap masukan password minimal :\n8 karakter, huruf besar, angka dan symbol');
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); // Close the keyboard
                } else if (controller.image.value == null) {
                  controller.showProgress.value = true;
                  Get.snackbar('ATENTION :', '* Foto wajib dimasukan');
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
                      controller.registerAftap();
                    },
                  );
                }
              } else {
                null;
              }
            },
            text: 'Register Akun',
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}
