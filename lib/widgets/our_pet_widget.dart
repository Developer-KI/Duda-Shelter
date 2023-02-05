import 'package:duda_shelter/pages/Admin/adminPetPage.dart';
import 'package:duda_shelter/pages/Main/improved_PetPage.dart';
import 'package:duda_shelter/pages/models/Dog.dart';
import 'package:duda_shelter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OurPetWidget extends StatelessWidget {
  final Pet petData;

  const OurPetWidget({
    super.key,
    required this.petData,
  });

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    bool isAdmin = false;

    return GestureDetector(
      onTap: () async {
        final navigator = Navigator.of(context);
        var prefs = await SharedPreferences.getInstance();
        isAdmin = prefs.getBool('isAdmin') ?? false;

        if (likedPets.any((element) => element.dogId == petData.dogId)) {
          petData.isLiked = true;
        } else {
          petData.isLiked = false;
        }

        if (isAdmin) {
          navigator.push(
            MaterialPageRoute(
              builder: (context) => OurAdminPetPage(
                selectedPet: petData,
              ),
            ),
          );
        } else {
          navigator.push(
            MaterialPageRoute(
              builder: (context) => OurPetPage(
                selectedPet: petData,
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        height: 250,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 250,
                  width: deviceWidth * 0.45,
                  color: const Color.fromRGBO(228, 193, 141, 1),
                  child: Image.network(
                    petData.imageURL,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: deviceWidth * 0.45,
                height: 175,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            petData.name,
                            style: TextStyle(
                              color: Colors.grey[900],
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          Icon(
                            petData.gender
                                ? FontAwesomeIcons.mars
                                : FontAwesomeIcons.venus,
                            color: Colors.grey[500],
                          )
                        ],
                      ),
                      Text(
                        petData.race,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        petData.age == 1
                            ? "${petData.age} year old"
                            : "${petData.age} year old",
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
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
                            petData.ownerLocation.split(",").first.trim(),
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
            ],
          ),
        ),
      ),
    );
  }
}
