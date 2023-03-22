// ignore_for_file: depend_on_referenced_packages

import 'package:duda_shelter/firebase_options.dart';
import 'package:duda_shelter/pages/Auth/authPage.dart';
import 'package:duda_shelter/pages/OnBoarding/onBoardPage.dart';
import 'package:duda_shelter/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey =
      'pk_live_51MYDhoHkiOfBM7yoSHMycpURiyI7CyXdLyip29wWrUBD5azLNIzNcMvON8g5LOMc92WRe58IME4zSz9K00fYRofx00IUacKHGq';

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Duda Shelter',
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.white, primaryColor: ourPrimaryColor),
      home: const LoadApp(),
    );
  }
}

class LoadApp extends StatelessWidget {
  const LoadApp({super.key});

  Future<bool> showOnBoardPage() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool('welcomed') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: (showOnBoardPage()),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data) {
            return const OurAuth(isLogin: true);
          } else {
            return const OurOnBoardingPage();
          }
        } else {
          return const OurOnBoardingPage();
        }
      },
    );
  }
}
