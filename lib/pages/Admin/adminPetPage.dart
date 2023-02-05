// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duda_shelter/pages/models/Dog.dart';
import 'package:duda_shelter/pages/models/Profile.dart';
import 'package:duda_shelter/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OurAdminPetPage extends StatefulWidget {
  final Pet selectedPet;

  const OurAdminPetPage({
    super.key,
    required this.selectedPet,
  });

  @override
  State<OurAdminPetPage> createState() => _OurAdminPetPageState();
}

class _OurAdminPetPageState extends State<OurAdminPetPage> {
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

  void removeSelectedPet() async {
    FirebaseFirestore.instance
        .collection("dogs")
        .doc(widget.selectedPet.dogId)
        .delete();

    FirebaseStorage.instance.refFromURL(widget.selectedPet.imageURL).delete();

    loadedPets.remove(widget.selectedPet);

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Dog Deleted!",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(
                                FontAwesomeIcons.arrowLeft,
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "You shared this pet with someone!"),
                                  ),
                                )
                              },
                              child: const Icon(
                                FontAwesomeIcons.arrowUpFromBracket,
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
                              Expanded(
                                child: GestureDetector(
                                  onTap: removeSelectedPet,
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.red[700],
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.5),
                                          spreadRadius: 0,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Delete",
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
