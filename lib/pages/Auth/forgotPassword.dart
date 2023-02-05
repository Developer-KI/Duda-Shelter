// ignore_for_file: file_names

import 'package:duda_shelter/utils/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OurForgotPassowrd extends StatefulWidget {
  const OurForgotPassowrd({super.key});

  @override
  State<OurForgotPassowrd> createState() => _OurForgotPassowrdState();
}

class _OurForgotPassowrdState extends State<OurForgotPassowrd> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  Future resetPassword() async {
    final navigator = Navigator.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Sent recovery e-mail to ${emailController.text.trim()}",
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.green,
        ),
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
      backgroundColor: Colors.black,
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
            height: deviceHeight * 0.4,
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Recover Account",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Column(
                    children: [
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        controller: emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? "Enter a valid email"
                                : null,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        keyboardType: TextInputType.emailAddress,
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
                          labelText: "Your e-mail",
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
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: resetPassword,
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
                            "Reset password",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: (() {
                          Navigator.of(context).pop();
                        }),
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
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
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
