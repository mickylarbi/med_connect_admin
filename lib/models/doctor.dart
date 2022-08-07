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
  List<DateTimeRange>? availablehours;

  Doctor(
      {this.id,
      this.firstName,
      this.surname,
      this.mainSpecialty,
      this.otherSpecialties,
      this.experiences,
      this.reviews,
      this.bio,
      this.currentLocation,
      this.services,
      this.availablehours});

  Doctor.fromFireStore(Map<String, dynamic> map, String dId) {
    id = dId;
    firstName = map['firstName'] as String?;
    firstName = map['surname'] as String?;
    mainSpecialty = map['mainSpecialty'] as String?;

    otherSpecialties = [];
    experiences = (map['experiences'] as List<dynamic>?)!
        .map((e) => Experience.fromFirestore(e))
        .toList();
    reviews = (map['reviews'] as List<dynamic>?)!
        .map((e) => Review.fromFirestore(e))
        .toList();
    bio = map['bio'] as String?;
    currentLocation = Experience.fromFirestore(
        map['currentLocation'] as Map<String, dynamic>);
    services =
        (map['services'] as List<dynamic>?)!.map((e) => e.toString()).toList();

    List<Map>? al = map['availableHours'] as List<Map>?;
    for (Map element in al!) {
      availablehours!.add(
          DateTimeRange(start: element['startDate'], end: element['endDate']));
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'surname': surname,
      'mainSpecialty': mainSpecialty,
      'otherSpecialties': otherSpecialties,
      'experiences': experiences,
      'reviews': reviews,
      'bio': bio,
      'currentLocation': currentLocation,
      'services': services,
      'availableHours': availablehours!
          .map((e) => {'startDate': e.start, 'endDate': e.end})
          .toList()
    };
  }

  String get name => '$firstName $surname';
}
