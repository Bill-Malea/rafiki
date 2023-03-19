// ignore: file_names
class Therapist {
  final String id;
  final String name;
  final String phone;
  final String county;
  final String rating;
  final String gender;
  final String price;
  String specialties;
  String description;

  Therapist({
   required this.specialties,
  required  this.description, 
    required this.id,
    required this.name,
    required this.phone,
    required this.county,
    required this.rating,
    required this.gender,
    required this.price,
  });
}
