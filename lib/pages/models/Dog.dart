// ignore_for_file: file_names

class Pet {
  final String dogId;
  final String name;
  final bool gender;
  final String race;
  final String size;
  final int age;
  final String bio;
  bool isLiked = false;
  final String ownerName;
  final String ownerEmail;
  final String ownerLocation;
  final String imageURL;

  Pet({
    required this.dogId,
    required this.name,
    required this.gender,
    required this.race,
    required this.size,
    required this.age,
    required this.bio,
    required this.ownerName,
    required this.ownerEmail,
    required this.ownerLocation,
    required this.imageURL,
  });
}
