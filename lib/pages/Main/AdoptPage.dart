// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duda_shelter/pages/Main/ProfilePage.dart';
import 'package:duda_shelter/pages/models/Dog.dart';
import 'package:duda_shelter/utils/constants.dart';
import 'package:duda_shelter/widgets/our_drawer_widget.dart';
import 'package:duda_shelter/widgets/our_pet_widget.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum SearchSizeOptions { mini, medium, maxi }

class OurAdoptPage extends StatefulWidget {
  final VoidCallback openDrawer;

  const OurAdoptPage({
    super.key,
    required this.openDrawer,
  });

  @override
  State<OurAdoptPage> createState() => _OurAdoptPageState();
}

class _OurAdoptPageState extends State<OurAdoptPage> {
  dynamic query = FirebaseFirestore.instance.collection("dogs");
  final searchLocationController = TextEditingController();
  SearchSizeOptions searchSizeOption = SearchSizeOptions.medium;
  late String searchSize;
  bool isFiltered = false;

  void filterLoadedPets() async {
    setState(() {
      isFiltered = true;
    });

    switch (searchSizeOption) {
      case SearchSizeOptions.mini:
        searchSize = "mini";
        break;
      case SearchSizeOptions.medium:
        searchSize = "medium";
        break;
      case SearchSizeOptions.maxi:
        searchSize = "maxi";
        break;
    }

    if (isFiltered) {
      if (searchLocationController.text.isEmpty) {
        query = FirebaseFirestore.instance
            .collection("dogs")
            .where("size", isEqualTo: searchSize);
      } else {
        query = FirebaseFirestore.instance
            .collection("dogs")
            .where("size", isEqualTo: searchSize)
            .where("ownerCountry", isEqualTo: searchLocationController.text);
      }
    } else {
      query = FirebaseFirestore.instance.collection("dogs");
    }
  }

  Widget customRadioButton(String text, SearchSizeOptions type) {
    return GestureDetector(
      onTap: (() {
        setState(() {
          searchSizeOption = type;
        });
      }),
      child: Container(
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: searchSizeOption == type ? ourPrimaryColor : Colors.white,
          border: Border.all(
            color: ourPrimaryColor,
            width: searchSizeOption == type ? 0 : 1.5,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: searchSizeOption == type ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<List<String>> getCountries(String query) async {
    List<String> searchedContries = [];

    for (String country in countries) {
      country = country.toLowerCase();
      query = query.toLowerCase();

      if (country.contains(query)) {
        searchedContries.add(country.capitalize());
      }
    }

    return searchedContries;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 2,
            forceElevated: true,
            leading: OurDrawerMenuWidget(
              onClicked: widget.openDrawer,
            ),
            centerTitle: true,
            title: const Text(
              "D U D A   S H E L T E R",
              style: TextStyle(color: Colors.black),
            ),
            expandedHeight: 285,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: TypeAheadField<String>(
                      suggestionsBoxDecoration: SuggestionsBoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        hasScrollbar: false,
                        elevation: 10,
                        color: ourPrimaryColor,
                      ),
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: searchLocationController,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(color: Colors.black)),
                          hintText: "Find by country",
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                isFiltered = false;
                              });
                              query =
                                  FirebaseFirestore.instance.collection("dogs");

                              searchLocationController.clear();
                            },
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      suggestionsCallback: getCountries,
                      itemBuilder: ((context, String country) {
                        return ListTile(
                          title: Text(country),
                        );
                      }),
                      onSuggestionSelected: ((suggestion) {
                        searchLocationController.text = suggestion;
                      }),
                      noItemsFoundBuilder: (context) => Container(
                        height: 150,
                        alignment: Alignment.center,
                        child: const Text(
                          "No matching\ncountry found!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child:
                              customRadioButton("MINI", SearchSizeOptions.mini),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: customRadioButton(
                                "MEDIUM", SearchSizeOptions.medium)),
                        const SizedBox(width: 10),
                        Expanded(
                          child:
                              customRadioButton("MAXI", SearchSizeOptions.maxi),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: GestureDetector(
                      onTap: filterLoadedPets,
                      child: Container(
                        height: 75,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ourPrimaryColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: ourPrimaryColor,
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Text(
                          "Search",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const OurProfilePage(),
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
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 315,
              child: FirestoreListView(
                query: query,
                pageSize: 5,
                itemBuilder: (BuildContext context,
                    QueryDocumentSnapshot<dynamic> snapshot) {
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
            ),
          ),
        ],
      ),
    );
  }
}
