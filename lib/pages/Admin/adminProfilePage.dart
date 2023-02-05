// ignore_for_file: file_names

import 'package:duda_shelter/pages/Main/ProfilePage.dart';
import 'package:duda_shelter/pages/models/Profile.dart';
import 'package:duda_shelter/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OurAdminProfilePage extends StatefulWidget {
  const OurAdminProfilePage({super.key});

  @override
  State<OurAdminProfilePage> createState() => _OurAdminProfilePageState();
}

class _OurAdminProfilePageState extends State<OurAdminProfilePage> {
  Profile userInfo = Profile(
    firstName: "Loading...",
    lastName: "Loading...",
    phone: "Loading...",
    email: "Loading...",
    country: "Loading...",
    city: "Loading...",
  );

  Future<Profile> getUser() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.reload();

    setState(() {
      userInfo = Profile(
        firstName: sharedPreferences.getString('firstName') ?? 'Error',
        lastName: sharedPreferences.getString('lastName') ?? 'Error',
        email: FirebaseAuth.instance.currentUser?.email ?? 'Error',
        phone: sharedPreferences.getString('phone') ?? 'Error',
        country: sharedPreferences.getString('country') ?? 'Error',
        city: sharedPreferences.getString('city') ?? 'Error',
      );
    });

    return userInfo;
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeigth = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            FontAwesomeIcons.arrowLeft,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "My Admin Profile",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OurEditProfilePage(
                  user: userInfo,
                ),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                FontAwesomeIcons.userPen,
                color: Colors.black,
                size: 20,
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder<Profile>(
        future: getUser(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Name: ",
                        style: TextStyle(
                            color: ourPrimaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "${userInfo.firstName} ${userInfo.lastName}",
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Phone: ",
                        style: TextStyle(
                            color: ourPrimaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        userInfo.phone,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "E-mail: ",
                        style: TextStyle(
                            color: ourPrimaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        userInfo.email,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.fromLTRB(35, 0, 35, deviceHeigth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Location: ",
                        style: TextStyle(
                            color: ourPrimaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "${userInfo.city}, ${userInfo.country}",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Container(
              alignment: Alignment.center,
              child: const Text(
                "Error. Restart App and Check Internet Connection!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
