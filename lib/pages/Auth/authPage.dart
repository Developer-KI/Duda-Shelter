// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duda_shelter/ourMainPage.dart';
import 'package:duda_shelter/pages/Admin/ourAdminMainPage.dart';
import 'package:duda_shelter/pages/Auth/LoginPage.dart';
import 'package:duda_shelter/pages/Auth/RegisterPage.dart';
import 'package:duda_shelter/pages/models/Profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInOrRegister extends StatefulWidget {
  final bool logging;
  final bool error;

  const LogInOrRegister({
    super.key,
    required this.logging,
    required this.error,
  });

  @override
  State<LogInOrRegister> createState() => _LogInOrRegisterState();
}

class _LogInOrRegisterState extends State<LogInOrRegister> {
  late bool isLogin;

  @override
  void initState() {
    super.initState();

    isLogin = widget.logging;
    if (widget.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Couldn't connect to server! Check your Internet connection.",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => isLogin
      ? OurLoginPage(onClickedSignUp: toggle)
      : OurSignUpPage(onClickedSignUp: toggle);

  void toggle() => setState(
        () {
          isLogin = !isLogin;
        },
      );
}

class OurAuth extends StatefulWidget {
  final bool isLogin;

  const OurAuth({
    super.key,
    required this.isLogin,
  });

  @override
  State<OurAuth> createState() => _OurAuthState();
}

class _OurAuthState extends State<OurAuth> {
  bool isAdmin = false;

  Future<Profile> currentUserFromFirestoreSave() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    final queryResult = await FirebaseFirestore.instance
        .collection('userDetails')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .limit(1)
        .get();

    sharedPreferences.reload();

    for (var doc in queryResult.docs) {
      sharedPreferences.setString("profileId", doc.reference.id);
      sharedPreferences.setString("firstName", doc.get('firstName'));
      sharedPreferences.setString("lastName", doc.get('lastName'));
      sharedPreferences.setString('email', doc.get('email'));
      sharedPreferences.setString("phone", doc.get('phone'));
      sharedPreferences.setString("country", doc.get('country'));
      sharedPreferences.setString("city", doc.get('city'));
      sharedPreferences.setBool('isAdmin', doc.get('isAdmin'));
    }

    sharedPreferences.reload();

    Profile load = Profile(
      firstName: sharedPreferences.getString('firstName') ?? 'Error',
      lastName: sharedPreferences.getString('lastName') ?? 'Error',
      email: FirebaseAuth.instance.currentUser?.email ?? 'Error',
      phone: sharedPreferences.getString('phone') ?? 'Error',
      country: sharedPreferences.getString('country') ?? 'Error',
      city: sharedPreferences.getString('city') ?? 'Error',
    );

    sharedPreferences.reload();

    isAdmin = sharedPreferences.getBool('isAdmin') ?? false;

    return load;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder(
            future: currentUserFromFirestoreSave(),
            builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return LogInOrRegister(
                    logging: widget.isLogin,
                    error: true,
                  );
                case ConnectionState.done:
                default:
                  if (isAdmin) {
                    return const OurAdminMainPage();
                  } else {
                    return const OurMainPage();
                  }
              }
            },
          );
        } else {
          return LogInOrRegister(
            logging: widget.isLogin,
            error: false,
          );
        }
      },
    );
  }
}
