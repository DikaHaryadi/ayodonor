import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/app_style.dart';
import '../utils/colors.dart';
import '../utils/reusable_text.dart';

class Tentang extends StatelessWidget {
  const Tentang({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String paragraph1 =
        ' Setiap menit terdapat 1 (satu) Orang yang membutuhkan transfusi darah di Indonesia. Palang Merah Indonesia merupakan organisasi yang sah secara Undang-undang untuk membantu Pemerintah dalam memenuhi kebutuhan pelayanan darah transfusi dan pelayanan sosial kemanusian di Indonesia.';

    String paragraph2 =
        ' AYODONOR adalah aplikasi dan portal informasi yang dikemas untuk memudahkan pelayanan darah transfusi melalui Palang Merah Indonesia di seluruh Kota / Kabupaten di Indonesia, dalam hal Pelayanan Sosial dan Kemanusian kami mencoba memudahkan penyaluran bantuan/donasi Anda kepada penerima manfaat secara langsung melalui PMI.';

    String paragraph3 =
        'Seiring donasi menjadi lebih mudah, semoga akan lebih banyak yang dapat kita bantu.';

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/background_pmi.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: ListView(
        children: [
          Stack(
            children: <Widget>[
              Positioned(
                top: 10,
                left: 10,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.7),
                            spreadRadius: .5,
                            blurRadius: 6,
                          )
                        ],
                        color: Colors.black.withOpacity(.3),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10.0, 50, 10.0, 10.0),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(
                              left: 35.0, right: 35.0, top: 10.0, bottom: 15.0),
                          margin: const EdgeInsets.only(top: 20.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(kLightGrey.value), width: 1),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(left: 75.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    const Text(
                                      "Tentang Kami",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      "Ayodonor - Palang Merah Indonesia",
                                      style: TextStyle(
                                          color: Color(kLightGrey.value),
                                          fontFamily: 'Epilogue'),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Setetes Darah Anda\nMenyelamatkan Nyawa Mereka',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.actor(
                                      color: Color(kDark.value),
                                      fontStyle: FontStyle.italic),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: const DecorationImage(
                              image: AssetImage('images/logo.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          margin: const EdgeInsets.only(
                            left: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                border: Border.all(
                                    color: Color(kLightGrey.value), width: 1),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5)),
                              ),
                              width: Get.width,
                              padding: const EdgeInsets.only(
                                  left: 10.0, top: 5.0, bottom: 5.0),
                              child: ReusableText(
                                  text: 'Salam Kemanusiaan',
                                  style: appstyle(
                                      16, Color(kDark.value), FontWeight.w500)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(paragraph1,
                                  textAlign: TextAlign.justify,
                                  style: appstyle(
                                      14, Color(kDark.value), FontWeight.w400)),
                            ),
                          ],
                        )),
                    const SizedBox(height: 10.0),
                    Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                border: Border.all(
                                    color: Color(kLightGrey.value), width: 1),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5)),
                              ),
                              width: Get.width,
                              padding: const EdgeInsets.only(
                                  left: 10.0, top: 5.0, bottom: 5.0),
                              child: ReusableText(
                                  text: 'Ayodonor itu apa sih?',
                                  style: appstyle(
                                      16, Color(kDark.value), FontWeight.w500)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(paragraph2,
                                  textAlign: TextAlign.justify,
                                  style: appstyle(
                                      14, Color(kDark.value), FontWeight.w400)),
                            ),
                          ],
                        )),
                    const SizedBox(height: 10.0),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(paragraph3,
                              textAlign: TextAlign.center,
                              style: appstyle(
                                  14, Color(kDark.value), FontWeight.w400))),
                    ),
                    Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                border: Border.all(
                                    color: Color(kLightGrey.value), width: 1),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5)),
                              ),
                              width: Get.width,
                              padding: const EdgeInsets.only(
                                  left: 10.0, top: 5.0, bottom: 5.0),
                              child: ReusableText(
                                  text: 'Kontak Palang Merah Indonesia',
                                  style: appstyle(
                                      16, Color(kDark.value), FontWeight.w500)),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 8),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.contact_phone_outlined,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 5),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              _launchPhoneDialer('0217815465');
                                            },
                                            child: const ReusableText(
                                              text: '(021) 7815465',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _launchPhoneDialer(
                                                  '0831 4010 3054');
                                            },
                                            child: const ReusableText(
                                              text: '(+62) 831 4010 3054',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(child: Container()),
                                      const Icon(Icons.maps_home_work_outlined,
                                          color: Colors.grey),
                                      const SizedBox(width: 5),
                                      GestureDetector(
                                        onTap: () {
                                          launchMaps();
                                        },
                                        child: const ReusableText(
                                          text: 'alamat',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Icon(Ionicons.earth_outline,
                                          color: Colors.grey),
                                      const SizedBox(width: 5),
                                      InkWell(
                                        onTap: () => launchWebsite(),
                                        child: const ReusableText(
                                          text: 'https://uddpmi.or.id/',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Expanded(child: Container()),
                                      const Icon(Icons.contact_mail_outlined,
                                          color: Colors.grey),
                                      const SizedBox(width: 5),
                                      Flexible(
                                        child: InkWell(
                                          onTap: () => launchEmail(),
                                          child: const ReusableText(
                                            text: 'admin@utdp-pmi.or.id',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.blue,
                                                decoration:
                                                    TextDecoration.underline,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void launchMaps() async {
    const url =
        'https://www.google.com/maps/search/?api=1&query=-6.318680567443205,106.8345783118559';

    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      Get.snackbar('Error', 'Tidak bisa membuka maps: $e');
    }
  }

  void launchWebsite() async {
    const url = 'https://uddpmi.or.id/';

    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      Get.snackbar('Error', 'Tidak bisa membuka website: $e');
    }
  }

  void launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'admin@utdp-pmi.or.id',
      query: 'subject=Saya Ingin Bertanya=Halo PMI,',
    );

    try {
      await launchUrl(emailLaunchUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      Get.snackbar('Error', 'Tidak bisa membuka mail: $e');
    }
  }

  _launchPhoneDialer(String phoneNumber) async {
    // Remove non-numeric characters from the phone number
    final cleanPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    final Uri phoneLaunchUri = Uri(scheme: 'tel', path: cleanPhoneNumber);

    try {
      await launchUrl(phoneLaunchUri);
    } catch (e) {
      Get.snackbar('Error', 'Tidak bisa membuka telepon: $e');
    }
  }
}
