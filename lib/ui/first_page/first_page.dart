import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: const Text('I agree'),
        onPressed: () {
          SharedPreferences.getInstance().then((value) {
            value.setBool('agreedTerms', true);
            Navigator.pushReplacementNamed(context, '/home');
          }).catchError((err) {
            log('Get SharedPreferences instance failed: $err', name: 'firstPageOnAgree', error: 'ERROR');
          });
        },
      );
  }
}
