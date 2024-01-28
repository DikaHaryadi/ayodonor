import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/pages/aftap_root_page.dart';
import 'package:getdonor/pages/dokter_root_page.dart';
import 'package:getdonor/pages/login.dart';
import 'package:getdonor/pages/rootpage.dart';
import 'package:getdonor/utils/colors.dart';
import 'package:getdonor/utils/components/storage_util.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final controller = PageController();
  final selectedPageNotifier = ValueNotifier(0);
  final backgrounds = [
    "images/started-1.jpg",
    "images/started-2.jpg",
    "images/started-3.jpg",
  ];

  final titles = [
    "SETETES DARAH ANDA NYAWA BAGI SESAMA",
    "KITA SEHAT MEREKA SELAMAT",
    "DAFTAR DONOR DARAH DARI RUMAH",
  ];

  final desc = [
    "Kami dapat membantu anda menemukan golongan darah yang dibutuhkan",
    "Ayodonor dapat membantu anda mencari stock darah di berbagai UTD PMI di seluruh Indonesia",
    "Kami juga menyajikan anda terkait informasi tentang kesehatan, jadwal pendaftaran donor darah dan berita seputar kesehatan",
  ];

  final sub = [
    "Jika tidak nyaman dalam light mode, Anda dapat beralih kedalam dark mode",
    "Aplikasi ini juga di lengkapi dengan fitur feedback guna menjadi masukan terhadap aplikasi ini agar lebih baik",
    "Anda juga dapat login dengan menggunakan akun Ayodonor, Google & Facebook"
  ];

  @override
  Widget build(BuildContext context) {
    StorageUtil storage = StorageUtil();
    return Scaffold(
        body: Stack(children: [
      Positioned.fill(
          child: PageView.builder(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: backgrounds.length,
              itemBuilder: (context, index) {
                return BackgroundImage(asset: backgrounds[index]);
              },
              onPageChanged: (index) {
                selectedPageNotifier.value = index;
              })),
      Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Expanded(
            child: ValueListenableBuilder<int>(
                valueListenable: selectedPageNotifier,
                builder: (context, value, child) {
                  return BackgroundWording(
                      key: UniqueKey(),
                      title: titles[value],
                      desc: desc[value],
                      sub: sub[value],
                      duration: const Duration(milliseconds: 1000));
                })),
        InkWell(
            onTap: () {
              if (storage.getRoles() == '0') {
                storage.getLogin() == 'False'
                    ? Get.offAll(() => const Login())
                    : Get.offAll(() => const RootPage());
              } else if (storage.getRoles() == '1') {
                storage.getLogin() == 'False'
                    ? Get.offAll(() => const Login())
                    : Get.offAll(() => const DokterRootPage());
              } else if (storage.getRoles() == '2') {
                storage.getLogin() == 'False'
                    ? Get.offAll(() => const Login())
                    : Get.offAll(() => const AftapRootPage());
              } else {
                storage.getLogin() == 'False'
                    ? Get.offAll(() => const Login())
                    : Get.offAll(() => const RootPage());
              }
            },
            borderRadius: BorderRadius.circular(50),
            child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.fromLTRB(48, 0, 48, 16),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color(0xFFE8B448)),
                alignment: Alignment.center,
                child: Text(
                  "GET STARTED",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Color(kLight.value)),
                ))),
        Padding(
            padding: const EdgeInsets.all(24),
            child: ValueListenableBuilder<int>(
                valueListenable: selectedPageNotifier,
                builder: (context, value, _) {
                  return BackgroundIndicator(
                      key: UniqueKey(),
                      itemCount: backgrounds.length,
                      selectedIndex: value,
                      duration: const Duration(milliseconds: 6000),
                      onPageChange: (value) {
                        controller.animateToPage(
                          value,
                          duration: const Duration(
                            milliseconds: 1000,
                          ),
                          curve: Curves.ease,
                        );
                      });
                }))
      ])
    ]));
  }
}

class BackgroundIndicator extends StatefulWidget {
  const BackgroundIndicator({
    super.key,
    required this.itemCount,
    required this.selectedIndex,
    this.duration = const Duration(milliseconds: 300),
    this.onPageChange,
  });

  final int itemCount;
  final int selectedIndex;
  final Duration duration;
  final void Function(int)? onPageChange;

  @override
  State<BackgroundIndicator> createState() => _BackgroundIndicatorState();
}

class _BackgroundIndicatorState extends State<BackgroundIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _tween;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _tween = Tween<double>(
      begin: 0,
      end: widget.duration.inMilliseconds.toDouble(),
    ).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        if (widget.onPageChange != null) {
          final index = widget.selectedIndex + 1;
          widget.onPageChange!(index == widget.itemCount ? 0 : index);
        }
      }
    });

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        widget.itemCount,
        (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index != widget.itemCount - 1 ? 8 : 0,
              ),
              child: index == widget.selectedIndex
                  ? AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        return LinearProgressIndicator(
                          value: _tween.value / widget.duration.inMilliseconds,
                        );
                      },
                    )
                  : LinearProgressIndicator(
                      value: index < widget.selectedIndex ? 1 : 0,
                    ),
            ),
          );
        },
      ),
    );
  }
}

class BackgroundWording extends StatefulWidget {
  const BackgroundWording({
    super.key,
    required this.title,
    required this.desc,
    required this.sub,
    this.duration = const Duration(milliseconds: 300),
  });

  final String title;
  final String desc;
  final String sub;
  final Duration duration;

  @override
  State<BackgroundWording> createState() => _BackgroundWordingState();
}

class _BackgroundWordingState extends State<BackgroundWording>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _tween;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _tween = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _tween,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Color(kLight.value),
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              widget.desc,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Color(kLight.value),
                  fontFamily: 'Barlow',
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Text(
              widget.sub,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Color(kLight.value),
                  fontFamily: 'Barlow',
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({
    super.key,
    required this.asset,
  });
  final String asset;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            asset,
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color(kDark.value).withOpacity(0.2),
      ),
    );
  }
}
