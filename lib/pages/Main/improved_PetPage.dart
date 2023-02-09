// ignore_for_file: file_names

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duda_shelter/pages/models/Dog.dart';
import 'package:duda_shelter/pages/models/Profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:duda_shelter/utils/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OurPetPage extends StatefulWidget {
  final Pet selectedPet;

  const OurPetPage({
    super.key,
    required this.selectedPet,
  });

  @override
  State<OurPetPage> createState() => _OurPetPageState();
}

class _OurPetPageState extends State<OurPetPage> {
  bool sentEmail = false;

  Future<Profile> getUser() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.reload();

    return Profile(
      firstName: sharedPreferences.getString('firstName') ?? 'Error',
      lastName: sharedPreferences.getString('lastName') ?? 'Error',
      email: FirebaseAuth.instance.currentUser?.email ?? 'Error',
      phone: sharedPreferences.getString('phone') ?? 'Error',
      country: sharedPreferences.getString('country') ?? 'Error',
      city: sharedPreferences.getString('city') ?? 'Error',
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: FutureBuilder<Profile>(
        future: getUser(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: deviceHeight * 0.6,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color.fromRGBO(152, 163, 168, 1),
                              Color.fromRGBO(198, 209, 214, 1)
                            ]),
                      ),
                    ),
                    Container(
                      height: deviceHeight * 0.4,
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(240, 236, 236, 1)),
                    ),
                  ],
                ),
                Positioned(
                  width: deviceWidth,
                  height: deviceHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: deviceHeight * 0.04),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        height: deviceHeight * 0.05,
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(
                                FontAwesomeIcons.arrowLeft,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.35,
                        width: deviceWidth * 0.65,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            widget.selectedPet.imageURL,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: deviceHeight * 0.01),
                      Container(
                        height: deviceHeight * 0.15,
                        width: deviceWidth * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 5), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.selectedPet.name,
                                    style: TextStyle(
                                      color: Colors.grey[900],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                  Icon(
                                    widget.selectedPet.gender
                                        ? FontAwesomeIcons.mars
                                        : FontAwesomeIcons.venus,
                                    color: Colors.grey[500],
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.selectedPet.race,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "${widget.selectedPet.age} years old",
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.locationDot,
                                    color: ourPrimaryColor,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 7.5),
                                  Text(
                                    widget.selectedPet.ownerLocation,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: deviceHeight * 0.01),
                      Container(
                        width: deviceWidth * 0.9,
                        height: deviceHeight * 0.20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 5), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Text(
                            widget.selectedPet.bio,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: deviceHeight * 0.10,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(171, 182, 186, 0.2),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  var sharedPrefs =
                                      await SharedPreferences.getInstance();

                                  if (!widget.selectedPet.isLiked) {
                                    await FirebaseFirestore.instance
                                        .collection(
                                            "userDetails/${sharedPrefs.getString("profileId")}/likedPets")
                                        .add(
                                      {
                                        'referanceId': widget.selectedPet.dogId,
                                        'age': widget.selectedPet.age,
                                        'name': widget.selectedPet.name,
                                        'race': widget.selectedPet.race,
                                        'bio': widget.selectedPet.bio,
                                        'gender': widget.selectedPet.gender,
                                        'size': widget.selectedPet.size,
                                        'ownerName':
                                            widget.selectedPet.ownerName,
                                        'ownerEmail':
                                            widget.selectedPet.ownerEmail,
                                        'ownerCountry': widget
                                            .selectedPet.ownerLocation
                                            .split(",")
                                            .first
                                            .trim(),
                                        'ownerCity': widget
                                            .selectedPet.ownerLocation
                                            .split(",")
                                            .last
                                            .trim(),
                                        'imageURL': widget.selectedPet.imageURL,
                                      },
                                    );

                                    setState(() {
                                      widget.selectedPet.isLiked = true;
                                    });

                                    likedPets.add(widget.selectedPet);
                                  } else {
                                    var pet = await FirebaseFirestore.instance
                                        .collection(
                                            "userDetails/${sharedPrefs.getString("profileId")}/likedPets")
                                        .where('referanceId',
                                            isEqualTo: widget.selectedPet.dogId)
                                        .get();

                                    for (var doc in pet.docs) {
                                      doc.reference.delete();
                                    }

                                    likedPets.remove(widget.selectedPet);

                                    setState(() {
                                      widget.selectedPet.isLiked = false;
                                    });
                                  }
                                },
                                child: Container(
                                  height: 100,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: ourPrimaryColor,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 0,
                                        blurRadius: 7,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    widget.selectedPet.isLiked
                                        ? FontAwesomeIcons.solidHeart
                                        : FontAwesomeIcons.heart,
                                    size: 18,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: deviceWidth * 0.1,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    if (!sentEmail) {
                                      var sharedPreferences =
                                          await SharedPreferences.getInstance();

                                      final userName =
                                          "${sharedPreferences.getString('firstName')} ${sharedPreferences.getString('lastName')}";
                                      final userEmail =
                                          sharedPreferences.getString("email");
                                      final userPhone =
                                          sharedPreferences.getString("phone");
                                      final userLocation =
                                          "${sharedPreferences.getString("city")}, ${sharedPreferences.getString("country")}";

                                      const serviceId = 'service_h7fvcht';
                                      const templateId = 'template_kqqostf';
                                      const publicKey = 'hR3LKlgSIE6Oce0jC';

                                      final url = Uri.parse(
                                          'https://api.emailjs.com/api/v1.0/email/send');

                                      await http.post(
                                        url,
                                        headers: {
                                          'Content-Type': 'application/json',
                                        },
                                        body: jsonEncode({
                                          'service_id': serviceId,
                                          'template_id': templateId,
                                          'user_id': publicKey,
                                          'template_params': {
                                            'user_name': userName,
                                            'user_email': userEmail,
                                            'user_phone': userPhone,
                                            'user_location': userLocation,
                                            'dog_name':
                                                "${widget.selectedPet.name}, age: ${widget.selectedPet.age}, size: ${widget.selectedPet.size}",
                                            'owner_name':
                                                widget.selectedPet.ownerName,
                                            'owner_email':
                                                widget.selectedPet.ownerEmail,
                                          }
                                        }),
                                      );

                                      sentEmail = true;

                                      if (!mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Adoption Request Sent! Make sure to check your e-mail for updates!"),
                                        ),
                                      );
                                    } else {
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "The request has already been sent!"),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: ourPrimaryColor,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          spreadRadius: 0,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Adoption",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
