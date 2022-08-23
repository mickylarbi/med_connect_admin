import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_connect_admin/models/experience.dart';
import 'package:med_connect_admin/models/review.dart';

class Doctor {
  String? id;
  String? firstName;
  String? surname;
  String? mainSpecialty;
  List<String>? otherSpecialties;
  List<Experience>? experiences;
  List<Review>? reviews;
  String? bio;
  Experience? currentLocation;
  List<String>? services;

  Doctor({
    this.id,
    this.firstName,
    this.surname,
    this.bio,
    this.mainSpecialty,
    this.otherSpecialties,
    this.experiences,
    this.services,
    this.currentLocation,
    this.reviews,
  });

  Doctor.fromFireStore(Map<String, dynamic> map, String dId) {
    id = dId;
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
  }

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
      currentLocation == other.currentLocation;

  @override
  int get hashCode => hashValues(
        name,
        bio,
        mainSpecialty,
        hashList(otherSpecialties),
        hashList(experiences),
        hashList(services),
        currentLocation,
      );
}
