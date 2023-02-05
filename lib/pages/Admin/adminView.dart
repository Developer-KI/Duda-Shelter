// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duda_shelter/pages/Admin/adminProfilePage.dart';
import 'package:duda_shelter/pages/models/Dog.dart';
import 'package:duda_shelter/utils/constants.dart';
import 'package:duda_shelter/widgets/our_drawer_widget.dart';
import 'package:duda_shelter/widgets/our_pet_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OurAdminViewPage extends StatefulWidget {
  final VoidCallback openDrawer;

  const OurAdminViewPage({
    super.key,
    required this.openDrawer,
  });

  @override
  State<OurAdminViewPage> createState() => _OurAdminViewPageState();
}

class _OurAdminViewPageState extends State<OurAdminViewPage> {
  final query = FirebaseFirestore.instance
      .collection("dogs")
      .where('ownerEmail', isEqualTo: FirebaseAuth.instance.currentUser?.email)
      .orderBy('name');

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
      body: FirestoreListView(
        query: query,
        pageSize: 5,
        itemBuilder:
            (BuildContext context, QueryDocumentSnapshot<dynamic> snapshot) {
          return OurPetWidget(
            petData: Pet(
              dogId: snapshot.reference.id,
              name: snapshot.get("name"),
              gender: snapshot.get("gender"),
              race: snapshot.get("race"),
              size: snapshot.get("size"),
              age: snapshot.get("age"),
              bio: snapshot.get("bio"),
              ownerName: snapshot.get("ownerName"),
              ownerEmail: snapshot.get("ownerEmail"),
              ownerLocation:
                  "${snapshot.get("ownerCountry")}, ${snapshot.get("ownerCity")}",
              imageURL: snapshot.get("imageURL"),
            ),
          );
        },
      ),
    );
  }
}
