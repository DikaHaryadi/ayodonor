import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/feedback_controller.dart';
import 'package:getdonor/controllers/themes_controller.dart';
import 'package:getdonor/model/feedback_model.dart';
import 'package:getdonor/pages/create_feedback.dart';
import 'package:getdonor/pages/edit_feedback.dart';
import 'package:getdonor/pages/info_profile.dart';
import 'package:getdonor/utils/components/storage_util.dart';
import 'package:getdonor/utils/expandable_text.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';

import '../controllers/post_feedback_controller.dart';
import '../utils/Custom/is_login.dart';
import '../utils/app_constants.dart';
import '../utils/app_style.dart';
import '../utils/colors.dart';
import '../utils/components/feedback_loading.dart';
import '../utils/reusable_text.dart';

// ignore: must_be_immutable
class FeedBack extends StatefulWidget {
  const FeedBack({
    Key? key,
  }) : super(key: key);

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  final StorageUtil storage = StorageUtil();

  FeedBackController feedBackController = Get.put(FeedBackController());

  PostFeedBackController postFeedBackController =
      Get.put(PostFeedBackController());

  final ThemeController themeController = Get.find();

  final GlobalKey _draggableKey = GlobalKey();
  Offset _position = const Offset(0.0, 0.0);
  final dateTime = DateFormat("EEEE, d MMMM yyyy", 'id_ID');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await feedBackController.refreshData();
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border.all(
                        color: themeController.isDarkTheme()
                            ? Color(kAksenDark.value)
                            : Color(kLightGrey.value),
                        width: .5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                        text: 'FeedBack',
                        style: appstyle(
                            16,
                            themeController.isDarkTheme()
                                ? Color(kAksenDark.value)
                                : Color(kDarkGrey.value),
                            FontWeight.w600)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            storage.getLogin() == 'False'
                                ? showGeneralDialog(
                                    barrierDismissible: true,
                                    barrierLabel: "If Login",
                                    context: context,
                                    transitionDuration:
                                        const Duration(milliseconds: 400),
                                    transitionBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      Tween<Offset> tween;
                                      tween = Tween(
                                          begin: const Offset(0, -1),
                                          end: Offset.zero);
                                      return SlideTransition(
                                        position: tween.animate(
                                          CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.easeInOut),
                                        ),
                                        child: child,
                                      );
                                    },
                                    pageBuilder: (context, _, __) => Center(
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2,
                                        child: const Scaffold(
                                            backgroundColor: Colors.white,
                                            body: IsLogin()),
                                      ),
                                    ),
                                  )
                                : Get.to(() => const InfoProfile());
                          },
                          child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.transparent,
                              backgroundImage: getImage()),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              storage.getLogin() == 'False'
                                  ? showGeneralDialog(
                                      barrierDismissible: true,
                                      barrierLabel: "If Login",
                                      context: context,
                                      transitionDuration:
                                          const Duration(milliseconds: 400),
                                      transitionBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        Tween<Offset> tween;
                                        tween = Tween(
                                            begin: const Offset(0, -1),
                                            end: Offset.zero);
                                        return SlideTransition(
                                          position: tween.animate(
                                            CurvedAnimation(
                                                parent: animation,
                                                curve: Curves.easeInOut),
                                          ),
                                          child: child,
                                        );
                                      },
                                      pageBuilder: (context, _, __) => Center(
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              2,
                                          child: const Scaffold(
                                              backgroundColor: Colors.white,
                                              body: IsLogin()),
                                        ),
                                      ),
                                    )
                                  : Get.to(() => const CreateFeedBack());
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                      color: themeController.isDarkTheme()
                                          ? Color(kAksenDark.value)
                                          : Color(kDarkGrey.value),
                                      width: .8)),
                              child: ReusableText(
                                  text: 'Apa yang anda\npikirkan?',
                                  style: appstyle(
                                      13,
                                      themeController.isDarkTheme()
                                          ? Color(kLight.value)
                                          : Color(kAksenDark.value),
                                      FontWeight.normal)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            storage.getLogin() == 'False'
                                ? showGeneralDialog(
                                    barrierDismissible: true,
                                    barrierLabel: "If Login",
                                    context: context,
                                    transitionDuration:
                                        const Duration(milliseconds: 400),
                                    transitionBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      Tween<Offset> tween;
                                      tween = Tween(
                                          begin: const Offset(0, -1),
                                          end: Offset.zero);
                                      return SlideTransition(
                                        position: tween.animate(
                                          CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.easeInOut),
                                        ),
                                        child: child,
                                      );
                                    },
                                    pageBuilder: (context, _, __) => Center(
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2,
                                        child: const Scaffold(
                                            backgroundColor: Colors.white,
                                            body: IsLogin()),
                                      ),
                                    ),
                                  )
                                : Get.to(() => const CreateFeedBack());
                          },
                          child: const Icon(
                            Ionicons.image,
                            color: Color(0xff45bd63),
                          ),
                        ),
                      ],
                    )
                  ],
                )),
            Obx(() {
              if (feedBackController.isLoading.value) {
                return const FeedBackLoading();
              } else if (feedBackController.feedbackList.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('images/no_data.png'),
                    ReusableText(
                        text: 'Tidak ada postingan',
                        style: appstyle(
                          20,
                          themeController.isDarkTheme()
                              ? Color(kLight.value)
                              : Color(kAksenDark.value),
                          FontWeight.w600,
                        ))
                  ],
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: feedBackController.feedbackList.length,
                  itemBuilder: (context, index) {
                    FeedBackModel feedBackModel =
                        feedBackController.feedbackList[index];
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.8),
                          border: Border.all(
                              color: themeController.isDarkTheme()
                                  ? Color(kAksenDark.value)
                                  : Color(kLightGrey.value),
                              width: .5)),
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.transparent,
                              backgroundImage: feedBackModel.status == '1'
                                  ? NetworkImage(ApiUtils.getShearPreferenceImg(
                                      feedBackModel.imgUser!))
                                  : NetworkImage(feedBackModel.imgUser!),
                            ),
                            title: ReusableText(
                                text: feedBackModel.user!,
                                maxlines: 2,
                                style: appstyle(
                                    13,
                                    themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kDark.value),
                                    FontWeight.bold)),
                            subtitle: ReusableText(
                                text:
                                    'Golongan darah : ${feedBackModel.golDarah}',
                                style: TextStyle(
                                    color: themeController.isDarkTheme()
                                        ? Color(kLight.value)
                                        : Color(kDark.value),
                                    fontFamily: 'Barlow',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13)),
                            trailing: storage.getNik() == feedBackModel.nik
                                ? PopupMenuButton<String>(
                                    onSelected: (value) async {
                                      if (value == 'Edit') {
                                        Get.to(() => EditFeedbackPage(
                                              feedBackModel: feedBackModel,
                                            ));
                                      }
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<String>>[
                                      PopupMenuItem<String>(
                                        value: 'Edit',
                                        child: ReusableText(
                                            text: 'Edit',
                                            style: appstyle(
                                                14,
                                                themeController.isDarkTheme()
                                                    ? Color(kLight.value)
                                                    : Color(kDark.value),
                                                FontWeight.normal)),
                                      ),
                                      PopupMenuItem<String>(
                                        onTap: () {
                                          if (feedBackModel.id != null) {
                                            postFeedBackController
                                                .deleteFeedback(
                                                    feedBackModel.id!);
                                          }
                                        },
                                        value: 'Hapus',
                                        child: ReusableText(
                                            text: 'Hapus',
                                            style: appstyle(
                                                14,
                                                themeController.isDarkTheme()
                                                    ? Color(kLight.value)
                                                    : Color(kDark.value),
                                                FontWeight.normal)),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ExpandableTextWidget(
                                text: feedBackModel.deskripsi!),
                          ),
                          const SizedBox(height: 5),
                          GestureDetector(
                              onTap: () {
                                feedBackModel.img!.isEmpty
                                    ? const SizedBox.shrink()
                                    : showGeneralDialog(
                                        barrierDismissible: true,
                                        barrierLabel: "Image Content",
                                        context: context,
                                        transitionDuration:
                                            const Duration(milliseconds: 400),
                                        transitionBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          Tween<Offset> tween;
                                          tween = Tween(
                                              begin: const Offset(0, -1),
                                              end: Offset.zero);
                                          return SlideTransition(
                                            position: tween.animate(
                                              CurvedAnimation(
                                                  parent: animation,
                                                  curve: Curves.easeInOut),
                                            ),
                                            child: child,
                                          );
                                        },
                                        pageBuilder: (context, _, __) => Center(
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            child: Scaffold(
                                                backgroundColor:
                                                    const Color(0xFF000000),
                                                body: Stack(
                                                  children: [
                                                    Align(
                                                      key: _draggableKey,
                                                      alignment: Alignment(
                                                          _position.dx,
                                                          _position.dy),
                                                      child: Draggable(
                                                        feedback: Container(
                                                          width: Get.width,
                                                          height: Get.height,
                                                          decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  fit: BoxFit
                                                                      .fitWidth,
                                                                  image: NetworkImage(
                                                                      ApiUtils.getShearPreferenceImg(
                                                                          feedBackModel
                                                                              .img!)))),
                                                        ),
                                                        childWhenDragging:
                                                            Container(),
                                                        onDragEnd: (details) {
                                                          if (details
                                                                  .offset.dx >
                                                              0) {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          } else if (details
                                                                  .offset.dx <
                                                              0) {
                                                            Get.back();
                                                          }

                                                          if (details
                                                                  .offset.dy >
                                                              0) {
                                                            Get.back();
                                                          } else if (details
                                                                  .offset.dy <
                                                              0) {
                                                            Get.back();
                                                          }
                                                          setState(() {
                                                            _position =
                                                                const Offset(
                                                                    0.0, 0.0);
                                                          });
                                                        },
                                                        child: Container(
                                                          width: Get.width,
                                                          height: Get.height,
                                                          decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  fit: BoxFit
                                                                      .fitWidth,
                                                                  image: NetworkImage(
                                                                      ApiUtils.getShearPreferenceImg(
                                                                          feedBackModel
                                                                              .img!)))),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                        top: Get.height / 1.5,
                                                        bottom: 0,
                                                        left: 0,
                                                        right: 0,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          decoration: BoxDecoration(
                                                              color: Color(kDark
                                                                      .value)
                                                                  .withOpacity(
                                                                      0.3)),
                                                          child: ListView(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8),
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            5),
                                                                child: Text(
                                                                  feedBackModel
                                                                      .user!,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Eplogue',
                                                                      fontSize:
                                                                          15,
                                                                      color: Color(
                                                                          kLight
                                                                              .value),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 3),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            5),
                                                                child: Text(
                                                                  dateTime.format(
                                                                      DateTime.parse(
                                                                          feedBackModel
                                                                              .createdAt!)),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Eplogue',
                                                                      fontSize:
                                                                          15,
                                                                      color: Color(
                                                                          kLight
                                                                              .value),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 5),
                                                              ExpandableTextWidget(
                                                                text: feedBackModel
                                                                    .deskripsi!,
                                                                color: Color(
                                                                    kLight
                                                                        .value),
                                                              ),
                                                            ],
                                                          ),
                                                        ))
                                                  ],
                                                )),
                                          ),
                                        ),
                                      );
                              },
                              child: feedBackModel.img!.isNotEmpty
                                  ? CachedNetworkImage(
                                      height: Get.height * .25,
                                      imageUrl: ApiUtils.getShearPreferenceImg(
                                          feedBackModel.img!),
                                      placeholder: (context, url) =>
                                          LottieBuilder.asset(
                                              'images/feedback_loading.json'),
                                      errorWidget: (_, url, err) =>
                                          Image.asset('images/error_img.jpg'),
                                      fit: BoxFit.cover,
                                    )
                                  : const SizedBox.shrink()),
                          const SizedBox(height: 5)
                        ],
                      ),
                    );
                  },
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  NetworkImage getImage() {
    if (storage.getLogin() == 'False') {
      return const NetworkImage(
        'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
      );
    } else {
      if (storage.getStatus() == '1') {
        return NetworkImage(ApiUtils.baseImgURL + storage.getImg());
      } else if (storage.getStatus() == '2') {
        return NetworkImage(storage.getImgGoogle());
      } else if (storage.getStatus() == '3') {
        return NetworkImage(storage.getImgFb());
      } else {
        return const NetworkImage(
          'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
        );
      }
    }
  }
}
