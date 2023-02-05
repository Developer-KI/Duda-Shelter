// ignore_for_file: file_names

import 'package:duda_shelter/pages/models/Dog.dart';
import 'package:flutter/material.dart';
import 'package:duda_shelter/utils/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OurPetPageOld extends StatefulWidget {
  final Pet selectedPet;

  const OurPetPageOld({
    super.key,
    required this.selectedPet,
  });

  @override
  State<OurPetPageOld> createState() => _OurPetPageOldState();
}

class _OurPetPageOldState extends State<OurPetPageOld> {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: const Color.fromRGBO(185, 197, 203, 1),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            expandedHeight: deviceHeight * 0.45,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.transparent,
                alignment: const Alignment(0, 0.8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "lib/assets/dog_example.jpg",
                    fit: BoxFit.cover,
                    height: deviceHeight * 0.38,
                    width: deviceWidth * 0.65,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  height: deviceHeight * 0.1,
                  color: const Color.fromRGBO(185, 197, 203, 1),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  height: deviceHeight * 0.28,
                  color: const Color.fromRGBO(250, 250, 250, 1),
                  child: Column(
                    children: [
                      Container(
                        transform: Matrix4.translationValues(
                            0, -deviceHeight * 0.07, 0),
                        height: deviceHeight * 0.14,
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
                        width: deviceWidth * 0.90,
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
                      Expanded(
                        child: Container(
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20)),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          transform: Matrix4.translationValues(
                              0, -deviceHeight * 0.035, 0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              child: Text(
                                widget.selectedPet.bio,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(241, 241, 241, 1),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  height: deviceHeight * 0.14,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: () => {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("You liked this pet!")))
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: ourPrimaryColor,
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
                            margin: const EdgeInsets.fromLTRB(30, 25, 0, 25),
                            child: const Center(
                                child: Icon(
                              FontAwesomeIcons.heart,
                              color: Colors.white,
                            )),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        flex: 7,
                        child: GestureDetector(
                          onTap: () => ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Text(
                                      "You just started the adoption process!"))),
                          child: Container(
                            decoration: BoxDecoration(
                              color: ourPrimaryColor,
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
                            margin: const EdgeInsets.fromLTRB(0, 25, 30, 25),
                            child: const Center(
                              child: Text(
                                "Adoption",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
