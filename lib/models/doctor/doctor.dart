import 'package:flutter/material.dart';
import 'package:med_connect_admin/models/admin.dart';
import 'package:med_connect_admin/models/doctor/experience.dart';
import 'package:med_connect_admin/models/review.dart';

class Doctor extends Admin {
  String? firstName;
  String? surname;
  String? mainSpecialty;
  List<String>? otherSpecialties;
  List<Experience>? experiences;
  List<Review>? reviews;
  String? bio;
  Experience? currentLocation;
  List<String>? services;
  String? phone;
  String? licenseId;
  bool? isVerified;

  Doctor({
    id,
    this.firstName,
    this.surname,
    this.bio,
    this.mainSpecialty,
    this.otherSpecialties,
    this.experiences,
    this.services,
    this.currentLocation,
    this.reviews,
    this.phone,
    this.licenseId,
    this.isVerified,
  });

  @override
  Doctor fromFirestore(Map<String, dynamic> map, String aId) {
    id = aId;
    firstName = map['firstName'] as String?;
    surname = map['surname'] as String?;
    bio = map['bio'] as String?;

    mainSpecialty = map['mainSpecialty'] as String?;

    otherSpecialties = (map['otherSpecialties'] as List<dynamic>?)!
        .map((e) => e.toString())
        .toList();

    List? tempList = map['experiences'] as List<dynamic>?;
    if (tempList != null) {
      experiences = [];
      for (Map<String, dynamic> element in tempList) {
        experiences!.add(Experience.fromFirestore(element));
      }
    }

    services =
        (map['services'] as List<dynamic>?)!.map((e) => e.toString()).toList();

    currentLocation = Experience.fromFirestore(
        map['currentLocation'] as Map<String, dynamic>);

    tempList = map['reviews'] as List<Map<String, dynamic>>?;
    if (tempList != null) {
      reviews = [];
      for (Map<String, dynamic> element in tempList) {
        reviews!.add(Review.fromFirestore(element));
      }
    }

    phone = map['phone'];

    licenseId = map['licenseId'];

    isVerified = map['isVerified'];

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'surname': surname,
      'bio': bio,
      'mainSpecialty': mainSpecialty,
      'otherSpecialties': otherSpecialties,
      if (experiences != null)
        'experiences': experiences!.map((e) => e.toMap()).toList(),
      'services': services,
      if (currentLocation != null) 'currentLocation': currentLocation!.toMap(),
      'reviews': reviews,
      'phone': phone,
      'licenseId': licenseId,
      'isVerified': isVerified,
      'adminRole': 'doctor'
    };
  }

  String get name => '$firstName $surname';

  @override
  bool operator ==(other) =>
      other is Doctor &&
      name == other.name &&
      bio == other.bio &&
      mainSpecialty == other.mainSpecialty &&
      otherSpecialties == other.otherSpecialties &&
      experiences == other.experiences &&
      services == other.services &&
      currentLocation == other.currentLocation &&
      phone == other.phone &&
      licenseId == other.licenseId;

  @override
  int get hashCode => Object.hash(
      name,
      bio,
      mainSpecialty,
      Object.hashAll(otherSpecialties!.map((e) => e)),
      Object.hashAll(experiences!.map((e) => e)),
      Object.hashAll(services!.map((e) => e)),
      currentLocation,
      phone,
      licenseId);
}
