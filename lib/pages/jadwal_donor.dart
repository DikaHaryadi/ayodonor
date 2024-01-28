import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/daftar_donor_controller.dart';
import 'package:getdonor/controllers/themes_controller.dart';
import 'package:getdonor/pages/daftar_donor.dart';
import 'package:getdonor/utils/components/storage_util.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

import '../utils/app_constants.dart';
import '../utils/app_style.dart';
import '../utils/colors.dart';
import '../utils/reusable_text.dart';

DateTime selecteDay = DateTime.now();

class JadwalDonor extends StatefulWidget {
  const JadwalDonor({
    Key? key,
  }) : super(key: key);

  @override
  State<JadwalDonor> createState() => _JadwalDonorState();
}

class _JadwalDonorState extends State<JadwalDonor> {
  List<dynamic> listJadwalDonor = [];
  List<Color> eventColors = [];

  // DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  final dateTime = DateFormat("EEEE, d MMMM yyyy", 'id_ID');
  final timeFormat = DateFormat.Hm();
  final StorageUtil storage = StorageUtil();
  final ThemeController themeController = Get.find();

  var height = Get.height;
  var width = Get.width;

  List<DateTime> markedDates = [];
  late List<NeatCleanCalendarEvent> _eventList = [];

  void _onDateSelected(DateTime newSelectedDate) {
    setState(() {
      // Update the global selectedDate
      // print(' hehe ' + newSelectedDate.toString());
      getData(newSelectedDate);
      selecteDay = newSelectedDate;
    });

    // Call getData when the date is selected
  }

  Future<void> fetchEventData() async {
    final url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getDonorSchedule}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        final List<NeatCleanCalendarEvent> eventsAPI = jsonData.map((data) {
          final DateTime startDate = DateTime.parse(data['tanggal']);
          final DateTime endDate = DateTime.parse(data['tanggal_berakhir']);
          final TimeOfDay startTime = TimeOfDay(
            hour: int.parse(data['waktu_mulai'].split(':')[0]),
            minute: int.parse(data['waktu_mulai'].split(':')[1]),
          );
          final TimeOfDay endTime = TimeOfDay(
            hour: int.parse(data['waktu_berakhir'].split(':')[0]),
            minute: int.parse(data['waktu_berakhir'].split(':')[1]),
          );

          return NeatCleanCalendarEvent(
            '${data['nama_event']}',
            description: '${data['nama_instansi']} ',
            location: '${data['alamat']} ',
            startTime: DateTime(
              startDate.year,
              startDate.month,
              startDate.day,
              startTime.hour,
              startTime.minute,
            ),
            endTime: DateTime(
              endDate.year,
              endDate.month,
              endDate.day,
              endTime.hour,
              endTime.minute,
            ),
            color: getRandomColor(),
          );
        }).toList();

