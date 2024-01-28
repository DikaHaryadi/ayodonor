import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getdonor/controllers/themes_controller.dart';
import 'package:getdonor/pages/onboarding_page.dart';
import 'package:getdonor/utils/components/storage_util.dart';
import 'package:getdonor/utils/themes.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final storage = StorageUtil();

  if (storage.prefs.read('login') == null ||
      storage.prefs.read('login') == 'False') {
    storage.prefs.write('login', 'False');
  } else if (storage.prefs.read('login_google') == null ||
      storage.prefs.read('login_google') == 'False') {
    storage.prefs.write('login_google', 'False');
  } else if (storage.prefs.read('login_facebook') == null ||
      storage.prefs.read('login_facebook') == 'False') {
    storage.prefs.write('login_facebook', 'False');
  }
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initializeDateFormatting('id_ID', null).then(
    (_) => runApp(MyApp()),
  );
}

class MyApp extends StatelessWidget {
  MyApp({
    Key? key,
  }) : super(key: key);

  final themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('id')],
      debugShowCheckedModeBanner: false,
      themeMode: themeController.theme,
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
      home: const OnBoardingPage(),
    );
  }
}
