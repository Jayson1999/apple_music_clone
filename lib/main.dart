import 'package:apple_music_clone/ui/first_page/first_page.dart';
import 'package:apple_music_clone/ui/home_page/home.dart';
import 'package:apple_music_clone/ui/settings_page/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

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
      title: 'Apple Music Clone',
      theme: _getAppTheme(),
      initialRoute: widget.agreedTerms? '/home': '/first',
      routes: {
        '/first': (context) => const FirstPage(),
        '/home': (context) => const HomePage(),
        '/settings': (context) => const SettingsPage()
      },
    );
  }

  ThemeData _getAppTheme() =>
      ThemeData(
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.red,
          selectedLabelStyle: TextStyle(fontSize: 12),
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.grey,
          unselectedLabelStyle: TextStyle(fontSize: 12),
        ),
      );
}