        setState(() {
          _eventList = eventsAPI;
        });
      } else {
        _dialogLocation('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      _dialogLocation('Error during API call: $error');
    }
  }

  Widget buildEventList(
      BuildContext context, List<NeatCleanCalendarEvent> selectedEvents) {
    final DateTime currentDateTime = DateTime.now();

    return ListView.builder(
      itemCount: selectedEvents.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        double width = MediaQuery.of(context).size.width;

        NeatCleanCalendarEvent event = selectedEvents[index];
        if (index < selectedEvents.length) {
          final item = selectedEvents[index];
          final color = eventColors[index];

          bool eventHasEnded = item.endTime.isBefore(currentDateTime);

          return Column(
            children: [
              if (eventHasEnded) ...[
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      width: width,
                      height: height * 0.15,
                      decoration: BoxDecoration(
                        color: themeController.isDarkTheme()
                            ? Color(kLight.value)
                            : Color(kAksenDark.value),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0xFFe8e8e8),
                              blurRadius: 5.0,
                              offset: Offset(0, 5)),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: 0,
                      top: 0,
                      child: LottieBuilder.asset(
                        'images/sorry.json',
                      ),
                    ),
                    Positioned(
                      right: 70,
                      bottom: 0,
                      width: 70,
                      child: LottieBuilder.asset(
                        'images/asap.json',
                      ),
                    ),
                    Positioned(
                        right: 120,
                        bottom: 10,
                        top: 25,
                        child: Column(
                          children: [
                            Text('Sorry Out of Date',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                        color: themeController.isDarkTheme()
                                            ? Color(kDark.value)
                                            : Color(kLight.value),
                                        fontWeight: FontWeight.w300,
                                        fontStyle: FontStyle.italic)),
                            ReusableText(
                                text: "We'll back later..",
                                style: GoogleFonts.ubuntu(
                                    color: themeController.isDarkTheme()
                                        ? Color(kDark.value)
                                        : Color(kLight.value),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    fontStyle: FontStyle.italic)),
                          ],
                        )),
                    Positioned(
                        top: 0,
                        left: 0,
                        width: 100,
                        child: LottieBuilder.asset(
                          'images/close.json',
                        )),
                    Positioned(
                        bottom: 20,
                        left: 30,
                        child: Text(
                            'Note :\nJadwal pendonoran selanjutnya akan diberikan\nRefresh halaman ini jika jadwal tidak muncul',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontSize: 8,
                                    color: themeController.isDarkTheme()
                                        ? Color(kDark.value)
                                        : Color(kLight.value),
                                    fontFamily: 'Barlow',
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic)))
                  ],
                )
              ] else ...[
                InkWell(
                  onTap: () {
                    DaftarDonorController daftarDonorController =
                        DaftarDonorController(
                      nik: storage.getNik(),
                      namaInstansi: listJadwalDonor[index]['nama_instansi'],
                      idProv: listJadwalDonor[index]['id_prov'],
                      lokasiDonor: listJadwalDonor[index]['alamat'],
                      tanggalDonor: DateFormat('yyyy-MM-dd').format(selecteDay),
                      waktuDimulai: listJadwalDonor[index]['waktu_mulai'],
                      waktuBerakhir: listJadwalDonor[index]['waktu_berakhir'],
                    );

                    print('ini selected date nya : ${selecteDay.toString()}');
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            DaftarDonor(controller: daftarDonorController),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) =>
                                FadeTransition(
                          opacity:
                              Tween(begin: 0.0, end: 1.0).animate(animation),
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    width: width,
                    decoration: BoxDecoration(
                      color: Color(kLight.value),
                      border:
                          Border.all(color: Color(kAksenDark.value), width: 1),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFe8e8e8),
                          blurRadius: 1,
                          offset: Offset(2, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                height: 20,
                                margin: const EdgeInsets.only(right: 8),
                                width: width,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            ReusableText(
                                text: timeFormat.format(timeFormat.parse(
                                    '${item.startTime.hour}:${item.startTime.minute}')),
                                style: appstyle(
                                    13,
                                    Color(kDarkGreyAppBar.value),
                                    FontWeight.w400)),
                            ReusableText(
                                text: ' - ',
                                style: appstyle(
                                    13,
                                    Color(kDarkGreyAppBar.value),
                                    FontWeight.w400)),
                            ReusableText(
                                text: timeFormat.format(timeFormat.parse(
                                    '${item.endTime.hour}:${item.endTime.minute}')),
                                style: appstyle(
                                  13,
                                  Color(kDarkGreyAppBar.value),
                                  FontWeight.w400,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ReusableText(
                                      text: event.summary,
                                      maxlines: 2,
                                      style: appstyle(14, Color(kDark.value),
                                          FontWeight.w700)),
                                  const SizedBox(height: 5),
                                  ReusableText(
                                      text: event.description,
                                      maxlines: 2,
                                      style: TextStyle(
                                          fontFamily: 'Barlow',
                                          fontSize: 13,
                                          color: Color(kDark.value),
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 5),
                                  ReusableText(
                                      text: event.location,
                                      maxlines: 3,
                                      style: TextStyle(
                                          fontFamily: 'Barlow',
                                          fontSize: 13,
                                          color: Color(kDark.value),
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            DaftarDonorController daftarDonorController =
                                DaftarDonorController(
                              nik: storage.getNik(),
                              namaInstansi: listJadwalDonor[index]
                                  ['nama_instansi'],
                              idProv: listJadwalDonor[index]['id_prov'],
                              lokasiDonor: listJadwalDonor[index]['alamat'],
                              tanggalDonor:
                                  DateFormat('yyyy-MM-dd').format(selecteDay),
                              waktuDimulai: listJadwalDonor[index]
                                  ['waktu_mulai'],
                              waktuBerakhir: listJadwalDonor[index]
                                  ['waktu_berakhir'],
                            );

                            print(
                                'ini selected date nya : ${selecteDay.toString()}');
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        DaftarDonor(
                                            controller: daftarDonorController),
                                transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) =>
                                    FadeTransition(
                                  opacity: Tween(begin: 0.0, end: 1.0)
                                      .animate(animation),
                                  child: child,
                                ),
                              ),
                            );
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ReusableText(
                              text: 'Daftar Donor',
                              style:
                                  appstyle(13, Colors.green, FontWeight.w400),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

//akhir dari buildEvent
  void getData(DateTime selectedDate) async {
    print('get data ' + selectedDate.toString());
    try {
      final response = await http.get(Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.getDonorScheduleByDate}?tanggal=${DateFormat('yyyy-MM-dd').format(selectedDate)}'));

      if (response.statusCode == 200) {
        var isi = json.decode(response.body);
        print(' isi' + isi.toString());
        setState(() {
          listJadwalDonor = isi;
        });
        print('list data' + listJadwalDonor.toString());
      } else {
        _dialogLocation('Ada yang salah');
      }
    } catch (e) {
      _dialogLocation(e.toString());
    }
  }
  // Future getData() async {'
  //   try {
  //     final response = await http.get(
  //         Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getDonorSchedule}'));
  //     if (response.statusCode == 200) {
  //       var isi = json.decode(response.body);
  //       setState(() {
  //         listJadwalDonor = isi;
  //       });
  //     } else {
  //       _dialogLocation('Ada yang salah');
  //     }
  //   } catch (e) {
  //     _dialogLocation(e.toString());
  //   }
  // }

  void _dialogLocation(String errormsg) async {
    locationDialog({
      required AlignmentGeometry alignment,
      double width = double.infinity,
      double height = double.infinity,
    }) async {
      SmartDialog.show(
        alignment: alignment,
        builder: (_) => Container(
          width: width,
          padding: const EdgeInsets.all(10.0),
          color: Color(kDark.value),
          child: ReusableText(
              text: errormsg,
              style: appstyle(14, Color(kLight.value), FontWeight.w500)),
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      SmartDialog.dismiss();
    }

    await locationDialog(height: 70, alignment: Alignment.bottomCenter);
  }

  @override
  void initState() {
    // // Set the initial selected date (you can use DateTime.now() or any default date)
    // selecteDay = DateTime.now();

    // // Call _onDateSelected to trigger data loading for the initial date
    // _onDateSelected(selecteDay);
    fetchEventData();
    getData(selecteDay);
    // Delayed operation (if needed)
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          eventColors = generateEventColors(_eventList.length);
        });
      }
    });

    super.initState();
  }

  // @override
  // void initState() {
  //   Future.delayed(const Duration(seconds: 3), () {
  //     if (mounted) {
  //       setState(() {
  //         fetchEventData();
  //         eventColors = generateEventColors(_eventList.length);
  //         getData();
  //         _onDateSelected(selecteDay);
  //       });
  //     }
  //   });
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      init: themeController,
      builder: (controller) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
              color: themeController.isDarkTheme()
                  ? Color(kLightGrey.value)
                  : Color(kLight.value),
              border: Border.all(
                  color: themeController.isDarkTheme()
                      ? Color(kAksenDark.value)
                      : Color(kDarkGrey.value),
                  width: .8)),
          child: Calendar(
            eventListBuilder: (BuildContext context,
                List<NeatCleanCalendarEvent> selectedEvents) {
              return buildEventList(context,
                  selectedEvents); //ini ada bug nih, harusnya tanggal yang di klik itu bakalan jadi nilai tanggalDonor
            },
            onDateSelected: _onDateSelected,
            startOnMonday: true,
            hideArrows: false,
            hideTodayIcon: true,
            datePickerConfig: null,
            weekDays: const [
              'Senin',
              'Selasa',
              'Rabu',
              'Kamis',
              'Jumat',
              'Sabtu',
              'Minggu'
            ],
            eventsList: _eventList,
            eventDoneColor: Colors.green,
            selectedColor: Colors.pink,
            selectedTodayColor: Colors.red,
            todayColor: Colors.blue,
            eventColor: null,
            locale: 'id_ID',
            eventTileHeight: 120,
            isExpanded: true,
            hideBottomBar: true,
            datePickerType: DatePickerType.date,
            defaultDayColor: themeController.isDarkTheme()
                ? Color(kLight.value)
                : Color(kDark.value),
            defaultOutOfMonthDayColor: themeController.isDarkTheme()
                ? Color(kLight.value)
                : Color(kDarkGrey.value),
            dayOfWeekStyle: TextStyle(
                color: themeController.isDarkTheme()
                    ? Color(kLight.value)
                    : Color(kDarkGrey.value),
                fontWeight: FontWeight.w400,
                fontSize: 11),
          ),
        );
      },
    );
  }

  List<Color> generateEventColors(int count) {
    final random = Random();
    List<Color> colors = [];
    for (int i = 0; i < count; i++) {
      final color = Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
      colors.add(color);
    }
    return colors;
  }

  Color getRandomColor() {
    final random = Random();
    final color = Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
    eventColors.add(color);
    return color;
  }
}
