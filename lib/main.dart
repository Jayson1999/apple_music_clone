import 'package:apple_music_clone/ui/first_page/first_page.dart';
import 'package:apple_music_clone/ui/home_page/home.dart';
import 'package:apple_music_clone/ui/home_page/bloc/theme_bloc.dart';
import 'package:apple_music_clone/utils/app_routes.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final SharedPreferences preferences = await SharedPreferences.getInstance();
  bool agreedTerms = preferences.getBool('agreedTerms') ?? false;
  int themeIndex = preferences.getInt('theme') ?? 2;
  runApp(BlocProvider(
      create: (context) => ThemeBloc(),
      child: MyApp(agreedTerms, themeIndex)
  ));
}

class MyApp extends StatefulWidget {
  final bool agreedTerms;
  final int themeIndex;
  const MyApp(this.agreedTerms, this.themeIndex, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ThemeBloc>(context).add(GetCurrentTheme());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        if (state.status.isLoading || state.status.isInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        else if (state.status.isSuccess) {
          return MaterialApp(
            title: AppConfig.appTitle,
            theme: AppConfig.getAppLightTheme(),
            darkTheme: AppConfig.getAppDarkTheme(),
            themeMode: state.themeMode,
            initialRoute: widget.agreedTerms ? AppRoutes.homePage : AppRoutes
                .firstPage,
            routes: {
              AppRoutes.firstPage: (context) => const FirstPage(),
              AppRoutes.homePage: (context) => const HomePage(),
            },
          );
        }

        else if (state.status.isError) {
          return Center(
            child: Text('Failed to fetch data: ${state.errorMsg}'),
          );
        }

        return Text('$state');
      }
    );
  }

}
