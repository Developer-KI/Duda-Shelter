// ignore_for_file: file_names

import 'package:duda_shelter/pages/Auth/forgotPassword.dart';
import 'package:duda_shelter/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class OurLoginPage extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const OurLoginPage({
    super.key,
    required this.onClickedSignUp,
  });

  @override
  State<OurLoginPage> createState() => _OurLoginPageState();
}

class _OurLoginPageState extends State<OurLoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future signIn() async {
    final navigator = Navigator.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.message!,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            alignment: const Alignment(0, -0.75),
            height: deviceHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.topCenter,
                colors: [
                  Colors.teal.shade700,
                  ourPrimaryColor,
                ],
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              height: deviceHeight * 0.2,
              width: deviceWidth * 0.8,
              color: Colors.transparent,
              child: const Text(
                "D U D A\n    S H E L T E R",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Positioned(
            width: deviceWidth,
            height: deviceHeight * 0.6,
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 40, 30, 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome back!",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextField(
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    autocorrect: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.teal,
                        ),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      labelText: "E-mail",
                      labelStyle: TextStyle(
                        color: Colors.grey[700],
                      ),
                      hintText: "Email@example.com",
                      hintStyle: TextStyle(
                        color: Colors.grey[700],
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                        onPressed: () => emailController.clear(),
                      ),
                    ),
                  ),
                  TextField(
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    controller: passwordController,
                    textInputAction: TextInputAction.done,
                    autocorrect: false,
                    obscureText: isPasswordVisible,
                    decoration: InputDecoration(
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.teal,
                        ),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      labelText: "Password",
                      labelStyle: TextStyle(
                        color: Colors.grey[700],
                      ),
                      hintText: "Your Password",
                      hintStyle: TextStyle(
                        color: Colors.grey[700],
                      ),
                      suffixIcon: IconButton(
                        icon: isPasswordVisible
                            ? const Icon(
                                Icons.visibility_off,
                                color: Colors.black,
                              )
                            : const Icon(
                                Icons.visibility,
                                color: Colors.black,
                              ),
                        onPressed: (() => setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            })),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const OurForgotPassowrd())),
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.teal),
                    ),
                  ),
                  GestureDetector(
                    onTap: signIn,
                    child: Container(
                      alignment: Alignment.center,
                      width: deviceWidth,
                      height: deviceHeight * 0.08,
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
                        "Sign in",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          height: deviceHeight * 0.08,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ourPrimaryColor,
                              width: 3,
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: ourPrimaryColor,
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Sign in with",
                                style: TextStyle(
                                  color: ourPrimaryColor,
                                ),
                              ),
                              SizedBox(width: 7.5),
                              Icon(
                                FontAwesomeIcons.google,
                                color: ourPrimaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          height: deviceHeight * 0.08,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ourPrimaryColor,
                              width: 3,
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: ourPrimaryColor,
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Sign in with",
                                style: TextStyle(
                                  color: ourPrimaryColor,
                                ),
                              ),
                              SizedBox(width: 7.5),
                              Icon(
                                FontAwesomeIcons.apple,
                                color: ourPrimaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),*/
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        text: "Don't have an account already? ",
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onClickedSignUp,
                            text: "Sign Up",
                            style: const TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.teal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
