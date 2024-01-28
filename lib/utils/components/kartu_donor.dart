import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:getdonor/controllers/themes_controller.dart';
import 'package:getdonor/pages/info_profile.dart';
import 'package:getdonor/utils/components/storage_util.dart';
import 'package:get/get.dart';

import '../app_constants.dart';
import '../app_style.dart';
import '../colors.dart';

class KartuDonor extends StatefulWidget {
  const KartuDonor({
    Key? key,
  }) : super(key: key);

  @override
  State<KartuDonor> createState() => _KartuDonorState();
}

class _KartuDonorState extends State<KartuDonor> {
  final StorageUtil storage = StorageUtil();
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    var height = Get.height;
    var width = Get.height;

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'images/pmi.png',
                  height: 30,
                  fit: BoxFit.cover,
                ),
                Image.asset(
                  'images/ayodonorshadow.png',
                  height: 35,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: height * 0.2,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('images/blood_donation.jpg'),
                  fit: BoxFit.fill,
                )),
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
              Positioned(
                  bottom: 10,
                  top: 10,
                  left: 100,
                  right: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: storage.getStatus() == '1'
                              ? NetworkImage(
                                  ApiUtils.baseImgURL + storage.getImg())
                              : storage.getStatus() == '2'
                                  ? NetworkImage(storage.getImgGoogle())
                                  : storage.getStatus() == '3'
                                      ? NetworkImage(storage.getImgFb())
                                      : const NetworkImage(
                                          'https://cdn-icons-png.flaticon.com/512/3135/3135715.png')),
                    ),
                    width: width * 0.4,
                    height: height * 0.2,
                  )),
            ],
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              Get.to(() => const InfoProfile());
            },
            child: Text(
              storage.getName().isNotEmpty == true
                  ? storage.getName().toUpperCase()
                  : storage.getUserGoogle().isNotEmpty == true
                      ? storage.getUserGoogle().toUpperCase()
                      : '',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            storage.getPekerjaan().toLowerCase(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
          const SizedBox(height: 5),
          _bottomKartu(),
        ],
      ),
    );
  }

  _bottomKartu() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 5),
      color: Colors.red,
      child: Column(
        children: [
          Text(
            'KARTU PENDOOR DARAH',
            style: appstyle(14, Color(kLight.value), FontWeight.w400),
          ),
          Text(
            'Palang Merah Indonesia',
            style: appstyle(14, Color(kLight.value), FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
