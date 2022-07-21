
import 'package:med_connect_admin/models/experience.dart';
import 'package:med_connect_admin/models/review.dart';

class Doctor {
  String? id;
  String? name;
  String? mainSpecialty;
  List<String>? otherSpecialties;
  List<Experience>? experiences;
  List<Review>? reviews;
  String? bio;
  String? currentLocation;
  List<String>? services;

  Doctor(
      {this.id,
      this.name,
      this.mainSpecialty,
      this.otherSpecialties,
      this.experiences,
      this.reviews,
      this.bio,
      this.currentLocation,
      this.services});

  Doctor.fromFireStore(Map<String, dynamic> map, String dId) {
    id = dId;
    name = map['name'] as String?;
    mainSpecialty = map['mainSpecialty'] as String?;
    
    otherSpecialties = [];
    experiences = (map['experiences'] as List<dynamic>?)!
        .map((e) => Experience.fromFirestore(e))
        .toList();
    reviews = (map['reviews'] as List<dynamic>?)!
        .map((e) => Review.fromFirestore(e))
        .toList();
    bio = map['bio'] as String?;
    currentLocation = map['currentLocation'] as String?;
    services =
        (map['services'] as List<dynamic>?)!.map((e) => e.toString()).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mainSpecialty': mainSpecialty,
      'otherSpecialties': otherSpecialties,
      'experiences': experiences,
      'reviews': reviews,
      'bio': bio,
      'currentLocation': currentLocation,
      'services': services,
    };
  }
}
