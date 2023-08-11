import 'package:apple_music_clone/ui/first_page/first_page.dart';
import 'package:apple_music_clone/ui/home_page/home.dart';
import 'package:apple_music_clone/ui/settings_page/settings_page.dart';
import 'package:apple_music_clone/utils/app_routes.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final SharedPreferences preferences = await SharedPreferences.getInstance();
  bool agreedTerms = preferences.getBool('agreedTerms') ?? false;
  runApp(MyApp(agreedTerms));
}

class MyApp extends StatefulWidget {
  final bool agreedTerms;
  const MyApp(this.agreedTerms, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appTitle,
      theme: AppConfig.getAppLightTheme(),
      darkTheme: AppConfig.getAppDarkTheme(),
      themeMode: ThemeMode.system,
      initialRoute: widget.agreedTerms? AppRoutes.homePage: AppRoutes.firstPage,
      routes: {
        AppRoutes.firstPage: (context) => const FirstPage(),
        AppRoutes.homePage: (context) => const HomePage(),
        AppRoutes.settingsPage: (context) => const SettingsPage()
      },
    );
  }

}
