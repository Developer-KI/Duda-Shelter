// ignore_for_file: file_names

class Profile {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String country;
  final String city;
  bool isAdmin = false;

  Profile({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.country,
    required this.city,
  });
}
