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
  static const String randomTextAgreement = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam sollicitudin laoreet suscipit. Nam pretium, quam id rhoncus feugiat, urna massa bibendum ante, vitae efficitur diam nibh a diam. Phasellus dignissim finibus neque, non lacinia nunc eleifend nec. Donec eget lectus ac neque volutpat pharetra quis id magna. Vestibulum fermentum ac erat a pellentesque. Integer mollis eleifend ex, vel consectetur nibh tincidunt id. Vestibulum maximus justo lectus, elementum vestibulum eros gravida sed. \n\nFusce aliquam justo ac turpis lobortis, in ultrices nibh facilisis. Mauris a placerat ligula. Aliquam quam massa, mollis eget tempor ac, elementum ut velit. Pellentesque lacinia et elit in vulputate. Vivamus blandit ante vel tempor ultricies. Cras imperdiet, ligula quis dictum accumsan, neque diam semper nulla, vitae blandit diam massa eu sem. Nullam vitae magna id urna facilisis imperdiet id at lacus. Integer molestie egestas tortor, quis tempus eros scelerisque vel. Aliquam suscipit quam ac egestas ornare. Curabitur aliquam euismod lorem tincidunt tempus. Sed orci nisl, cursus ac eros ac, laoreet bibendum ipsum. Morbi posuere lacus et tellus luctus sagittis ac in diam. In hac habitasse platea dictumst. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos\n\n\Pellentesque et bibendum ex. Pellentesque ultricies nulla a elit dapibus scelerisque. Donec ut finibus dui, vel egestas leo. Aliquam dapibus gravida nisi ac porttitor. Duis diam risus, placerat eu tellus sed, tempus aliquet magna. Curabitur luctus sapien sit amet sapien varius ornare. Vestibulum rutrum, libero at sollicitudin maximus, ligula odio pharetra ante, et posuere odio nulla semper lacus. Cras mollis ex purus, non pulvinar augue euismod ac. Sed ut orci id dolor molestie ultrices. Etiam suscipit tincidunt est ac lobortis. Ut diam risus, posuere at porta sit amet, suscipit at leo. Suspendisse laoreet sapien eget risus blandit, vel mattis ante sagittis. Sed vulputate sodales vehicula. Cras vel massa efficitur, euismod turpis at, lobortis nisi. Donec ac purus sed neque hendrerit placerat.';

  static ThemeData getAppLightTheme() =>
      ThemeData(
        colorScheme: const ColorScheme.light().copyWith(
          primary: Colors.red,
          secondary: Colors.grey,
        ),
        iconTheme: const IconThemeData(
          color: Colors.red
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: Colors.red
          )
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
          iconTheme: const IconThemeData(
              color: Colors.red
          ),
          iconButtonTheme: IconButtonThemeData(
              style: IconButton.styleFrom(
                  foregroundColor: Colors.red
              )
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
