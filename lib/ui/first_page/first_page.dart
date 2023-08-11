import 'dart:developer';
import 'package:apple_music_clone/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: ListTile(
          shape: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 0.5
            )
          ),
          leading: TextButton(
            onPressed: ()=> SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary
            ),
            child: const Text('Disagree'),
          ),
          trailing: TextButton(
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary
            ),
            onPressed: () {
              SharedPreferences.getInstance().then((value) {
                value.setBool('agreedTerms', true);
                Navigator.pushReplacementNamed(context, '/home');
              }).catchError((err) {
                log('Get SharedPreferences instance failed: $err', name: 'firstPageOnAgree', error: 'ERROR');
              });
            },
            child: const Text('Agree'),
          ),
        ),
        body: ListView(
          children: [
            Text('APPLE CLONE INC.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppConfig.mediumText, color: Theme.of(context).colorScheme.primary)),
            const Text(
              AppConfig.randomTextAgreement,
              style: TextStyle(fontSize: AppConfig.mediumText, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
          ]
        ),
      ),
    );
  }
}
