// ignore_for_file: depend_on_referenced_packages

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:duda_shelter/firebase_options.dart';
import 'package:duda_shelter/pages/Auth/authPage.dart';
import 'package:duda_shelter/pages/OnBoarding/onBoardPage.dart';
import 'package:duda_shelter/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey =
      'pk_test_51MYDhoHkiOfBM7yokKKbT6FY4NtfE79YK4DWRTPe4lLgx1QPP0o2NV2iACvJoZ87VctyA4yq0AZsuJJ6X1Bklwky00R6xZcJZ7';

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
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: ourPrimaryColor,
      nextScreen: const LoadApp(),
      splash: Image.asset(
        "lib/assets/logo.png",
        fit: BoxFit.cover,
      ),
      splashIconSize: 300,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.rightToLeft,
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