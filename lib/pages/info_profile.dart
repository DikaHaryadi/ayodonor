import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/google_sigin_controller.dart';
import 'package:getdonor/controllers/themes_controller.dart';
import 'package:getdonor/pages/blood_info.dart';
import 'package:getdonor/pages/check_nik_cp.dart';
import 'package:getdonor/pages/donasi.dart';
import 'package:getdonor/pages/info_pertolongan_pertama.dart';
import 'package:getdonor/utils/components/storage_util.dart';
import 'package:lottie/lottie.dart';

import '../controllers/fb_controller.dart';
import '../utils/Custom/app_bar.dart';
import '../utils/app_constants.dart';
import '../utils/app_style.dart';
import '../utils/colors.dart';
import '../utils/reusable_text.dart';

class InfoProfile extends StatefulWidget {
  const InfoProfile({
    Key? key,
  }) : super(key: key);

  @override
  State<InfoProfile> createState() => _InfoProfileState();
}

class _InfoProfileState extends State<InfoProfile> {
  final GlobalKey _draggableKey = GlobalKey();
  Offset _position = const Offset(0.0, 0.0);
  final StorageUtil storage = StorageUtil();
  final GoogleController googleController = Get.put(GoogleController());
  final FacebookAuthController fbController = Get.put(FacebookAuthController());
  late ThemeController themeController;

  @override
  void initState() {
    themeController = Get.find<ThemeController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomAppBar(
            bgColor: Theme.of(context).scaffoldBackgroundColor,
            iconColor: themeController.isDarkTheme()
                ? Color(kLight.value)
                : Color(kDark.value),
            text: 'Profile',
            centerTitle: false,
            actions: [
              storage.getRoles() == '0'
                  ? PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Info') {
                          Get.to(() => const InfoPertolonganPertama());
                        } else if (value == 'blood-info') {
                          Get.to(() => BloodInformation(
                                nik: storage.getNik(),
                              ));
                        } else if (value == 'change-profile') {
                          Get.to(() => const CheckNikChangeProfile());
                        } else if (value == 'logout') {
                          storage.getloginGoogle() == 'True'
                              ? googleController.signOut()
                              : storage.getLogin() == 'True'
                                  ? storage.logout()
                                  : fbController
                                      .logOutFb(); // Move logout logic to a separate function
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'Info',
                          child: ReusableText(
                            text: 'Info',
                            style: appstyle(
                              14,
                              themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kDark.value),
                              FontWeight.normal,
                            ),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'blood-info',
                          child: ReusableText(
                            text: 'Blood Information',
                            style: appstyle(
                              14,
                              themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kDark.value),
                              FontWeight.normal,
                            ),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'change-profile',
                          child: ReusableText(
                            text: 'Change Profile',
                            style: appstyle(
                              14,
                              themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kDark.value),
                              FontWeight.normal,
                            ),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'logout',
                          child: ReusableText(
                            text: 'Logout',
                            style: appstyle(
                              14,
                              themeController.isDarkTheme()
                                  ? Color(kLight.value)
                                  : Color(kDark.value),
                              FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    )
                  : storage.getRoles() == '1' || storage.getRoles() == '2'
                      ? PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'logout') {
                              storage.logout();
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'logout',
                              child: ReusableText(
                                text: 'Logout',
                                style: appstyle(
                                  14,
                                  themeController.isDarkTheme()
                                      ? Color(kLight.value)
                                      : Color(kDark.value),
                                  FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink()
            ],
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(Icons.arrow_back_ios),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: InkWell(
                  onTap: () {
                    showGeneralDialog(
                      barrierDismissible: true,
                      barrierLabel: "Image Content",
                      context: context,
                      transitionDuration: const Duration(milliseconds: 400),
                      transitionBuilder:
                          (context, animation, secondaryAnimation, child) {
                        Tween<Offset> tween;
                        tween =
                            Tween(begin: const Offset(0, -1), end: Offset.zero);
                        return SlideTransition(
                          position: tween.animate(
                            CurvedAnimation(
                                parent: animation, curve: Curves.easeInOut),
                          ),
                          child: child,
                        );
                      },
                      pageBuilder: (context, _, __) => Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Scaffold(
                            backgroundColor: const Color(0xFF000000),
                            body: Align(
                              key: _draggableKey,
                              alignment: Alignment(_position.dx, _position.dy),
                              child: Draggable(
                                feedback: Container(
                                  width: Get.width,
                                  height: Get.height,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    image: _getImage(),
                                  )),
                                ),
                                childWhenDragging: Container(),
                                onDragEnd: (details) {
                                  if (details.offset.dx > 0) {
                                    Navigator.of(context).pop();
                                  } else if (details.offset.dx < 0) {
                                    Navigator.of(context).pop();
                                  }

                                  if (details.offset.dy > 0) {
                                    Navigator.of(context).pop();
                                  } else if (details.offset.dy < 0) {
                                    Navigator.of(context).pop();
                                  }
                                  setState(() {
                                    _position = const Offset(0.0, 0.0);
                                  });
                                },
                                child: Container(
                                  width: Get.width,
                                  height: Get.height,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    image: _getImage(),
                                  )),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: _getImage(), fit: BoxFit.cover),
                      border: Border.all(
                        width: 4,
                        color: themeController.isDarkTheme()
                            ? Color(kAksenDark.value)
                            : Color(kAksenDark.value),
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
                ),
              ),
              const SizedBox(height: 10),
              buildContent(
                _getNameProfile(),
                Icons.person,
                'Nama',
                InkWell(
                  onTap: () {
                    Get.to(() => Donasi());
                  },
                  child: Lottie.asset('images/animation_lktvemax.json',
                      width: width * 0.15, fit: BoxFit.fill),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 65),
                child: Divider(
                  color: themeController.isDarkTheme()
                      ? Color(kLight.value).withOpacity(0.2)
                      : Color(kDark.value).withOpacity(0.2),
                ),
              ),
              buildContent(
                  storage.getEmail().isNotEmpty == true
                      ? storage.getEmail()
                      : storage.getemailGoogle().isNotEmpty == true
                          ? storage.getemailGoogle()
                          : storage.getEmailFb(),
                  Icons.info_outline,
                  'Email',
                  null),
              Padding(
                padding: const EdgeInsets.only(left: 65),
                child: Divider(
                  color: themeController.isDarkTheme()
                      ? Color(kLight.value).withOpacity(0.2)
                      : Color(kDark.value).withOpacity(0.2),
                ),
              ),
              buildContent(
                  storage.getRoles() == '0'
                      ? storage.getGolDarah()
                      : storage.getPhone(),
                  storage.getRoles() == '0'
                      ? Icons.bloodtype_outlined
                      : Icons.contact_phone_outlined,
                  storage.getRoles() == '0'
                      ? 'Golongan Darah'
                      : 'Nomer Telepon',
                  null),
              storage.getRoles() == '0'
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(left: 65),
                      child: Divider(
                        color: themeController.isDarkTheme()
                            ? Color(kLight.value).withOpacity(0.2)
                            : Color(kDark.value).withOpacity(0.2),
                      ),
                    ),
              storage.getRoles() == '0'
                  ? const SizedBox.shrink()
                  : buildContent(
                      storage.getKelamin(),
                      storage.getKelamin() == 'Pria'
                          ? Icons.male_outlined
                          : storage.getKelamin() == 'Wanita'
                              ? Icons.female_rounded
                              : null,
                      'Jenis Kelamin',
                      null),
            ],
          ),
        ));
  }

