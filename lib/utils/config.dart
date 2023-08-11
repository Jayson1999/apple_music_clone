import 'dart:ui';
import 'package:flutter/material.dart';


class AppConfig{
  static const String clientId = '941e3aa6d6e6469a911d295923431c73';
  // Usually secrets are stored in Secret Manager/Key Vault, not in repo
  static const String clientSecret = 'c2eb8de6ad4849fca4875797a26f75c4';
  static const String appTitle = 'Apple Music Clone';
  static final String localRegion = window.locale.countryCode ?? '';
  static const double bigText = 24.0;
  static const double mediumText = 15.0;
  static const double smallText = 9.0;
  static const String placeholderImgUrl = 'https://www.w3schools.com/howto/img_avatar2.png';

  static ThemeData getAppLightTheme() =>
      ThemeData(
        colorScheme: const ColorScheme.light().copyWith(
          primary: Colors.red,
          secondary: Colors.grey,
        ),
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.red)
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.grey),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black
          )
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.red,
          selectedLabelStyle: TextStyle(fontSize: 12),
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.grey,
          unselectedLabelStyle: TextStyle(fontSize: 12),
        ),
      );

  static ThemeData getAppDarkTheme() =>
      ThemeData(
          colorScheme: const ColorScheme.dark().copyWith(
            primary: Colors.red,
            secondary: Colors.grey,
          ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.red)
        ),
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.grey),
        ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                foregroundColor: Colors.white
            )
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.red,
          selectedLabelStyle: TextStyle(fontSize: 12),
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.grey,
          unselectedLabelStyle: TextStyle(fontSize: 12),
      ));
}
