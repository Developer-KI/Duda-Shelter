// ignore_for_file: file_names

import 'package:duda_shelter/pages/Auth/authPage.dart';
import 'package:duda_shelter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OurOnBoardingPage extends StatelessWidget {
  const OurOnBoardingPage({super.key});

  Widget buildImage(String path) => Container(
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            path,
          ),
        ),
      );

  DotsDecorator getDotsDecorator() {
    return const DotsDecorator(
      spacing: EdgeInsets.symmetric(horizontal: 5),
      activeColor: ourPrimaryColor,
      color: Colors.grey,
      size: Size(12, 12),
      activeSize: Size(20, 12),
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: IntroductionScreen(
          pages: [
            PageViewModel(
              title: "Welcome to \nDuda Shelter!",
              body: "",
              image: buildImage("lib/assets/onBoard_3.png"),
              decoration: const PageDecoration(
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                imagePadding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                imageFlex: 2,
                bodyFlex: 0,
                footerFlex: 0,
              ),
            ),
            PageViewModel(
              title: "Endless Dogs",
              body: "The place where you will find your new best friend",
              image: buildImage("lib/assets/onBoard_5.png"),
              decoration: const PageDecoration(
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                bodyTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
                imagePadding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                bodyPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                imageFlex: 2,
                bodyFlex: 1,
                footerFlex: 0,
              ),
            ),
            PageViewModel(
              title: "What are you waiting for?",
              body:
                  "Start today by creating a free account or sign in if you already have one!",
              image: buildImage("lib/assets/onBoard_4.png"),
              footer: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () async {
                        final navigator = Navigator.of(context);
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool('welcomed', true);

                        navigator.pushReplacement(
                          MaterialPageRoute(
                            builder: ((context) =>
                                const OurAuth(isLogin: true)),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                          color: ourPrimaryColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: ourPrimaryColor,
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        final navigator = Navigator.of(context);
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool('welcomed', true);

                        navigator.pushReplacement(
                          MaterialPageRoute(
                            builder: ((context) =>
                                const OurAuth(isLogin: false)),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                          color: ourPrimaryColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: ourPrimaryColor,
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ]),
              decoration: const PageDecoration(
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                bodyTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
                imagePadding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                bodyPadding: EdgeInsets.symmetric(horizontal: 40),
                imageFlex: 6,
                bodyFlex: 3,
                footerFlex: 3,
              ),
            )
          ],
          onDone: () {},
          isProgressTap: false,
          scrollPhysics: const ClampingScrollPhysics(),
          showDoneButton: false,
          showNextButton: true,
          showSkipButton: true,
          isBottomSafeArea: true,
          skip: const Text(
            "Skip",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          next: const Icon(
            Icons.arrow_forward,
            color: Colors.black,
            size: 28,
          ),
          done: const Text(
            "Done",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          dotsDecorator: getDotsDecorator(),
        ),
      ),
    );
  }
}