  String _getNameProfile() {
    if (storage.getRoles() == '0') {
      if (storage.getStatus() == '1') {
        return storage.getName();
      } else if (storage.getStatus() == '2') {
        return storage.getUserGoogle();
      } else if (storage.getStatus() == '3') {
        return storage.getUserFb();
      }
    } else if (storage.getRoles() == '1') {
      return storage.getNameDokter();
    } else if (storage.getRoles() == '2') {
      return storage.getNameAFTAP();
    }

    // Default image if none of the conditions match
    return 'Logic error, silahkan hubungi developer';
  }

  NetworkImage _getImage() {
    if (storage.getRoles() == '0') {
      if (storage.getStatus() == '1') {
        return NetworkImage(ApiUtils.baseImgURL + storage.getImg());
      } else if (storage.getStatus() == '2') {
        return NetworkImage(storage.getImgGoogle());
      } else if (storage.getStatus() == '3') {
        return NetworkImage(storage.getImgFb());
      }
    } else if (storage.getRoles() == '1') {
      return NetworkImage(ApiUtils.baseImgURL + storage.getImg());
    } else if (storage.getRoles() == '2') {
      return NetworkImage(ApiUtils.baseImgURL + storage.getImg());
    }

    // Default image if none of the conditions match
    return const NetworkImage(
        'https://cdn-icons-png.flaticon.com/512/3135/3135715.png');
  }

  Widget buildContent(
      String title, IconData? leading, String titleAtas, Widget? trailing) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            leading: Icon(
              leading,
              size: 20,
              color: themeController.isDarkTheme()
                  ? Color(kLight.value)
                  : Color(kDarkGrey.value),
            ),
            title: ReusableText(
                text: titleAtas, style: appstyle(14, null, FontWeight.w500)),
            subtitle: ReusableText(
                text: title, style: appstyle(14, null, FontWeight.w500)),
            trailing:
                storage.getRoles() == '0' ? trailing : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
