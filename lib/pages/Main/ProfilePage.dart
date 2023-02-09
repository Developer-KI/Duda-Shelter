// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duda_shelter/pages/models/Dog.dart';
import 'package:duda_shelter/pages/models/Profile.dart';
import 'package:duda_shelter/utils/constants.dart';
import 'package:duda_shelter/widgets/our_pet_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OurEditProfilePage extends StatefulWidget {
  final Profile user;

  const OurEditProfilePage({
    super.key,
    required this.user,
  });

  @override
  State<OurEditProfilePage> createState() => _OurEditProfilePageState();
}

class _OurEditProfilePageState extends State<OurEditProfilePage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    countryController.dispose();
    cityController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    firstNameController.text = widget.user.firstName;
    lastNameController.text = widget.user.lastName;
    phoneController.text = widget.user.phone;
    countryController.text = widget.user.country;
    cityController.text = widget.user.city;

    super.initState();
  }

  Future updateUser() async {
    final navigator = Navigator.of(context);
    var sharedPreferences = await SharedPreferences.getInstance();

    await FirebaseFirestore.instance
        .collection("userDetails")
        .doc(sharedPreferences.getString("profileId"))
        .update({
      'firstName': firstNameController.text.trim(),
      'lastName': lastNameController.text.trim(),
      'phone': phoneController.text.trim(),
      'country': countryController.text.trim(),
      'city': cityController.text.trim(),
    });

    sharedPreferences.setString("firstName", firstNameController.text.trim());
    sharedPreferences.setString("lastName", lastNameController.text.trim());
    sharedPreferences.setString("phone", phoneController.text.trim());
    sharedPreferences.setString("country", countryController.text.trim());
    sharedPreferences.setString("city", cityController.text.trim());

    sharedPreferences.reload();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Saved the changes!"),
      ),
    );

    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            FontAwesomeIcons.arrowLeft,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.transparent,
                height: 100,
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
                height: 100,
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
                height: 100,
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
                height: 100,
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
                  validator: (country) => country != null && country.length < 2
                      ? "Your country should be at least 2 letters"
                      : null,
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 100,
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
                onTap: updateUser,
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.08,
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
                    "Save Changes",
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
    );
  }
}

class OurProfilePage extends StatefulWidget {
  const OurProfilePage({
    super.key,
  });

  @override
  State<OurProfilePage> createState() => _OurProfilePageState();
}

class _OurProfilePageState extends State<OurProfilePage> {
  bool isLoading = false;
  Profile userInfo = Profile(
    firstName: "Loading...",
    lastName: "Loading...",
    phone: "Loading...",
    email: "Loading...",
    country: "Loading...",
    city: "Loading...",
  );

  Future<Profile> getUserAndPets() async {
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

  SliverList _getSlivers(List myList, BuildContext context) {
    if (likedPets.isEmpty && !isLoading) getPets();

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return OurPetWidget(
            petData: likedPets[index],
          );
        },
        childCount: myList.length,
      ),
    );
  }

  void getPets() async {
    isLoading = true;
    var sharedPreferences = await SharedPreferences.getInstance();
    final queryLiked = await FirebaseFirestore.instance
        .collection(
            'userDetails/${sharedPreferences.getString("profileId")}/likedPets')
        .get();

    final queryAll = await FirebaseFirestore.instance.collection('dogs').get();

    for (var like in queryLiked.docs) {
      bool isThere = false;
      for (var doc in queryAll.docs) {
        if (doc.reference.id == like.get('referanceId')) {
          isThere = true;
        }
      }
      if (isThere) {
        if (!likedPets.any((element) => element.dogId == like.reference.id)) {
          likedPets.add(Pet(
              dogId: like.get('referanceId'),
              name: like.get('name'),
              gender: like.get('gender'),
              race: like.get('race'),
              size: like.get('size'),
              age: like.get('age'),
              bio: like.get('bio'),
              ownerName: like.get('ownerName'),
              ownerEmail: like.get('ownerEmail'),
              ownerLocation:
                  "${like.get('ownerCountry')}, ${like.get('ownerCity')}",
              imageURL: like.get('imageURL')));
        }
      } else {
        FirebaseFirestore.instance
            .collection(
                'userDetails/${sharedPreferences.getString("profileId")}/likedPets')
            .doc(like.id)
            .delete();
      }
    }
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeigth = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureBuilder<Profile>(
        future: getUserAndPets(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  pinned: true,
                  elevation: 2,
                  forceElevated: true,
                  backgroundColor: Colors.white,
                  leading: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      FontAwesomeIcons.arrowLeft,
                      color: Colors.black,
                    ),
                  ),
                  centerTitle: true,
                  expandedHeight: deviceHeigth * 0.4,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: const Text(
                      "My Liked Pets",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    background: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              35, deviceHeigth * 0.05, 0, 0),
                          child: const Text(
                            "My Profile",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
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
                          padding: EdgeInsets.fromLTRB(
                              35, 0, 35, deviceHeigth * 0.05),
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
                    ),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OurEditProfilePage(
                            user: snapshot.data,
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
                _getSlivers(likedPets, context),
              ],
            );
          } else {
            return Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: const Text(
                "Error. Restart App and Check Internet Connection!",
                textAlign: TextAlign.center,
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
