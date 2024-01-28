// import 'dart:convert';

// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import '../utils/success_dialog.dart';

// // class LengkapiProfileGoogleController extends GetxController {
// //   final String email;
// //   final String username;

// //   LengkapiProfileGoogleController(
// //       {required this.email, required this.username});

// //   final nikController = TextEditingController();
// //   final phoneController = TextEditingController();
// //   final pekerjaanController = TextEditingController();

// //   final nikFN = FocusNode();
// //   final phoneFN = FocusNode();
// //   final pekerjaanFN = FocusNode();

// //   RxString golDarah = RxString('');

// //   final showProgress = false.obs;
// //   final errorMessage = ''.obs;

// //   Future<void> registerLP() async {
// //     try {
// //       showProgress.value = true;

// //       final uri = Uri.parse('url');
// //       final request = http.MultipartRequest('POST', uri);

// //       request.fields['nik'] = nikController.text;
// //       request.fields['email_google'] = email;
// //       request.fields['phone'] = phoneController.text;
// //       request.fields['gol_darah'] = golDarah.toString();
// //       request.fields['pekerjaan'] = pekerjaanController.text;

// //       final streamResponse = await request.send();
// //       final response = await http.Response.fromStream(streamResponse);

// //       final jsonData = json.decode(response.body);
// //       if (jsonData[0]["success"] == true) {
// //         showDialogAndNavigate(
// //           title: 'Pendaftaran Berhasil',
// //           subtitle: '$email.\n$username}',
// //         );
// //       } else {
// //         print(jsonData[0]["msg"]);
// //       }
// //     } catch (err) {
// //       showProgress.value = false;
// //       errorMessage.value = 'Terjadi kesalahan';
// //       Get.snackbar('Error', errorMessage.value);
// //     } finally {
// //       showProgress(false);
// //     }
// //   }

// //   void showDialogAndNavigate(
// //       {required String title, required String subtitle}) async {
// //     await Future.delayed(const Duration(seconds: 2));
// //     showProgress.value = false;

// //     Get.generalDialog(
// //       barrierDismissible: false,
// //       barrierLabel: "Pendaftaran Donor Darah",
// //       transitionDuration: const Duration(milliseconds: 400),
// //       transitionBuilder: (context, animation, secondaryAnimation, child) {
// //         final tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
// //         return SlideTransition(
// //           position: tween.animate(
// //             CurvedAnimation(parent: animation, curve: Curves.easeInOut),
// //           ),
// //           child: child,
// //         );
// //       },
// //       pageBuilder: (context, _, __) => Center(
// //         child: Container(
// //           padding: const EdgeInsets.only(left: 10, right: 10),
// //           width: MediaQuery.of(context).size.width,
// //           height: MediaQuery.of(context).size.height / 2,
// //           decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
// //           child: Scaffold(
// //             backgroundColor: Colors.white,
// //             body: Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 10),
// //               child: SuccessDialog(
// //                 title: title,
// //                 subtitle: subtitle,
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
