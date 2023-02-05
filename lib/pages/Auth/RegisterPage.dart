// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duda_shelter/utils/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class OurSignUpPage extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const OurSignUpPage({
    super.key,
    required this.onClickedSignUp,
  });

  @override
  State<OurSignUpPage> createState() => _OurSignUpPageState();
}

class _OurSignUpPageState extends State<OurSignUpPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  bool isPasswordVisible = false;
  bool isCreatingAccount = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    countryController.dispose();
    cityController.dispose();

    super.dispose();
  }

  void signUp() {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (confirmPasswordController.text.trim() ==
        passwordController.text.trim()) {
      setState(() {
        isCreatingAccount = true;
      });
    }
    Navigator.of(context).pop();
  }

  Future finish() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      await FirebaseFirestore.instance.collection("userDetails").add({
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'phone': phoneController.text.trim(),
        'email': emailController.text.trim(),
        'country': countryController.text.trim(),
        'city': cityController.text.trim(),
        'isAdmin': false,
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        isCreatingAccount = false;
      });

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
  }

  Widget buildUserDetails() {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(alignment: Alignment.bottomCenter, children: [
        Container(
          alignment: const Alignment(0, -0.95),
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
          height: deviceHeight * 0.8,
          child: Container(
            padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Fill In Details",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      color: Colors.transparent,
                      height: 75,
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        controller: firstNameController,
                        keyboardType: TextInputType.name,
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
                          labelText: "First Name",
                          labelStyle: TextStyle(
                            color: Colors.grey[700],
                          ),
                          hintText: "ex: Jhon",
                          hintStyle: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (firstName) =>
                            firstName != null && firstName.length < 3
                                ? "Your first name should be at least 3 letters"
                                : null,
                      ),
                    ),
                    Container(
                      color: Colors.transparent,
                      height: 75,
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        controller: lastNameController,
                        keyboardType: TextInputType.name,
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
                          labelText: "Last Name",
                          labelStyle: TextStyle(
                            color: Colors.grey[700],
                          ),
                          hintText: "ex: Doe",
                          hintStyle: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (lastName) =>
                            lastName != null && lastName.length < 3
                                ? "Your last name should be at least 3 letters"
                                : null,
                      ),
                    ),
                    Container(
                      color: Colors.transparent,
                      height: 75,
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
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
                          labelText: "Phone Number",
                          labelStyle: TextStyle(
                            color: Colors.grey[700],
                          ),
                          hintText: "ex: 0881234567",
                          hintStyle: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (phone) => phone != null && phone.length < 10
                            ? "Your phone have at least 10 characters"
                            : null,
                      ),
                    ),
                    Container(
                      color: Colors.transparent,
                      height: 75,
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        controller: countryController,
                        keyboardType: TextInputType.text,
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
                          labelText: "Country",
                          labelStyle: TextStyle(
                            color: Colors.grey[700],
                          ),
                          hintText: "ex: Bulgaria",
                          hintStyle: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (country) =>
                            country != null && country.length < 2
                                ? "Your country should be at least 2 letters"
                                : null,
                      ),
                    ),
                    Container(
                      color: Colors.transparent,
                      height: 75,
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        controller: cityController,
                        keyboardType: TextInputType.text,
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
                          labelText: "City",
                          labelStyle: TextStyle(
                            color: Colors.grey[700],
                          ),
                          hintText: "ex: Stara Zagora",
                          hintStyle: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (city) => city != null && city.length < 2
                            ? "Your city name should be at least 2 letters"
                            : null,
                      ),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: finish,
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
                          "Finish",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return isCreatingAccount
        ? buildUserDetails()
        : Scaffold(
            body: Stack(alignment: Alignment.bottomCenter, children: [
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
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Create account",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 35,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextFormField(
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (email) =>
                              email != null && !EmailValidator.validate(email)
                                  ? "Enter a valid email"
                                  : null,
                        ),
                        TextFormField(
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
                                      Icons.visibility,
                                      color: Colors.black,
                                    )
                                  : const Icon(
                                      Icons.visibility_off,
                                      color: Colors.black,
                                    ),
                              onPressed: (() => setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  })),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (password) =>
                              password != null && password.length < 6
                                  ? "Enter a min. of 6 characters"
                                  : null,
                        ),
                        TextFormField(
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          controller: confirmPasswordController,
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
                            labelText: "Confirm Password",
                            labelStyle: TextStyle(
                              color: Colors.grey[700],
                            ),
                            hintText: "Repeat Password",
                            hintStyle: TextStyle(
                              color: Colors.grey[700],
                            ),
                            suffixIcon: IconButton(
                              icon: isPasswordVisible
                                  ? const Icon(
                                      Icons.visibility,
                                      color: Colors.black,
                                    )
                                  : const Icon(
                                      Icons.visibility_off,
                                      color: Colors.black,
                                    ),
                              onPressed: (() => setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  })),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (password) =>
                              password != passwordController.text.trim()
                                  ? "Passwords don't match"
                                  : null,
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: signUp,
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
                                  "Sign up",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  text: "Already have an account? ",
                                  children: [
                                    TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = widget.onClickedSignUp,
                                      text: "Sign In",
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
                      ],
                    ),
                  ),
                ),
              )
            ]),
          );
  }
}
