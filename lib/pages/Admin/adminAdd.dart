// ignore_for_file: file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duda_shelter/pages/Admin/adminProfilePage.dart';
import 'package:duda_shelter/utils/constants.dart';
import 'package:duda_shelter/widgets/our_drawer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OurAdminAddPage extends StatefulWidget {
  final VoidCallback openDrawer;

  const OurAdminAddPage({
    super.key,
    required this.openDrawer,
  });

  @override
  State<OurAdminAddPage> createState() => _OurAdminAddPageState();
}

enum Size { mini, medium, maxi }

class _OurAdminAddPageState extends State<OurAdminAddPage> {
  // ignore: avoid_init_to_null
  File? imageFile = null;
  late Reference referenceImageToUpload;

  String imageURL = '';
  final nameTextController = TextEditingController();
  final ageTextController = TextEditingController();
  final raceTextController = TextEditingController();
  final bioTextController = TextEditingController();

  Size searchSize = Size.mini;
  bool searchGender = true;

  @override
  void dispose() {
    nameTextController.dispose();
    ageTextController.dispose();
    raceTextController.dispose();
    bioTextController.dispose();

    super.dispose();
  }

  void addDogToDatabase() async {
    late String size;

    switch (searchSize) {
      case Size.mini:
        size = "mini";
        break;
      case Size.medium:
        size = "medium";
        break;
      case Size.maxi:
        size = "maxi";
        break;
    }

    try {
      var prefs = await SharedPreferences.getInstance();
      String? ownerName =
          "${prefs.getString("firstName")} ${prefs.getString("lastName")}";
      String? ownerCountry = prefs.getString("country");
      String? ownerCity = prefs.getString("city");

      try {
        await referenceImageToUpload.putFile(imageFile!);
        imageURL = await referenceImageToUpload.getDownloadURL();
      } catch (error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Error!",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }

      if (imageURL.isEmpty ||
          nameTextController.text.isEmpty ||
          ageTextController.text.isEmpty ||
          raceTextController.text.isEmpty ||
          bioTextController.text.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Upload an image first by taping on the example image at the top of the page and selecting an already existing image in the storage or type in other missing data about your new dog!",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }

      await FirebaseFirestore.instance.collection("dogs").add({
        'name': nameTextController.text.trim(),
        'age': int.tryParse(ageTextController.text.trim()),
        'race': raceTextController.text.trim(),
        'bio': bioTextController.text.trim(),
        'gender': searchGender,
        'size': size,
        'ownerName': ownerName,
        'ownerEmail': FirebaseAuth.instance.currentUser?.email,
        'ownerCountry': ownerCountry,
        'ownerCity': ownerCity,
        'imageURL': imageURL,
      });

      setState(() {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Dog added successfully!",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.green,
          ),
        );
      });
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Error!",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget customRadioButtonSize(String text, Size type) {
    return GestureDetector(
      onTap: (() {
        setState(() {
          searchSize = type;
        });
      }),
      child: Container(
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: searchSize == type ? ourPrimaryColor : Colors.white,
          border: Border.all(
            color: ourPrimaryColor,
            width: searchSize == type ? 0 : 1.5,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: searchSize == type ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget customRadioButtonGender(String text, bool gender) {
    return GestureDetector(
      onTap: (() {
        setState(() {
          searchGender = gender;
        });
      }),
      child: Container(
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: searchGender == gender ? ourPrimaryColor : Colors.white,
          border: Border.all(
            color: ourPrimaryColor,
            width: searchGender == gender ? 0 : 1.5,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: searchGender == gender ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        leading: OurDrawerMenuWidget(
          onClicked: widget.openDrawer,
        ),
        centerTitle: true,
        title: const Text(
          "D U D A   S H E L T E R",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const OurAdminProfilePage(),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromRGBO(223, 190, 140, 1),
                    border: Border.all(color: Colors.black, width: 1.3)),
                child: const Icon(
                  FontAwesomeIcons.solidUser,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file = await imagePicker.pickImage(
                        source: ImageSource.gallery);
                    setState(() {
                      imageFile = File(file!.path);
                    });

                    String uniqueFileName =
                        DateTime.now().microsecondsSinceEpoch.toString();

                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceImageDir = referenceRoot.child("images");

                    referenceImageToUpload =
                        referenceImageDir.child(uniqueFileName);
                  },
                  child: Container(
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: imageFile != null
                          ? Image.file(
                              imageFile!,
                              fit: BoxFit.cover,
                            )
                          : const Icon(FontAwesomeIcons.camera),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: nameTextController,
                        keyboardType: TextInputType.name,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          counterStyle: const TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Name',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: ageTextController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          counterStyle: const TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Age',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: raceTextController,
                  keyboardType: TextInputType.name,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    counterStyle: const TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Breed',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: bioTextController,
                  minLines: 6,
                  maxLines: 6,
                  maxLength: 200,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    counterStyle: const TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText:
                        'Here write a short dog description containing no more than 200 characters',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: customRadioButtonSize("MINI", Size.mini),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: customRadioButtonSize("MEDIUM", Size.medium),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: customRadioButtonSize("MAXI", Size.maxi),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: customRadioButtonGender("MALE", true),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: customRadioButtonGender("FEMALE", false),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                GestureDetector(
                  onTap: addDogToDatabase,
                  child: Container(
                    height: 75,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ourPrimaryColor,
                      borderRadius: BorderRadius.circular(15),
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
                      "ADD TO DATABASE",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
